import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/user_model.dart';
import '../repositories/user_repository.dart';
import 'settings_service.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

class AuthService extends GetxService {
  final user = User().obs;
  GetStorage _box;

  UserRepository _usersRepo;

  AuthService() {
    _usersRepo = new UserRepository();
    _box = new GetStorage();
  }

  Future<AuthService> init() async {
    user.listen((User _user) {
      if (Get.isRegistered<SettingsService>()) {
        Get.find<SettingsService>().address.value.userId = _user.id;
      }
      _box.write('current_user', _user.toJson());
    });
    await getCurrentUser();
    return this;
  }

  Future getCurrentUser() async {
    if (user.value.auth == null && _box.hasData('current_user')) {
      user.value = User.fromJson(await _box.read('current_user'));
      user.value.auth = true;
    } else {
      user.value.auth = false;
    }
  }

  Future removeCurrentUser() async {
    user.value = new User();
    await _usersRepo.signOut();
    await _box.remove('current_user');
  }

  Future isRoleChanged() async {
    try {
      var _user = await _usersRepo.getCurrentUser();
      if (_user.isProvider != user.value.isProvider) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
    }
  }

  Future<void> clear() async {
    // Clear user-specific data from your app's state and API client

    // Clear the cache
    await DefaultCacheManager().emptyCache();

    // Delete any user-specific files
    final appDir = await getApplicationDocumentsDirectory();
    final files = await appDir.list().toList();
    files.forEach((file) {
      if (file.path.contains('previous_user_id')) {
        file.deleteSync();
      }
    });
  }

  bool get isAuth => user.value.auth ?? false;

  String get apiToken => (user.value.auth ?? false) ? user.value.apiToken : '';
}
