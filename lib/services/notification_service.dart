import 'package:local_notifier/local_notifier.dart';
import '../l10n/app_locale.dart';

class NotificationService {
  static Future<void> init() async {
    await localNotifier.setup(appName: 'Quran Break');
  }

  static Future<void> showBreakAlert({
    required AppStrings strings,
    required void Function() onTap,
  }) async {
    final n = LocalNotification(
      identifier: 'break',
      title: strings.notificationTitle,
      body: strings.notificationBody,
    );
    n.onClick = onTap;
    await localNotifier.notify(n);
  }
}
