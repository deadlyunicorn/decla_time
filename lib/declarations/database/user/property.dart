import 'package:isar/isar.dart';

part 'property.g.dart';

@embedded
class Property {
  final String propertyId;
  final String address;
  final String atak;
  final String serialNumber;

  Property():address = "DEFAULT", propertyId = "DEFAULT", atak = "DEFAULT", serialNumber = "DEFAULT";

  Property.build({
    required this.propertyId,
    required this.address,
    required this.atak,
    required this.serialNumber,
  });
}
