import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/media_model.dart';
import '../../../repositories/e_provider_repository.dart';

class PortfolioViewController extends GetxController {
  final eProvider = EProvider().obs;
  final galleries = <Media>[].obs;
  final currentSlide = 0.obs;
  EProviderRepository _eProviderRepository;
  PortfolioViewController() {
    _eProviderRepository = new EProviderRepository();
  }

  @override
  void onInit() {
    refreshEProvider();
    super.onInit();
  }

  Future refreshEProvider({bool showMessage = false}) async {
    await getEProvider();

    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(
          message:
              eProvider.value.name + " " + "page refreshed successfully".tr));
    }
  }

  Future getEProvider() async {
    try {
      List<EProvider> _eProviders = [];
      _eProviders = await _eProviderRepository.getEProviders();
      eProvider.value = _eProviders[0];
      if (eProvider.value.hasData) {
        await getGalleries();
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getGalleries() async {
    try {
      final _galleries =
          await _eProviderRepository.getGalleries(eProvider.value.id);
      galleries.assignAll(_galleries.map((e) {
        e.image.name = e.description;
        e.image.id = e.id;
        return e.image;
      }));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
