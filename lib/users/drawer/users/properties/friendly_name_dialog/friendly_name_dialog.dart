import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:decla_time/core/widgets/custom_alert_dialog.dart";
import "package:decla_time/declarations/database/user/user_property.dart";
import "package:decla_time/users/users_controller.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class FriendlyNameDialog extends StatefulWidget {
  const FriendlyNameDialog({
    required this.property,
    required this.localized,
    super.key,
  });

  final AppLocalizations localized;
  final UserProperty property;

  @override
  State<FriendlyNameDialog> createState() => _FriendlyNameDialogState();
}

class _FriendlyNameDialogState extends State<FriendlyNameDialog> {
  final TextEditingController friendlyNameController = TextEditingController();
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      confirmButtonAction: () async {
        if (friendlyNameController.text.isNotEmpty) {
          await context.read<IsarHelper>().userActions.setPropertyFriendlyName(
                propertyId: widget.property.propertyId,
                friendlyName: friendlyNameController.text,
              );
          if (context.mounted) await context.read<UsersController>().sync();
          if (context.mounted) Navigator.pop(context);
        }
      },
      title: widget.localized.setFriendlyNameTitle.capitalized,
      localized: widget.localized,
      child: ColumnWithSpacings(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: <Widget>[
          Text(
            // ignore: lines_longer_than_80_chars
            "${widget.localized.setFriendlyNameBody.capitalized}: ${widget.property.address}\n( ATAK: ${widget.property.atak} )",
            textAlign: TextAlign.center,
          ),
          RowWithSpacings(
            spacing: 16,
            children: <Widget>[
              IconButton(
                onPressed: () async {
                  if (widget.property.friendlyName != null) {
                    await context
                        .read<IsarHelper>()
                        .userActions
                        .setPropertyFriendlyName(
                          propertyId: widget.property.propertyId,
                          friendlyName: null,
                        );
                    if (context.mounted) {
                      await context.read<UsersController>().sync();
                    }
                    if (context.mounted) Navigator.pop(context);
                  } else {
                    setState(() {
                      errorText =
                          widget.localized.noFriendlyNameToDelete.capitalized;
                    });
                  }
                },
                icon: const Icon(Icons.delete),
                color: Theme.of(context).colorScheme.error,
                tooltip: widget.localized.removeFriendlyName.capitalized,
              ),
              Expanded(
                child: TextField(
                  maxLength: 32,
                  controller: friendlyNameController,
                  decoration: InputDecoration(
                    labelText: widget.localized.friendlyName.capitalized,
                  ),
                ),
              ),
            ],
          ),
          if (errorText != null)
            Text(
              errorText!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
        ],
      ),
    );
  }
}
