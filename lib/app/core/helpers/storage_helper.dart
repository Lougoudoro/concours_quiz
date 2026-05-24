import 'package:get_storage/get_storage.dart';

class StorageHelper {
  static final _getStorage = GetStorage();
  final String _languageKey = 'language';

  static void set(String key, value) async {
    await _getStorage.write(key, value);
  }

  static dynamic get(String key, {def = ''}) {
    return _getStorage.read(key) ?? def;
  }

  static void delete(String key) {
    _getStorage.remove(key);
  }

  // Sauvegarder la langue
  void saveLanguage(String language) {
    _getStorage.write(_languageKey, language);
  }

  // Récupérer la langue
  String? getLanguage() {
    return _getStorage.read(_languageKey);
  }
}
