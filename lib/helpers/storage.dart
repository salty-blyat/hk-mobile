import 'package:get_storage/get_storage.dart';


class StorageKeys {
  static String staffUser = "staff-user";
  static String accessToken ="access-token";
}

class Storage {
  final storage = GetStorage();

  void write(String key, String value) {
    storage.write(key, value);
  }

  String? read(String key) {
    return storage.read(key);
  }

  void delete(String key) {
    storage.remove(key);
  }

  void deleteAll() {
    storage.erase();
  }
}
