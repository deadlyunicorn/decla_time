import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class DateFieldWrap extends StatefulWidget {
  const DateFieldWrap({
    super.key,
    required this.title,
    required this.handleDateSetButton,
    required this.localized,
    this.date,
  });

  final void Function(BuildContext context) handleDateSetButton;
  final AppLocalizations localized;
  final DateTime? date;
  final String title;

  @override
  State<DateFieldWrap> createState() => _DateFieldWrapState();
}

class _DateFieldWrapState extends State<DateFieldWrap> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.symmetric(
              horizontal: BorderSide(
                  color: Theme.of(context).colorScheme.onBackground))),
      child: Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 160,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            width: 160,
            height: 36,
            child: TextButton(
              style: datePickerTextButtonStyle(context),
              onPressed: () {
                widget.handleDateSetButton(context);
              },
              onHover: (value) {
                setState(() {
                  isHovering = value;
                });
              },
              child: SizedBox(
                child: Text(
                  showDateOrSet(widget.date, isHovering),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  ButtonStyle datePickerTextButtonStyle(BuildContext context) {
    return TextButton.styleFrom(
      textStyle: TextStyle(
        fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
        fontFamily: Theme.of(context).textTheme.headlineSmall?.fontFamily,
      ),
    );
  }

  String showDateOrSet(DateTime? date, bool isHovering) {
    return (!isHovering && date != null)
        ? DateFormat('dd/MM/y').format(date)
        : widget.localized.setText.capitalized;
  }
}
