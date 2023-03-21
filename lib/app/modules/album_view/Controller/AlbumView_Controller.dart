import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/Album1_Model.dart';
import '../../../models/e_provider_model.dart';
import '../../../repositories/e_provider_repository.dart';

class AlbumViewController extends GetxController {
  final eProvider = EProvider().obs;
  final album = <AlbumModel1>[].obs;
  final isDeletable = false.obs;
  final isEditable = false.obs;
  final itemList = <AlbumModel1>[].obs;
  final selectedList = <AlbumModel1>[].obs;
  EProviderRepository _eProviderRepository;

  AlbumViewController() {
    _eProviderRepository = new EProviderRepository();
  }

  @override
  void onInit() {
    print("this is running in album");
    isEditable.value = false;
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
      album.value = [];
      final _Album = await _eProviderRepository.getAlbum(eProvider.value.id);
      if (_Album.isNotEmpty) {
        for (int i = 0; i < _Album.length; i++) {
          if (_Album[i].images.isNotEmpty) {
            album.add(_Album[i]);
            print(_Album[i]);
          }
        }
      }

      // album.value = _Album;

      // }));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future delAlbum() async {
    try {
      for (int i = 0; i < selectedList.length; i++) {
        print("check this del items ${selectedList[i].images[0].albums_id} ");
        await _eProviderRepository
            .delAlbum(selectedList[i].images[0].albums_id);
      }

      Get.showSnackbar(
          Ui.SuccessSnackBar(message: "Album SuccessFully deleted"));

      await getGalleries();
      selectedList.value = [];

      // }));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
