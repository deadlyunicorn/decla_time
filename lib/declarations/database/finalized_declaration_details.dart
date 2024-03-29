import "package:decla_time/core/enums/declaration_type.dart";
import "package:decla_time/core/functions/fasthash.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:isar/isar.dart";

part "finalized_declaration_details.g.dart";

@collection
class FinalizedDeclarationDetails {
  final DateTime declarationDate;

  @Enumerated(EnumType.name)
  final DeclarationType declarationType; //Ammending or Initial

  @Index(unique: true)
  final int serialNumber;

  @Index(unique: true)
  final int declarationDbId;

  final int? serialNumberOfAmendingDeclaration;
  //! We basically check which declarations have not been amended.
  //! Don't display a reservation that has been amandeded.
  // List<int> relatedDeclarationsSerialNumbers = <int>[];
  //! We have a "history" button for the declaration.
  //! We can check our ammendments. -
  //! Only a finalized declaration can have a SerialNumber.

  FinalizedDeclarationDetails({
    required this.declarationDbId,
    required this.declarationDate,
    required this.declarationType,
    required this.serialNumber,
    required this.serialNumberOfAmendingDeclaration,
  });

  Id get isarId => fastHash("$serialNumber");

  bool isEqualTo(FinalizedDeclarationDetails finalizedDeclarationDetails) {
    return finalizedDeclarationDetails.declarationDate == declarationDate &&
        finalizedDeclarationDetails.declarationType == declarationType &&
        finalizedDeclarationDetails.serialNumber == serialNumber &&
        finalizedDeclarationDetails.declarationDbId == declarationDbId &&
        finalizedDeclarationDetails.serialNumberOfAmendingDeclaration ==
            serialNumberOfAmendingDeclaration;
  }

  static String getDeclarationTypeLocalized({
    required AppLocalizations localized,
    required DeclarationType type,
  }) {
    switch (type) {
      case DeclarationType.amending:
        return localized.declarationType_amending;
      case DeclarationType.initial:
        return localized.declarationType_initial;
    }
  }
}
