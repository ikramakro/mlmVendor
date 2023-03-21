import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/review_model.dart';
import '../../../repositories/e_provider_repository.dart';

class ReviewsController extends GetxController {
  final reviews = <Review>[].obs;
  final totalReviews = 0.obs;
  final rate = 0.0.obs;
  final eProvider = <EProvider>[].obs;
  EProviderRepository _eProviderRepository;

  ReviewsController() {
    _eProviderRepository = new EProviderRepository();
  }

  @override
  void onInit() {
    // getVendorReviews();
    super.onInit();
  }

  @override
  void onReady() async {
    await GetEProviders();
    await refreshReviews();
    super.onReady();
  }

  Future refreshReviews({bool showMessage = false}) async {
    // await GetEProviders();
    await GetEProviders();
    // await getReviews();
    if (showMessage) {
      Get.showSnackbar(
          Ui.SuccessSnackBar(message: "Reviews refreshed successfully".tr));
    }
  }

  Future GetEProviders() async {
    try {
      List<EProvider> _eProviders = [];
      _eProviders = (await _eProviderRepository.getEProviders());
      if (_eProviders.isNotEmpty) {
        this.eProvider.addAll(_eProviders);
      } else {
        print("not geting any provider");
      }
      print("_eProviders value ${_eProviders[0].cat_id}");
      if (eProvider[0]?.id != null) {
        await getVendorReviews();
        print("eprovider value ${eProvider[0].id}");
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {}
  }
  // Future getReviews() async {
  //   try {
  //     reviews.assignAll(await _eProviderRepository
  //         .getReviews(Get.find<AuthService>().user.value.id));
  //     totalReviews.value = reviews.length;
  //     rate.value = reviews
  //             .map((element) => element.rate)
  //             .reduce((value, element) => value + element) /
  //         reviews.length;
  //   } catch (e) {
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   }
  // }

  Future getVendorReviews() async {
    try {
      reviews.assignAll(
          await _eProviderRepository.getProviderReviews(eProvider[0].id));
      totalReviews.value = reviews.length;
      rate.value = reviews
              .map((element) => element.rate)
              .reduce((value, element) => value + element) /
          reviews.length;
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
