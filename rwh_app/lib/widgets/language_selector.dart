import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../l10n/app_localizations.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final l10n = AppLocalizations.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 8),
        Text(l10n.chooseLanguage),
        const SizedBox(width: 12),
        DropdownButton<Locale>(
          value: app.locale ?? const Locale('en'),
          items: [
            DropdownMenuItem(
              value: const Locale('en'),
              child: Text(l10n.languageEnglish),
            ),
            DropdownMenuItem(
              value: const Locale('hi'),
              child: Text(l10n.languageHindi),
            ),
          ],
          onChanged: (loc) {
            if (loc != null) {
              context.read<AppProvider>().setLocale(loc);
            }
          },
        ),
      ],
    );
  }
}
