import 'package:get/get.dart';

import '../Controller/ViewSubAlbumController.dart';

class ViewSubAlbumBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ViewSubAlbumsController>(
      ViewSubAlbumsController(),
    );
  }
}
