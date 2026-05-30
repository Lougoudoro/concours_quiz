import 'package:get_storage/get_storage.dart';

class StorageHelper {
  static GetStorage? _storage;
  final String _languageKey = 'language';

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
