import 'dart:math';

import 'package:decla_time/core/connection/isar_helper.dart';
import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/declarations/login/user_credentials_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:decla_time/settings.dart';
import 'package:decla_time/skeleton/skeleton.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsController = SettingsController();
  await settingsController.loadSettings();

  runApp(
    MyApp(
      settingsController: settingsController,
    ),
  );
}

class MyApp extends StatelessWidget {
  final SettingsController settingsController;

  const MyApp({super.key, required this.settingsController});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => settingsController),
        ChangeNotifierProvider(create: (context) => IsarHelper()),
        ChangeNotifierProvider(
          create: (context) => DeclarationsAccountNotifier(),
        ),
      ],
      builder: (context, child) => Consumer<SettingsController>(
        builder: (context, value, child) => MaterialApp(
          title: 'DeclaTime',
          darkTheme: darkTheme(context),
          themeMode: ThemeMode.dark,
          home: const Skeleton(),
          locale: Locale(settingsController.locale),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
  }

  static const _white = Color.fromARGB(255, 218, 216, 248);
  static const _primary = Color(0xFF3B197B);
  static const _secondary = Color(0xFF2619B4);
  static const _tetriary = Color.fromARGB(255, 13, 181, 97);
  static const _background = Color(0xFF040412);
  static const _error = Color.fromARGB(255, 199, 11, 68);

  ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      fontFamily: 'Ysabeau',
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
          onSurface: _white),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _tetriary,
        foregroundColor: _white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _background,
        selectedItemColor: _tetriary,
      ),
      textTheme: const TextTheme(
          headlineLarge: TextStyle(fontFamily: "Do Hyeon", fontSize: 40),
          headlineMedium: TextStyle(fontFamily: "Do Hyeon", fontSize: 32),
          headlineSmall: TextStyle(
            fontFamily: "Do Hyeon",
          ),
          bodyLarge: TextStyle(fontSize: 24),
          bodyMedium: TextStyle(fontSize: 16),
          bodySmall: TextStyle(fontSize: 16)),
      appBarTheme: const AppBarTheme(backgroundColor: _primary),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            foregroundColor: _tetriary),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        width: min(kMaxWidthMedium, MediaQuery.sizeOf(context).width - 64),
        backgroundColor: _secondary,
        contentTextStyle: const TextStyle(color: _white),
      ),
      datePickerTheme: const DatePickerThemeData(
        backgroundColor: _background,
        dividerColor: Colors.transparent,
        todayBorder: BorderSide(style: BorderStyle.none),
        todayForegroundColor: MaterialStatePropertyAll(_tetriary),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: MaterialStatePropertyAll(
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
            overlayColor: MaterialStatePropertyAll(_secondary.withAlpha(64))),
      ),
      useMaterial3: true,
    );
  }
}
