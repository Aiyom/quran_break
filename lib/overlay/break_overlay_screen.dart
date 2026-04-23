import 'dart:async';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../constants/surah_data.dart';
import '../l10n/app_locale.dart';
import '../l10n/strings.dart';
import '../models/app_settings.dart';
import '../models/ayah_model.dart';
import '../services/break_window_bridge.dart';
import '../widgets/arabic_text.dart';
import 'overlay_state.dart';

const int _skipDelaySeconds = 10;

class BreakOverlayScreen extends StatefulWidget {
  final BreakOverlayData state;

  const BreakOverlayScreen({super.key, required this.state});

  @override
  State<BreakOverlayScreen> createState() => _BreakOverlayScreenState();
}

class _BreakOverlayScreenState extends State<BreakOverlayScreen> {
  int _skipCountdown = _skipDelaySeconds;
  Timer? _skipTimer;

  @override
  void initState() {
    super.initState();
    _skipTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_skipCountdown <= 0) {
        t.cancel();
        return;
      }
      setState(() => _skipCountdown--);
    });
  }

  @override
  void dispose() {
    _skipTimer?.cancel();
    super.dispose();
  }

  Future<void> _send(String method) async {
    try {
      await const WindowMethodChannel(BreakWindowBridge.channelName)
          .invokeMethod(method);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.state,
      builder: (context, _) => _buildBody(),
    );
  }

  Widget _buildBody() {
    final state = widget.state;
    final s = getStrings(state.appLocale);
    final canSkip = _skipCountdown <= 0;
    final ayah = state.ayah;

    return Directionality(
      textDirection: state.appLocale.textDirection,
      child: Scaffold(
        backgroundColor: Colors.black.withValues(alpha: 0.92),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.3),
                  radius: 1.2,
                  colors: [Color(0xFF16432F), kBg],
                ),
              ),
            ),
            Column(
              children: [
                LinearProgressIndicator(
                  value: state.progress,
                  backgroundColor: kSurface,
                  color: _progressColor(state.progress),
                  minHeight: 4,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 20, 32, 8),
                  child: Row(
                    children: [
                      const Icon(Icons.self_improvement_rounded,
                          color: kGold, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        s.breakTitle,
                        style: cairoStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: kGold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: kSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: kGold.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          state.remainingFormatted,
                          style: cairoStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: kGold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _SkipButton(
                        canSkip: canSkip,
                        countdown: _skipCountdown,
                        label: s.skipBreak,
                        onPressed: () => _send('skip'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1000),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: ayah == null
                            ? const _LoadingPlaceholder()
                            : _AyahView(
                                key: ValueKey(ayah.verseKey),
                                ayah: ayah,
                                state: state,
                                strings: s,
                              ),
                      ),
                    ),
                  ),
                ),
                if (ayah != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (state.contentMode != ContentMode.randomAyah) ...[
                          Tooltip(
                            message: s.previous,
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.arrow_back_rounded),
                              label: Text(s.previous),
                              onPressed: () => _send('previous'),
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                        Tooltip(
                          message: s.another,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.shuffle_rounded),
                            label: Text(s.another),
                            onPressed: () => _send('another'),
                          ),
                        ),
                        if (state.contentMode != ContentMode.randomAyah) ...[
                          const SizedBox(width: 16),
                          Tooltip(
                            message: s.next,
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.arrow_forward_rounded),
                              label: Text(s.next),
                              onPressed: () => _send('next'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _progressColor(double p) {
    if (p < 0.5) return kGreen;
    if (p < 0.85) return kGold;
    return kRed;
  }
}

class _AyahView extends StatelessWidget {
  final AyahModel ayah;
  final BreakOverlayData state;
  final AppStrings strings;

  const _AyahView({
    super.key,
    required this.ayah,
    required this.state,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    final surah = getSurah(ayah.surahNumber);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: cardDecoration(),
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${surah.nameTranslit} · ${ayah.ayahNumberInSurah}/${surah.ayahCount}',
                        style: cairoStyle(fontSize: 15, color: kGold),
                      ),
                    ),
                    if (state.isOffline)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: kRed.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          strings.offline,
                          style: cairoStyle(
                            fontSize: 11,
                            color: kRed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    'سورة ${ayah.surahNameArabic} · ${ayah.ayahNumberInSurah} · الجزء ${ayah.juz}',
                    style: arabicStyle(fontSize: 16, color: kGoldLight),
                  ),
                ),
                const SizedBox(height: 24),
                Divider(color: kGold.withValues(alpha: 0.15)),
                const SizedBox(height: 24),
                ArabicText(ayah.arabicText, fontSize: 40),
                if (state.showTranslation && ayah.translationText != null) ...[
                  const SizedBox(height: 24),
                  Divider(color: kGold.withValues(alpha: 0.15)),
                  const SizedBox(height: 24),
                  Text(
                    ayah.translationText!,
                    textAlign:
                        state.translationLocale.textDirection ==
                                TextDirection.rtl
                            ? TextAlign.right
                            : TextAlign.center,
                    style: cairoStyle(
                      fontSize: 20,
                      height: 1.7,
                      color: kTextPrimary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (state.showTafsir) ...[
            const SizedBox(height: 16),
            _TafsirBlock(ayah: ayah, state: state, strings: strings),
          ],
        ],
      ),
    );
  }
}

class _TafsirBlock extends StatelessWidget {
  final AyahModel ayah;
  final BreakOverlayData state;
  final AppStrings strings;

  const _TafsirBlock({
    required this.ayah,
    required this.state,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: cardDecoration(),
      child: ExpansionTile(
        initiallyExpanded: true,
        iconColor: kGold,
        collapsedIconColor: kGold,
        shape: const Border(),
        title: Row(
          children: [
            const Icon(Icons.auto_stories_rounded, color: kGold, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${strings.tafsirOf}: ${state.tafsirName}',
                style: cairoStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: kGold,
                ),
              ),
            ),
          ],
        ),
        childrenPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        children: [
          if (ayah.tafsirText == null)
            const Padding(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: kGold,
                  strokeWidth: 2,
                ),
              ),
            )
          else
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 320),
              child: SingleChildScrollView(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    ayah.tafsirText!,
                    style: arabicStyle(fontSize: 17, color: kTafsirText),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SkipButton extends StatelessWidget {
  final bool canSkip;
  final int countdown;
  final String label;
  final VoidCallback onPressed;

  const _SkipButton({
    required this.canSkip,
    required this.countdown,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (!canSkip) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: kSurface.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                value: (_skipDelaySeconds - countdown) / _skipDelaySeconds,
                strokeWidth: 2,
                color: kTextSecond,
              ),
            ),
            const SizedBox(width: 8),
            Text('$countdown',
                style: cairoStyle(fontSize: 13, color: kTextSecond)),
          ],
        ),
      );
    }
    return Tooltip(
      message: label,
      child: TextButton.icon(
        icon: const Icon(Icons.close_rounded, size: 18),
        label: Text(label),
        onPressed: onPressed,
      ),
    );
  }
}

class _LoadingPlaceholder extends StatelessWidget {
  const _LoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Container(
        decoration: cardDecoration(),
        padding: const EdgeInsets.all(40),
        child: Column(
          children: List.generate(6, (i) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Container(
                height: 20,
                decoration: BoxDecoration(
                  color: kSurfaceHover,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
