import 'package:decla_time/analytics/analytics_page.dart';
import 'package:decla_time/core/enums/selected_page.dart';
import 'package:decla_time/declarations/declarations_page.dart';
import 'package:decla_time/reservations/reservations_page.dart';
import 'package:flutter/material.dart';

class SelectPageToDisplay extends StatelessWidget {

  final SelectedPage selectedPage;

  const SelectPageToDisplay( { super.key, required this.selectedPage });

  @override
  Widget build(BuildContext context) {

    switch( selectedPage ){

      case SelectedPage.reservations:
        return const ReservationsPage();
      case SelectedPage.declarations:
        return const DeclarationsPage();
      case SelectedPage.analytics:
        return const AnalyticsPage();
      
    }
  }
}
