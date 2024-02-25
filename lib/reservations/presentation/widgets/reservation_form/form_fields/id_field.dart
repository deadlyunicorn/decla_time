import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/core/functions/fasthash.dart";
import "package:decla_time/reservations/presentation/widgets/reservation_form/form_fields/required_text_field.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class IdField extends StatelessWidget {
  const IdField({
    required this.hasInitialId,
    required this.idController,
    required this.refresh,
    required this.localized,
    super.key,
  });

  final bool hasInitialId;
  final TextEditingController idController;
  final void Function() refresh;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: kMaxContainerWidthSmall * 2,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 64,
            child: Center(
              child: IconButton(
                mouseCursor: hasInitialId
                    ? SystemMouseCursors.forbidden
                    : SystemMouseCursors.click,
                onPressed: () {
                  if (!hasInitialId) {
                    idController.text = fastHash(DateTime.now().toString())
                        .abs()
                        .toRadixString(16)
                        .substring(0, 10)
                        .toUpperCase();
                  }
                },
                icon: const Icon(Icons.shuffle_rounded),
              ),
            ),
          ),
          const SizedBox.square(
            dimension: 8,
          ),
          Flexible(
            child: RequiredTextField(
              submitFormHandler: () {},
              isEditingExistingEntry: hasInitialId,
              controller: idController,
              label: "ID",
              localized: localized,
              refresh: refresh,
            ),
          ),
        ],
      ),
    );
  }
}
