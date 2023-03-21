import 'package:get/get.dart';

import '../controllers/PortfolioViewController.dart';

class PortfolioViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PortfolioViewController>(
      () => PortfolioViewController(),
    );
  }
}
