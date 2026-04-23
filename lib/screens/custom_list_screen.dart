import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants/app_theme.dart';
import '../constants/surah_data.dart';
import '../models/custom_ayah_ref.dart';
import '../providers/settings_provider.dart';
import 'surah_picker_screen.dart';

class CustomListScreen extends StatelessWidget {
  const CustomListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final s = settings.strings;
    final list = settings.settings.customAyahList;

    return Scaffold(
      appBar: AppBar(title: Text(s.myList)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Text(
              s.myListSubtitle,
              style: cairoStyle(fontSize: 13, color: kTextSecond, height: 1.4),
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? _Empty(onAdd: () => _addAyah(context))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: list.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 6),
                    itemBuilder: (_, i) {
                      final ref = list[i];
                      return _AyahTile(
                        ref: ref,
                        onDelete: () => _deleteAyah(context, ref, i),
                      );
                    },
                  ),
          ),
          if (list.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  s.totalAyahs(list.length),
                  style: cairoStyle(fontSize: 12, color: kTextSecond),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add_rounded),
              label: Text(s.addAyah),
              onPressed: () => _addAyah(context),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addAyah(BuildContext context) async {
    final settings = context.read<SettingsProvider>();
    final ref = await showDialog<CustomAyahRef>(
      context: context,
      builder: (_) => _AddAyahDialog(existing: settings.settings.customAyahList),
    );
    if (ref != null && context.mounted) {
      await settings.addCustomAyah(ref);
    }
  }

  Future<void> _deleteAyah(
    BuildContext context,
    CustomAyahRef ref,
    int index,
  ) async {
    final settings = context.read<SettingsProvider>();
    final s = settings.strings;
    await settings.removeCustomAyah(ref);
    if (!context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(s.ayahRemoved(ref.verseKey)),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: s.undo,
          textColor: kGold,
          onPressed: () {
            settings.insertCustomAyahAt(index, ref);
          },
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  final VoidCallback onAdd;
  const _Empty({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<SettingsProvider>().strings;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kGold.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.library_books_rounded,
                size: 56,
                color: kGold.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              s.listEmpty,
              style: cairoStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              s.listEmptyHint,
              textAlign: TextAlign.center,
              style: cairoStyle(fontSize: 13, color: kTextSecond, height: 1.5),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.add_rounded),
              label: Text(s.addFirstAyah),
              onPressed: onAdd,
            ),
          ],
        ),
      ),
    );
  }
}

class _AyahTile extends StatefulWidget {
  final CustomAyahRef ref;
  final VoidCallback onDelete;

  const _AyahTile({required this.ref, required this.onDelete});

  @override
  State<_AyahTile> createState() => _AyahTileState();
}

class _AyahTileState extends State<_AyahTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final s = context.read<SettingsProvider>().strings;
    final ref = widget.ref;
    final surah = getSurah(ref.surahNumber);
    return Dismissible(
      key: ValueKey(ref.verseKey),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: kRed.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kRed.withValues(alpha: 0.6)),
        ),
        child: const Icon(Icons.delete_rounded, color: kRed),
      ),
      onDismissed: (_) => widget.onDelete(),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: _hover ? kSurfaceHover : kSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kGold.withValues(alpha: 0.1)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: kGold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  ref.verseKey,
                  style: cairoStyle(
                    fontSize: 13,
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
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        surah.nameArabic,
                        style: arabicStyle(fontSize: 16),
                      ),
                    ),
                    Text(
                      '${surah.nameTranslit} · ${surah.nameRussian}',
                      style: cairoStyle(fontSize: 11, color: kTextSecond),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: s.deleteFromList,
                icon: const Icon(Icons.delete_outline_rounded, color: kRed),
                onPressed: widget.onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddAyahDialog extends StatefulWidget {
  final List<CustomAyahRef> existing;
  const _AddAyahDialog({required this.existing});

  @override
  State<_AddAyahDialog> createState() => _AddAyahDialogState();
}

class _AddAyahDialogState extends State<_AddAyahDialog> {
  int? _surahNumber;
  final _ayahController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _ayahController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.read<SettingsProvider>().strings;
    final surah = _surahNumber == null ? null : getSurah(_surahNumber!);
    return AlertDialog(
      title: Text(s.addAyah),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s.selectSurahStep,
                style: cairoStyle(fontSize: 13, color: kTextSecond)),
            const SizedBox(height: 8),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () async {
                final n = await SurahPickerScreen.pick(
                  context,
                  initialSelection: _surahNumber,
                );
                if (n != null) {
                  setState(() {
                    _surahNumber = n;
                    _errorText = null;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: kBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kGold.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.menu_book_rounded, color: kGold),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        surah == null
                            ? s.chooseSurah
                            : '${surah.nameTranslit} · ${surah.ayahCount} ${s.ayahCount}',
                        style: cairoStyle(fontSize: 14),
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: kGold),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(s.enterAyahNumber,
                style: cairoStyle(fontSize: 13, color: kTextSecond)),
            const SizedBox(height: 8),
            TextField(
              controller: _ayahController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              enabled: surah != null,
              decoration: InputDecoration(
                hintText: surah == null
                    ? '—'
                    : s.enterAyahNumberHint(surah.ayahCount),
                errorText: _errorText,
                isDense: true,
              ),
              onChanged: (_) {
                if (_errorText != null) setState(() => _errorText = null);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(s.cancel),
        ),
        ElevatedButton(
          onPressed: _canSubmit() ? () => _submit(s) : null,
          child: Text(s.add),
        ),
      ],
    );
  }

  bool _canSubmit() =>
      _surahNumber != null && _ayahController.text.trim().isNotEmpty;

  void _submit(dynamic s) {
    final surah = getSurah(_surahNumber!);
    final n = int.tryParse(_ayahController.text.trim());
    if (n == null || n < 1 || n > surah.ayahCount) {
      setState(() => _errorText = s.ayahOutOfRange);
      return;
    }
    final ref = CustomAyahRef(surahNumber: _surahNumber!, ayahNumber: n);
    if (widget.existing.contains(ref)) {
      setState(() => _errorText = s.ayahAlreadyInList);
      return;
    }
    Navigator.of(context).pop(ref);
  }
}
