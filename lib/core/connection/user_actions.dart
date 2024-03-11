import "package:decla_time/core/errors/exceptions.dart";
import "package:decla_time/declarations/database/user/user.dart";
import "package:decla_time/declarations/database/user/user_property.dart";
import "package:isar/isar.dart";

class UserActions {
  final Future<Isar> _isarFuture;
  final void Function() _notifyListeners;

  UserActions({
    required Future<Isar> isarFuture,
    required void Function() notifyListeners,
  })  : _isarFuture = isarFuture,
        _notifyListeners = notifyListeners;

  Future<List<User>> getAll() async {
    return (await _isarFuture).users.where().findAll();
  }

  Future<void> addNewUser({
    required String username,
  }) async {
    final Isar isar = await _isarFuture;
    if ((await isar.users.getByUsername(username)) == null) {
      await isar.writeTxn(() async {
        await isar.users.put(User(username: username, propertyIds: <String>[]));
      });
      _notifyListeners();
    }
  }

  Future<void> addProperties({
    required String username,
    required Iterable<UserProperty> propertyIterable,
  }) async {
    final Isar isar = await _isarFuture;

    final Set<String> oldPropertyIdSet = Set<String>.from(
      (await isar.users.getByUsername(username))?.propertyIds.toSet() ??
          <String>{},
    );
    final Set<String> newPropertyIdsSet = Set<String>.from(oldPropertyIdSet)
      ..addAll(
        propertyIterable.map((UserProperty property) => property.propertyId),
      );

    if (newPropertyIdsSet.length == oldPropertyIdSet.length) {
      throw EntryAlreadyExistsException();
    }

    await isar.writeTxn(() async {
      await Future.wait(
        <Future<void>>[
          isar.users.put(
            User(
              username: username,
              propertyIds: newPropertyIdsSet.toList(),
            ),
          ),
          isar.userPropertys.putAll(propertyIterable.toList()),
        ],
      );
    });
    _notifyListeners();
  }

  Future<Set<UserProperty>> readProperties({
    required String username,
  }) async {
    final Isar isar = await _isarFuture;
    final Set<String> propertyIds =
        ((await isar.users.getByUsername(username))?.propertyIds.toSet() ??
            <String>{});

    return await isar.userPropertys
        .getAllByPropertyId(propertyIds.toList())
        .then((List<UserProperty?> properties) => properties.nonNulls.toSet());
  }

  Future<UserProperty?> getProperty({required String propertyId}) async {
    final Isar isar = await _isarFuture;
    return await isar.userPropertys.getByPropertyId(propertyId);
  }

  Future<void> setPropertyFriendlyName({
    required String propertyId,
    required String friendlyName,
  }) async {
    final Isar isar = await _isarFuture;
    final UserProperty? property =
        await isar.userPropertys.getByPropertyId(propertyId);
    if (property == null) {
      throw UserPropertyNotFoundException();
    } else {
      if (property.friendlyName == friendlyName) return;
      await isar.writeTxn(() async {
        await isar.userPropertys.put(
          property..friendlyName = friendlyName,
        );
      });
      _notifyListeners();
    }
  }
}
