import 'package:flutter/material.dart';

class RememberUsernameCheckbox extends StatelessWidget {
  const RememberUsernameCheckbox({
    super.key,
    required this.rememberUsername,
    required this.setRememberUsername,
  });

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
          child: const Text("Remember username"),
        ),
      ],
    );
  }
}
