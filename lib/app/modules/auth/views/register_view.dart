import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/helper.dart';
import '../../../../common/ui.dart';
import '../../../models/category_model.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/e_provider_type_model.dart';
import '../../../models/setting_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/phone_field_widget.dart';
import '../../global_widgets/registerTextField.dart';
import '../../global_widgets/select_dialog.dart';
import '../../global_widgets/single_select_dialog.dart';
import '../../global_widgets/text_field_widget.dart';
import '../../root/controllers/root_controller.dart';
import '../controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  final Setting _settings = Get.find<SettingsService>().setting.value;

  @override
  Widget build(BuildContext context) {
    controller.registerFormKey = new GlobalKey<FormState>();
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Register".tr,
            style: Get.textTheme.headline6
                .merge(TextStyle(color: context.theme.primaryColor)),
          ),
          centerTitle: true,
          backgroundColor: Get.theme.colorScheme.secondary,
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.primaryColor),
            onPressed: () => {Get.find<RootController>().changePageOutRoot(0)},
          ),
        ),
        body: Form(
          key: controller.registerFormKey,
          child: ListView(
            primary: true,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Container(
                    height: 160,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.secondary,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                            color: Get.theme.focusColor.withOpacity(0.2),
                            blurRadius: 10,
                            offset: Offset(0, 5)),
                      ],
                    ),
                    margin: EdgeInsets.only(bottom: 50),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            _settings.providerAppName,
                            style: Get.textTheme.headline6.merge(TextStyle(
                                color: Get.theme.primaryColor, fontSize: 24)),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Welcome to the best service provider system!".tr,
                            style: Get.textTheme.caption.merge(
                                TextStyle(color: Get.theme.primaryColor)),
                            textAlign: TextAlign.center,
                          ),
                          // Text("Fill the following credentials to login your account", style: Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor))),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: Ui.getBoxDecoration(
                      radius: 14,
                      border:
                          Border.all(width: 5, color: Get.theme.primaryColor),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Image.asset(
                        'assets/icon/icon.png',
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                ],
              ),
              Obx(() {
                if (controller.loading.isTrue) {
                  return CircularLoadingWidget(height: 300);
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFieldWidget(
                        labelText: "Full Name".tr,
                        hintText: "John Doe".tr,
                        initialValue: controller.currentUser?.value?.name,
                        onSaved: (input) =>
                            controller.currentUser.value.name = input,
                        validator: (input) => input.length < 3
                            ? "Should be more than 3 characters".tr
                            : null,
                        iconData: Icons.person_outline,
                        isFirst: true,
                        isLast: false,
                      ),
                      RegisterTextFieldWidget(
                        // isFirst: true,
                        controller: controller.emailController,
                        labelText: "Email Address".tr,
                        hintText: "johndoe@gmail.com".tr,
                        initialValue: controller.currentUser?.value?.email,
                        onSaved: (input) =>
                            controller.currentUser.value.email = input,
                        validator: (input) => !input.contains('@')
                            ? "Should be a valid email".tr
                            : null,
                        iconData: Icons.alternate_email,
                        // isLast: false,
                      ),
                      TextFieldWidget(
                        // isFirst: true,
                        labelText: "Confirm Email Address".tr,
                        hintText: "johndoe@gmail.com".tr,
                        // initialValue: controller.currentUser?.value?.email,
                        // onSaved: (input) =>
                        //     controller.currentUser.value.email = input,
                        validator: (input) =>
                            controller.emailController.text != input
                                ? "email not match".tr
                                : null,
                        iconData: Icons.alternate_email,
                        // isLast: false,
                      ),
                      TextFieldWidget(
                        isFirst: false,
                        onSaved: (input) =>
                            controller.eProvider.value.description = input,
                        validator: (input) => input.length < 3
                            ? "Should be more than 3 letters".tr
                            : null,
                        keyboardType: TextInputType.multiline,
                        initialValue: controller.eProvider.value.description,
                        hintText: "Description for Architect Mayer Group".tr,
                        labelText: "*Description".tr,
                      ),
                      PhoneFieldWidget(
                        readOnly: false,
                        labelText: "Phone Number".tr,
                        hintText: "223 665 7896".tr,
                        initialCountryCode: controller.currentUser?.value
                            ?.getPhoneNumber()
                            ?.countryISOCode,
                        initialValue: controller.currentUser?.value
                            ?.getPhoneNumber()
                            ?.number,
                        onSaved: (phone) {
                          return controller.currentUser.value.phoneNumber =
                              phone.completeNumber;
                        },
                        isLast: false,
                        isFirst: false,
                      ),
                      TextFieldWidget(
                        onSaved: (input) => controller.eProvider.value
                            .availabilityRange = double.tryParse(input) ?? 0,
                        validator: (input) => (double.tryParse(input) ?? 0) <= 0
                            ? "Should be more than 0".tr
                            : null,
                        initialValue: controller
                                .eProvider.value.availabilityRange
                                ?.toString() ??
                            null,
                        keyboardType: TextInputType.numberWithOptions(
                            signed: false, decimal: true),
                        hintText: "5".tr,
                        labelText: "Availability Range".tr,
                        suffix: Text(Get.find<SettingsService>()
                            .setting
                            .value
                            .distanceUnit
                            .tr),
                      ),
                      Obx(() {
                        if (controller.eProviderTypes.isEmpty)
                          return SizedBox();
                        else
                          return Container(
                            padding: EdgeInsets.only(
                                top: 8, bottom: 10, left: 20, right: 20),
                            margin: EdgeInsets.only(
                                left: 20, right: 20, top: 0, bottom: 0),
                            decoration: BoxDecoration(
                                color: Get.theme.primaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          Get.theme.focusColor.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: Offset(0, 5)),
                                ],
                                border: Border.all(
                                    color: Get.theme.focusColor
                                        .withOpacity(0.05))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Provider Types".tr,
                                        style: Get.textTheme.bodyText1,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    MaterialButton(
                                      onPressed: () async {
                                        final selectedValue =
                                            await showDialog<EProviderType>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return SelectDialog(
                                              title: "Select Provider Type".tr,
                                              submitText: "Submit".tr,
                                              cancelText: "Cancel".tr,
                                              items: controller
                                                  .getSelectProviderTypesItems(),
                                              initialSelectedValue: controller
                                                  .eProviderTypes
                                                  .firstWhere(
                                                (element) =>
                                                    element.id ==
                                                    controller.eProvider.value
                                                        .type?.id,
                                                orElse: () =>
                                                    new EProviderType(),
                                              ),
                                            );
                                          },
                                        );
                                        controller.eProvider.update((val) {
                                          val.type = selectedValue;
                                        });
                                      },
                                      shape: StadiumBorder(),
                                      color: Get.theme.colorScheme.secondary
                                          .withOpacity(0.1),
                                      child: Text("Select".tr,
                                          style: Get.textTheme.subtitle1),
                                      elevation: 0,
                                      hoverElevation: 0,
                                      focusElevation: 0,
                                      highlightElevation: 0,
                                    ),
                                  ],
                                ),
                                Obx(() {
                                  if (controller.eProvider.value?.type ==
                                      null) {
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20),
                                      child: Text(
                                        "Select providers".tr,
                                        style: Get.textTheme.caption,
                                      ),
                                    );
                                  } else {
                                    return buildProviderType(
                                        controller.eProvider.value);
                                  }
                                })
                              ],
                            ),
                          );
                      }),
                      Container(
                        padding: EdgeInsets.only(
                            top: 8, bottom: 10, left: 20, right: 20),
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            color: Get.theme.primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                  color: Get.theme.focusColor.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 5)),
                            ],
                            border: Border.all(
                                color: Get.theme.focusColor.withOpacity(0.05))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Category".tr,
                                    style: Get.textTheme.bodyText1,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                // if (controller.selectedCategory.isEmpty)
                                MaterialButton(
                                  onPressed: () async {
                                    final selectedValues =
                                        await showDialog<Set<Category>>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SingleSelectDialog(
                                          title: "Select Category".tr,
                                          submitText: "Submit".tr,
                                          cancelText: "Cancel".tr,
                                          items: controller
                                              .getMultiSelectCategoriesItems(),
                                          initialSelectedValues: controller
                                              .categories
                                              .where(
                                                (category) =>
                                                    controller.selectedCategory
                                                        ?.where((element) =>
                                                            element.id ==
                                                            category.id)
                                                        ?.isNotEmpty ??
                                                    false,
                                              )
                                              .toSet(),
                                          // initialSelectedValues:
                                        );
                                      },
                                    );
                                    controller.selectedCategory.value =
                                        selectedValues?.toList();
                                    controller.selectedCategoryId.value =
                                        controller.selectedCategory[0].id;
                                    controller.selectedCategoryName.value =
                                        controller.selectedCategory[0].name;
                                    if (controller.selectedCategoryId != null) {
                                      controller.eProvider.value.cat_id =
                                          controller.selectedCategoryId.value;
                                    }

                                    // print("selected catagry is $selectedValues");
                                    // print(
                                    //     "selected catagry is ${controller.selectedCategoryId.value}");
                                    // print(
                                    //     "selected catagry is ${controller.selectedCategoryName.value}");
                                    // print(
                                    //     "list of map array ${controller.selectedCategory[0].id}");
                                  },
                                  shape: StadiumBorder(),
                                  color: Get.theme.colorScheme.secondary
                                      .withOpacity(0.1),
                                  child: Text("Select".tr,
                                      style: Get.textTheme.subtitle1),
                                  elevation: 0,
                                  hoverElevation: 0,
                                  focusElevation: 0,
                                  highlightElevation: 0,
                                ),
                              ],
                            ),
                            Obx(() {
                              if (controller.selectedCategory.isEmpty) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Text(
                                    "Select Category".tr,
                                    style: Get.textTheme.caption,
                                  ),
                                );
                              }
                              // else if (!controller.categoryName.value.isEmpty) {
                              //   return buildProviderCategory(
                              //       controller.categoryName.value);
                              // }
                              else {
                                return buildProviderCategory(
                                    controller.selectedCategoryName.value);
                              }
                            })
                          ],
                        ),
                      ),
                      Obx(() {
                        return RegisterTextFieldWidget(
                          controller: controller.passwordController,
                          labelText: "Password".tr,
                          hintText: "••••••••••••".tr,
                          initialValue: controller.currentUser?.value?.password,
                          onSaved: (input) =>
                              controller.currentUser.value.password = input,
                          validator: (input) => input.length < 3
                              ? "Should be more than 3 characters".tr
                              : null,
                          obscureText: controller.hidePassword.value,
                          iconData: Icons.lock_outline,
                          keyboardType: TextInputType.visiblePassword,
                          isLast: true,
                          isFirst: false,
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.hidePassword.value =
                                  !controller.hidePassword.value;
                            },
                            color: Theme.of(context).focusColor,
                            icon: Icon(controller.hidePassword.value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                          ),
                        );
                      }),
                      Obx(() {
                        return TextFieldWidget(
                          labelText: "Confirm Password".tr,
                          hintText: "••••••••••••".tr,
                          // initialValue: controller.currentUser?.value?.password,
                          // onSaved: (input) =>
                          //     controller.currentUser.value.password = input,
                          validator: (input) =>
                              controller.passwordController.text != input
                                  ? "password not match".tr
                                  : null,
                          obscureText: controller.hidePassword.value,
                          iconData: Icons.lock_outline,
                          keyboardType: TextInputType.visiblePassword,
                          isLast: true,
                          isFirst: false,
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.hidePassword.value =
                                  !controller.hidePassword.value;
                            },
                            color: Theme.of(context).focusColor,
                            icon: Icon(controller.hidePassword.value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                          ),
                        );
                      }),
                    ],
                  );
                }
              })
            ],
          ),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.vertical,
              children: [
                SizedBox(
                  width: Get.width,
                  child: BlockButtonWidget(
                    onPressed: () async {
                      if (!controller.selectedCategory.isEmpty &&
                          controller.eProvider.value.type != null) {
                        await controller.register();
                      } else {
                        Get.showSnackbar(Ui.ErrorSnackBar(
                            message:
                                "There are errors in some fields please correct them!"
                                    .tr));
                      }

                      //Get.offAllNamed(Routes.PHONE_VERIFICATION);
                    },
                    color: Get.theme.colorScheme.secondary,
                    text: Text(
                      "Register".tr,
                      style: Get.textTheme.headline6
                          .merge(TextStyle(color: Get.theme.primaryColor)),
                    ),
                  ).paddingOnly(top: 15, bottom: 5, right: 20, left: 20),
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed(Routes.LOGIN);
                  },
                  child: Text("You already have an account?".tr),
                ).paddingOnly(bottom: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProviderType(EProvider _eProvider) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        child:
            Text(_eProvider.type?.name ?? '', style: Get.textTheme.bodyText2),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }

  Widget buildProviderCategory(String _Category) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Text(_Category ?? '', style: Get.textTheme.bodyText2),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }
}
