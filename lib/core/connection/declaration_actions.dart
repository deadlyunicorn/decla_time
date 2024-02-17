import 'package:decla_time/core/errors/exceptions.dart';
import 'package:decla_time/declarations/database/user/user.dart';
import 'package:decla_time/declarations/database/user/user_property.dart';
import 'package:isar/isar.dart';

class DeclarationActions {
  final Future<Isar> _isarFuture;
  final void Function() _notifyListeners;

  DeclarationActions({required isarFuture, required notifyListeners})
      : _isarFuture = isarFuture,
        _notifyListeners = notifyListeners;
  UserActions get userActions => UserActions(
        isarFuture: _isarFuture,
        notifyListeners: _notifyListeners,
      );
}

class UserActions {
  final Future<Isar> _isarFuture;
  final void Function() _notifyListeners;

  UserActions({required isarFuture, required notifyListeners})
      : _isarFuture = isarFuture,
        _notifyListeners = notifyListeners;

  Future<List<User>> getAll() async {
    return (await _isarFuture).users.where().findAll();
  }

  Future<void> add({
    required String username,
  }) async {
    final isar = await _isarFuture;
    isar.writeTxn(() async {
      await isar.users.put(User(username: username, propertyIds: []));
    });
    _notifyListeners();
  }

  Future<void> addProperty({
    required String username,
    required UserProperty property,
  }) async {
    final isar = await _isarFuture;

    Set<String> oldPropertyIdList = Set.from(
        (await isar.users.getByUsername(username))?.propertyIds.toSet() ?? {});
    final newPropertyList = oldPropertyIdList..add(property.propertyId);

    if (newPropertyList.length == oldPropertyIdList.length) {
      throw EntryAlreadyExistsException();
    }

    isar.writeTxn(() async {
      await isar.users.put(
          User(username: username, propertyIds: oldPropertyIdList.toList()));
      await isar.userPropertys.put(property);
    });
    _notifyListeners();
  }

  Future<Set<UserProperty>> getProperties({
    required String username,
  }) async {
    final isar = await _isarFuture;
    final Set<String> propertyIds =
        ((await isar.users.getByUsername(username))?.propertyIds.toSet() ?? {});

    return await isar.userPropertys
        .getAllByPropertyId(propertyIds.toList())
        .then((properties) => properties.nonNulls.toSet());
  }
}
