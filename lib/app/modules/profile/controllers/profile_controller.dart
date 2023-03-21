import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/media_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/e_provider_repository.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/auth_service.dart';
import '../../global_widgets/select_dialog.dart';

class ProfileController extends GetxController {
  var user = new User().obs;
  var avatar = new Media().obs;
  var portfolio = new Media().obs;
  final available_status = "Available to get orders".obs;
  final availableStatusValue = 1.obs;
  final availableStatusValueBool = true.obs;
  final hidePassword = true.obs;
  final oldPassword = "".obs;
  final newPassword = "".obs;
  final eProvider = EProvider().obs;
  final confirmPassword = "".obs;
  final smsSent = "".obs;
  final days = <String>[].obs;
  // final availabilityHour = AvailabilityHour().obs;
  GlobalKey<FormState> eProviderAvailabilityForm = new GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();
  GlobalKey<FormState> profileForm;
  final eProviders = <EProvider>[].obs;
  UserRepository _userRepository;
  EProviderRepository _eProviderRepository;

  ProfileController() {
    _userRepository = new UserRepository();
    _eProviderRepository = new EProviderRepository();
  }
  // @override
  // void onClose() {
  //   days.value = [];
  //   availabilityHour.value = AvailabilityHour();
  //   eProvider.value = EProvider();
  //   super.onClose();
  // }

  Future getEProviders() async {
    try {
      eProviders.assignAll(await _eProviderRepository.getFull());
      if (eProviders[0].accept == 1) {
        availableStatusValueBool.value = true;
        availableStatusValue.value = 1;
      } else if (eProviders[0].accept == 3) {
        availableStatusValueBool.value = false;
        availableStatusValue.value = 3;
      }
      print("this is the eprovider which is fetch in setting $eProviders");
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void availableEProvider() async {
    try {
      EProvider _eprovider = new EProvider(
        id: eProviders[0].id,
        name: eProviders[0].name,
        availabilityRange: eProviders[0].availabilityRange,
        e_provider_type_id: 2,
        accept: 1,
      );
      print("check new provider details $_eprovider");

      await _eProviderRepository.status(_eprovider);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {}
  }

  void unavailableEProvider() async {
    try {
      EProvider _eprovider = new EProvider(
        id: eProviders[0].id,
        name: eProviders[0].name,
        availabilityRange: eProviders[0].availabilityRange,
        e_provider_type_id: 2,
        accept: 3,
      );
      print("check new provider details $_eprovider");

      await _eProviderRepository.status(_eprovider);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {}
  }

  @override
  void onInit() {
    getEProviders();
    user.value = Get.find<AuthService>().user.value;
    avatar.value = new Media(thumb: user.value.avatar.thumb);
    getEProviders();
    // loadEProviders();
    getDays();
    super.onInit();
  }

  // Future loadEProviders() async {
  //   try {
  //     List<EProvider> _eProviders = [];
  //
  //     _eProviders = await _eProviderRepository.getAcceptedEProviders();
  //     print("loadeprovider value ${_eProviders[0].id}");
  //     print("loadeprovider value ${_eProviders[0]}");
  //
  //     if (_eProviders.isNotEmpty) {
  //       print("eprovider id is${_eProviders[0].id}");
  //       await getEProvider(_eProviders[0].id);
  //     } else {}
  //   } catch (e) {
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   }
  // }

  // Future getEProvider(String EproviderId) async {
  //   print("Eprovider id in geteprovider $EproviderId");
  //
  //   try {
  //     eProvider.value = await _eProviderRepository.get(EproviderId);
  //
  //     availabilityHour.value.eProvider = eProvider.value;
  //   } catch (e) {
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   }
  // }

  // Future<dynamic> createAvailabilityHour() async {
  //   print(
  //       "availability method is calling and eprovider id is ${eProvider.value.id}");
  //   Get.focusScope.unfocus();
  //   if (eProviderAvailabilityForm.currentState.validate()) {
  //     try {
  //       eProviderAvailabilityForm.currentState.save();
  //       // scrollController.animateTo(0,
  //       //     duration: Duration(milliseconds: 500), curve: Curves.ease);
  //       print("check this availabilityHour value ${availabilityHour.value}");
  //       final _availabilityHour = await _eProviderRepository
  //           .createAvailabilityHour(this.availabilityHour.value);
  //       print("response avaliability $_availabilityHour");
  //
  //       eProvider.update((val) {
  //         val.availabilityHours.insert(0, _availabilityHour);
  //         return val;
  //       });
  //       availabilityHour.value =
  //           AvailabilityHour(eProvider: availabilityHour.value.eProvider);
  //       eProviderAvailabilityForm.currentState.reset();
  //     } catch (e) {
  //       Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //     } finally {}
  //   } else {
  //     Get.showSnackbar(Ui.ErrorSnackBar(
  //         message: "There are errors in some fields please correct them!".tr));
  //   }
  // }

  List<SelectDialogItem<String>> getSelectDaysItems() {
    return days.map((element) {
      return SelectDialogItem(element, element.tr);
    }).toList();
  }

  Future refreshProfile({bool showMessage}) async {
    await getUser();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(
          message: "List of faqs refreshed successfully".tr));
    }
  }

  getDays() {
    days.assignAll([
      "monday",
      "tuesday",
      "wednesday",
      "thursday",
      "friday",
      "saturday",
      "sunday",
    ]);
  }

  void saveProfileForm() async {
    Get.focusScope.unfocus();
    if (eProviders[0].accept != availableStatusValue.value) {
      if (availableStatusValue.value == 1) {
        await availableEProvider();
      } else {
        await unavailableEProvider();
      }
      // print(
      //     "eprovider accept is ${eProviders[0].accept.toString()} and setting status is ${availableStatusValue.value.toString()}");
    }
    if (profileForm.currentState.validate()) {
      try {
        profileForm.currentState.save();
        user.value.deviceToken = null;
        user.value.password = newPassword.value == confirmPassword.value
            ? newPassword.value
            : null;
        user.value.avatar.id = avatar.value.id;
        // if (Get.find<SettingsService>().setting.value.enableOtp) {
        //   await _userRepository.sendCodeToPhone();
        //   Get.bottomSheet(
        //     PhoneVerificationBottomSheetWidget(),
        //     isScrollControlled: false,
        //   );
        // } else {
        user.value = await _userRepository.update(user.value);
        Get.find<AuthService>().user.value = user.value;
        Get.showSnackbar(
            Ui.SuccessSnackBar(message: "Profile saved successfully".tr));
        // }
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {}
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(
          message: "There are errors in some fields please correct them!".tr));
    }
  }

  Future<void> verifyPhone() async {
    try {
      await _userRepository.verifyPhone(smsSent.value);
      user.value = await _userRepository.update(user.value);
      Get.find<AuthService>().user.value = user.value;
      Get.back();
      Get.showSnackbar(
          Ui.SuccessSnackBar(message: "Profile saved successfully".tr));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void resetProfileForm() {
    avatar.value = new Media(thumb: user.value.avatar.thumb);
    profileForm.currentState.reset();
  }

  Future getUser() async {
    try {
      user.value = await _userRepository.getCurrentUser();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> deleteUser() async {
    try {
      await _userRepository.deleteCurrentUser();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
