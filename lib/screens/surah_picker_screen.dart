import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../constants/surah_data.dart';
import '../l10n/app_locale.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SurahPickerScreen extends StatefulWidget {
  final int? initialSelection;

  const SurahPickerScreen({super.key, this.initialSelection});

  static Future<int?> pick(BuildContext context, {int? initialSelection}) {
    return Navigator.of(context).push<int>(
      MaterialPageRoute(
        builder: (_) =>
            SurahPickerScreen(initialSelection: initialSelection),
      ),
    );
  }

  @override
  State<SurahPickerScreen> createState() => _SurahPickerScreenState();
}

class _SurahPickerScreenState extends State<SurahPickerScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final s = context.watch<SettingsProvider>().strings;
    final filtered = _filter(s.locale);
    return Scaffold(
      appBar: AppBar(title: Text(s.chooseSurahTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              autofocus: true,
              onChanged: (v) => setState(() => _query = v.trim()),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_rounded, color: kGold),
                hintText: s.searchSurahHint,
                isDense: true,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: filtered.length,
              separatorBuilder: (_, _) => const SizedBox(height: 6),
              itemBuilder: (_, i) {
                final surah = filtered[i];
                final selected = widget.initialSelection == surah.number;
                return _SurahTile(
                  surah: surah,
                  selected: selected,
                  strings: s,
                  onTap: () => Navigator.of(context).pop(surah.number),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<SurahInfo> _filter(AppLocale locale) {
    if (_query.isEmpty) return kSurahs;
    final q = _query.toLowerCase();
    return kSurahs.where((s) {
      return s.nameArabic.contains(_query) ||
          s.nameTranslit.toLowerCase().contains(q) ||
          s.nameRussian.toLowerCase().contains(q) ||
          s.nameEnglish.toLowerCase().contains(q) ||
          s.number.toString() == _query;
    }).toList();
  }
}

class _SurahTile extends StatefulWidget {
  final SurahInfo surah;
  final bool selected;
  final AppStrings strings;
  final VoidCallback onTap;

  const _SurahTile({
    required this.surah,
    required this.selected,
    required this.strings,
    required this.onTap,
  });

  @override
  State<_SurahTile> createState() => _SurahTileState();
}

class _SurahTileState extends State<_SurahTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.strings;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: _hover ? kSurfaceHover : kSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.selected
                  ? kGold
                  : kGold.withValues(alpha: 0.1),
              width: widget.selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: kGold.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  widget.surah.number.toString().padLeft(3, '0'),
                  style: cairoStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: kGold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.surah.nameTranslit,
                          style: cairoStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                            widget.surah.nameArabic,
                            style: arabicStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${widget.surah.ayahCount} ${s.ayahCount} · ${widget.surah.isMeccan ? s.meccan : s.medinan}',
                      style: cairoStyle(fontSize: 11, color: kTextSecond),
                    ),
                  ],
                ),
              ),
              if (widget.selected)
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.check_circle_rounded, color: kGold, size: 20),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
