import 'package:decla_time/core/enums/selected_page.dart';
import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {

  const CustomFloatingActionButton({
    super.key,
    required this.selectedPage,
  });

  final SelectedPage selectedPage;

  @override
  Widget build(BuildContext context) {

    switch( selectedPage ){
      case SelectedPage.reservations:
      case SelectedPage.declarations:
        return AnimatedContainer(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular( 16 ),
            color: Theme.of(context).colorScheme.surface,
          ),
          height: 48,
          width: 48,
          duration: const Duration( milliseconds: 50),
          child: FloatingActionButton(
            onPressed: (){
              if ( selectedPage == SelectedPage.reservations ){
                throw UnimplementedError();
                //Add a new reservation entry to the local database
              }
              else{
                throw UnimplementedError();
                //Create a new declaration to the external .gov
              }
            },
            tooltip: selectedPage == SelectedPage.reservations 
              ? "Add entries from file"
              : "New declaration",
            child: const Icon(Icons.add),
          ),
        );

      case SelectedPage.analytics:
        return AnimatedContainer(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular( 8 ),
            color: Theme.of(context).colorScheme.surface,
          ),
          height: 16,
          width: 16,
          duration: const Duration( milliseconds: 50),
          child: const SizedBox.shrink(),
        );
    } 
    
  }
}


