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

  Future<void> addProperties({
    required String username,
    required Iterable<UserProperty> propertyIterable,
  }) async {
    final isar = await _isarFuture;

    final Set<String> oldPropertyIdSet = Set.from(
        (await isar.users.getByUsername(username))?.propertyIds.toSet() ?? {});
    final Set<String> newPropertyIdsSet = Set.from(oldPropertyIdSet)
      ..addAll(propertyIterable.map((property) => property.propertyId));

    if (newPropertyIdsSet.length == oldPropertyIdSet.length) {
      throw EntryAlreadyExistsException();
    }

    await isar.writeTxn(() async {
      await isar.users.put(
        User(
          username: username,
          propertyIds: newPropertyIdsSet.toList(),
        ),
      );
      await isar.userPropertys.putAll( propertyIterable.toList() );
    });
    _notifyListeners();
  }

  Future<Set<UserProperty>> readProperties({
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
