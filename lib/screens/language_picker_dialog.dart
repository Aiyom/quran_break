import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../l10n/app_locale.dart';
import '../l10n/strings.dart';

/// Shown on first launch to pick UI + translation language.
class LanguagePickerDialog extends StatefulWidget {
  final AppLocale initialLocale;

  const LanguagePickerDialog({super.key, this.initialLocale = AppLocale.ru});

  static Future<AppLocale?> show(
    BuildContext context, {
    AppLocale initialLocale = AppLocale.ru,
  }) {
    return showDialog<AppLocale>(
      context: context,
      barrierDismissible: false,
      builder: (_) => LanguagePickerDialog(initialLocale: initialLocale),
    );
  }

  @override
  State<LanguagePickerDialog> createState() => _LanguagePickerDialogState();
}

class _LanguagePickerDialogState extends State<LanguagePickerDialog> {
  late AppLocale _selected = widget.initialLocale;

  @override
  Widget build(BuildContext context) {
    final s = getStrings(_selected);
    return Directionality(
      textDirection: _selected.textDirection,
      child: AlertDialog(
        title: Text(s.chooseLanguageTitle),
        content: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                s.chooseLanguageSubtitle,
                style: cairoStyle(fontSize: 12, color: kTextSecond),
              ),
              const SizedBox(height: 16),
              ...AppLocale.values.map((l) {
                final isSelected = _selected == l;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => setState(() => _selected = l),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? kGold.withValues(alpha: 0.15) : null,
                        border: Border.all(
                          color: isSelected
                              ? kGold
                              : kGold.withValues(alpha: 0.1),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              l.nativeName,
                              style: cairoStyle(
                                fontSize: 15,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_rounded,
                                color: kGold, size: 20),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        actions: [
          ElevatedButton.icon(
            icon: const Icon(Icons.arrow_forward_rounded),
            label: Text(s.continueText),
            onPressed: () => Navigator.of(context).pop(_selected),
          ),
        ],
      ),
    );
  }
}
