import "dart:math";

import "package:decla_time/app_disclaimer.dart";
import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/declarations/status_indicator_declare/declaration_submit_controller.dart";
import "package:decla_time/declarations/status_indicator_import/declarations_import_route/declaration_import_controller.dart";
import "package:decla_time/settings.dart";
import "package:decla_time/skeleton/skeleton.dart";
import "package:decla_time/users/users_controller.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SettingsController settingsController = SettingsController();
  await settingsController.loadSettings();

  final IsarHelper isarHelper = IsarHelper();
  final UsersController usersController =
      await UsersController.initialize(isarHelper);

  runApp(
    MyApp(
      settingsController: settingsController,
      isarHelper: isarHelper,
      usersController: usersController,
    ),
  );
}

class MyApp extends StatelessWidget {
  final SettingsController settingsController;
  final IsarHelper isarHelper;
  final UsersController usersController;

  const MyApp({
    required this.settingsController,
    required this.isarHelper,
    required this.usersController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // ignore: always_specify_types
      providers: [
        ChangeNotifierProvider<SettingsController>(
          create: (BuildContext context) => settingsController,
        ),
        ChangeNotifierProvider<IsarHelper>(
          create: (BuildContext context) => isarHelper,
        ),
        ChangeNotifierProvider<UsersController>(
          create: (BuildContext context) => usersController,
        ),
        ChangeNotifierProvider<DeclarationImportController>(
          create: (BuildContext context) =>
              DeclarationImportController(isarHelper: isarHelper),
        ),
        ChangeNotifierProvider<DeclarationSubmitController>(
          create: (BuildContext context) => DeclarationSubmitController(),
        ),
      ],
      builder: (BuildContext context, Widget? child) =>
          Consumer<SettingsController>(
        builder:
            (BuildContext context, SettingsController value, Widget? child) =>
                MaterialApp(
          title: "DeclaTime",
          darkTheme: darkTheme(context),
          themeMode: ThemeMode.dark,
          home: FutureBuilder<bool>(
            future: settingsController.hasAcceptedDisclaimer(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              return MainApp(
                hasAcceptedDisclaimer: snapshot.data ?? false,
              );
            },
          ),
          locale: Locale(settingsController.locale),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
  }

  static const Color _white = Color.fromARGB(255, 218, 216, 248);
  static const Color _primary = Color(0xFF3B197B);
  static const Color _secondary = Color(0xFF2619B4);
  static const Color _tetriary = Color.fromARGB(255, 13, 181, 97);
  static const Color _background = Color(0xFF040412);
  static const Color _error = Color.fromARGB(255, 199, 11, 68);

  ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      fontFamily: "SourceSans",
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: _primary,
        onPrimary: _white,
        secondary: _secondary,
        onSecondary: _white,
        error: _error,
        onError: _white,
        background: _background,
        onBackground: _white,
        surface: _tetriary,
        onSurface: _white,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _tetriary,
        foregroundColor: _white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _background,
        selectedItemColor: _tetriary,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          letterSpacing: 0.7,
          fontSize: 56,
          fontWeight: FontWeight.w900,
        ),
        headlineMedium: TextStyle(
          letterSpacing: 0.7,
          fontWeight: FontWeight.w800,
          fontSize: 48,
        ),
        headlineSmall: TextStyle(
          letterSpacing: 0.7,
          fontWeight: FontWeight.w800,
          fontSize: 36,
        ),
        bodyLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
      appBarTheme: const AppBarTheme(backgroundColor: _primary),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: Theme.of(context).textTheme.bodySmall,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          foregroundColor: _tetriary,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        width: min(kMaxWidthMedium, MediaQuery.sizeOf(context).width - 64),
        backgroundColor: _secondary,
        contentTextStyle: const TextStyle(color: _white),
      ),
      datePickerTheme: const DatePickerThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        backgroundColor: _background,
        dividerColor: Colors.transparent,
        todayBorder: BorderSide(style: BorderStyle.none),
        todayForegroundColor: MaterialStatePropertyAll<Color>(_tetriary),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(
            _background.withOpacity(0.94),
          ),
        ),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          foregroundColor: _tetriary,
          backgroundColor: _secondary.withAlpha(64),
        ).copyWith(
          overlayColor:
              MaterialStatePropertyAll<Color>(_secondary.withAlpha(64)),
        ),
      ),
      menuBarTheme: const MenuBarThemeData(
        style: MenuStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(_background),
          padding:
              MaterialStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.zero),
        ),
      ),
      menuTheme: const MenuThemeData(
        style: MenuStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(Colors.transparent),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      useMaterial3: true,
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({
    required this.hasAcceptedDisclaimer,
    super.key,
  });

  final bool hasAcceptedDisclaimer;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localized = AppLocalizations.of(context)!;

    return hasAcceptedDisclaimer
        ? Skeleton(
            localized: localized,
          )
        : AppDisclaimer(
            localized: localized,
          );
  }
}
