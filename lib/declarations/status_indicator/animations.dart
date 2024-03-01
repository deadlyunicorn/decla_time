import "package:decla_time/declarations/status_indicator/custom_animation_controller.dart";
import "package:flutter/material.dart";

class SyncingAnimatedIcon extends StatefulWidget {
  const SyncingAnimatedIcon({
    super.key,
  });

  @override
  State<SyncingAnimatedIcon> createState() => _SyncingAnimatedIconState();
}

class _SyncingAnimatedIconState extends State<SyncingAnimatedIcon>
    with TickerProviderStateMixin {
  late final CustomAnimationController animationController =
      CustomAnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: animationController,
    curve: Curves.linear,
  );

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    animationController.repeat(reverse: true);

    return RotationTransition(
      turns: _animation,
      child: const Icon(
        Icons.sync,
      ),
    );
  }
}

class AnimationTest1 extends StatelessWidget {
  const AnimationTest1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: (() async* {
        double i = 0;
        while (true) {
          yield i++;
          await Future<void>.delayed(const Duration(milliseconds: 600));
        }
      })(),
      builder: (BuildContext context, AsyncSnapshot<double> snapshot) =>
          AnimatedRotation(
        duration: const Duration(milliseconds: 600),
        turns: 0.1 * (snapshot.data ?? 0),
        child: const Icon(
          Icons.read_more,
        ),
      ),
    );
  }
}

class AnimationTest3 extends StatelessWidget {
  const AnimationTest3({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: (() async* {
        double i = 0;
        while (true) {
          yield i++;
          await Future<void>.delayed(const Duration(milliseconds: 600));
        }
      })(),
      builder: (BuildContext context, AsyncSnapshot<double> snapshot) =>
          AnimatedCrossFade(
        firstChild: AnimatedCrossFade(
          crossFadeState: (snapshot.data ?? 0) % 3 == 0
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 600),
          firstChild: const Icon(Icons.wifi_1_bar),
          // turns: 0.1 * (snapshot.data ?? 0),
          secondChild: const Icon(Icons.wifi_2_bar),
        ),
        secondChild: const Icon(Icons.wifi),
        crossFadeState: (snapshot.data ?? 3) % 3 == 2
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 600),
      ),
    );
  }
}
