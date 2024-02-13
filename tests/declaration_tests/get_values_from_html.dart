import 'package:flutter_test/flutter_test.dart';

List<String> getValuesFromHtml(
    String html, String startingString, String endingString) {
  final values = <String>[];

  for (int i = html.indexOf(startingString, 0);
      i > -1;
      i = html.indexOf(startingString, ++i)) {
    values.add(
      html.substring(
        i + startingString.length,
        html.indexOf(endingString, i),
      ),
    );
  }

  return values;
}

//? Tests
void main() {
  test("Testing if get values from html works", () {
    final values = getValuesFromHtml(
      "value=[4211]asderq value=[4311]asderqvalue=[4611]asderqvalue=[4711]",
      "[",
      "]",
    );

    expect(values[2], "4611");
  });
}
