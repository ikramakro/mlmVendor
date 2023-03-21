import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/helper.dart';
import '../../../models/category_model.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/media_model.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/images_field_widget.dart';
import '../../global_widgets/phone_field_widget.dart';
import '../../global_widgets/single_select_dialog.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/e_provider_form_controller.dart';
import '../widgets/horizontal_stepper_widget.dart';
import '../widgets/step_widget.dart';

class EProviderFormView extends GetView<EProviderFormController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Obx(() {
            return Text(
              controller.isCreateForm()
                  ? "New Service Provider".tr
                  : controller.eProvider.value.name ?? '',
              style: context.textTheme.headline6,
            );
          }),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
            onPressed: () => Get.back(),
          ),
          elevation: 0,
          actions: [
            // if (!controller.isCreateForm())
            //   new IconButton(
            //     padding: EdgeInsets.symmetric(horizontal: 20),
            //     icon: new Icon(
            //       Icons.delete_outline,
            //       color: Colors.redAccent,
            //       size: 28,
            //     ),
            //     onPressed: () async {
            //       final confirm = await showDialog<bool>(
            //         context: context,
            //         builder: (BuildContext context) {
            //           return ConfirmDialog(
            //             title: "Delete Provider".tr,
            //             content:
            //                 "Are you sure you want to delete this provider?".tr,
            //             submitText: "Confirm".tr,
            //             cancelText: "Cancel".tr,
            //           );
            //         },
            //       );
            //       if (confirm) {
            //         await controller.deleteEProvider();
            //       }
            //     },
            //   ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Get.theme.primaryColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  color: Get.theme.focusColor.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, -5)),
            ],
          ),
          child: Row(
            children: [
              Obx(() {
                return Expanded(
                  child: MaterialButton(
                    onPressed: controller.eProvider.value.addresses.isEmpty
                        ? null
                        : () {
                            if (controller.isCreateForm()) {
                              controller.createEProviderForm();
                            } else {
                              controller.updateEProviderForm();
                            }
                          },
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Get.theme.colorScheme.secondary,
                    disabledElevation: 0,
                    disabledColor: Get.theme.focusColor,
                    child: Text("Save & Next".tr,
                        style: Get.textTheme.bodyText2
                            .merge(TextStyle(color: Get.theme.primaryColor))),
                    elevation: 0,
                  ),
                );
              }),
            ],
          ).paddingSymmetric(vertical: 10, horizontal: 20),
        ),
        body: Form(
          key: controller.eProviderForm,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HorizontalStepperWidget(
                  controller: new ScrollController(initialScrollOffset: 50),
                  steps: [
                    StepWidget(
                      title: Text(
                        "Addresses".tr,
                      ),
                      color: Get.theme.focusColor,
                      index: Text("1",
                          style: TextStyle(color: Get.theme.primaryColor)),
                    ),
                    StepWidget(
                      title: Text(
                        "Provider Details".tr,
                      ),
                      index: Text("2",
                          style: TextStyle(color: Get.theme.primaryColor)),
                    ),
                    StepWidget(
                      title: Text(
                        "Availability".tr,
                      ),
                      color: Get.theme.focusColor,
                      index: Text("3",
                          style: TextStyle(color: Get.theme.primaryColor)),
                    ),
                  ],
                ),
                Text("Provider details".tr, style: Get.textTheme.headline5)
                    .paddingOnly(top: 25, bottom: 0, right: 22, left: 22),
                Text("Fill the following details and save them".tr,
                        style: Get.textTheme.caption)
                    .paddingSymmetric(horizontal: 22, vertical: 5),
                Obx(() {
                  return ImagesFieldWidget(
                    label: "Images".tr,
                    field: 'image',
                    tag: controller.eProviderForm.hashCode.toString(),
                    initialImages: controller.eProvider.value.images,
                    uploadCompleted: (uuid) {
                      controller.eProvider.update((val) {
                        val.images = val.images ?? [];
                        val.images.add(new Media(id: uuid));
                      });
                    },
                    reset: (uuids) {
                      controller.eProvider.update((val) {
                        val.images.clear();
                      });
                    },
                  );
                }),
                TextFieldWidget(
                  onSaved: (input) => controller.eProvider.value.name = input,
                  validator: (input) => input.length < 3
                      ? "Should be more than 3 letters".tr
                      : null,
                  initialValue: controller.eProvider.value.name,
                  hintText: "Architect Mayer Group".tr,
                  labelText: "*Name".tr,
                ),
                TextFieldWidget(
                  onSaved: (input) =>
                      controller.eProvider.value.description = input,
                  validator: (input) => input.length < 3
                      ? "Should be more than 3 letters".tr
                      : null,
                  keyboardType: TextInputType.multiline,
                  initialValue: controller.eProvider.value.description,
                  hintText: "Description for Architect Mayer Group".tr,
                  labelText: "*Profile Overview".tr,
                ),
                PhoneFieldWidget(
                  // readOnly: true,
                  labelText: "Phone Number".tr,
                  hintText: "223 665 7896".tr,
                  initialCountryCode: Helper.getPhoneNumber(
                          controller.eProvider.value.phoneNumber)
                      ?.countryISOCode,
                  initialValue: Helper.getPhoneNumber(
                          controller.eProvider.value.phoneNumber)
                      ?.number,
                  onSaved: (phone) {
                    return controller.eProvider.value.phoneNumber =
                        phone.completeNumber;
                  },
                ),
                PhoneFieldWidget(
                  // readOnly: true,
                  labelText: "Mobile Number".tr,
                  hintText: "223 665 7896".tr,
                  initialCountryCode: Helper.getPhoneNumber(
                          controller.eProvider.value.mobileNumber)
                      ?.countryISOCode,
                  initialValue: Helper.getPhoneNumber(
                          controller.eProvider.value.mobileNumber)
                      ?.number,
                  onSaved: (phone) {
                    return controller.eProvider.value.mobileNumber =
                        phone.completeNumber;
                  },
                ),
                TextFieldWidget(
                  onSaved: (input) => controller.eProvider.value
                      .availabilityRange = double.tryParse(input) ?? 0,
                  validator: (input) => (double.tryParse(input) ?? 0) <= 0
                      ? "Should be more than 0".tr
                      : null,
                  initialValue: controller.eProvider.value.availabilityRange
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
                // Obx(() {
                //   if (controller.eProviderTypes.isEmpty)
                //     return SizedBox();
                //   else
                //     return Container(
                //       padding: EdgeInsets.only(
                //           top: 8, bottom: 10, left: 20, right: 20),
                //       margin: EdgeInsets.only(
                //           left: 20, right: 20, top: 20, bottom: 20),
                //       decoration: BoxDecoration(
                //           color: Get.theme.primaryColor,
                //           borderRadius: BorderRadius.all(Radius.circular(10)),
                //           boxShadow: [
                //             BoxShadow(
                //                 color: Get.theme.focusColor.withOpacity(0.1),
                //                 blurRadius: 10,
                //                 offset: Offset(0, 5)),
                //           ],
                //           border: Border.all(
                //               color: Get.theme.focusColor.withOpacity(0.05))),
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.stretch,
                //         children: [
                //           Row(
                //             children: [
                //               Expanded(
                //                 child: Text(
                //                   "Provider Types".tr,
                //                   style: Get.textTheme.bodyText1,
                //                   textAlign: TextAlign.start,
                //                 ),
                //               ),
                //               MaterialButton(
                //                 onPressed: () async {
                //                   final selectedValue =
                //                       await showDialog<EProviderType>(
                //                     context: context,
                //                     builder: (BuildContext context) {
                //                       return SelectDialog(
                //                         title: "Select Provider Type".tr,
                //                         submitText: "Submit".tr,
                //                         cancelText: "Cancel".tr,
                //                         items: controller
                //                             .getSelectProviderTypesItems(),
                //                         initialSelectedValue: controller
                //                             .eProviderTypes
                //                             .firstWhere(
                //                           (element) =>
                //                               element.id ==
                //                               controller
                //                                   .eProvider.value.type?.id,
                //                           orElse: () => new EProviderType(),
                //                         ),
                //                       );
                //                     },
                //                   );
                //                   controller.eProvider.update((val) {
                //                     val.type = selectedValue;
                //                   });
                //                 },
                //                 shape: StadiumBorder(),
                //                 color: Get.theme.colorScheme.secondary
                //                     .withOpacity(0.1),
                //                 child: Text("Select".tr,
                //                     style: Get.textTheme.subtitle1),
                //                 elevation: 0,
                //                 hoverElevation: 0,
                //                 focusElevation: 0,
                //                 highlightElevation: 0,
                //               ),
                //             ],
                //           ),
                //           Obx(() {
                //             if (controller.eProvider.value?.type == null) {
                //               return Padding(
                //                 padding: EdgeInsets.symmetric(vertical: 20),
                //                 child: Text(
                //                   "Select providers".tr,
                //                   style: Get.textTheme.caption,
                //                 ),
                //               );
                //             } else {
                //               return buildProviderType(
                //                   controller.eProvider.value);
                //             }
                //           })
                //         ],
                //       ),
                //     );
                // }),
                Container(
                  padding:
                      EdgeInsets.only(top: 8, bottom: 10, left: 20, right: 20),
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
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
                          if (controller.selectedCategory.isEmpty)
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
                                                (controller.eProvider.value
                                                        .cat_id ==
                                                    category.id?.isNotEmpty) ??
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
                                  controller.eProvider.value.type =
                                      controller.eProviderTypes[0];
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
                      SizedBox(
                        height: 20,
                      ),
                      Obx(
                        () => Text(
                          controller.categoryName.value,
                          style: Get.textTheme.bodyText2.merge(TextStyle(
                            color: Colors.black,
                          )),
                          textAlign: TextAlign.start,
                        ),
                      )
                      // Obx(() {
                      //   if (controller.selectedCategory.value.isNull) {
                      //     return Padding(
                      //       padding: EdgeInsets.symmetric(vertical: 20),
                      //       child: Text(
                      //         "Select Category".tr,
                      //         style: Get.textTheme.caption,
                      //       ),
                      //     );
                      //   }
                      //   // else if (!controller.categoryName.value.isEmpty) {
                      //   //   return buildProviderCategory(
                      //   //       controller.categoryName.value);
                      //   // }
                      //   else {
                      //     return buildProviderCategory(
                      //         controller.selectedCategoryName.value);
                      //   }
                      // })
                    ],
                  ),
                ),
                // if (!controller.isCreateForm())
                // Container(
                //   padding: EdgeInsets.only(
                //       top: 8, bottom: 10, left: 20, right: 20),
                //   margin: EdgeInsets.only(
                //       left: 20, right: 20, top: 20, bottom: 20),
                //   decoration: BoxDecoration(
                //       color: Get.theme.primaryColor,
                //       borderRadius: BorderRadius.all(Radius.circular(10)),
                //       boxShadow: [
                //         BoxShadow(
                //             color: Get.theme.focusColor.withOpacity(0.1),
                //             blurRadius: 10,
                //             offset: Offset(0, 5)),
                //       ],
                //       border: Border.all(
                //           color: Get.theme.focusColor.withOpacity(0.05))),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.stretch,
                //     children: [
                //       Row(
                //         children: [
                //           Expanded(
                //             child: Text(
                //               "Employees".tr,
                //               style: Get.textTheme.bodyText1,
                //               textAlign: TextAlign.start,
                //             ),
                //           ),
                //           MaterialButton(
                //             onPressed: () async {
                //               final selectedValues =
                //                   await showDialog<Set<User>>(
                //                 context: context,
                //                 builder: (BuildContext context) {
                //                   return MultiSelectDialog(
                //                     title: "Select Employees".tr,
                //                     submitText: "Submit".tr,
                //                     cancelText: "Cancel".tr,
                //                     items: controller
                //                         .getMultiSelectEmployeesItems(),
                //                     initialSelectedValues: controller
                //                         .employees
                //                         .where(
                //                           (user) =>
                //                               controller
                //                                   .eProvider.value.employees
                //                                   ?.where((element) =>
                //                                       element.id == user.id)
                //                                   ?.isNotEmpty ??
                //                               false,
                //                         )
                //                         .toSet(),
                //                   );
                //                 },
                //               );
                //               controller.eProvider.update((val) {
                //                 val.employees = selectedValues?.toList();
                //               });
                //             },
                //             shape: StadiumBorder(),
                //             color: Get.theme.colorScheme.secondary
                //                 .withOpacity(0.1),
                //             child: Text("Select".tr,
                //                 style: Get.textTheme.subtitle1),
                //             elevation: 0,
                //             hoverElevation: 0,
                //             focusElevation: 0,
                //             highlightElevation: 0,
                //           ),
                //         ],
                //       ),
                //       Obx(() {
                //         if (controller.eProvider.value?.employees?.isEmpty ??
                //             true) {
                //           return Padding(
                //             padding: EdgeInsets.symmetric(vertical: 20),
                //             child: Text(
                //               "Select Employees".tr,
                //               style: Get.textTheme.caption,
                //             ),
                //           );
                //         } else {
                //           return buildEmployees(controller.eProvider.value);
                //         }
                //       })
                //     ],
                //   ),
                // ),
                // Container(
                //   padding:
                //       EdgeInsets.only(top: 8, bottom: 10, left: 20, right: 20),
                //   margin:
                //       EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                //   decoration: BoxDecoration(
                //       color: Get.theme.primaryColor,
                //       borderRadius: BorderRadius.all(Radius.circular(10)),
                //       boxShadow: [
                //         BoxShadow(
                //             color: Get.theme.focusColor.withOpacity(0.1),
                //             blurRadius: 10,
                //             offset: Offset(0, 5)),
                //       ],
                //       border: Border.all(
                //           color: Get.theme.focusColor.withOpacity(0.05))),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.stretch,
                //     children: [
                //       Row(
                //         children: [
                //           Expanded(
                //             child: Text(
                //               "Taxes".tr,
                //               style: Get.textTheme.bodyText1,
                //               textAlign: TextAlign.start,
                //             ),
                //           ),
                //           MaterialButton(
                //             onPressed: () async {
                //               final selectedValues = await showDialog<Set<Tax>>(
                //                 context: context,
                //                 builder: (BuildContext context) {
                //                   return MultiSelectDialog(
                //                     title: "Select Taxes".tr,
                //                     submitText: "Submit".tr,
                //                     cancelText: "Cancel".tr,
                //                     items:
                //                         controller.getMultiSelectTaxesItems(),
                //                     initialSelectedValues: controller.taxes
                //                         .where(
                //                           (tax) =>
                //                               controller.eProvider.value.taxes
                //                                   ?.where((element) =>
                //                                       element.id == tax.id)
                //                                   ?.isNotEmpty ??
                //                               false,
                //                         )
                //                         .toSet(),
                //                   );
                //                 },
                //               );
                //               controller.eProvider.update((val) {
                //                 val.taxes = selectedValues?.toList();
                //               });
                //             },
                //             shape: StadiumBorder(),
                //             color: Get.theme.colorScheme.secondary
                //                 .withOpacity(0.1),
                //             child: Text("Select".tr,
                //                 style: Get.textTheme.subtitle1),
                //             elevation: 0,
                //             hoverElevation: 0,
                //             focusElevation: 0,
                //             highlightElevation: 0,
                //           ),
                //         ],
                //       ),
                //       Obx(() {
                //         if (controller.eProvider.value?.taxes?.isEmpty ??
                //             true) {
                //           return Padding(
                //             padding: EdgeInsets.symmetric(vertical: 20),
                //             child: Text(
                //               "Select Taxes".tr,
                //               style: Get.textTheme.caption,
                //             ),
                //           );
                //         } else {
                //           return buildTaxes(controller.eProvider.value);
                //         }
                //       })
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ));
  }

  Widget buildEmployees(EProvider _eProvider) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Wrap(
          alignment: WrapAlignment.start,
          spacing: 5,
          runSpacing: 8,
          children: List.generate(_eProvider.employees?.length ?? 0, (index) {
            final _user = _eProvider.employees.elementAt(index);
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Text(_user.name,
                  style: Get.textTheme.bodyText1.merge(
                      TextStyle(color: Get.theme.colorScheme.secondary))),
              decoration: BoxDecoration(
                  color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                  border: Border.all(
                    color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            );
          })),
    );
  }

  Widget buildTaxes(EProvider _eProvider) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Wrap(
          alignment: WrapAlignment.start,
          spacing: 5,
          runSpacing: 8,
          children: List.generate(_eProvider.taxes?.length ?? 0, (index) {
            final tax = _eProvider.taxes.elementAt(index);
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Text(tax.name,
                  style: Get.textTheme.bodyText1.merge(
                      TextStyle(color: Get.theme.colorScheme.secondary))),
              decoration: BoxDecoration(
                  color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                  border: Border.all(
                    color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            );
          })),
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
