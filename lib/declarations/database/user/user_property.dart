import "package:decla_time/core/extensions/get_values_between_strings.dart";
import "package:decla_time/core/functions/fasthash.dart";
import "package:isar/isar.dart";

part "user_property.g.dart";

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

  static List<UserProperty> generateFromHtml(String body) {
    final List<String> propertyIds =
        getAllBetweenStrings(body, "propertyId',value:'", "'}");
    if (propertyIds.isEmpty) return <UserProperty>[];
    final List<String> atakNumbers = getAllBetweenStrings(
      body,
      'atakOutput" style="width:90px;">',
      "</span>",
    );
    final List<String> addressOfProperties =
        getAllBetweenStrings(body, 'addressOutput">', "<")
            .map((String addressEntry) => addressEntry.trim())
            .toList();
    final List<String> registryNumbers =
        getAllBetweenStrings(body, 'amaOutput" style="width:90px;">', "<");

    if (propertyIds.length != atakNumbers.length &&
        atakNumbers.length != addressOfProperties.length &&
        addressOfProperties.length != registryNumbers.length) {
      return <UserProperty>[];
    } else {
      final List<UserProperty> properties = <UserProperty>[];
      for (int i = 0; i < propertyIds.length; i++) {
        properties.add(
          UserProperty(
            propertyId: propertyIds[i],
            address: addressOfProperties[i],
            atak: atakNumbers[i],
            serialNumber: registryNumbers[i],
          ),
        );
      }
      return properties;
    }
  }
}
