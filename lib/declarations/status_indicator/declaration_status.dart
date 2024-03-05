import "package:decla_time/declarations/database/declaration.dart";

class DeclarationImportStatus {
  ///? Was it imported or did it already exist?
  final bool imported;
  final Declaration declaration;

  const DeclarationImportStatus({
    required this.declaration,
    required this.imported,
  });
}
