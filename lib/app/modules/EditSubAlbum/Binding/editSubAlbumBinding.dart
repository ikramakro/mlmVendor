import 'package:get/get.dart';

import '../Controller/EditSubAlbumController.dart';

class EditSubAlbumBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<EditSubAlbumController>(
      EditSubAlbumController(),
    );
  }
}
