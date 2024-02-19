import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RememberUsernameCheckbox extends StatelessWidget {
  const RememberUsernameCheckbox({
    super.key,
    required this.rememberUsername,
    required this.setRememberUsername,
    required this.localized,
  });
  final AppLocalizations localized;
  final bool rememberUsername;
  final void Function(bool?) setRememberUsername;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: rememberUsername,
          onChanged: setRememberUsername,
        ),
        TextButton(
          onPressed: () {
            setRememberUsername(!rememberUsername);
          },
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onBackground,
          ).copyWith(
              overlayColor: const MaterialStatePropertyAll(Colors.transparent)),
          child: Text(localized.rememberUsername.capitalized),
        ),
      ],
    );
  }
}
