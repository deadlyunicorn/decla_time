import 'dart:math';
import 'package:flutter/material.dart';

class ImportManuallyButton extends StatelessWidget {
  const ImportManuallyButton({
    super.key,
    required this.description,
    required this.icon,
    required this.onTap,
    this.children,
  });

  final String description;
  final IconData icon;
  final void Function() onTap;
  final List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    final dimension = min(
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
            children: [
              Positioned(
                left: dimension < 140 ? 8 : null, 
                top: dimension < 140 ? 8 : null,
                child: Icon(
                  icon,
                  size: dimension < 140 ? 32 : 48,
                ),
              ),
              Positioned(
                bottom: 8,
                child: SizedBox(
                  width: dimension,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              ...?children
            ],
          ),
        ),
      ),
    );
  }
}
