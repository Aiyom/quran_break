import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants/app_theme.dart';
import '../constants/surah_data.dart';
import '../l10n/app_locale.dart';
import '../models/app_settings.dart';
import '../providers/settings_provider.dart';
import '../providers/quran_provider.dart';
import '../services/autostart_service.dart';
import 'custom_list_screen.dart';
import 'surah_picker_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _startCtrl;
  late TextEditingController _endCtrl;

  @override
  void initState() {
    super.initState();
    final s = context.read<SettingsProvider>().settings;
    _startCtrl = TextEditingController(text: s.specificAyahStart.toString());
    _endCtrl = TextEditingController(text: s.specificAyahEnd.toString());
  }

  @override
  void dispose() {
    _startCtrl.dispose();
    _endCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<SettingsProvider>();
    final s = sp.strings;
    final settings = sp.settings;

    return Scaffold(
      appBar: AppBar(title: Text(s.settings)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
        children: [
          _Section(
            title: s.sectionLanguage,
            icon: Icons.language_rounded,
            children: [
              _LanguageTile(
                label: s.interfaceLanguage,
                subtitle: s.interfaceLanguageSubtitle,
                value: settings.appLocale,
                showNoTranslationOption: false,
                onChanged: (v) => sp.setAppLocale(v!),
              ),
              const Divider(height: 24),
              _LanguageTile(
                label: s.translationLanguage,
                subtitle: s.translationLanguageSubtitle,
                value: settings.translationLocale,
                showNoTranslationOption: true,
                noTranslationLabel: s.noTranslation,
                onChanged: (v) async {
                  if (v == null) return;
                  await sp.setTranslationLocale(v);
                  if (!context.mounted) return;
                  // Clear quran provider caches — new language needs refetch
                  context.read<QuranProvider>().clearCaches();
                },
              ),
            ],
          ),

          _Section(
            title: s.sectionSchedule,
            icon: Icons.schedule_rounded,
            children: [
              _LabelWithSubtitle(
                label: s.breakEvery,
                subtitle: s.breakEverySubtitle,
              ),
              const SizedBox(height: 10),
              _ChipsRow<int>(
                options: const [1, 15, 30, 45, 60, 90, 120],
                value: settings.breakIntervalMinutes,
                labelFor: (v) => '$v ${s.minutesShort}',
                onChanged: (v) => sp.setBreakInterval(v),
              ),
              const Divider(height: 24),
              _LabelWithSubtitle(
                label: s.breakDuration,
                subtitle: s.breakDurationSubtitle,
              ),
              const SizedBox(height: 10),
              _ChipsRow<int>(
                options: const [60, 120, 180, 300],
                value: settings.breakDurationSeconds,
                labelFor: (v) => '${v ~/ 60} ${s.minutesShort}',
                onChanged: (v) => sp.setBreakDuration(v),
              ),
              const Divider(height: 24),
              SwitchListTile(
                value: settings.notificationsEnabled,
                onChanged: (v) => sp.setNotificationsEnabled(v),
                contentPadding: EdgeInsets.zero,
                title: Text(s.showNotification, style: cairoStyle(fontSize: 14)),
                subtitle: Text(
                  s.showNotificationSubtitle,
                  style: cairoStyle(fontSize: 12, color: kTextSecond),
                ),
              ),
            ],
          ),

          _Section(
            title: s.sectionContent,
            icon: Icons.menu_book_rounded,
            children: [
              _ModeTile(
                title: s.modeRandomAyah,
                subtitle: s.modeRandomAyahSubtitle,
                value: ContentMode.randomAyah,
                groupValue: settings.contentMode,
                icon: Icons.casino_rounded,
                onChanged: (v) => sp.setContentMode(v!),
              ),
              _ModeTile(
                title: s.modeRandomSurah,
                subtitle: s.modeRandomSurahSubtitle,
                value: ContentMode.randomSurah,
                groupValue: settings.contentMode,
                icon: Icons.shuffle_rounded,
                onChanged: (v) => sp.setContentMode(v!),
              ),
              _ModeTile(
                title: s.modeSpecificSurah,
                subtitle: s.modeSpecificSurahSubtitle,
                value: ContentMode.specificSurah,
                groupValue: settings.contentMode,
                icon: Icons.bookmark_rounded,
                onChanged: (v) => sp.setContentMode(v!),
                extra: settings.contentMode == ContentMode.specificSurah
                    ? _SurahButton(
                        surahNumber: settings.specificSurahNumber,
                        onChanged: (n) => sp.setSpecificSurah(n),
                      )
                    : null,
              ),
              _ModeTile(
                title: s.modeSpecificAyahs,
                subtitle: s.modeSpecificAyahsSubtitle,
                value: ContentMode.specificAyahs,
                groupValue: settings.contentMode,
                icon: Icons.format_list_numbered_rounded,
                onChanged: (v) => sp.setContentMode(v!),
                extra: settings.contentMode == ContentMode.specificAyahs
                    ? Column(
                        children: [
                          _SurahButton(
                            surahNumber: settings.specificSurahNumber,
                            onChanged: (n) => sp.setSpecificSurah(n),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: _NumberField(
                                  label: s.ayahFrom,
                                  controller: _startCtrl,
                                  onSubmit: () => _applyRange(sp),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _NumberField(
                                  label: s.ayahTo,
                                  controller: _endCtrl,
                                  onSubmit: () => _applyRange(sp),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : null,
              ),
              _ModeTile(
                title: s.modeCustomList,
                subtitle: settings.customAyahList.isEmpty
                    ? s.modeCustomListSubtitleEmpty
                    : s.modeCustomListSubtitleCount(
                        settings.customAyahList.length,
                      ),
                value: ContentMode.customList,
                groupValue: settings.contentMode,
                icon: Icons.playlist_add_check_rounded,
                onChanged: (v) => sp.setContentMode(v!),
                extra: settings.contentMode == ContentMode.customList
                    ? OutlinedButton.icon(
                        icon: const Icon(Icons.edit_rounded),
                        label: Text(s.manageList),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const CustomListScreen(),
                          ));
                        },
                      )
                    : null,
              ),
            ],
          ),

          _Section(
            title: s.sectionTranslation,
            icon: Icons.translate_rounded,
            children: [
              if (!settings.hasTranslation)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    s.arabicOnlyNoTranslation,
                    style: cairoStyle(color: kTextSecond, fontSize: 12),
                  ),
                )
              else
                SwitchListTile(
                  value: settings.showTranslation,
                  onChanged: (v) => sp.setShowTranslation(v),
                  contentPadding: EdgeInsets.zero,
                  title: Text(s.showTranslation, style: cairoStyle(fontSize: 14)),
                  subtitle: Text(
                    s.showTranslationSubtitle(
                      settings.translationLocale.nativeName,
                    ),
                    style: cairoStyle(fontSize: 12, color: kTextSecond),
                  ),
                ),
            ],
          ),

          _Section(
            title: s.sectionTafsir,
            icon: Icons.auto_stories_rounded,
            children: [
              SwitchListTile(
                value: settings.showTafsir,
                onChanged: (v) => sp.setShowTafsir(v),
                contentPadding: EdgeInsets.zero,
                title: Text(s.showTafsir, style: cairoStyle(fontSize: 14)),
                subtitle: Text(
                  s.showTafsirSubtitle,
                  style: cairoStyle(fontSize: 12, color: kTextSecond),
                ),
              ),
              if (settings.showTafsir) ...[
                const Divider(height: 24),
                _TafsirRadio(
                  title: '${s.tafsirPrimary} — ${settings.primaryTafsirName}',
                  subtitle: s.tafsirPrimarySubtitle,
                  value: TafsirChoice.primary,
                  groupValue: settings.tafsirChoice,
                  onChanged: (v) => sp.setTafsirChoice(v!),
                ),
                _TafsirRadio(
                  title:
                      '${s.tafsirSecondary} — ${settings.secondaryTafsirName}',
                  subtitle: s.tafsirSecondarySubtitle,
                  value: TafsirChoice.secondary,
                  groupValue: settings.tafsirChoice,
                  onChanged: (v) => sp.setTafsirChoice(v!),
                ),
                const SizedBox(height: 8),
                Text(
                  s.tafsirLanguageInfo(
                    settings.translationLocale.nativeName,
                  ),
                  style: cairoStyle(fontSize: 11, color: kTextSecond, height: 1.4),
                ),
              ],
            ],
          ),

          _Section(
            title: s.sectionSystem,
            icon: Icons.computer_rounded,
            children: [
              SwitchListTile(
                value: AutostartService.isEnabled(),
                onChanged: (v) async {
                  await AutostartService.toggle();
                  await sp.setAutostartEnabled(AutostartService.isEnabled());
                },
                contentPadding: EdgeInsets.zero,
                title: Text(s.autostart, style: cairoStyle(fontSize: 14)),
                subtitle: Text(
                  s.autostartSubtitle,
                  style: cairoStyle(fontSize: 12, color: kTextSecond),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${s.currentPlatform}: ${_platformName()}',
                style: cairoStyle(fontSize: 11, color: kTextSecond),
              ),
              Text(
                AutostartService.autostartPath(),
                style: cairoStyle(fontSize: 10, color: kTextSecond, height: 1.4),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _applyRange(SettingsProvider sp) {
    final start = int.tryParse(_startCtrl.text) ?? 1;
    final end = int.tryParse(_endCtrl.text) ?? start;
    final surah = getSurah(sp.settings.specificSurahNumber);
    final clampedStart = start.clamp(1, surah.ayahCount);
    final clampedEnd = end.clamp(clampedStart, surah.ayahCount);
    _startCtrl.text = clampedStart.toString();
    _endCtrl.text = clampedEnd.toString();
    sp.setAyahRange(clampedStart, clampedEnd);
  }

  String _platformName() {
    if (Platform.isLinux) return 'Linux';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    return 'Unknown';
  }
}

class _Section extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _Section({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: kGold, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: cairoStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: kGold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

class _LabelWithSubtitle extends StatelessWidget {
  final String label;
  final String subtitle;
  const _LabelWithSubtitle({required this.label, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: cairoStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 2),
        Text(subtitle,
            style: cairoStyle(fontSize: 12, color: kTextSecond)),
      ],
    );
  }
}

class _ChipsRow<T> extends StatelessWidget {
  final List<T> options;
  final T value;
  final String Function(T) labelFor;
  final ValueChanged<T> onChanged;

  const _ChipsRow({
    required this.options,
    required this.value,
    required this.labelFor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        final selected = opt == value;
        return FilterChip(
          selected: selected,
          label: Text(labelFor(opt)),
          onSelected: (_) => onChanged(opt),
        );
      }).toList(),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String label;
  final String subtitle;
  final AppLocale value;
  final bool showNoTranslationOption;
  final String? noTranslationLabel;
  final ValueChanged<AppLocale?> onChanged;

  const _LanguageTile({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.showNoTranslationOption,
    required this.onChanged,
    this.noTranslationLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LabelWithSubtitle(label: label, subtitle: subtitle),
        const SizedBox(height: 8),
        DropdownButtonFormField<AppLocale>(
          initialValue: value,
          isDense: true,
          dropdownColor: kSurface,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          ),
          items: [
            ...AppLocale.values.map(
              (l) => DropdownMenuItem(
                value: l,
                child: Text(
                  showNoTranslationOption && l == AppLocale.ar
                      ? '${l.nativeName} — ${noTranslationLabel ?? ''}'
                      : l.nativeName,
                  style: cairoStyle(fontSize: 14),
                ),
              ),
            ),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _ModeTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final ContentMode value;
  final ContentMode groupValue;
  final IconData icon;
  final ValueChanged<ContentMode?> onChanged;
  final Widget? extra;

  const _ModeTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.groupValue,
    required this.icon,
    required this.onChanged,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: selected ? kGold.withValues(alpha: 0.08) : null,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? kGold.withValues(alpha: 0.4) : Colors.transparent,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => onChanged(value),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              child: Row(
                children: [
                  Radio<ContentMode>(
                    value: value,
                    // ignore: deprecated_member_use
                    groupValue: groupValue,
                    // ignore: deprecated_member_use
                    onChanged: onChanged,
                  ),
                  Icon(icon, color: kGold, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: cairoStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text(subtitle,
                            style: cairoStyle(
                                fontSize: 12, color: kTextSecond, height: 1.3)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (extra != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 12, 10),
              child: extra!,
            ),
        ],
      ),
    );
  }
}

class _TafsirRadio extends StatelessWidget {
  final String title;
  final String subtitle;
  final TafsirChoice value;
  final TafsirChoice groupValue;
  final ValueChanged<TafsirChoice?> onChanged;

  const _TafsirRadio({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Radio<TafsirChoice>(
              value: value,
              // ignore: deprecated_member_use
              groupValue: groupValue,
              // ignore: deprecated_member_use
              onChanged: onChanged,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: cairoStyle(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                  Text(subtitle,
                      style:
                          cairoStyle(fontSize: 11, color: kTextSecond)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SurahButton extends StatelessWidget {
  final int surahNumber;
  final ValueChanged<int> onChanged;

  const _SurahButton({required this.surahNumber, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final surah = getSurah(surahNumber);
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: const Icon(Icons.menu_book_rounded),
        label: Text('${surah.number}. ${surah.nameTranslit}'),
        onPressed: () async {
          final n = await SurahPickerScreen.pick(
            context,
            initialSelection: surahNumber,
          );
          if (n != null) onChanged(n);
        },
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final VoidCallback onSubmit;

  const _NumberField({
    required this.label,
    required this.controller,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onSubmitted: (_) => onSubmit(),
      onTapOutside: (_) => onSubmit(),
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}
