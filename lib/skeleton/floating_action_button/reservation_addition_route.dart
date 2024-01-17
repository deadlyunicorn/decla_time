import 'dart:math';

import 'package:decla_time/core/widgets/route_outline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReservationAdditionRoute extends StatelessWidget {
  const ReservationAdditionRoute({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final localized = AppLocalizations.of(context)!;

    return RouteOutline(
      title: localized.addEntries,
      child: SizedBox(
        width: min(MediaQuery.sizeOf(context).width, 900),
        child: Column(
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 32,
              runSpacing: 32,
              children: [
                AdditionOptionContainer(
                  description: "Add from file",
                  icon: Icons.file_copy,
                  //functions to add...
                ),
                AdditionOptionContainer(
                  description: "Manual Entry",
                  icon: Icons.edit,
                ),
                
              ],
            ),
            Text(
              "Basically below the inserted entries will appear and the user will be able to select them.",
            )
          ],
        ),
      ),
    );
  }
}

class AdditionOptionContainer extends StatelessWidget {
  const AdditionOptionContainer(
      {super.key, required this.description, required this.icon});

  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final dimension = min(
            200,
            min(MediaQuery.sizeOf(context).width / 3,
                MediaQuery.sizeOf(context).height / 3))
        .toDouble();

    return Container(
      height: dimension,
      width: dimension,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.secondary),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            icon,
            size: 32,
          ),
          Positioned(
            bottom: 8,
            child: Text(description),
          ),
        ],
      ),
    );
  }
}
