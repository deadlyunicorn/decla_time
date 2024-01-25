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
        appBar: AppBar(),
        body: Align(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all( 16.0),
                child: Center(
                  child: Text(
                    title.capitalized,
                    style: Theme.of(context).textTheme.headlineLarge,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox.square(dimension: 32),
              Expanded(child: child)
            ],
          ),
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
