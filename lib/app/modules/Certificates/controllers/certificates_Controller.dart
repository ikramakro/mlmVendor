import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common/ui.dart';
import '../../../models/certificates_model.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/media_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/e_provider_repository.dart';
import '../../../repositories/upload_repository.dart';
import '../../../repositories/user_repository.dart';
import '../../../routes/app_routes.dart';

class CertificatesController extends GetxController {
  GlobalKey<FormState> certificateForm;
  var user = new User().obs;
  final hidePassword = true.obs;
  final portfolio = <Media>[].obs;
  final images = <File>[].obs;
  final imagesLength = 1.obs;
  final uploaded = false.obs;
  final uploading = false.obs;
  final oldPassword = "".obs;
  final newPassword = "".obs;
  final confirmPassword = "".obs;
  final albumCoverName = "".obs;
  final albumCoverDes = "".obs;
  final loop = 1.obs;
  List<String> uuids = <String>[];
  final AlbumCoverUrl = "".obs;
  final uuidPortfolio = [].obs;
  final eProvider = EProvider().obs;
  final descriptionList = [].obs;
  final titleList = [].obs;
  UploadRepository _uploadRepository;
  final createAlbum = false.obs;

  UserRepository _userRepository;
  EProviderRepository _eProviderRepository;

  CertificatesController() {
    _userRepository = new UserRepository();
    _uploadRepository = new UploadRepository();
    _eProviderRepository = new EProviderRepository();
  }

  @override
  void onInit() async {
    // loadEProviders();
    super.onInit();
  }

  // Future refreshProfile({bool showMessage}) async {
  //
  //   if (showMessage == true) {
  //     Get.showSnackbar(Ui.SuccessSnackBar(
  //         message: "List of faqs refreshed successfully".tr));
  //   }
  // }

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

  Future<void> certificates() async {
    await loadEProviders();
    Get.focusScope.unfocus();

    if (certificateForm.currentState.validate()) {
      certificateForm.currentState.save();
      try {
        final _certificate = new Certificate(
          image: uuids,
          desc: descriptionList,
          title: titleList,
          e_provider_id: eProvider.value.id,
        );
        print("check this portfolio data ${_certificate.toString()}");
        print("length of portfolio list ${uuids.length}");
        print("length of descriotion list ${descriptionList.length}");
        print("length of title list ${titleList.length}");

        await _eProviderRepository.certificate(_certificate);
        images.clear();
        descriptionList.clear();
        titleList.clear();
        uuids.clear();
        imagesLength.value = 1;
        uploaded.value = false;
        await Get.toNamed(Routes.ROOT, arguments: 0);
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      }
    }
  }
}
