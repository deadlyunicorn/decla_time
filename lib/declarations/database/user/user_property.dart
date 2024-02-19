import 'package:decla_time/core/functions/fasthash.dart';
import 'package:isar/isar.dart';

part 'user_property.g.dart';

@collection
class UserProperty {
  //!!! DONT NAME YOUR COLLECTION "PROPERTY" :))))))))

  @Index(unique: true)
  final String propertyId;
  final String address;

  final String atak;
  final String serialNumber;

  String? friendlyName;

  Id get isarId => fastHash(propertyId);

  UserProperty({
    required this.propertyId,
    required this.address,
    required this.atak,
    required this.serialNumber,
    this.friendlyName,
  });
}
