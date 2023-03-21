import 'package:get/get.dart';

import '../../Albums/controllers/AlbumController.dart';
import '../../Portfolio/controllers/portfolioController.dart';

class PortfolioAndAlbumViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<PortfolioController>(
      PortfolioController(),
    );

    Get.put<AlbumController>(
      AlbumController(),
    );
  }
}
