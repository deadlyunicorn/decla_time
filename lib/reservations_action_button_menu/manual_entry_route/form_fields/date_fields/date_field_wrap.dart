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
    this.date,
  });

  final Future<DateTime?> Function(BuildContext context) handleDateSetButton;
  final AppLocalizations localized;
  final DateTime? date;
  final String label;

  @override
  State<DateFieldWrap> createState() => _DateFieldWrapState();
}

class _DateFieldWrapState extends State<DateFieldWrap> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      initialValue: widget.date,
      validator: (value) {
        if (value == null) {
          return widget.localized.invalidDateError.capitalized;
        } else {
          return null;
        }
      },
      builder: (field) {
        final errorText = field.errorText;
        return SizedBox(
          width: kDatePickerWidth,
          child: Column(
            children: [
              Container(
                height: kMenuHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      //Border Colors
                      color: errorText != null
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      //Label
                      top: -24,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        color: Theme.of(context).colorScheme.background,
                        child: Text(
                          widget.label,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: errorText != null
                                      ? Theme.of(context).colorScheme.error
                                      : null),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      //Button
                      child: TextButton(
                        style: datePickerTextButtonStyle(context),
                        onPressed: () async {
                          await handleButtonPress(context, field);
                        },
                        onHover: (value) {
                          handleButtonHover(value);
                        },
                        child: Text(
                          showDateOrSet(widget.date, isHovering),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding( //Error Text
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  errorText ?? "",
                  maxLines: 2,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void handleButtonHover(bool value) {
    setState(() {
      isHovering = value;
    });
  }

  Future<void> handleButtonPress(
      BuildContext context, FormFieldState<DateTime> field) async {
    final newDate = await widget.handleDateSetButton(context);
    if (newDate != null) {
      field.didChange(newDate);
      field.validate();
    }
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
