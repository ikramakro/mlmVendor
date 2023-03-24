import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services_provider/app/modules/home/controllers/home_controller.dart';

import '../../../../common/ui.dart';
import '../../../models/category_model.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/e_provider_type_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/category_repository.dart';
import '../../../repositories/e_provider_repository.dart';
import '../../../repositories/user_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/firebase_messaging_service.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/select_dialog.dart';
import '../../global_widgets/single_select_dialog.dart';

class AuthController extends GetxController {
  final Rx<User> currentUser = Get.find<AuthService>().user;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  GlobalKey<FormState> loginFormKey;
  final eProvider = EProvider().obs;
  final eProviderTypes = <EProviderType>[].obs;
  GlobalKey<FormState> registerFormKey;
  GlobalKey<FormState> forgotPasswordFormKey;
  final hidePassword = true.obs;
  final selectedCategory = <Category>[].obs;
  final selectedCategoryName = "".obs;
  final selectedCategoryId = "".obs;
  final loading = false.obs;
  final smsSent = ''.obs;
  CategoryRepository _categoryRepository;
  UserRepository _userRepository;
  final categories = <Category>[].obs;
  final SelectedCategoryName = "".obs;
  final SelectedCategoryId = "".obs;
  EProviderRepository _eProviderRepository;

  AuthController() {
    _userRepository = UserRepository();
    _eProviderRepository = new EProviderRepository();
    _categoryRepository = new CategoryRepository();
  }
  List<SingleSelectDialogItem<Category>> getMultiSelectCategoriesItems() {
    return categories.map((element) {
      return SingleSelectDialogItem(element, element.name);
    }).toList();
  }

  Future getCategories() async {
    try {
      categories.assignAll(await _categoryRepository.getAll());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getEProviderTypes() async {
    try {
      eProviderTypes.assignAll(await _eProviderRepository.getEProviderTypes());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  List<SelectDialogItem<EProviderType>> getSelectProviderTypesItems() {
    return eProviderTypes.map((element) {
      return SelectDialogItem(element, element.name);
    }).toList();
  }

  @override
  void onInit() async {
    await getCategories();
    await getEProviderTypes();
    // TODO: implement onInit
    super.onInit();
  }

  Future createEProviderForm() async {
    // Get.focusScope.unfocus();
    eProvider.value.name = currentUser.value.name;
    eProvider.value.phoneNumber = currentUser.value.phoneNumber;
    eProvider.value.employees = [currentUser.value];

    print("creating provider ${eProvider.value.toString()}");
    try {
      final _eProvider = await _eProviderRepository.create(eProvider.value);
      eProvider.value.id = _eProvider.id;
      // await Get.toNamed(Routes.E_PROVIDER_AVAILABILITY_FORM,
      //     arguments: {'eProvider': _eProvider});
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
  // void updateEProviderForm() async {
  //   print("updateEProvider is trigger");
  //   Get.focusScope.unfocus();
  //   try {
  //     await _eProviderRepository.update(eProvider.value);
  //     await SendEmail();
  //
  //     // await Get.toNamed(Routes.E_PROVIDER_AVAILABILITY_FORM,
  //     //     arguments: {'eProvider': _eProvider});
  //   } catch (e) {
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   } finally {}
  // }

  void login() async {
    Get.focusScope.unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      loading.value = true;
      try {
        await Get.find<FireBaseMessagingService>().setDeviceToken();

        currentUser.value = await _userRepository.login(currentUser.value);
        if (currentUser.value != null) {
          await _userRepository.signInWithEmailAndPassword(
              currentUser.value.email, currentUser.value.apiToken);
          loading.value = false;
          // await Get.find<HomeController>().refreshHome();
          await Get.toNamed(Routes.ROOT, arguments: 0);
        } else {
          loginFormKey.currentState.reset();
          loading.value = false;
        }
      } catch (e) {
        if (e.toString() ==
            "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
          Get.showSnackbar(Ui.ErrorSnackBar(message: "Account not Found"));
        }
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {
        loading.value = false;
      }
    }
  }

  Future register() async {
    print("register is trigger");
    Get.focusScope.unfocus();
    if (registerFormKey.currentState.validate()) {
      registerFormKey.currentState.save();

      String checkNum =
          await _userRepository.checkNum(currentUser.value.phoneNumber);
      print("status phone num $checkNum");
      if (checkNum == "False") {
        loading.value = true;
        try {
          if (Get.find<SettingsService>().setting.value.enableOtp) {
            print("this is running first");
            await _userRepository.sendCodeToPhone();
            loading.value = false;
            await Get.toNamed(Routes.PHONE_VERIFICATION);
          } else {
            print("this is running second");
            await Get.find<FireBaseMessagingService>().setDeviceToken();
            currentUser.value =
                await _userRepository.register(currentUser.value);
            await _userRepository.signUpWithEmailAndPassword(
                currentUser.value.email, currentUser.value.apiToken);
            // await SendEmail();

            // loading.value = false;
          }
        } catch (e) {
          Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
        } finally {
          loading.value = false;
        }
      } else {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Number already used"));
      }
    }
  }

  Future SendEmail() async {
    try {
      await _eProviderRepository.sendEmail(currentUser.value.email);
      // await Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> verifyPhone() async {
    try {
      loading.value = true;
      await _userRepository.verifyPhone(smsSent.value);
      await Get.find<FireBaseMessagingService>().setDeviceToken();
      currentUser.value = await _userRepository.register(currentUser.value);
      await _userRepository.signUpWithEmailAndPassword(
          currentUser.value.email, currentUser.value.apiToken);
      await createEProviderForm();
      await _eProviderRepository.sendEmail(currentUser.value.email);

      loading.value = false;
      await Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      loading.value = false;
      Get.toNamed(Routes.REGISTER);
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      loading.value = false;
    }
  }

  Future<void> resendOTPCode() async {
    await _userRepository.sendCodeToPhone();
  }

  void sendResetLink() async {
    Get.focusScope.unfocus();
    if (forgotPasswordFormKey.currentState.validate()) {
      forgotPasswordFormKey.currentState.save();
      loading.value = true;
      try {
        await _userRepository.sendResetLinkEmail(currentUser.value);
        loading.value = false;
        Get.showSnackbar(Ui.SuccessSnackBar(
            message:
                "The Password reset link has been sent to your email: ".tr +
                    currentUser.value.email));
        Timer(Duration(seconds: 5), () {
          Get.offAndToNamed(Routes.LOGIN);
        });
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {
        loading.value = false;
      }
    }
  }
}
