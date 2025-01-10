import 'package:get_storage/get_storage.dart';

class Storage {
  final storage = GetStorage();

  void write(String key, String value) {
    storage.write(key, value);
  }

  String read(String key) {
    return storage.read(key);
  }

  void delete(String key) {
    storage.remove(key);
  }

  void deleteAll() {
    storage.erase();
  }
}
