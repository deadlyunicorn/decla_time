import "package:flutter/material.dart";

class YearTaxDetailsButton extends StatefulWidget {
  const YearTaxDetailsButton({
    required this.yearString,
    super.key,
  });

  final String yearString;

  @override
  State<YearTaxDetailsButton> createState() => _YearTaxDetailsButtonState();
}

class _YearTaxDetailsButtonState extends State<YearTaxDetailsButton> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onHover: (bool value) {
        setState(() {
          isHovered = value;
        });
      },
      onPressed: () {
        print(
            "Open a new page with the possible taxations based on total income");
      },
      child: AnimatedDefaultTextStyle(
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: isHovered ? 28 : 24,
              shadows: const <Shadow>[
                Shadow(blurRadius: 2, color: Colors.black),
              ],
            ) ??
            const TextStyle(),
        duration: const Duration(
          milliseconds: 240,
        ),
        child: Text(
          widget.yearString,
        ),
      ),
    );
  }
}
