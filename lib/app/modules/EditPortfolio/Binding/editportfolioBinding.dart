import 'package:get/get.dart';

import '../Controller/EditPorfolioController.dart';

class EditPortfolioBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditPortfolioController>(
      () => EditPortfolioController(),
    );
  }
}
