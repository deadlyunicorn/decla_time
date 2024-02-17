import 'package:decla_time/core/errors/exceptions.dart';
import 'package:decla_time/declarations/database/user/user.dart';
import 'package:decla_time/declarations/database/user/user_property.dart';
import 'package:isar/isar.dart';

class UserActions {
  
  final Future<Isar> _isarFuture;
  final void Function() _notifyListeners;

  UserActions({required isarFuture, required notifyListeners})
      : _isarFuture = isarFuture,
        _notifyListeners = notifyListeners;

  Future<List<User>> getAll() async {
    return (await _isarFuture).users.where().findAll();
  }

  Future<void> addNew({
    required String username,
  }) async {
    final isar = await _isarFuture;
    if ((await isar.users.getByUsername(username)) == null) {
      await isar.writeTxn(() async {
        await isar.users.put(User(username: username, propertyIds: []));
      });
      _notifyListeners();
    }
  }

  Future<void> addProperty({
    required String username,
    required UserProperty property,
  }) async {
    final isar = await _isarFuture;

    final Set<String> oldPropertyIdSet = Set.from(
        (await isar.users.getByUsername(username))?.propertyIds.toSet() ?? {});
    final Set<String> newPropertySet = Set.from(oldPropertyIdSet)
      ..add(property.propertyId);

    if (newPropertySet.length == oldPropertyIdSet.length) {
      throw EntryAlreadyExistsException();
    }

    await isar.writeTxn(() async {
      await isar.users.put(
        User(
          username: username,
          propertyIds: newPropertySet.toList(),
        ),
      );
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
