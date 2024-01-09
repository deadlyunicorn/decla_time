import 'package:decla_time/core/enums/selected_page.dart';
import 'package:decla_time/skeleton/custom_bottom_navigation_bar.dart';
import 'package:decla_time/skeleton/custom_floating_action_button.dart';
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
        floatingActionButton: CustomFloatingActionButton(
          selectedPage: selectedPage,
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          selectedPage: selectedPage,
          setSelectedPage: setSelectedPage,
        ),
      ),
    );
  }

  void setSelectedPage(index) {
    setState(() {
      selectedPage = convertIndexToSelectedPage(index);
    });
  }
}
