import 'package:decla_time/core/enums/selected_page.dart';
import 'package:decla_time/skeleton/custom_bottom_navigation_bar.dart';
import 'package:decla_time/skeleton/floating_action_button/custom_floating_action_button.dart';
import 'package:decla_time/skeleton/select_page_to_display.dart';
import 'package:decla_time/skeleton/access_users_drawer.dart';
import 'package:decla_time/users/drawer/users_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Skeleton extends StatefulWidget {
  const Skeleton({super.key});

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> {
  SelectedPage selectedPage = SelectedPage.reservations;
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final localized = AppLocalizations.of(context)!;

    return SafeArea(
      child: Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: SelectPageToDisplay(
                  scrollController: scrollController,
                  selectedPage: selectedPage,
                  localized: localized,
                ),
              ),
              Positioned(
                bottom: 32,
                right: 16,
                child: CustomFloatingActionButton(
                  localized: localized,
                  selectedPage: selectedPage,
                ),
              ),
              Positioned.fill(
                child: UsersDrawerAccess(
                  localized: localized,
                ),
              ),
            ],
          ),
          drawer: const UsersDrawer(),
          bottomNavigationBar: CustomBottomNavigationBar(
            localized: localized,
            selectedPage: selectedPage,
            setSelectedPage: setSelectedPage,
          )),
    );
  }

  void setSelectedPage(newPageIndex) {
    final newPage = convertIndexToSelectedPage(newPageIndex);

    if (selectedPage != newPage) {
      setState(() {
        selectedPage = newPage;
      });
    } else {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 480),
          curve: Curves.decelerate,
        );
      }
    }
  }
}
