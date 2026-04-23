import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_theme.dart';
import '../constants/surah_data.dart';
import '../l10n/app_locale.dart';
import '../models/app_settings.dart';
import '../models/ayah_model.dart';
import '../providers/quran_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/timer_provider.dart';
import '../widgets/arabic_text.dart';

const int _skipDelaySeconds = 10;

class BreakScreen extends StatefulWidget {
  const BreakScreen({super.key});

  @override
  State<BreakScreen> createState() => _BreakScreenState();
}

class _BreakScreenState extends State<BreakScreen> {
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

  @override
  Widget build(BuildContext context) {
    final timer = context.watch<TimerProvider>();
    final quran = context.watch<QuranProvider>();
    final sp = context.watch<SettingsProvider>();
    final s = sp.strings;
    final settings = sp.settings;
    final canSkip = _skipCountdown <= 0;

    return Scaffold(
      backgroundColor: kBg,
      body: Stack(
        children: [
          // Decorative background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.3),
                radius: 1.2,
                colors: [Color(0xFF16432F), kBg],
              ),
            ),
          ),
          // Main content
          SafeArea(
            child: Column(
              children: [
                // Progress bar at top
                LinearProgressIndicator(
                  value: timer.breakProgress,
                  backgroundColor: kSurface,
                  color: _progressColor(timer.breakProgress),
                  minHeight: 4,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                  child: Row(
                    children: [
                      Icon(Icons.self_improvement_rounded,
                          color: kGold, size: 26),
                      const SizedBox(width: 12),
                      Text(
                        s.breakTitle,
                        style: cairoStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: kGold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: kSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: kGold.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          timer.breakRemainingFormatted,
                          style: cairoStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: kGold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _SkipButton(
                        canSkip: canSkip,
                        countdown: _skipCountdown,
                        label: s.skipBreak,
                        onPressed: () => timer.skipBreak(settings),
                      ),
                    ],
                  ),
                ),
                // Body
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 880),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: _buildBody(context, quran, settings, s),
                      ),
                    ),
                  ),
                ),
                // Navigation buttons
                if (quran.currentAyah != null && !quran.isLoading)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (settings.contentMode != ContentMode.randomAyah) ...[
                          Tooltip(
                            message: s.previous,
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.arrow_back_rounded),
                              label: Text(s.previous),
                              onPressed: () => quran.loadPrevious(settings),
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                        Tooltip(
                          message: s.another,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.shuffle_rounded),
                            label: Text(s.another),
                            onPressed: () => quran.loadAnother(settings),
                          ),
                        ),
                        if (settings.contentMode != ContentMode.randomAyah) ...[
                          const SizedBox(width: 16),
                          Tooltip(
                            message: s.next,
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.arrow_forward_rounded),
                              label: Text(s.next),
                              onPressed: () => quran.loadNext(settings),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _progressColor(double p) {
    if (p < 0.5) return kGreen;
    if (p < 0.85) return kGold;
    return kRed;
  }

  Widget _buildBody(
    BuildContext context,
    QuranProvider quran,
    AppSettings settings,
    dynamic s,
  ) {
    if (quran.isLoading && quran.currentAyah == null) {
      return const _LoadingPlaceholder();
    }
    if (quran.error != null && quran.currentAyah == null) {
      return _ErrorView(
        message: s.errorLoading,
        hint: s.checkConnection,
        retryLabel: s.retry,
        onRetry: () => quran.loadContent(settings),
      );
    }
    final ayah = quran.currentAyah;
    if (ayah == null) return const SizedBox();
    return _AyahView(
      key: ValueKey(ayah.verseKey),
      ayah: ayah,
      offline: quran.isOffline,
      settings: settings,
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
            Text(
              '$countdown',
              style: cairoStyle(fontSize: 13, color: kTextSecond),
            ),
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

class _AyahView extends StatelessWidget {
  final AyahModel ayah;
  final bool offline;
  final AppSettings settings;

  const _AyahView({
    super.key,
    required this.ayah,
    required this.offline,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    final s = context.read<SettingsProvider>().strings;
    final surah = getSurah(ayah.surahNumber);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: cardDecoration(),
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${surah.nameTranslit} · ${ayah.ayahNumberInSurah}/${surah.ayahCount}',
                        style: cairoStyle(fontSize: 14, color: kGold),
                      ),
                    ),
                    if (offline)
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
                          s.offline,
                          style: cairoStyle(
                            fontSize: 11,
                            color: kRed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    'سورة ${ayah.surahNameArabic} · ${ayah.ayahNumberInSurah} · الجزء ${ayah.juz}',
                    style: arabicStyle(fontSize: 15, color: kGoldLight),
                  ),
                ),
                const SizedBox(height: 20),
                Divider(color: kGold.withValues(alpha: 0.15)),
                const SizedBox(height: 20),
                ArabicText(
                  ayah.arabicText,
                  fontSize: 34,
                ),
                if (settings.showTranslation &&
                    settings.hasTranslation &&
                    ayah.translationText != null) ...[
                  const SizedBox(height: 20),
                  Divider(color: kGold.withValues(alpha: 0.15)),
                  const SizedBox(height: 20),
                  Text(
                    ayah.translationText!,
                    textAlign:
                        settings.translationLocale.textDirection ==
                                TextDirection.rtl
                            ? TextAlign.right
                            : TextAlign.center,
                    style: cairoStyle(
                      fontSize: 18,
                      height: 1.7,
                      color: kTextPrimary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (settings.showTafsir) ...[
            const SizedBox(height: 16),
            _TafsirBlock(ayah: ayah, settings: settings),
          ],
        ],
      ),
    );
  }
}

class _TafsirBlock extends StatelessWidget {
  final AyahModel ayah;
  final AppSettings settings;

  const _TafsirBlock({required this.ayah, required this.settings});

  @override
  Widget build(BuildContext context) {
    final s = context.read<SettingsProvider>().strings;
    final name = settings.tafsirChoice == TafsirChoice.primary
        ? settings.primaryTafsirName
        : settings.secondaryTafsirName;
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
                '${s.tafsirOf}: $name',
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
              constraints: const BoxConstraints(maxHeight: 280),
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

class _LoadingPlaceholder extends StatelessWidget {
  const _LoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Container(
        decoration: cardDecoration(),
        padding: const EdgeInsets.all(32),
        child: Column(
          children: List.generate(6, (i) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Container(
                height: 18,
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

class _ErrorView extends StatelessWidget {
  final String message;
  final String hint;
  final String retryLabel;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.hint,
    required this.retryLabel,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 64, color: kRed),
            const SizedBox(height: 20),
            Text(
              message,
              style: cairoStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              hint,
              textAlign: TextAlign.center,
              style: cairoStyle(fontSize: 14, color: kTextSecond),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              icon: const Icon(Icons.refresh_rounded),
              label: Text(retryLabel),
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
