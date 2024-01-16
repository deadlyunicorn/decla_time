import 'package:decla_time/skeleton/skeleton.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeclaTime',
      darkTheme: darkTheme(),
      themeMode: ThemeMode.dark,
      home: const Skeleton(),
    );
  }

  ThemeData darkTheme() {
    return ThemeData(
      fontFamily: 'Ysabeau',
      colorScheme: const ColorScheme(
        brightness: Brightness.dark, 
        primary:  Color(0xFF3B197B), 
        onPrimary:  Color( 0xFFEAE9FC ), 
        secondary:  Color( 0xFF2619B4 ), 
        onSecondary:  Color(0xFFEAE9FC), 
        error:  Color.fromARGB(255, 199, 11, 68), 
        onError:  Color( 0xFFEAE9FC ), 
        background:  Color( 0xFF040412), 
        onBackground:  Color( 0xFFEAE9FC ), 
        surface:  Color( 0xFFB59C0D ), 
        onSurface:  Color(0xFFEAE9FC)
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color( 0xFFB59C0D ),
        foregroundColor: Color(0xFFEAE9FC)
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF04041A),
        selectedItemColor: Color( 0xFFB59C0D ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontFamily: "Do Hyeon",
          fontSize: 40
        ),
        headlineMedium: TextStyle(
          fontFamily: "Do Hyeon",
          fontSize: 32
        ),
        headlineSmall: TextStyle(
          fontFamily: "Do Hyeon",
        ),
        bodyLarge: TextStyle(
          fontSize: 24
        ),
        bodyMedium: TextStyle(
          fontSize: 16
        ),
        bodySmall: TextStyle(
          fontSize: 8
        )
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF3B197B)
      ),
      useMaterial3: true,
    );
  }
}
