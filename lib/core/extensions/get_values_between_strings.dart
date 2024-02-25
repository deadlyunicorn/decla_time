List<String> getAllBetweenStrings(
  String html,
  String startingString,
  String endingString,
) {
  final List<String> values = <String>[];

  for (int i = html.indexOf(startingString, 0);
      i > -1;
      i = html.indexOf(startingString, ++i)) {
    values.add(
      html.substring(
        i + startingString.length,
        html.indexOf(endingString, i + startingString.length),
      ),
    );
  }

  return values;
}

String getBetweenStrings(
  String html,
  String startingString,
  String endingString,
) {
  final int indexOfKeyword = html.indexOf(startingString);
  if (indexOfKeyword == -1) return "";
  final int targetStartingIndex = indexOfKeyword + startingString.length;

  return html.substring(
    targetStartingIndex,
    html.indexOf(endingString, targetStartingIndex),
  );
}
