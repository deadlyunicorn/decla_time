import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StatusIndicator extends StatefulWidget {
  const StatusIndicator({
    super.key,
    required this.localized,
  });

  final AppLocalizations localized;
  static const double _buttonSize = 48;

  @override
  State<StatusIndicator> createState() => _StatusIndicatorState();
}

class _StatusIndicatorState extends State<StatusIndicator> {
  double rightOffset = 0;
  double topOffset = 0;

  @override
  Widget build(BuildContext context) {
    final isVisible = true; //context.select((value) => isUploading);
    const double padding = 8;
    return !isVisible
        ? SizedBox.shrink()
        : Positioned(
            left: min(MediaQuery.sizeOf(context).width - padding * 4,
                max(padding, rightOffset)),
            top: min(MediaQuery.sizeOf(context).height - 64 * 3 - padding,
                max(padding + 64, topOffset)),
            child: Container(
              height: StatusIndicator._buttonSize,
              width: StatusIndicator._buttonSize,
              color: Colors.transparent,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  setState(() {
                    rightOffset =
                        details.globalPosition.dx - StatusIndicator._buttonSize / 2;
                    topOffset =
                        details.globalPosition.dy - StatusIndicator._buttonSize / 2;
                  });
                },
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    rightOffset =
                        details.globalPosition.dx - StatusIndicator._buttonSize / 2;
                    topOffset =
                        details.globalPosition.dy - StatusIndicator._buttonSize / 2;
                  });
                },
                child: TextButton(
                  style: TextButton.styleFrom().copyWith(
                    shape: const MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.all( Radius.circular(StatusIndicator._buttonSize/2))
                    )) 
                  ),
                  onPressed: () {
                    print("hello");
                  },
                  child: StreamBuilder<double>(
                    stream: (() async* {
                      double i = 0;
                      while (true) {
                        yield i++;
                        await Future.delayed(const Duration(milliseconds: 600));
                      }
                    })(),
                    builder: (context, snapshot) => AnimatedRotation(
                      duration: const Duration(milliseconds: 600),
                      turns: 0.1 * (snapshot.data ?? 0),
                      child: const Icon(
                        Icons.read_more,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
