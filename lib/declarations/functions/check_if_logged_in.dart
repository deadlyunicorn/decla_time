import "package:decla_time/core/errors/exceptions.dart";

void checkIfLoggedIn(String body) {
  if (body.contains(
    "<b>Απαγορεύεται η μη εξουσιοδοτημένη χρήση αυτής της τοποθεσίας,<br/>η οποία μπορεί να επιφέρει αστική και ποινική δίωξη.</b>",
  )) {
    throw NotLoggedInException();
  }
}
