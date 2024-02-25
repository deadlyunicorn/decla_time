//? Tests
import "package:decla_time/core/extensions/get_values_between_strings.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  test("Testing if get values from html works", () {
    final List<String> values = getAllBetweenStrings(
      "value=[4211]asderq value=[4311]asderqvalue=[4611]asderqvalue=[4711]",
      "[",
      "]",
    );

    expect(values[2], "4611");
  });
}
