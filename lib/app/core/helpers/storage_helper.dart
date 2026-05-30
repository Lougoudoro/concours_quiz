import 'package:get_storage/get_storage.dart';

class StorageHelper {
  static GetStorage? _storage;
  final String _languageKey = 'language';

  static const String cachedUserKey = 'cached_user';
  static const String cachedSessionKey = 'cached_session';
  static String cachedCrudListKey(String resource) =>
      'cached_crud_list_$resource';
  static String cachedCrudItemKey(String resource, dynamic id) =>
      'cached_crud_${resource}_$id';

  static GetStorage get _getStorage {
    _storage ??= GetStorage();
    return _storage!;
  }

  static Future<void> set(String key, value) async {
    await _getStorage.write(key, value);
  }

  static dynamic get(String key, {def = ''}) {
    return _getStorage.read(key) ?? def;
  }

  static void delete(String key) {
    _getStorage.remove(key);
  }

  void saveLanguage(String language) {
    _getStorage.write(_languageKey, language);
  }

  String? getLanguage() {
    return _getStorage.read(_languageKey);
  }
}
