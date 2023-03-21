import 'package:get/get.dart';

import '../controller/EditAlbumController.dart';

class EditAlbumBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<EditAlbumController>(
      EditAlbumController(),
    );
  }
}
