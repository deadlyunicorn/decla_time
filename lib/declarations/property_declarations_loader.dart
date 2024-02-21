import 'package:decla_time/core/connection/isar_helper.dart';
import 'package:decla_time/users/users_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PropertyDeclarationsLoader extends StatelessWidget {
  const PropertyDeclarationsLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final selectedPropertyId = context.select<UsersController, String>((controller) => controller.selectedProperty);

    return FutureBuilder(
      future: context.read<IsarHelper>().declarationActions.getAllEntriesFromDeclarations(),
      builder: (context, snapshot) {
        if ( snapshot.connectionState == ConnectionState.done ){
          return Text("No declarations found");
          //TODO here!
        }
        else{
          return CircularProgressIndicator();
        }
      },
    );
  }
}
