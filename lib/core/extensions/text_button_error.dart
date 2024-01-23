import 'package:flutter/material.dart';

extension TextButtonError on ThemeData {
  TextButtonThemeData get textButtonErrorTheme => TextButtonThemeData(
        style: TextButton.styleFrom().copyWith(
          overlayColor: MaterialStateColor.resolveWith((states){
                if ( states.contains( MaterialState.pressed)   ){
                  return const Color.fromARGB(255, 199, 11, 68).withAlpha( 16 );
                }
                else if ( states.contains( MaterialState.hovered )  ){
                  return const Color.fromARGB(255, 199, 11, 68).withAlpha( 16 );
                }
                else{
                  return const Color(0xFF040412);
                }
              }),
        )
      );
}
