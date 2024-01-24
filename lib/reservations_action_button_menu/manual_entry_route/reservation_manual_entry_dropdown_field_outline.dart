import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/reservations_action_button_menu/manual_entry_route/shared_prefs_list_string_addition_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReservationManualEntryDropdownFieldOutline extends StatefulWidget {
  //This is a stateful widget in order to refresh when we change the SharedPreferences entries.

  const ReservationManualEntryDropdownFieldOutline({
    super.key,
    required this.localized,
    required this.textEditingController,
    required this.sharedPrefsListKey,
    required this.label,
    this.helperText,
    this.defaultDropdownEntriesList,
  });

  final AppLocalizations localized;
  final TextEditingController textEditingController;
  final String sharedPrefsListKey;
  final String label;
  final String? helperText;
  final List<DropdownMenuEntry<String>>? defaultDropdownEntriesList;

  @override
  State<ReservationManualEntryDropdownFieldOutline> createState() =>
      _ReservationManualEntryDropdownFieldOutlineState();
}

class _ReservationManualEntryDropdownFieldOutlineState
    extends State<ReservationManualEntryDropdownFieldOutline> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: dropDownMenuEntriesFuture(), //getBookingPlatforms(),
      builder: (context, snapshot) {
        final List<DropdownMenuEntry<String>> snapshotData =
            snapshot.data ?? [];

        return DropdownMenu(
          menuHeight: 256,
          width: kMaxContainerWidthSmall * 2,
          textStyle: Theme.of(context).textTheme.headlineSmall,
          label: Text(widget.label.capitalized),
          controller: widget.textEditingController,
          helperText: widget.helperText,
          dropdownMenuEntries: [
            DropdownMenuEntry(
              value: "newEntry",
              label: widget.localized.add.capitalized,
            ),
            ...snapshotData,
          ],
          onSelected: (value) async {
            if (value == "newEntry") {
              final String? newEntry = ( await showDialog(
                context: context,
                builder: (context) {
                  return SharedPrefsListStringAdditionAlertDialog(
                      title:
                          "${widget.localized.add.capitalized} ${widget.label}",
                      listStringKey: widget.sharedPrefsListKey,
                      hintText:
                          "${widget.localized.enter.capitalized} ${widget.label}",
                      refreshParent: () {
                        setState(() {});
                      },
                      dropdownMenuEntries:
                          (snapshot.data ?? []).map((e) => e.value).toSet());
                },
              ));

              widget.textEditingController.text = newEntry ?? "" ;
            }
          },
        );
      },
    );
  }

  Future<List<DropdownMenuEntry<String>>> dropDownMenuEntriesFuture() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, String>? defaultValuesMap =
        widget.defaultDropdownEntriesList?.fold(
            {},
            (previousValue, element) => {
                  ...?previousValue,
                  ...{element.value: element.label}
                });

    final dropdownMenuListStringEntries =
        prefs.getStringList(widget.sharedPrefsListKey);
    if (dropdownMenuListStringEntries != null &&
        dropdownMenuListStringEntries.isNotEmpty) {
      return dropdownMenuListStringEntries.map((stringValue) {
        return DropdownMenuEntry(
            value: stringValue,
            label: defaultValuesMap?[stringValue] ?? stringValue);
      }).toList();
    } else {
      prefs.setStringList(
          widget.sharedPrefsListKey,
          widget.defaultDropdownEntriesList
                  ?.map(
                      (dropdownMenuEntry) => dropdownMenuEntry.value.toString())
                  .toList() ??
              []);
      return widget.defaultDropdownEntriesList ?? [];
    }
  }
}
