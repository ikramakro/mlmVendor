import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/album_model2.dart';
import '../../../models/e_provider_model.dart';
import '../../../repositories/e_provider_repository.dart';

class ViewSubAlbumsController extends GetxController {
  final eProvider = EProvider().obs;
  // final subAlbums = <SubAlbum>[].obs;
  final album = <AlbumModelNew2>[].obs;
  final heroTag = "".obs;
  final currentSlide = 0.obs;
  EProviderRepository _eProviderRepository;
  final session = Get.arguments as Map<String, dynamic>;
  ViewSubAlbumsController() {
    _eProviderRepository = new EProviderRepository();
  }

  @override
  void onInit() {
    print("this is calling sub album");
    // album.value = [];
    // var arguments = Get.arguments as Map<String, dynamic>;
    album.value = session['album'];
    heroTag.value = session['hero'] as String;
    eProvider.value = session['eProvider'] as EProvider;
    print("check this out");
    print(album.value.toString());
    refreshEProvider();
    super.onInit();
  }

  Future refreshEProvider({bool showMessage = false}) async {
    // await getSubAlbums();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(
          message:
              eProvider.value.name + " " + "page refreshed successfully".tr));
    }
  }

  // Future getSubAlbums() async {
  //   subAlbums.value = [];
  //   try {
  //     List<SubAlbum> _galleries =
  //         await _eProviderRepository.getSubAlbums(album.value.id);
  //     for (var gallery in _galleries) {
  //       if (gallery.galleries.isNotEmpty) {
  //         subAlbums.add(gallery);
  //       }
  //     }
  //   } catch (e) {
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   }
  // }
}
