// ignore_for_file: prefer_const_declarations, non_constant_identifier_names, avoid_print

import 'get_values_between_strings.dart';
import 'package:intl/intl.dart';

class DeclarationListPageData {
  final List<DateTime> _arrivalDates;
  final List<DateTime> _departureDates;
  final List<String> _payouts;
  final String _viewState;

  DeclarationListPageData({
    required List<DateTime> arrivalDates,
    required List<DateTime> departureDates,
    required List<String> payouts,
    required String viewState,
  })  : _arrivalDates = arrivalDates,
        _departureDates = departureDates,
        _payouts = payouts,
        _viewState = viewState;

  List<DateTime> get arrivalDates => _arrivalDates;
  List<DateTime> get departureDates => _departureDates;
  List<String> get payouts => _payouts;
  String get viewState => _viewState;

  String get viewStateParsed => "javax.faces.ViewState=${_viewState.split(":")[0]}%3A${_viewState.split(":")[1] }&";


  static DeclarationListPageData getFromHtml(String body) {
    final List<DateTime> arrivalDates =
        getAllBetweenStrings(body, ':rentalFrom"', "</")
            .map(
              (arrivalDateString) =>
                  DateFormat('>dd/MM/y').parse(arrivalDateString),
            )
            .toList();

    final List<DateTime> departureDates =
        getAllBetweenStrings(body, ':rentalTo"', "</")
            .map(
              (departureDateString) =>
                  DateFormat('>dd/MM/y').parse(departureDateString),
            )
            .toList();

    final List<String> payouts = getAllBetweenStrings(body, ':sumAmount"', "</")
        .map((payout) => payout.substring(1))
        .toList();

    final String viewState =
        getAllBetweenStrings(body, 'faces.ViewState" value="', '"')[0];
    return DeclarationListPageData(
      arrivalDates: arrivalDates,
      departureDates: departureDates,
      payouts: payouts,
      viewState: viewState,
    );
  }
}
