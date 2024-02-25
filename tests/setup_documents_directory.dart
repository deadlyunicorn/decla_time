import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";

const String testMockDirectory = "./tests/mockFs";

void setUpDocumentsDirectoryForTesting() {
  TestWidgetsFlutterBinding.ensureInitialized();

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel(
      "plugins.flutter.io/path_provider",
    ),
    (MethodCall message) async => testMockDirectory,
  );
}
