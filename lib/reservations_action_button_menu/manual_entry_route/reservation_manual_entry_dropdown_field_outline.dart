import "dart:async";

import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/reservations_action_button_menu/manual_entry_route/shared_prefs_list_string_addition_alert_dialog.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:shared_preferences/shared_preferences.dart";

class ReservationManualEntryDropdownFieldOutline extends StatefulWidget {
  //This is a stateful widget in order to refresh
  //when we change the SharedPreferences entries.

  const ReservationManualEntryDropdownFieldOutline({
    required this.localized,
    required this.textEditingController,
    required this.sharedPrefsListKey,
    required this.label,
    required this.isRequired,
    this.addNewEntryFuture,
    this.dropdownMenuEntriesFuture,
    this.helperText,
    this.defaultDropdownEntriesList,
    super.key,
  });

  final AppLocalizations localized;
  final TextEditingController textEditingController;
  final String sharedPrefsListKey;
  final String label;
  final String? helperText;
  final bool isRequired;
  final List<DropdownMenuEntry<String>>? defaultDropdownEntriesList;
  final Future<List<DropdownMenuEntry<String>>> Function({
    required BuildContext context,
  })? dropdownMenuEntriesFuture;

  final Future<void> Function({
    required BuildContext context,
    required String newEntry,
  })? addNewEntryFuture;

  @override
  State<ReservationManualEntryDropdownFieldOutline> createState() =>
      _ReservationManualEntryDropdownFieldOutlineState();
}

class _ReservationManualEntryDropdownFieldOutlineState
    extends State<ReservationManualEntryDropdownFieldOutline> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: FutureBuilder<List<DropdownMenuEntry<String>>>(
        future: widget.dropdownMenuEntriesFuture != null
            ? widget.dropdownMenuEntriesFuture!(context: context)
            : defaultDropDownMenuEntriesFuture(), //getBookingPlatforms(),
        builder: (
          BuildContext context,
          AsyncSnapshot<List<DropdownMenuEntry<String>>> snapshot,
        ) {
          final List<DropdownMenuEntry<String>> additionalDropdownMenuEntries =
              snapshot.data ?? <DropdownMenuEntry<String>>[];

          return FormField<String>(
            initialValue: widget.textEditingController.text,
            builder: (FormFieldState<String> field) {
              return SizedBox(
                child: DropdownMenu<String>(
                  errorText:
                      (field.hasError) ? field.errorText?.capitalized : null,
                  menuHeight: 256,
                  menuStyle:
                      Theme.of(context).dropdownMenuTheme.menuStyle?.copyWith(
                            alignment: Alignment.centerLeft,
                          ),
                  width: kMaxContainerWidthSmall * 2,
                  textStyle: Theme.of(context).textTheme.headlineSmall,
                  label: Text(widget.label.capitalized),
                  controller: widget.textEditingController,
                  helperText: widget.helperText,
                  dropdownMenuEntries: <DropdownMenuEntry<String>>[
                    DropdownMenuEntry<String>(
                      value: "newEntry",
                      label: widget.localized.add.capitalized,
                    ),
                    ...additionalDropdownMenuEntries,
                  ],
                  onSelected: (String? value) async {
                    if (value == "newEntry") {
                      final String? newEntry = (await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SharedPrefsListStringAdditionAlertDialog(
                            localized: widget.localized,
                            title:
                                // ignore: lines_longer_than_80_chars
                                "${widget.localized.add.capitalized} ${widget.label}",
                            listStringKey: widget.sharedPrefsListKey,
                            hintText:
                                // ignore: lines_longer_than_80_chars
                                "${widget.localized.enter.capitalized} ${widget.label}",
                            refreshParent: () {
                              setState(() {});
                            },
                            dropdownMenuEntries: (snapshot.data ??
                                    <DropdownMenuEntry<String>>[])
                                .map((DropdownMenuEntry<String> e) => e.value)
                                .toSet(),
                          );
                        },
                      ));
                      if (widget.addNewEntryFuture != null &&
                          newEntry != null &&
                          newEntry.isNotEmpty &&
                          context.mounted) {
                        await widget.addNewEntryFuture!(
                          context: context,
                          newEntry: newEntry,
                        );
                      }
                      field.didChange(newEntry ?? "");
                      widget.textEditingController.text = newEntry ?? "";
                    } else {
                      final DropdownMenuEntry<String> finalValue =
                          widget.defaultDropdownEntriesList?.firstWhere(
                                (DropdownMenuEntry<String> dropdownMenuEntry) =>
                                    dropdownMenuEntry.value == value,
                              ) ??
                              additionalDropdownMenuEntries.firstWhere(
                                (DropdownMenuEntry<String> dropdownMenuEntry) =>
                                    dropdownMenuEntry.value == value,
                              );

                      field.didChange(finalValue.value);
                      widget.textEditingController.text = finalValue.label;
                    }
                  },
                ),
              );
            },
            validator: (String? value) {
              final String stringValue = value ?? "";

              if (stringValue.isEmpty ||
                  widget.textEditingController.text.isEmpty) {
                if (widget.isRequired) {
                  return widget.localized.selectSomeField;
                } else {
                  return null;
                }
              } else if (stringValue.length < 4) {
                return widget.localized.insertAtleastFour;
              } else {
                final List<DropdownMenuEntry<String>> dropDownEntries =
                    additionalDropdownMenuEntries
                      ..addAll(
                        widget.defaultDropdownEntriesList ??
                            <DropdownMenuEntry<String>>[],
                      );
                if (dropDownEntries
                    .where(
                      (DropdownMenuEntry<String> element) =>
                          element.label == widget.textEditingController.text,
                    )
                    .isEmpty) {
                  return widget.localized.selectSomeField;
                }
                return null;
              }
            },
          );
        },
      ),
    );
  }

  Future<List<DropdownMenuEntry<String>>>
      defaultDropDownMenuEntriesFuture() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, String>? defaultValuesMap =
        widget.defaultDropdownEntriesList?.fold(
      <String, String>{},
      (Map<String, String>? previousValue, DropdownMenuEntry<String> element) =>
          <String, String>{
        ...?previousValue,
        ...<String, String>{element.value: element.label},
      },
    );

    final List<String>? dropdownMenuListStringEntries =
        prefs.getStringList(widget.sharedPrefsListKey);
    if (dropdownMenuListStringEntries != null &&
        dropdownMenuListStringEntries.isNotEmpty) {
      return dropdownMenuListStringEntries.map((String stringValue) {
        return DropdownMenuEntry<String>(
          value: stringValue,
          label: defaultValuesMap?[stringValue] ?? stringValue,
        );
      }).toList();
    } else {
      unawaited(
        prefs.setStringList(
          widget.sharedPrefsListKey,
          widget.defaultDropdownEntriesList
                  ?.map(
                    (DropdownMenuEntry<String> dropdownMenuEntry) =>
                        dropdownMenuEntry.value.toString(),
                  )
                  .toList() ??
              <String>[],
        ),
      );
      return widget.defaultDropdownEntriesList ?? <DropdownMenuEntry<String>>[];
    }
  }
}
