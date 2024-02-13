import 'package:flutter_test/flutter_test.dart';

List<String> getAllBetweenStrings(
    String html, String startingString, String endingString) {
  final values = <String>[];

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
    String html, String startingString, String endingString) {
  final startingIndex = html.indexOf(startingString) + startingString.length;

  return html.substring(
    startingIndex,
    html.indexOf(endingString, startingIndex),
  );
}

//? Tests
void main() {
  test("Testing if get values from html works", () {
    final values = getAllBetweenStrings(
      "value=[4211]asderq value=[4311]asderqvalue=[4611]asderqvalue=[4711]",
      "[",
      "]",
    );

    expect(values[2], "4611");
  });
}