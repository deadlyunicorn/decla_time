import 'package:decla_time/core/functions/fasthash.dart';
import 'package:decla_time/declarations/database/user/property.dart';
import 'package:isar/isar.dart';

part 'user.g.dart';

@collection
class User {

  String username;
  List<Property> properties = [];

  Id get isarId => fastHash( username );

  User({
    required this.username
  });
}