import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/category_model.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/e_service_model.dart';
import '../../../models/option_group_model.dart';
import '../../../repositories/category_repository.dart';
import '../../../repositories/e_provider_repository.dart';
import '../../../repositories/e_service_repository.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/select_dialog.dart';
import '../../global_widgets/single_select_dialog.dart';

class EServiceFormController extends GetxController {
  final eService = EService().obs;
  final optionGroups = <OptionGroup>[].obs;
  // final categories = <Category>[].obs;
  final Subcategories = <Category>[].obs;
  final ServiceCategories = <Category>[].obs;
  var SubcategoriesReuse = <Category>[].obs;
  final eProviders = <EProvider>[].obs;
  final eProvider = <EProvider>[].obs;
  final eServices = <EService>[].obs;
  var reuseCat = <Category>[].obs;
  // List<EProvider> providerCat_id = [].obs as List<EProvider>;
  GlobalKey<FormState> eServiceForm = new GlobalKey<FormState>();
  EServiceRepository _eServiceRepository;
  CategoryRepository _categoryRepository;
  EProviderRepository _eProviderRepository;

  EServiceFormController() {
    _eServiceRepository = new EServiceRepository();
    _categoryRepository = new CategoryRepository();
    _eProviderRepository = new EProviderRepository();
  }

  @override
  void onInit() async {
    print("this is calling one servie from Services");
    var arguments = Get.arguments as Map<String, dynamic>;
    if (arguments != null) {
      eService.value = arguments['eService'] as EService;
    }
    await GetEProviders();
    await loadEServicesOfCategory();
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshEService();
    super.onReady();
  }

  Future loadEServicesOfCategory() async {
    try {
      List<EService> _eServices = [];
      print("eprovider id to get service is${eProvider.toString()}");
      _eServices = await _eProviderRepository.getServices(
          eProviderId: eProvider?.value[0].id);
      print(_eServices);

      if (_eServices.isNotEmpty) {
        for (int i = 0; i < _eServices.length; i++) {
          ServiceCategories.add(_eServices[i].categories[0]);
        }
        this.eServices.addAll(_eServices);
        var SubcategoriesReuse1 = SplayTreeSet<Category>.from(Subcategories)
            .difference(SplayTreeSet<Category>.from(ServiceCategories));
        SubcategoriesReuse.addAll(SubcategoriesReuse1);
        print("check thi subcat1$SubcategoriesReuse");
        // for (int q = 0; q < eServices?.length; q++) {
        //   print("q $q");
        //   for (int i = 0; i < Subcategories?.length; i++) {
        //     print('i$i');
        //     if (Subcategories[i].id != eServices[q].categories[0].id) {
        //       print("comapre in not same");
        //       print(
        //           "${Subcategories[i].id} != ${eServices[q].categories[0].id}");
        //       print("these are not same ${Subcategories[i].toString()}");
        //       SubcategoriesReuse.add(Subcategories[i]);
        //       print("these are resuse $SubcategoriesReuse");
        //     }
        //   }
        // }
      } else {
        SubcategoriesReuse.value = Subcategories;
      }

      // print("checkkkk this ${Subcategories.toString()}");
      // print("checkkkk this ${eServices.toString()}");
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
        await getSubCategories(_eProviders[0].cat_id);
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {}
  }

  Future getSubCategories(catID) async {
    try {
      print("eprovider cat id ${eProvider[0].cat_id}");
      Subcategories.assignAll(
          await _categoryRepository.getAllWithSubCategories(catID));

      print("subCategories are $Subcategories");
    } catch (e) {
      print("this is the error ${e.toString()}");
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future refreshEService({bool showMessage = false}) async {
    await getEService();
    // await getCategories();
    await getEProviders();
    await getOptionGroups();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(
          message:
              eService.value.name + " " + "page refreshed successfully".tr));
    }
  }

  Future getEService() async {
    if (eService.value.hasData) {
      try {
        eService.value = await _eServiceRepository.get(eService.value.id);
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      }
    }
  }

  Future getEProviders() async {
    try {
      eProviders.assignAll(await _eProviderRepository.getAll());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  List<SingleSelectDialogItem<Category>> getMultiSelectCategoriesItems() {
    print("check for select cetegory are $SubcategoriesReuse");
    return SubcategoriesReuse.map((element) {
      return SingleSelectDialogItem(element, element.name);
    }).toList();
  }

  List<SelectDialogItem<EProvider>> getSelectProvidersItems() {
    return eProviders.map((element) {
      return SelectDialogItem(element, element.name);
    }).toList();
  }

  Future getOptionGroups() async {
    if (eService.value.hasData) {
      try {
        var _optionGroups =
            await _eServiceRepository.getOptionGroups(eService.value.id);
        optionGroups.assignAll(_optionGroups);
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      }
    }
  }

  /*
  * Check if the form for create new service or edit
  * */
  bool isCreateForm() {
    return !eService.value.hasData;
  }

  void createEServiceForm({bool createOptions = false}) async {
    Get.focusScope.unfocus();
    if (eServiceForm.currentState.validate()) {
      eService.update((val) {
        val.priceUnit = "fixed";
      });
      try {
        eServiceForm.currentState.save();
        var _eService = await _eServiceRepository.create(eService.value);
        if (createOptions)
          Get.offAndToNamed(Routes.OPTIONS_FORM,
              arguments: {'eService': _eService});
        else
          Get.offAndToNamed(Routes.E_SERVICE, arguments: {
            'eService': _eService,
            'heroTag': 'e_service_create_form'
          });
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {}
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(
          message: "There are errors in some fields please correct them!".tr));
    }
  }

  void updateEServiceForm() async {
    Get.focusScope.unfocus();
    if (eServiceForm.currentState.validate()) {
      try {
        eServiceForm.currentState.save();
        var _eService = await _eServiceRepository.update(eService.value);
        Get.offAndToNamed(Routes.E_SERVICE, arguments: {
          'eService': _eService,
          'heroTag': 'e_service_update_form'
        });
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {}
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(
          message: "There are errors in some fields please correct them!".tr));
    }
  }

  void deleteEService() async {
    try {
      await _eServiceRepository.delete(eService.value.id);
      Get.offAndToNamed(Routes.E_SERVICES);
      Get.showSnackbar(Ui.SuccessSnackBar(
          message: eService.value.name + " " + "has been removed".tr));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
