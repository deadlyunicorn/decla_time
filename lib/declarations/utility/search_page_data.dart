import 'package:decla_time/core/enums/declaration_status.dart';
import 'package:decla_time/core/extensions/get_values_between_strings.dart';
import 'package:decla_time/declarations/utility/search_page_declaration.dart';
import 'package:intl/intl.dart';

class SearchPageData {
  final List<SearchPageDeclaration> _declarations;
  final String _viewState;
  final int _total;

  SearchPageData(
      {required List<SearchPageDeclaration> declarations,
      required String viewState,
      required int total})
      : _declarations = declarations,
        _total = total,
        _viewState = viewState;

  List<SearchPageDeclaration> get declarations => _declarations;
  int get total => _total;

  String get viewStateParsed => _viewState.contains(":")
      ? "${_viewState.split(":")[0]}%3A${_viewState.split(":")[1]}"
      : _viewState;

  static SearchPageData getFromHtml(String body) {
    final List<DateTime> arrivalDates =
        getAllBetweenStrings(body, ':rentalFrom"', "</")
            .map(
              (arrivalDateString) =>
                  DateFormat('>dd/MM/y').parse(arrivalDateString),
            )
            .toList();
    final List<DeclarationStatus> statusList =
        getAllBetweenStrings(body, ':statusDescr"', "</span>")
            .map(
              (htmlSlice) => htmlSlice.contains("draft")
                  ? DeclarationStatus.temporary
                  : DeclarationStatus.finalized,
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

    if (arrivalDates.length != departureDates.length ||
        statusList.length != payouts.length ||
        payouts.length != arrivalDates.length) {
      throw "Invalid search page data";
    }

    final total = int.tryParse( getBetweenStrings(body, 'totalResults" class="ui-outputlabel ui-widget paginationLabel">', '</label>'));

    final List<SearchPageDeclaration> declarations = List.generate(
      arrivalDates.length,
      (index) => SearchPageDeclaration(
        arrivalDates: arrivalDates[index],
        declarationIndex: index,
        departureDates: departureDates[index],
        payouts: payouts[index],
        status: statusList[index],
      ),
    );

    final String viewState =
        getAllBetweenStrings(body, 'faces.ViewState" value="', '"')[0];
    return SearchPageData(
      total: total ?? 0 ,
      declarations: declarations,
      viewState: viewState,
    );
  }
}
