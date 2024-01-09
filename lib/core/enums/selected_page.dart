enum SelectedPage {
  reservations,
  declarations,
  analytics
}

int convertSelectedPageToIndex( SelectedPage selectedPage ){
  
  switch( selectedPage ){
    case SelectedPage.reservations:
      return 0;
    case SelectedPage.declarations:
      return 1;
    case SelectedPage.analytics:
      return 2;
  }

}

SelectedPage convertIndexToSelectedPage( int index ){
  

  switch( index ){
    case 0:
      return SelectedPage.reservations;
    case 1:
      return SelectedPage.declarations;
    case 2:
      return SelectedPage.analytics;
    default:
      return SelectedPage.reservations;
  }

} 