import "package:decla_time/core/functions/fasthash.dart";
import "package:isar/isar.dart";

part "reservation_place.g.dart";

@collection
class ReservationPlace {
  @Index(unique: true)
  final Id id;

  String friendlyName;

  ReservationPlace({required this.friendlyName}) : id = fastHash(friendlyName);
}
