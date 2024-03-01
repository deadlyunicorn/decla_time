import "package:decla_time/core/extensions/capitalize.dart";
import "package:flutter/material.dart";

class RouteOutline extends StatelessWidget {
  const RouteOutline({
    required this.title,
    required this.child,
    super.key,
    void Function()? onExit,
  }) : _onExit = onExit;

  final String title;
  final Widget child;
  final void Function()? _onExit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              Navigator.pop(context);
              if (_onExit != null) _onExit();
            },
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          centerTitle: true,
          title: FittedBox(child: Text(title.capitalized)),
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
