
import 'package:flutter/material.dart';

class IdField extends StatelessWidget {
  const IdField({
    super.key,
    required this.idController,
  });

  final TextEditingController idController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: idController,
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          if (value.length < 6) {
            return "Insert atleast 6 characters";
          } else {
            return null;
          }
        } else {
          return "Must not be empty";
        }
      },
    );
  }
}
