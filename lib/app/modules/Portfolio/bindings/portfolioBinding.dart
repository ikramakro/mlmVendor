import 'package:get/get.dart';

import '../../album_view/Controller/AlbumView_Controller.dart';
import '../../portfolio_view/controllers/PortfolioViewController.dart';
import '../controllers/portfolioController.dart';

class PortfolioBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<PortfolioController>(
      PortfolioController(),
    );
    Get.put<AlbumViewController>(
      AlbumViewController(),
    );
    Get.put<AlbumViewController>(
      AlbumViewController(),
    );
    Get.put<PortfolioViewController>(
      PortfolioViewController(),
    );
  }
}
