import "package:decla_time/core/functions/fasthash.dart";
import "package:isar/isar.dart";

part "user.g.dart";

@collection
class User {

  @Index(unique: true)
  String username;
  List<String> propertyIds;

  Id get isarId => fastHash(username);

  User({
    required this.username, required this.propertyIds,
  });
}
