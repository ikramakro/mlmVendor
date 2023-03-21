import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/category_model.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/e_service_model.dart';
import '../../../repositories/category_repository.dart';
import '../../../repositories/e_provider_repository.dart';
import '../../../repositories/e_service_repository.dart';

class SearchController extends GetxController {
  final heroTag = "".obs;
  final categories = <Category>[].obs;
  final selectedCategories = <String>[].obs;
  TextEditingController textEditingController;
  EProviderRepository _eProviderRepository;
  final eProvider = <EProvider>[].obs;

  final eServices = <EService>[].obs;
  EServiceRepository _eServiceRepository;
  CategoryRepository _categoryRepository;

  SearchController() {
    _eServiceRepository = new EServiceRepository();
    _categoryRepository = new CategoryRepository();
    textEditingController = new TextEditingController();
    _eProviderRepository = new EProviderRepository();
  }

  @override
  void onInit() async {
    await refreshSearch();
    super.onInit();
  }

  @override
  void onReady() {
    heroTag.value = Get.arguments as String;
    super.onReady();
  }

  Future refreshSearch({bool showMessage}) async {
    // await getCategories();
    await GetEProviders();
    await searchEServices();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(
          message: "List of services refreshed successfully".tr));
    }
  }

  Future searchEServices({String keywords}) async {
    try {
      if (selectedCategories.isEmpty) {
        eServices.assignAll(await _eServiceRepository.search(
            keywords, categories.map((element) => element.id).toList()));
      } else {
        eServices.assignAll(await _eServiceRepository.search(
            keywords, selectedCategories.toList()));
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
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
      if (eProvider[0]?.cat_id != null) {
        print("eprovider value ${eProvider[0].cat_id}");
        await getCategories(_eProviders[0].cat_id);
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {}
  }

  Future getCategories(catID) async {
    try {
      // categories.assignAll(await _categoryRepository.getAllParents());
      categories
          .assignAll(await _categoryRepository.getAllWithSubCategories(catID));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  bool isSelectedCategory(Category category) {
    return selectedCategories.contains(category.id);
  }

  void toggleCategory(bool value, Category category) {
    if (value) {
      selectedCategories.add(category.id);
    } else {
      selectedCategories.removeWhere((element) => element == category.id);
    }
  }
}
