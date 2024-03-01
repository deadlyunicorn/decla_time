import "package:decla_time/core/enums/declaration_status.dart";
import "package:decla_time/core/enums/declaration_type.dart";
import "package:intl/intl.dart";

class SearchPageDeclaration {
  final int _declarationIndex;
  final int? _serialNumber;
  final DateTime _arrivalDate;
  final DateTime _departureDate;
  final String _payout;
  final DeclarationStatus _status;
  final DeclarationType _type;

  DateTime get arrivalDate => _arrivalDate;
  DateTime get departureDate => _departureDate;
  double get payout => double.parse(_payout.replaceAll(",", "."));
  DeclarationStatus get status => _status;
  DeclarationType get type => _type;
  int get declarationIndex => _declarationIndex;
  int? get serialNumber => _serialNumber;

  int get nights => departureDate.difference(arrivalDate).inDays + 1;

  String get arrivalDateString => DateFormat("dd/MM/y").format(arrivalDate);
  String get departureDateString => DateFormat("dd/MM/y").format(departureDate);

  SearchPageDeclaration({
    required DateTime arrivalDates,
    required DateTime departureDates,
    required String payouts,
    required DeclarationStatus status,
    required int declarationIndex,
    required DeclarationType type,
    required int? serialNumber,
  })  : _arrivalDate = arrivalDates,
        _departureDate = departureDates,
        _declarationIndex = declarationIndex,
        _status = status,
        _payout = payouts,
        _type = type,
        _serialNumber = serialNumber;

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
