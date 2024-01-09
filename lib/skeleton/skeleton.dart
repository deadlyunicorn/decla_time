import 'package:decla_time/core/enums/selected_page.dart';
import 'package:decla_time/skeleton/custom_bottom_navigation_bar.dart';
import 'package:decla_time/skeleton/select_page_to_display.dart';
import 'package:flutter/material.dart';

class Skeleton extends StatefulWidget {

  const Skeleton({super.key});

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> {

  SelectedPage selectedPage = SelectedPage.reservations;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body: SelectPageToDisplay(selectedPage: selectedPage),
        floatingActionButton: CustomFloatingActionButton(selectedPage: selectedPage),
        bottomNavigationBar: CustomBottomNavigationBar(
          selectedPage: selectedPage,
          setSelectedPage: setSelectedPage
        ),
      ),
    );
  }

  void setSelectedPage( index ){
  
    setState(() {
      
      selectedPage = convertIndexToSelectedPage(index);
      
    });
  }
}

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
          height: 48,
          width: 48,
          duration: const Duration( milliseconds: 50),
          child: FloatingActionButton(
            onPressed: (){
              if ( selectedPage == SelectedPage.reservations ){
                //Add a new reservation entry to the local database
              }
              else{
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
          height: 10,
          width: 10,
          duration: const Duration( milliseconds: 50),
          child: FloatingActionButton(onPressed: (){}),
        );
    } 
    
  }
}


