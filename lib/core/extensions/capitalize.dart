extension CapitalizeString on String{

  String get capitalized  => length > 1 
    ? "${this[0].toUpperCase()}${substring(1).toLowerCase()}"
    : length == 1 
      ? this[0].capitalized
      : "";
}