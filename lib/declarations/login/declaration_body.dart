import 'package:intl/intl.dart';

class DeclarationBody {
  final String platform;
  final DateTime arrivalDate;
  final DateTime departureDate;
  final double payout;
  final String? viewState;
  final DateTime? cancellationDate;
  final double? cancellationAmount;

  DeclarationBody({
    required this.arrivalDate,
    required this.departureDate,
    required this.payout,
    required this.platform,
    this.viewState,
    this.cancellationDate,
    this.cancellationAmount,
  });

  int get _translatedPlatform {
    final platformName = platform.toLowerCase();

    if (platformName.contains("airbnb")) {
      return 1;
    } else if (platformName.contains("booking")) {
      return 2;
    } else if (platformName.contains("clickstay")) {
      return 3;
    } else if (platformName.contains("homeaway")) {
      return 4;
    } else if (platformName.contains("homestay")) {
      return 5;
    } else if (platformName.contains("luxury")) {
      return 6;
    } else if (platformName.contains("apartments")) {
      return 7;
    } else if (platformName.contains("tripadvisor")) {
      return 8;
    } else {
      return 9;
    }
  }

  String translateDate(DateTime date) {
    return DateFormat("dd%2FMM%2Fy").format(date);
  }

  String get bodyString {
    double? payout = this.payout;

    if (cancellationAmount != null) {
      if (payout > 0) {
        throw ("Cancellation Amount while Payout > 0");
      }
      if (cancellationDate == null) {
        throw "Cancellation date missing";
      }
      payout = null;
    } else if (cancellationDate != null) {
      // && cancellation Amount == null
      throw "Cancellation date missing";
    }

    return "appForm%3ArentalFrom_input=${translateDate(arrivalDate)}&appForm%3ArentalTo_input=${translateDate(departureDate)}&appForm%3AsumAmount_hinput=${payout ?? ""}&appForm%3Aplatform_input=$_translatedPlatform&appForm%3AcancelAmount_hinput=${cancellationAmount ?? ""}&appForm%3AcancelDate_input=${cancellationDate != null ? translateDate(cancellationDate!) : ""}&appForm%3ArenterAfm=000000000&appForm%3ApaymentType_focus=&appForm%3ApaymentType_input=4&appForm%3Aplatform_focus=&appForm%3Aj_idt93=&${viewStateParsed}javax.faces.partial.ajax=true&javax.faces.source=appForm%3AsaveButton&javax.faces.partial.execute=%40all&javax.faces.partial.render=appForm&appForm%3AsaveButton=appForm%3AsaveButton&appForm=appForm";
  }

  String get submitReservationBody {
    double? payout = this.payout;

    if (cancellationAmount != null) {
      if (payout > 0) {
        throw ("Cancellation Amount while Payout > 0");
      }
      if (cancellationDate == null) {
        throw "Cancellation date missing";
      }
      payout = null;
    } else if (cancellationDate != null) {
      // && cancellation Amount == null
      throw "Cancellation date missing";
    }
    return "${viewStateParsed}appForm%3ArentalFrom_input=${translateDate(arrivalDate)}&appForm%3ArentalTo_input=${translateDate(departureDate)}&appForm%3AsumAmount_hinput=${payout ?? ""}&appForm%3Aplatform_input=$_translatedPlatform&appForm%3AcancelAmount_hinput=${cancellationAmount ?? ""}&appForm%3AcancelDate_input=${cancellationDate != null ? translateDate(cancellationDate!) : ""}&appForm%3ArenterAfm=000000000&appForm%3ApaymentType_focus=&appForm%3ApaymentType_input=4&appForm%3Aplatform_focus=&appForm%3Aj_idt93=&javax.faces.partial.ajax=true&javax.faces.source=appForm%3AsaveButton&javax.faces.partial.execute=%40all&javax.faces.partial.render=appForm&appForm%3AsaveButton=appForm%3AsaveButton&appForm=appForm&";
  }

  String get viewStateParsed => viewState == null 
    ? "" 
    : "javax.faces.ViewState=${viewState!.split(":")[0]}%3A${viewState!.split(":")[1] }&";

  static String get declarationCreationBody { 
    return "javax.faces.partial.ajax=true&javax.faces.source=appForm%3AnewDeclarationButtonLower&javax.faces.partial.execute=%40all&appForm%3AnewDeclarationButtonLower=appForm%3AnewDeclarationButtonLower&appForm=appForm";
  }
}
