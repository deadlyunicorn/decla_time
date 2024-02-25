import "package:decla_time/core/enums/declaration_type.dart";
import "package:decla_time/core/functions/fasthash.dart";
import "package:isar/isar.dart";

part "finalized_declaration_details.g.dart";

@collection
class FinalizedDeclarationDetails {
  final DateTime declarationDate;

  @Enumerated(EnumType.name)
  final DeclarationType declarationType; //Ammending or Initial

  @Index(unique: true)
  final int serialNumber;

  DateTime? amendmentDate;
  //! We basically check which declarations have not been amended.
  //! Don't display a reservation that has been amandeded.
  final List<int> relatedDeclarationsSerialNumbers = <int>[];
  //! We have a "history" button for the declaration.
  //! We can check our ammendments. -
  //! Only a finalized declaration can have a SerialNumber.

  FinalizedDeclarationDetails({
    required this.declarationDate,
    required this.declarationType,
    required this.serialNumber,
    this.amendmentDate,
  });

  Id get isarId => fastHash("$serialNumber");

  bool isEqualTo(FinalizedDeclarationDetails finalizedDeclarationDetails) {
    return finalizedDeclarationDetails.declarationDate == declarationDate &&
        finalizedDeclarationDetails.declarationType == declarationType &&
        finalizedDeclarationDetails.serialNumber == serialNumber &&
        finalizedDeclarationDetails.amendmentDate == amendmentDate;
  }
}
