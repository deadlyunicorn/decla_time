import "package:decla_time/declarations/status_indicator_declare/status_indicator.dart";
import "package:decla_time/declarations/status_indicator_import/status_indicator.dart";
import "package:decla_time/skeleton/access_users_drawer.dart";
import "package:decla_time/skeleton/custom_bottom_navigation_bar.dart";
import "package:decla_time/skeleton/floating_action_button/custom_floating_action_button.dart";
import "package:decla_time/skeleton/select_page_to_display.dart";
import "package:decla_time/skeleton/selected_page_controller.dart";
import "package:decla_time/users/drawer/users_drawer.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class Skeleton extends StatefulWidget {
  const Skeleton({super.key});

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localized = AppLocalizations.of(context)!;

    return SafeArea(
      child: ChangeNotifierProvider<SelectedPageController>(
        create: (_) =>
            SelectedPageController(scrollController: scrollController),
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              Positioned.fill(
                child: SelectPageToDisplay(
                  scrollController: scrollController,
                  localized: localized,
                ),
              ),
              Positioned(
                bottom: 32,
                right: 16,
                child: CustomFloatingActionButton(
                  localized: localized,
                ),
              ),
              Positioned.fill(
                child: UsersDrawerAccess(
                  localized: localized,
                ),
              ),
              Positioned.fill(
                child: Stack(
                  children: <Widget>[
                    StatusIndicatorImport(
                      localized: localized,
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: Stack(
                  children: <Widget>[
                    StatusIndicatorSubmit(
                      localized: localized,
                    ),
                  ],
                ),
              ),
              // const ButtonForTests(),
            ],
          ),
          drawer: UsersDrawer(
            localized: localized,
          ),
          bottomNavigationBar: CustomBottomNavigationBar(
            localized: localized,
          ),
        ),
      ),
    );
  }
}
