import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/declarations/synchronize_declarations/declaration_sync_range_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeclarationActions extends StatelessWidget {
  const DeclarationActions({
    super.key,
    required this.localized,
    required this.selectedPropertyId,
  });

  final AppLocalizations localized;
  final String selectedPropertyId;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: MediaQuery.sizeOf(context).width < kMaxWidthSmall
          ? Axis.vertical
          : Axis.horizontal,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FittedBox(child: Text(localized.noDeclarationsFound.capitalized)),
        const SizedBox.square(dimension: 8),
        FittedBox(
          child: TextButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (_) => DeclarationSyncRangePickerDialog(
                  parentContext: context,
                  localized: localized,
                  propertyId: selectedPropertyId,
                ),
              );
            },
            child: Text(localized.syncDeclarations.capitalized),
          ),
        )
      ],
    );
  }
}
