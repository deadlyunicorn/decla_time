import "package:decla_time/declarations/database/declaration.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class TemporaryDeclarationManipulationButtons extends StatelessWidget {
  const TemporaryDeclarationManipulationButtons({
    required this.localized,
    required this.declaration,
    super.key,
  });

  final AppLocalizations localized;
  final Declaration declaration;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Tooltip(
          message: "delete temporary declaration from gov",
          child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.dangerous,
                color: Colors.redAccent.shade700,
              )),
        ),
        Tooltip(
          message: "finalize",
          child: IconButton(
            onPressed: () {
              //TODO Basically get a viewState and copy the same body with the differences and finialize.
//               fetch("https://www1.aade.gr/taxisnet/short_term_letting/views/declaration.xhtml", {
//   "headers": {
//     "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
//     "cookie": "/",
//   },
//   "body": "javax.faces.partial.ajax=true&javax.faces.source=appForm%3AfinalizeButton&javax.faces.partial.execute=%40all&javax.faces.partial.render=appForm&appForm%3AfinalizeButton=appForm%3AfinalizeButton&appForm=appForm&appForm%3ArentalFrom_input=14%2F02%2F2024&appForm%3ArentalTo_input=__DAY%2F__MONTH%2F__YEARFULL&appForm%3AsumAmount_input=MONEY_NON_DECIMAL%2CMONEY_AFTER_DEC&appForm%3AsumAmount_hinput=MONEY_PRE.MONEY_AFTER&appForm%3ApaymentType_input=4&appForm%3ApaymentType_focus=&appForm%3Aplatform_input=1&appForm%3Aplatform_focus=&appForm%3ArenterAfm=000000000&appForm%3AcancelAmount_input=&appForm%3AcancelAmount_hinput=&appForm%3AcancelDate_input=&appForm%3Aj_idt92=&javax.faces.ViewState=ViewState",
//   "method": "POST"
// });
            },
            icon: Icon(
              Icons.bookmarks_rounded,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
        ),
      ],
    );
  }
}
