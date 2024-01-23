import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class DateFieldWrap extends StatelessWidget {

  const DateFieldWrap({
    super.key,
    required this.title,
    required this.handleDateSetButton,
    required this.localized, this.date,
  });

  final void Function(BuildContext context) handleDateSetButton;
  final AppLocalizations localized;
  final DateTime? date;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text("$title: "),
        TextButton(
          style: datePickerTextButtonStyle(context),
          onPressed: () {
            handleDateSetButton(context);
          },
          child: Text(
              showDateOrSet(date, false),
              ),
        )
      ],
    );
  }

  ButtonStyle datePickerTextButtonStyle(BuildContext context) {
    return TextButton.styleFrom(
        textStyle: TextStyle(
            fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
            fontFamily: Theme.of(context).textTheme.headlineSmall?.fontFamily));
  }

  String showDateOrSet(DateTime? date, bool isNotHovering) {
    return (!isNotHovering && date != null)
        ? DateFormat('dd/MM/y').format(date)
        : localized.setText.capitalized;
  }
}
