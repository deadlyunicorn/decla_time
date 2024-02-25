import "package:decla_time/core/enums/declaration_status.dart";

class SearchPageDeclaration {
  final int _declarationIndex;
  final DateTime _arrivalDate;
  final DateTime _departureDate;
  final String _payout;
  final DeclarationStatus _status;

  DateTime get arrivalDate => _arrivalDate;
  DateTime get departureDate => _departureDate;
  String get payout => _payout;
  DeclarationStatus get status => _status;
  int get declarationIndex => _declarationIndex;

  SearchPageDeclaration({
    required DateTime arrivalDates,
    required DateTime departureDates,
    required String payouts,
    required DeclarationStatus status,
    required int declarationIndex,
  })  : _arrivalDate = arrivalDates,
        _departureDate = departureDates,
        _declarationIndex = declarationIndex,
        _status = status,
        _payout = payouts;

  String deleteRequestBody(String viewState) =>
      // ignore: lines_longer_than_80_chars
      "javax.faces.ViewState=$viewState&appForm%3AbasicDT%3A$_declarationIndex%3AdeleteButton=appForm%3AbasicDT%3A$_declarationIndex%3AdeleteButton&javax.faces.source=appForm%3AbasicDT%3A$_declarationIndex%3AdeleteButton&javax.faces.partial.ajax=true&javax.faces.partial.execute=%40all&appForm=appForm";
  String deleteConfirmationBody(String viewState) =>
      // ignore: lines_longer_than_80_chars
      "javax.faces.ViewState=$viewState&javax.faces.partial.ajax=true&javax.faces.source=appForm%3AdeleteConfirm&javax.faces.partial.execute=%40all&javax.faces.partial.render=appForm%3AbasicDT&appForm%3AdeleteConfirm=appForm%3AdeleteConfirm&appForm=appForm";

  void printData() {
    // ignore: avoid_print
    print(
      // ignore: lines_longer_than_80_chars
      "$declarationIndex. $arrivalDate - $departureDate | $payout EUR | $status",
    );
  }
}
