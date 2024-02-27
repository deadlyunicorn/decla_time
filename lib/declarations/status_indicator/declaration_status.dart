class DeclarationImportStatus {
  ///? Was it imported or did it already exist?
  final bool imported;
  final int localDeclarationId;

  DeclarationImportStatus({
    required this.localDeclarationId,
    required this.imported,
  });
}
