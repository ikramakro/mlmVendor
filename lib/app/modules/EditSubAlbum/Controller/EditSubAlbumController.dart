import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/album_model2.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/media_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/e_provider_repository.dart';
import '../../../repositories/upload_repository.dart';
import '../../../routes/app_routes.dart';

class EditSubAlbumController extends GetxController {
  GlobalKey<FormState> portfolioEditForm;
  var user = new User().obs;
  final editable = false.obs;
  // var album = new Media().obs;
  // final portfolio = new Media().obs;
  final hidePassword = true.obs;
  final portfolio = <Media>[].obs;
  // final images = <File>[].obs;
  final oldPassword = "".obs;
  final newPassword = "".obs;
  final confirmPassword = "".obs;
  // final size = 500.obs;
  final albumCoverName = "".obs;
  final albumCoverDes = "".obs;
  final loop = 1.obs;
  final AlbumCoverUrl = "".obs;
  final uuidPortfolio = [].obs;
  final portfolioImage = [].obs;
  final images = <File>[].obs;
  final imagesLength = 1.obs;
  List<String> uuids = <String>[];
  final uploading = false.obs;
  final uploaded = false.obs;
  UploadRepository _uploadRepository;
  final eProvider = EProvider().obs;
  final description = "".obs;
  List<TextEditingController> controllers = [];
  final createAlbum = "false".obs;
  final smsSent = "".obs;
  final heroTag = "".obs;
  final subAlbum = AlbumModelNew2().obs;
  final des = "".obs;
  // GlobalKey<FormState> profileForm;
  EProviderRepository _eProviderRepository;

  EditSubAlbumController() {
    portfolioEditForm = GlobalKey<FormState>();
    // eService.value = arguments['eService'] as EService;
    _uploadRepository = new UploadRepository();
    _eProviderRepository = new EProviderRepository();
  }

  @override
  void onInit() {
    // subAlbum.value = AlbumModelNew2();
    print("edit chal gaya ${subAlbum.value}");
    var arguments = Get.arguments as Map<String, dynamic>;
    subAlbum.value = arguments['subAlbum'];
    print(subAlbum.value);
    heroTag.value = arguments['hero'] as String;
    eProvider.value = arguments['eProvider'] as EProvider;
    // print("this is calling every time");
    super.onInit();
  }

  @override
  void dispose() {
    for (TextEditingController c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> deletePortfolio(String Id) async {
    try {
      await _eProviderRepository.deletePortfolioImage(Id);
      editable.value = false;
      Future.delayed(const Duration(seconds: 1), () {
        Get.back(); // Prints after 1 second.
      });
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> updatePortfolio() async {
    print("deatil in edit $subAlbum");
    Get.focusScope.unfocus();
    if (portfolioEditForm.currentState.validate()) {
      portfolioEditForm.currentState.save();
      if (description.value != subAlbum.value.description) {
        await _eProviderRepository.updateAlbumImageDes(
            subAlbum.value.id, description.value, eProvider.value.id);
        Get.back();
        Get.toNamed(Routes.PortfolioAlbumView);
      } else {
        Get.back();
        Get.toNamed(Routes.PortfolioAlbumView);
      }
    }
  }
}
