import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:flutter/material.dart';

class RouteOutline extends StatelessWidget {
  const RouteOutline({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          centerTitle: true,
          title: Text( title.capitalized ),
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: child,
        ),
      ),
    );
  }
}


                // final reservations = await ReservationFolderActions
                //     .generateReservationTableFromFile("booking_gr_3.csv");
                // if ( context.mounted ){
                //   context
                //     .read<IsarHelper>()
                //     .insertMultipleEntriesToDb(reservations);
                // }
