import "package:decla_time/core/enums/booking_platform.dart";
import "package:intl/intl.dart";

class DeclarationBody {
  final String platform;
  final DateTime arrivalDate;
  final DateTime departureDate;
  final double payout;
  final DateTime? cancellationDate;
  final double? cancellationAmount;

  DeclarationBody({
    required this.arrivalDate,
    required this.departureDate,
    required this.payout,
    required this.platform,
    required this.cancellationDate,
    required this.cancellationAmount,
  });

  int get _translatedPlatform {
    final String platformName = platform.toLowerCase();

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

  String bodyStringPOST(String viewStateParsed) {
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

    // ignore: lines_longer_than_80_chars
    return "appForm%3ArentalFrom_input=${translateDate(arrivalDate)}&appForm%3ArentalTo_input=${translateDate(departureDate)}&appForm%3AsumAmount_hinput=${payout ?? ""}&appForm%3Aplatform_input=$_translatedPlatform&appForm%3AcancelAmount_hinput=${cancellationAmount ?? ""}&appForm%3AcancelDate_input=${cancellationDate != null ? translateDate(cancellationDate!) : ""}&appForm%3ArenterAfm=000000000&appForm%3ApaymentType_focus=&appForm%3ApaymentType_input=4&appForm%3Aplatform_focus=&appForm%3Aj_idt93=&javax.faces.ViewState=$viewStateParsed&javax.faces.partial.ajax=true&javax.faces.source=appForm%3AsaveButton&javax.faces.partial.execute=%40all&javax.faces.partial.render=appForm&appForm%3AsaveButton=appForm%3AsaveButton&appForm=appForm";
  }

  static String get declarationCreationBody {
    // ignore: lines_longer_than_80_chars
    return "javax.faces.partial.ajax=true&javax.faces.source=appForm%3AnewDeclarationButtonLower&javax.faces.partial.execute=%40all&appForm%3AnewDeclarationButtonLower=appForm%3AnewDeclarationButtonLower&appForm=appForm";
  }

  static BookingPlatform extractBookingPlatform(String text) {
    final String textToLowercase = text.toLowerCase();

    if (textToLowercase.contains("airbnb")) {
      return BookingPlatform.airbnb;
    } else if (textToLowercase.contains("booking")) {
      return BookingPlatform.booking;
    } else if (textToLowercase.contains("clickstay")) {
      return BookingPlatform.clickstay;
    } else if (textToLowercase.contains("homeaway")) {
      return BookingPlatform.homeaway;
    } else if (textToLowercase.contains("homestay")) {
      return BookingPlatform.homestay;
    } else if (textToLowercase.contains("luxury")) {
      return BookingPlatform.luxury;
    } else if (textToLowercase.contains("apartments")) {
      return BookingPlatform.apartments;
    } else if (textToLowercase.contains("tripadvisor")) {
      return BookingPlatform.tripadvisor;
    } else {
      return BookingPlatform.other;
    }
  }

}
