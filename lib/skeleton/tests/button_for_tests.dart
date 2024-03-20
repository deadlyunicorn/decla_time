import "package:decla_time/core/functions/snackbars.dart";
import "package:decla_time/users/users_controller.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class ButtonForTests extends StatelessWidget {
  const ButtonForTests({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          color: Colors.redAccent.shade700,
          child: TextButton(
            onPressed: () async {
              final LoggedUser user =
                  context.read<UsersController>().loggedUser;
              if (user.headers != null) {
                final String? propertyId = context
                    .read<UsersController>()
                    .selectedProperty
                    ?.propertyId;
                if (propertyId == null) {
                  showErrorSnackbar(
                    context: context,
                    message: "No property selected",
                  );
                  return;
                }
                throw UnimplementedError();
              }
            },
            child: const Text("Test Button"),
          ),
        ),
      ),
    );
  }
}

///Can throw `UnknownErrorException`.

