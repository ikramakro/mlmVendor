import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/category_model.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/e_provider_type_model.dart';
import '../../../models/media_model.dart';
import '../../../models/option_group_model.dart';
import '../../../models/tax_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/category_repository.dart';
import '../../../repositories/e_provider_repository.dart';
import '../../../repositories/user_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../global_widgets/multi_select_dialog.dart';
import '../../global_widgets/select_dialog.dart';
import '../../global_widgets/single_select_dialog.dart';

class EProviderFormController extends GetxController {
  GlobalKey<FormState> profileForm;
  var avatar = new Media().obs;
  var user = new User().obs;
  final available_status = "Available to get orders".obs;
  final availableStatusValueBool = true.obs;
  final availableStatusValue = 1.obs;
  UserRepository _userRepository;
  final eProviderss = <EProvider>[].obs;
  final eProvider = EProvider().obs;
  final optionGroups = <OptionGroup>[].obs;
  final categories = <Category>[].obs;
  var categoryName = ''.obs;
  final selectedCategory = <Category>[].obs;
  final eProviders = <EProvider>[].obs;
  final employees = <User>[].obs;
  final taxes = <Tax>[].obs;
  final eProviderTypes = <EProviderType>[].obs;
  GlobalKey<FormState> eProviderForm = new GlobalKey<FormState>();
  EProviderRepository _eProviderRepository;
  CategoryRepository _categoryRepository;
  final selectedCategoryName = "".obs;
  final selectedCategoryId = "".obs;

