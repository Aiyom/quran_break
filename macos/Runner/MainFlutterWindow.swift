import Cocoa
import FlutterMacOS
import desktop_multi_window

// MARK: - Private CoreGraphics Services API
//
// We use three private CGS functions to *actually* switch the user's
// current Space (the Mission Control-level teleport):
//
//   CGSMainConnectionID            — our process's CGS connection
//   CGSCopySpacesForWindows        — find which Space a window lives on
//   CGSManagedDisplaySetCurrentSpace — switch a display to a given Space
//
// These are the same functions Dock / Mission Control / Rectangle /
// Amethyst / BetterTouchTool all use. Stable since 10.8.

private typealias CGSConnection = UInt32
private typealias CGSSpaceID = UInt64
private let kCGSAllSpacesMask: Int32 = 7

@_silgen_name("CGSMainConnectionID")
private func CGSMainConnectionID() -> CGSConnection

@_silgen_name("CGSCopySpacesForWindows")
private func CGSCopySpacesForWindows(_ cid: CGSConnection, _ mask: Int32, _ wids: CFArray) -> CFArray

@_silgen_name("CGSManagedDisplaySetCurrentSpace")
private func CGSManagedDisplaySetCurrentSpace(_ cid: CGSConnection, _ display: CFString, _ space: CGSSpaceID)

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    NSApp.presentationOptions = []
    NSLog("[QuranBreak] launch — presentationOptions reset")

    FlutterMultiWindowPlugin.setOnWindowCreatedCallback { controller in
      NSLog("[QuranBreak] sub-window created — attaching KioskController")
      RegisterGeneratedPlugins(registry: controller)
      KioskController.attach(to: controller)

      if let window = NSApp.windows.first(where: { $0.contentViewController === controller }) {
        // Pin overlay to a single Space so CGSCopySpacesForWindows returns
        // a deterministic Space ID we can teleport the user to. No
        // .canJoinAllSpaces — we go the explicit teleport route instead.
        window.collectionBehavior = [
          .fullScreenAuxiliary,
          .stationary,
          .ignoresCycle,
        ]
        window.level = .screenSaver
        window.hidesOnDeactivate = false
        window.orderOut(nil)
        NSLog("[QuranBreak] sub-window prepared (pinned to single Space)")
      }
    }

    super.awakeFromNib()
  }
}

// MARK: - KioskController
final class KioskController {
  private static var instances: [KioskController] = []

  private let controller: FlutterViewController
  private weak var trackedWindow: NSWindow?
  private var previousPresentationOptions: NSApplication.PresentationOptions = []
  private var active: Bool = false

  private init(controller: FlutterViewController) {
    self.controller = controller
  }

  static func attach(to controller: FlutterViewController) {
    let kiosk = KioskController(controller: controller)
    instances.append(kiosk)

    let channel = FlutterMethodChannel(
      name: "quran_break.kiosk",
      binaryMessenger: controller.engine.binaryMessenger
    )
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "enable":
        kiosk.enable()
        result(nil)
      case "disable":
        kiosk.disable()
        result(nil)
      case "hide":
        kiosk.hideWindow()
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func resolveWindow() -> NSWindow? {
    if let w = trackedWindow, w.contentViewController === controller {
      return w
    }
    for candidate in NSApp.windows where candidate.contentViewController === controller {
      trackedWindow = candidate
      return candidate
    }
    return nil
  }

  // Primary-display UUID in CGS-compatible CFString form. Needed for
  // CGSManagedDisplaySetCurrentSpace — which takes a UUID string, not
  // a CGDirectDisplayID number.
  private static func displayUUIDString(for screen: NSScreen) -> CFString? {
    guard let screenNumber = screen.deviceDescription[
      NSDeviceDescriptionKey("NSScreenNumber")
    ] as? UInt32 else { return nil }
    guard let uuidRef = CGDisplayCreateUUIDFromDisplayID(screenNumber)?.takeRetainedValue()
    else { return nil }
    return CFUUIDCreateString(nil, uuidRef)
  }

  func enable() {
    guard let window = resolveWindow() else { return }
    if active {
      NSLog("[KioskController] re-asserting")
      teleportUserToOverlay()
      return
    }
    active = true
    previousPresentationOptions = NSApp.presentationOptions

    window.collectionBehavior = [
      .fullScreenAuxiliary,
      .stationary,
      .ignoresCycle,
    ]
    window.level = .screenSaver
    window.hidesOnDeactivate = false

    NSApp.presentationOptions = [
      .hideMenuBar,
      .hideDock,
      .disableAppleMenu,
      .disableProcessSwitching,
      .disableForceQuit,
      .disableSessionTermination,
      .disableHideApplication,
      .disableMenuBarTransparency,
    ]

    teleportUserToOverlay()
    NSLog("[KioskController] kiosk engaged")
  }

  // Variant A: explicit teleport via CGSManagedDisplaySetCurrentSpace.
  // Procedure:
  //   1. Show the overlay (gives it a valid Window Server ID).
  //   2. Ask Window Server which Space the overlay lives on.
  //   3. Switch the user's active display to that Space.
  //   4. Re-assert front.
  private func teleportUserToOverlay() {
    guard let window = resolveWindow() else { return }
    DispatchQueue.main.async {
      if let frame = (NSScreen.main ?? window.screen)?.frame {
        window.setFrame(frame, display: true)
      }

      // Show first so the window has a live WS identity.
      window.setIsVisible(true)
      window.orderFrontRegardless()
      window.makeKeyAndOrderFront(nil)

      let cid = CGSMainConnectionID()
      let wid = CGWindowID(window.windowNumber)
      NSLog("[KioskController] overlay windowNumber=\(wid)")

      guard wid > 0 else {
        NSLog("[KioskController] windowNumber invalid — falling back to NSApp.activate")
        NSApp.activate(ignoringOtherApps: true)
        return
      }

      // Find overlay's Space.
      let widsCF = [NSNumber(value: wid)] as CFArray
      let spacesCF = CGSCopySpacesForWindows(cid, kCGSAllSpacesMask, widsCF)
      let spaces = spacesCF as? [NSNumber] ?? []
      guard let spaceID = spaces.first?.uint64Value else {
        NSLog("[KioskController] no Space for overlay — falling back to NSApp.activate")
        NSApp.activate(ignoringOtherApps: true)
        return
      }
      NSLog("[KioskController] overlay lives on spaceID=\(spaceID)")

      // Teleport the user's active display to that Space.
      guard let screen = NSScreen.main,
            let uuidString = Self.displayUUIDString(for: screen) else {
        NSLog("[KioskController] could not resolve display UUID — falling back to NSApp.activate")
        NSApp.activate(ignoringOtherApps: true)
        return
      }
      CGSManagedDisplaySetCurrentSpace(cid, uuidString, spaceID)
      NSLog("[KioskController] teleported display \(uuidString) to spaceID=\(spaceID)")

      // Bring window to front on the (now current) Space.
      window.makeKeyAndOrderFront(nil)
      NSApp.activate(ignoringOtherApps: true)
    }
  }

  func disable() {
    guard active else { return }
    active = false
    NSApp.presentationOptions = previousPresentationOptions
    NSLog("[KioskController] kiosk disabled")
  }

  func hideWindow() {
    guard let window = resolveWindow() else { return }
    DispatchQueue.main.async {
      window.orderOut(nil)
      NSLog("[KioskController] overlay hidden")
    }
  }
}
