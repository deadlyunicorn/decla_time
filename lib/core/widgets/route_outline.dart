import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      title.capitalized,
                      style: Theme.of(context).textTheme.headlineLarge,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox.square(dimension: 16),
                  Expanded(child: child)
                ],
              ),
            ),
          )),
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