  EProviderFormController() {
    _userRepository = new UserRepository();
    _eProviderRepository = new EProviderRepository();
    _categoryRepository = new CategoryRepository();
  }
  Future getEProviderss() async {
    try {
      eProviderss.assignAll(await _eProviderRepository.getFull());
      if (eProviderss[0].accept == 1) {
        availableStatusValueBool.value = true;
        availableStatusValue.value = 1;
      } else if (eProviderss[0].accept == 3) {
        availableStatusValueBool.value = false;
        availableStatusValue.value = 3;
      }
      Get.log("this is the eprovider which is fetch in setting $eProviderss");
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  @override
  void onInit() async {
    getEProviderss();
    user.value = Get.find<AuthService>().user.value;
    avatar.value = new Media(thumb: user.value.avatar.thumb);
    getEProviderss();
    getCategories();
    var arguments = Get.arguments as Map<String, dynamic>;
    if (arguments != null) {
      eProvider.value = arguments['eProvider'] as EProvider;
    }

    if (eProvider.value.cat_id != null) {
      await getCategory(eProvider.value.cat_id);

      // print("geting cat detail ${categoriesDetails.toString()}");
    }
    super.onInit();
  }

  Future getCategory(String id) async {
    try {
      categoryName.value = (await _categoryRepository.getOne(id));
      print("check array $categoryName");
    } catch (e) {
      print("this is the error ${e.toString()}");
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  @override
  void onReady() async {
    await refreshEProvider();
    super.onReady();
  }

  Future refreshEProvider({bool showMessage = false}) async {
    await getEProviderTypes();
    await getEmployees();
    await getTaxes();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(
          message:
              eProvider.value.name + " " + "page refreshed successfully".tr));
    }
  }

  List<SingleSelectDialogItem<Category>> getMultiSelectCategoriesItems() {
    return categories.map((element) {
      return SingleSelectDialogItem(element, element.name);
    }).toList();
  }

  // Future getCategories() async {
  //   try {
  //     categories.assignAll(await _categoryRepository.getAll());
  //   } catch (e) {
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   }
  // }

  Future getEProviderTypes() async {
    try {
      eProviderTypes.assignAll(await _eProviderRepository.getEProviderTypes());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getEmployees() async {
    try {
      employees.assignAll(await _eProviderRepository.getAllEmployees());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getTaxes() async {
    try {
      taxes.assignAll(await _eProviderRepository.getTaxes());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getCategories() async {
    try {
      categories.assignAll(await _categoryRepository.getAll());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getEProviders() async {
    try {
      eProviders.assignAll(await _eProviderRepository.getAll());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  List<MultiSelectDialogItem<User>> getMultiSelectEmployeesItems() {
    return employees.map((element) {
      return MultiSelectDialogItem(element, element.name);
    }).toList();
  }

  List<MultiSelectDialogItem<Tax>> getMultiSelectTaxesItems() {
    return taxes.map((element) {
      return MultiSelectDialogItem(element, element.name);
    }).toList();
  }

  List<SelectDialogItem<EProviderType>> getSelectProviderTypesItems() {
    return eProviderTypes.map((element) {
      return SelectDialogItem(element, element.name);
    }).toList();
  }

  /*
  * Check if the form for create new service or edit
  * */
  bool isCreateForm() {
    return !eProvider.value.hasData;
  }

  void availableEProvider() async {
    try {
      EProvider _eprovider = new EProvider(
        id: eProviderss[0].id,
        name: eProviderss[0].name,
        availabilityRange: eProviderss[0].availabilityRange,
        e_provider_type_id: 2,
        accept: 1,
      );
      Get.log("check new provider Available details $_eprovider");

      await _eProviderRepository.status(_eprovider);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {}
  }

  void unavailableEProvider() async {
    try {
      EProvider _eprovider = new EProvider(
        id: eProviderss[0].id,
        name: eProviderss[0].name,
        availabilityRange: eProviderss[0].availabilityRange,
        e_provider_type_id: 2,
        accept: 3,
      );
      Get.log("check new provider unavailable details $_eprovider");

      await _eProviderRepository.status(_eprovider);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {}
  }

  void saveImageAndAvailabel() async {
    Get.focusScope.unfocus();
    if (eProviderss[0].accept != availableStatusValue.value) {
      if (availableStatusValue.value == 1) {
        await availableEProvider();
      } else {
        await unavailableEProvider();
      }
      // print(
      //     "eprovider accept is ${eProviders[0].accept.toString()} and setting status is ${availableStatusValue.value.toString()}");
    }
    // if (profileForm.currentState.validate()) {
    try {
      // profileForm.currentState.save();
      user.value.deviceToken = null;
      user.value.avatar.id = avatar.value.id;
      // if (Get.find<SettingsService>().setting.value.enableOtp) {
      //   await _userRepository.sendCodeToPhone();
      //   Get.bottomSheet(
      //     PhoneVerificationBottomSheetWidget(),
      //     isScrollControlled: false,
      //   );
      // } else {
      // Get.log('${user.value}');
      user.value = await _userRepository.update(user.value);
      Get.find<AuthService>().user.value = user.value;
      // }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {}
    // } else {
    //   Get.showSnackbar(Ui.ErrorSnackBar(
    //       message: "There are errors in some fields please correct them!".tr));
    // }
  }

  void saveProfileForm() async {
    Get.focusScope.unfocus();
    if (eProviderss[0].accept != availableStatusValue.value) {
      if (availableStatusValue.value == 1) {
        await availableEProvider();
      } else {
        await unavailableEProvider();
      }
      // print(
      //     "eprovider accept is ${eProviders[0].accept.toString()} and setting status is ${availableStatusValue.value.toString()}");
    }
  }

  void createEProviderForm() async {
    Get.focusScope.unfocus();
    if (eProviderForm.currentState.validate()) {
      try {
        eProviderForm.currentState.save();
        // eProvider.value.accepted = 1;
        final _eProvider = await _eProviderRepository.create(eProvider.value);
        eProvider.value.id = _eProvider.id;
        await Get.toNamed(Routes.E_PROVIDER_ADDRESSES_FORM,
            arguments: {'eProvider': _eProvider});
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {}
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(
          message: "There are errors in some fields please correct them!".tr));
    }
  }

  void updateEProviderForm() async {
    Get.focusScope.unfocus();
    if (eProviderForm.currentState.validate()) {
      try {
        eProviderForm.currentState.save();
        // saveProfileForm();

        // user.value.deviceToken = null;
        // user.value.avatar.id = avatar.value.id;
        // user.value = await _userRepository.update(user.value);
        // Get.find<AuthService>().user.value = user.value;
        saveImageAndAvailabel();
        final _eProvider = await _eProviderRepository.update(eProvider.value);
        await Get.toNamed(Routes.E_PROVIDER_ADDRESSES_FORM,
            arguments: {'eProvider': _eProvider});
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {}
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(
          message: "There are errors in some fields please correct them!".tr));
    }
  }

  Future<void> deleteEProvider() async {
    try {
      await _eProviderRepository.delete(eProvider.value);
      Get.offNamedUntil(Routes.E_PROVIDERS,
          (route) => route.settings.name == Routes.E_PROVIDERS);
      Get.showSnackbar(Ui.SuccessSnackBar(
          message: eProvider.value.name + " " + "has been removed".tr));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
