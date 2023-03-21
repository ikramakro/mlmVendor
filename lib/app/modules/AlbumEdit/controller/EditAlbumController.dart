import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common/ui.dart';
import '../../../models/Album1_Model.dart';
import '../../../models/album_model.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/media_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/e_provider_repository.dart';
import '../../../repositories/upload_repository.dart';

class EditAlbumController extends GetxController {
  final albumForm1 = GlobalKey<FormState>().obs;
  var user = new User().obs;
  // var album = new Media().obs;
  // final portfolio = new Media().obs;
  final hidePassword = true.obs;
  // final List<Media> portfolio = [].obs as List<Media>;
  final portfolio = <Media>[].obs;
  // final images = <File>[].obs;
  List<TextEditingController> controllers = [];
  final Name = TextEditingController().obs;
  final Des = TextEditingController().obs;
  final oldPassword = "".obs;
  final newImages = false.obs;
  final newPassword = "".obs;
  final confirmPassword = "".obs;
  // final size = 500.obs;
  final albumCoverName = "".obs;
  final albumCoverDes = "".obs;
  final loop = 1.obs;
  final AlbumCoverUrl = "".obs;
  // GlobalKey<FormState> portfolioAlbumFormKey;
  final uuidPortfolio = [].obs;
  final portfolioImage = [].obs;
  ScrollController controller1 = new ScrollController();
  ScrollController controller2 = new ScrollController();
  final images = <File>[].obs;
  final imagesLength = 1.obs;
  List<String> uuids = <String>[];
  final uploading = false.obs;
  final uploaded = false.obs;
  final album = AlbumModel1().obs;
  UploadRepository _uploadRepository;
  final eProvider = EProvider().obs;
  List descriptionList = [].obs;
  final createAlbum = "on".obs;
  final smsSent = "".obs;
  // GlobalKey<FormState> profileForm;

  EProviderRepository _eProviderRepository;

  EditAlbumController() {
    _uploadRepository = new UploadRepository();
    _eProviderRepository = new EProviderRepository();
  }
  @override
  void dispose() {
    for (TextEditingController c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  void onInit() {
    var arguments = Get.arguments as Map<String, dynamic>;
    album.value = arguments['album'] as AlbumModel1;

    print("this is edit ${album.value}");
    albumForm1.value = new GlobalKey<FormState>();
    images.clear();
    descriptionList.clear();
    // uploading.value = false;
    // loadEProviders();
    super.onInit();
  }

  void reset(int index) async {
    if (imagesLength.value != 1) {
      imagesLength.value = imagesLength.value - 1;
    } else {
      uploaded.value = false;
    }

    final done = await _uploadRepository.deleteOne(uuids[index]);
    images.removeAt(index);
    uuids.removeAt(index);
    descriptionList.removeAt(index);
  }

  // Future<bool> onBack() {
  //   return true;
  // }

  // Future refreshProfile({bool showMessage}) async {
  //
  //   if (showMessage == true) {
  //     Get.showSnackbar(Ui.SuccessSnackBar(
  //         message: "List of faqs refreshed successfully".tr));
  //   }
  // }

  Future pickImage(
    ImageSource source,
    String field,
  ) async {
    // imageFiles;

    // File image;
    final ImagePicker _picker = new ImagePicker();
    List<XFile> pickedFiles = await _picker.pickMultiImage();
    // imageFiles = pickedFiles;
    print("check this image file");
    print(pickedFiles.length);
    if (pickedFiles != null) {
      // imageFiles = pickedFiles;
      uploading.value = true;
      newImages.value = true;
      images.value = pickedFiles.map((imagex) => File(imagex.path)).toList();
      print("check this final ${images.toString()}");

      try {
        for (int i = 0; i < images.length; i++) {
          Future.delayed(Duration(seconds: 1));
          final _uuid = await _uploadRepository.image(images[i], "image");
          uuids.add(_uuid);
        }
        print("check this images ${images.toString()}");
        // images.value = images;
        imagesLength.value = images.length;
        print("check this images ${imagesLength.value}");
        uploading.value = false;
        uploaded.value = true;
      } catch (e) {
        uploading.value = false;
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      }
    } else {
      uploading.value = false;
      Get.showSnackbar(
          Ui.ErrorSnackBar(message: "Please select an image file".tr));
    }
  }

  // Future<void> deleteUploaded() async {
  //   if (uuids.isNotEmpty) {
  //     final done = await _uploadRepository.deleteAll(uuids);
  //     if (done) {
  //       uuids = <String>[];
  //       images.clear();
  //       // uploaded.value = false;
  //     }
  //   }
  // }

  void loadEProviders() async {
    try {
      List<EProvider> eProviders = [];
      print("this is the load eprovider call");

      eProviders = await _eProviderRepository.getEProviders(page: 1);

      if (eProviders.isNotEmpty) {
        eProvider.value = eProviders[0];
        print("eprovider id is${eProviders[0].id}");
        // await getEProvider(_eProviders[0].id);
      } else {}
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> createPortfolioAlbum() async {
    await loadEProviders();
    Get.focusScope.unfocus();

    if (albumForm1.value.currentState.validate()) {
      albumForm1.value.currentState.save();
      for (int i = 0; i < uuids.length; i++) {
        descriptionList.add(controllers[i].text);
      }
      print("Description is ${descriptionList.toString()}");
      try {
        final _portfolioAlbum = new AlbumModelNew(
          image: uuids,
          description: descriptionList,
          name: albumCoverName.value,
          description_album: albumCoverDes.value,
          e_provider_id: eProvider.value.id,
        );
        print("check this portfolio data ${_portfolioAlbum.toString()}");
        print("lenth of portfolio list ${uuids.length}");
        print("lenth of descriotion list ${descriptionList.length}");
        await _eProviderRepository.AlbumEdit(
            _portfolioAlbum, album.value.images[0].albums_id);
        images.clear();
        Name.value.text = "";
        Des.value.text = "";
        newImages.value = false;
        descriptionList.clear();
        uuids.clear();
        imagesLength.value = 1;
        for (TextEditingController c in controllers) {
          c.text = "";
        }
        uploaded.value = false;
        await Get.back();
        Get.showSnackbar(Ui.SuccessSnackBar(message: "Album Uploaded"));
        Get.back();
        // await Get.toNamed(Routes.PortfolioAlbumView);
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      }
    }
  }
}
