import "dart:math";

extension ToStringMax60 on Object {
  String get toStringMax60 => toString().substring(
        0,
        min(toString().length, 60),
      );
}
