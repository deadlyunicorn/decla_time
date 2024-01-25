import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class DateFieldWrap extends StatefulWidget {
  const DateFieldWrap({
    super.key,
    required this.handleDateSetButton,
    required this.localized,
    required this.label,
    this.errorText,
    this.date,
  });

  final void Function(BuildContext context) handleDateSetButton;
  final AppLocalizations localized;
  final String? errorText;
  final DateTime? date;
  final String label;

  @override
  State<DateFieldWrap> createState() => _DateFieldWrapState();
}

class _DateFieldWrapState extends State<DateFieldWrap> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return FormField(

      onSaved:(newValue) {
        print( newValue );
      },
      validator: (value) {
        
      },
      builder: (field) => SizedBox(
        height: kMenuHeightWithError,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
              width: kContainerWidthMedium,
              height: kMenuHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.symmetric(
                  horizontal: BorderSide(
                      color: widget.errorText != null
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.onBackground),
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: -24,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Theme.of(context).colorScheme.background,
                      child: Text(
                        widget.label,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: widget.errorText != null ? Theme.of(context).colorScheme.error : null
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
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
                      child: Text(
                        showDateOrSet(widget.date, isHovering),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -32,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.errorText ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                  )
                ],
              )),
        ),
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
