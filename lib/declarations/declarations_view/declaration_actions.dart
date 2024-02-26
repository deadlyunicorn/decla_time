import "dart:async";

import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/declarations/declarations_view/synchronize_declarations/declaration_sync_range_picker_dialog.dart";
import "package:decla_time/users/users_controller.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class DeclarationActions extends StatelessWidget {
  const DeclarationActions({
    required this.localized,
    required this.selectedPropertyId,
    super.key,
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
      children: <Widget>[
        FittedBox(child: Text(localized.noDeclarationsFound.capitalized)),
        const SizedBox.square(dimension: 8),
        FittedBox(
          child: TextButton(
            onPressed: () async {
              final UsersController userActions =
                  context.read<UsersController>();
              if (userActions.isLoggedIn) {
                unawaited(
                  showDialog(
                    context: context,
                    builder: (_) => DeclarationSyncRangePickerDialog(
                      parentContext: context,
                      localized: localized,
                      propertyId: selectedPropertyId,
                    ),
                  ),
                );
              } else {
                userActions.setRequestLogin(true);
              }
            },
            child: Text(localized.syncDeclarations.capitalized),
          ),
        ),
      ],
    );
  }
}
