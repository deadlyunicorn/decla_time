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
    required this.headlineText,
    required this.sharedPrefsListKey,
    required this.label,
    this.helperText,
    this.defaultDropdownEntries,
  });

  final AppLocalizations localized;
  final TextEditingController textEditingController;
  final String headlineText;
  final String sharedPrefsListKey;
  final String label;
  final String? helperText;
  final List<DropdownMenuEntry<String>>? defaultDropdownEntries;

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
        final dropDownMenuEntries = snapshot.data
            ?.map((dropdownMenuEntry) => dropdownMenuEntry.value)
            .toList();
        final Set<String> dropdownMenuEntries = {
          widget.localized.addNewPlatform.capitalized,
          ...(dropDownMenuEntries ?? []),
        };

        return DropdownMenu(
          menuHeight: 256,
          width: kMaxContainerWidthSmall * 2,
          textStyle: Theme.of(context).textTheme.headlineSmall,
          label: Text(widget.label),
          controller: widget.textEditingController,
          helperText: widget.helperText,
          dropdownMenuEntries: [
            ...dropdownMenuEntries.map(
              (entryName) => DropdownMenuEntry(
                value: entryName,
                label: entryName,
              ),
            )
          ],
          onSelected: (value) {
            if (value?.toLowerCase() == widget.localized.addNewPlatform) {
              showDialog(
                context: context,
                builder: (context) {
                  return SharedPrefsListStringAdditionAlertDialog(
                    title: widget.localized.platformAddition.capitalized,
                    listStringKey: widget.sharedPrefsListKey,
                    hintText: widget.localized.platformAdditionHint.capitalized,
                    refreshParent: () {
                      setState(() {});
                    },
                    dropdownMenuEntries: dropdownMenuEntries,
                  );
                },
              );
              widget.textEditingController.text = "";
            }
          },
        );
      },
    );
  }

  Future<List<DropdownMenuEntry<String>>> dropDownMenuEntriesFuture() async {
    final prefs = await SharedPreferences.getInstance();

    final dropdownMenuListStringEntries =
        prefs.getStringList(widget.sharedPrefsListKey);
    if (dropdownMenuListStringEntries != null &&
        dropdownMenuListStringEntries.isNotEmpty) {
      return dropdownMenuListStringEntries
          .map((entry) => DropdownMenuEntry(value: entry, label: entry))
          .toList();
    } else {
      prefs.setStringList(
          widget.sharedPrefsListKey,
          widget.defaultDropdownEntries
                  ?.map(
                      (dropdownMenuEntry) => dropdownMenuEntry.value.toString())
                  .toList() ??
              []);
      return widget.defaultDropdownEntries ?? [];
    }
  }
}
