extension CapitalizeString on String {
  String get capitalized => length > 1
      ? "${this[0].toUpperCase()}${substring(1).toLowerCase()}"
      : length == 1
          ? this[0].capitalized
          : "";

  String get capitalizedAll => length > 1
      ? (() {
          final tempString = [];
          for (int i = 0; i < runes.length; i++) {
            if (i == 0) {
              tempString.add(this[i].toUpperCase());
              continue;
            }
            tempString
                .add((this[i - 1] == " ") ? this[i].toUpperCase() : this[i]);
          }
          return tempString.join("");
        })()
      : length == 1
          ? this[0].capitalized
          : "";
}
