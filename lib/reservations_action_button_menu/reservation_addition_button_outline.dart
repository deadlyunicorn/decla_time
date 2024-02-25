import "dart:math";
import "package:flutter/material.dart";

class ReservationAdditionButtonOutline extends StatelessWidget {
  const ReservationAdditionButtonOutline({
    required this.description,
    required this.icon,
    required this.onTap,
    super.key,
    this.children,
  });

  final String description;
  final IconData icon;
  final void Function() onTap;
  final List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    final double dimension = min(
      160,
      min(
        MediaQuery.sizeOf(context).width / 3,
        MediaQuery.sizeOf(context).height / 3,
      ),
    ).toDouble();

    return SizedBox(
      height: dimension,
      width: dimension,
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        color: Theme.of(context).colorScheme.secondary,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: FittedBox(
                          child: Icon(
                            icon,
                            size: dimension < 140 ? 32 : 48,
                          ),
                        ),
                      ),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              description.replaceAll(" ", "\n"),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ...?children,
            ],
          ),
        ),
      ),
    );
  }
}
