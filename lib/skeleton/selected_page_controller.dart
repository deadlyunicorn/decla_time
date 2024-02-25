import "package:decla_time/core/enums/selected_page.dart";
import "package:flutter/material.dart";

class SelectedPageController extends ChangeNotifier{

  SelectedPage _selectedPage = SelectedPage.reservations;
  final ScrollController _scrollController;
  SelectedPageController({
   required ScrollController scrollController,
  }
  ):_scrollController = scrollController;

  SelectedPage get selectedPage => _selectedPage;
  int get selectedPageIndex => convertSelectedPageToIndex(_selectedPage);

  void setSelectedPageByIndex( int newPageIndex) {
    final SelectedPage newPage = convertIndexToSelectedPage(newPageIndex);

    if (_selectedPage != newPage) {
        _selectedPage = newPage;
        notifyListeners();
    } else {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 480),
          curve: Curves.decelerate,
        );
      }
    }
  }

  void setSelectedPage( SelectedPage newPage ) {
    if (_selectedPage != newPage) {
        _selectedPage = newPage;
        notifyListeners();
    } else {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 480),
          curve: Curves.decelerate,
        );
      }
    }
  }



}