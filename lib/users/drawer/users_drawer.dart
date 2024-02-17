import 'package:decla_time/users/drawer/drawer_outline.dart';
import 'package:flutter/material.dart';

class UsersDrawer extends StatelessWidget {
  const UsersDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DrawerOutline(
      child: Column(
                children: [
                  Text("Users",style: Theme.of(context).textTheme.headlineMedium,),
                  Text("Hello world"),
                  Text("Hello world"),
                  Text("Hello world"),
                ],
              ),
    );
  }
}
