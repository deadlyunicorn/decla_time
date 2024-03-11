import "dart:async";

import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/functions/snackbars.dart";
import "package:decla_time/declarations/database/user/user_property.dart";
import "package:decla_time/declarations/declarations_view/synchronize_declarations/declaration_sync_range_picker_dialog.dart";
import "package:decla_time/users/users_controller.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class DeclarationActions extends StatelessWidget {
  const DeclarationActions({
    required this.localized,
    required this.selectedProperty,
    required this.totalDeclarations,
    super.key,
  });

  final AppLocalizations localized;
  final UserProperty? selectedProperty;
  final int totalDeclarations;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: MediaQuery.sizeOf(context).width < kMaxWidthSmall
          ? Axis.vertical
          : Axis.horizontal,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        (selectedProperty != null && totalDeclarations > 0)
            ? FittedBox(
                child: Text(
                  // ignore: lines_longer_than_80_chars
                  "${localized.found.capitalized}: $totalDeclarations ${totalDeclarations > 1 ? localized.declarations : localized.declaration}",
                ),
              )
            : FittedBox(child: Text(localized.noDeclarationsFound.capitalized)),
        const SizedBox.square(dimension: 8),
        FittedBox(
          child: TextButton(
            onPressed: () async {
              final UsersController userActions =
                  context.read<UsersController>();
              if (userActions.isLoggedIn && selectedProperty != null) {
                if (selectedProperty!.propertyId.isNotEmpty) {
                  unawaited(
                    showDialog(
                      context: context,
                      builder: (_) => DeclarationSyncRangePickerDialog(
                        parentContext: context,
                        localized: localized,
                        propertyId: selectedProperty!.propertyId,
                      ),
                    ),
                  );
                } else {
                  showNormalSnackbar(
                    context: context,
                    message: localized.noPropertySelected.capitalized,
                  );
                }
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
