// ignore_for_file: prefer_const_declarations, non_constant_identifier_names, avoid_print

import 'get_values_from_html.dart';

class UserPropertiesInformation {

  final List<String> _atakNumbers;
  final List<String> _propertyIds;
  final List<String> _addressOfProperties;
  final List<String> _registryNumbers;

  UserPropertiesInformation(
    this._atakNumbers,
    this._propertyIds,
    this._addressOfProperties,
    this._registryNumbers,
  );

  static UserPropertiesInformation generateFromHtml(String body) {
    final propertyIds = getValuesFromHtml(body, "propertyId',value:'", "'}");
    final atakNumbers =
        getValuesFromHtml(body, 'atakOutput" style="width:90px;">', "</span>");
    final addressOfProperties = getValuesFromHtml(body, 'addressOutput">', "<")
        .map((addressEntry) => addressEntry.trim())
        .toList();
    final registryNumbers =
        getValuesFromHtml(body, 'amaOutput" style="width:90px;">', '<');
    return UserPropertiesInformation(
        atakNumbers, propertyIds, addressOfProperties, registryNumbers);
  }

  List<String> get atakNumbers => _atakNumbers;
  List<String> get propertyIds => _propertyIds;
  List<String> get addressOfProperties => _addressOfProperties;
  List<String> get registryNumbers => _registryNumbers;
}
