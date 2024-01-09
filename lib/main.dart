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
      darkTheme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.dark, 
          primary:  Color( 0xFF2619B4 ), 
          onPrimary:  Color( 0xFFEAE9FC ), 
          secondary:  Color(0xFF3B197B), 
          onSecondary:  Color(0xFFEAE9FC), 
          error:  Color( 0xFF9E0030 ), 
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
          selectedItemColor: Color( 0xFFB59C0D )
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      home: const Skeleton(),
    );
  }
}
