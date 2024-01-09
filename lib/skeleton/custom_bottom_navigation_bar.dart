import 'package:decla_time/core/enums/selected_page.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {

  final void Function( int ) setSelectedPage;
  final SelectedPage selectedPage;

  const CustomBottomNavigationBar({ 
    super.key,
    required this.setSelectedPage,
    required this.selectedPage
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: setSelectedPage,
      items: const [
        BottomNavigationBarItem(
          icon: Icon( Icons.hotel ),
          label: "Reservations",
        ),
        BottomNavigationBarItem(
          icon: Icon( Icons.book ),
          label: "Declarations",
        ),
        BottomNavigationBarItem(
          icon: Icon( Icons.analytics ),
          label: "Analytics",
        )
      ],
      currentIndex: convertSelectedPageToIndex(selectedPage),
    );
  }
}