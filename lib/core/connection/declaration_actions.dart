import 'package:isar/isar.dart';

class DeclarationActions {
  final Future<Isar> _isarFuture;
  final void Function() _notifyListeners;

  DeclarationActions({required isarFuture, required notifyListeners})
      : _isarFuture = isarFuture,
        _notifyListeners = notifyListeners;
  
}
