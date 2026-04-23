import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_theme.dart';
import '../constants/surah_data.dart';
import '../models/app_settings.dart';
import '../providers/settings_provider.dart';
import '../providers/timer_provider.dart';
import '../widgets/timer_ring_widget.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final timer = context.watch<TimerProvider>();
    final sp = context.watch<SettingsProvider>();
    final s = sp.strings;
    final settings = sp.settings;
    final isRunning = timer.state != TimerState.idle;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/icons/app_crescent.png',
              width: 24,
              height: 24,
              filterQuality: FilterQuality.high,
            ),
            const SizedBox(width: 10),
            Text(s.appName),
          ],
        ),
        actions: [
          IconButton(
            tooltip: s.settings,
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          children: [
            if (!settings.welcomeDismissed) _WelcomeCard(onDismiss: () => sp.dismissWelcome()),
            const SizedBox(height: 20),
            TimerRingWidget(
              progress: timer.progress,
              centerText:
                  isRunning ? timer.remainingFormatted : _initialTime(settings),
              subtitle: s.timeUntilBreak,
            ),
            const SizedBox(height: 20),
            _StartStopButton(
              isRunning: isRunning,
              label: isRunning ? s.pauseTimer : s.startTimer,
              onPressed: () => timer.toggle(settings),
            ),
            const SizedBox(height: 20),
            _SettingsCard(settings: settings, s: s),
            const SizedBox(height: 12),
            Text(
              isRunning
                  ? '${s.nextBreakAt} ${timer.nextBreakAt}'
                  : s.timerStopped,
              style: cairoStyle(fontSize: 13, color: kTextSecond),
            ),
          ],
        ),
      ),
    );
  }

  String _initialTime(AppSettings settings) {
    final total = settings.breakIntervalMinutes * 60;
    final m = total ~/ 60;
    final sec = total % 60;
    return '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }
}

class _WelcomeCard extends StatelessWidget {
  final VoidCallback onDismiss;
  const _WelcomeCard({required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final s = context.read<SettingsProvider>().strings;
    return Card(
      color: kGold.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: kGold, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.celebration_rounded, color: kGold, size: 20),
                const SizedBox(width: 8),
                Text(s.welcomeTitle,
                    style: cairoStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: kGold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(s.welcomeText,
                style: cairoStyle(fontSize: 13, height: 1.5)),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: const Icon(Icons.check_rounded, size: 16),
                label: Text(s.understood),
                onPressed: onDismiss,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StartStopButton extends StatelessWidget {
  final bool isRunning;
  final String label;
  final VoidCallback onPressed;

  const _StartStopButton({
    required this.isRunning,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded),
      label: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(label, style: cairoStyle(fontSize: 16, fontWeight: FontWeight.w700, color: kBg)),
      ),
      onPressed: onPressed,
    );
  }
}

class _SettingsCard extends StatefulWidget {
  final AppSettings settings;
  final dynamic s;

  const _SettingsCard({required this.settings, required this.s});

  @override
  State<_SettingsCard> createState() => _SettingsCardState();
}

class _SettingsCardState extends State<_SettingsCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.s;
    final settings = widget.settings;
    final modeLabel = _modeLabel(s, settings);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SettingsScreen()),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _hover ? kSurfaceHover : kSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kGold.withValues(alpha: 0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _row(
                Icons.schedule_rounded,
                '${s.breakEvery} ${settings.breakIntervalMinutes} ${s.minutesWord}',
              ),
              const SizedBox(height: 8),
              _row(
                Icons.timer_rounded,
                '${s.breakDuration}: ${settings.breakDurationSeconds ~/ 60} ${s.minutesWord}',
              ),
              const SizedBox(height: 8),
              _row(Icons.menu_book_rounded, modeLabel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: kGold, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text, style: cairoStyle(fontSize: 14)),
        ),
      ],
    );
  }

  String _modeLabel(dynamic s, AppSettings settings) {
    switch (settings.contentMode) {
      case ContentMode.randomAyah:
        return s.modeRandomAyah;
      case ContentMode.randomSurah:
        return s.modeRandomSurah;
      case ContentMode.specificSurah:
        final surah = getSurah(settings.specificSurahNumber);
        return '${s.modeSpecificSurah}: ${surah.nameTranslit}';
      case ContentMode.specificAyahs:
        final surah = getSurah(settings.specificSurahNumber);
        return '${surah.nameTranslit} ${settings.specificAyahStart}–${settings.specificAyahEnd}';
      case ContentMode.customList:
        return settings.customAyahList.isEmpty
            ? s.modeCustomListSubtitleEmpty
            : s.modeCustomListSubtitleCount(settings.customAyahList.length);
    }
  }
}
