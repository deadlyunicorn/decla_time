import "package:flutter/material.dart";

class DeclarationSubmitController extends ChangeNotifier {
  
  //* Submit Operations
  
  bool _isSubmitting = false;

  bool get isSubmitting => _isSubmitting;
  set setSubmit(bool newStatus) {
    _isSubmitting = newStatus;
    notifyListeners();
  }
  //? Submit Operations *//


}
