import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/media_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/e_provider_repository.dart';
import '../../../repositories/upload_repository.dart';
import '../../../routes/app_routes.dart';

class EditPortfolioController extends GetxController {
  GlobalKey<FormState> portfolioEditForm;
  var user = new User().obs;
  final editable = false.obs;
  // var album = new Media().obs;
  // final portfolio = new Media().obs;
  final hidePassword = true.obs;
  // final List<Media> portfolio = [].obs as List<Media>;
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
  // GlobalKey<FormState> portfolioAlbumFormKey;
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
  final galleries = Media().obs;
  final heroTag = "".obs;
  // GlobalKey<FormState> profileForm;
  EProviderRepository _eProviderRepository;

  EditPortfolioController() {
    portfolioEditForm = GlobalKey<FormState>();
    // eService.value = arguments['eService'] as EService;
    _uploadRepository = new UploadRepository();
    _eProviderRepository = new EProviderRepository();
  }

  @override
  void onInit() async {
    var arguments = Get.arguments as Map<String, dynamic>;
    galleries.value = arguments['gallery'] as Media;
    heroTag.value = arguments['hero'] as String;
    eProvider.value = arguments['eProvider'] as EProvider;
    print("this is calling every time");
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
      Get.back(closeOverlays: true);
      // Get.offNamed(Routes.PortfolioAlbumView, preventDuplicates: false);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> updatePortfolio() async {
    Get.focusScope.unfocus();
    if (portfolioEditForm.currentState.validate()) {
      portfolioEditForm.currentState.save();
      if (description.value != galleries.value.name) {
        await _eProviderRepository.updatePortfolioImageDes(
            galleries.value.id, description.value, eProvider.value.id);
        Get.offNamed(Routes.PortfolioAlbumView, preventDuplicates: false);
      } else {
        Get.offNamed(Routes.PortfolioAlbumView, preventDuplicates: false);
      }
    }
  }
}
