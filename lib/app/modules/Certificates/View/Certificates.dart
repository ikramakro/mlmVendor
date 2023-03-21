import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../global_widgets/PortflioTextFieldWidget.dart';
import '../controllers/certificates_Controller.dart';

class Certificates extends GetView<CertificatesController> {
  final bool hideAppBar;

  Certificates({this.hideAppBar = false}) {
    // controller.profileForm = new GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    controller.certificateForm = new GlobalKey<FormState>();
    return Scaffold(
        appBar: hideAppBar
            ? null
            : AppBar(
                title: Text(
                  "Certificates".tr,
                  style: context.textTheme.headline6,
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back_ios,
                      color: Get.theme.hintColor),
                  onPressed: () => Get.back(),
                ),
                elevation: 0,
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
              Expanded(
                child: MaterialButton(
                  onPressed: () async {
                    print(
                        "length of portfolio list ${controller.uuidPortfolio.length}");
                    print(
                        "length of description list ${controller.descriptionList.length}");
                    controller.certificates();
                  },
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Get.theme.colorScheme.secondary,
                  child: Text("Save".tr,
                      style: Get.textTheme.bodyText2
                          .merge(TextStyle(color: Get.theme.primaryColor))),
                  elevation: 0,
                  highlightElevation: 0,
                  hoverElevation: 0,
                  focusElevation: 0,
                ),
              ),
            ],
          ).paddingSymmetric(vertical: 10, horizontal: 20),
        ),
        body: Form(
          key: controller.certificateForm,
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Certificates".tr,
                                  style: Get.textTheme.headline5)
                              .paddingOnly(
                                  top: 25, bottom: 0, right: 22, left: 22),
                          Text("Upload images of your Certificates".tr,
                                  style: Get.textTheme.caption)
                              .paddingSymmetric(horizontal: 22, vertical: 5),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    // height: controller.size.value.toDouble(),
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 0, bottom: 0, left: 20, right: 20),
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 5, bottom: 0),
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
                        children: [
                          Container(
                              height: 500,
                              child: Obx(() {
                                return ListView.builder(
                                  itemCount: controller.imagesLength.value,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Obx(
                                          () => Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              if (controller.uploaded.isTrue)
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  child: Image.file(
                                                    controller.images[index],
                                                    fit: BoxFit.cover,
                                                    width: 100,
                                                    height: 100,
                                                  ),
                                                ),
                                              if (controller.uploaded.isFalse)
                                                if (controller.uploading.isTrue)
                                                  buildLoader()
                                                else
                                                  GestureDetector(
                                                    onTap: () async {
                                                      await controller
                                                          .pickImage(
                                                        ImageSource.gallery,
                                                        "image",
                                                      );
                                                    },
                                                    child: Container(
                                                      width: 100,
                                                      height: 100,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                          color: Get
                                                              .theme.focusColor
                                                              .withOpacity(0.1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: Icon(
                                                          Icons
                                                              .add_photo_alternate_outlined,
                                                          size: 42,
                                                          color: Get
                                                              .theme.focusColor
                                                              .withOpacity(
                                                                  0.4)),
                                                    ),
                                                  ).paddingOnly(top: 10),
                                              MaterialButton(
                                                onPressed: () async {
                                                  // await controller
                                                  //     .deleteUploaded();
                                                  controller.reset(index);
                                                },
                                                shape: StadiumBorder(),
                                                color: Get.theme.focusColor
                                                    .withOpacity(0.1),
                                                child: Text("Reset".tr,
                                                    style: Get
                                                        .textTheme.bodyText1),
                                                elevation: 0,
                                                hoverElevation: 0,
                                                focusElevation: 0,
                                                highlightElevation: 0,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Obx(
                                          () => PortfolioTextFieldWidget(
                                            initialValue: controller
                                                    .titleList.isNotEmpty
                                                ? controller.titleList[index]
                                                : "",
                                            isFirst: false,

                                            onSaved: (input) {
                                              if (input != "") {
                                                if (index <=
                                                    controller
                                                            .titleList.length -
                                                        1) {
                                                  if (controller
                                                          .titleList[index] !=
                                                      "") {
                                                    controller.titleList
                                                        .removeAt(index);
                                                  }
                                                }
                                                controller.titleList
                                                    .insert(index, input);
                                              }
                                            },
                                            validator: (input) => input.length <
                                                    3
                                                ? "Should be more than 3 characters"
                                                    .tr
                                                : null,
                                            keyboardType:
                                                TextInputType.multiline,
                                            // initialValue: controller.eProvider.value.description,
                                            hintText:
                                                "Title for Certificate Image"
                                                    .tr,
                                            labelText: "*Title".tr,
                                          ),
                                        ),
                                        PortfolioTextFieldWidget(
                                          isFirst: false,
                                          onSaved: (input) {
                                            if (input != "") {
                                              if (index <=
                                                  controller.descriptionList
                                                          .length -
                                                      1) {
                                                if (controller.descriptionList[
                                                        index] !=
                                                    "") {
                                                  controller.descriptionList
                                                      .removeAt(index);
                                                }
                                              }
                                              controller.descriptionList
                                                  .insert(index, input);
                                            }
                                          },
                                          validator: (input) => input.length < 3
                                              ? "Should be more than 3 characters"
                                                  .tr
                                              : null,
                                          keyboardType: TextInputType.multiline,
                                          // initialValue: controller.eProvider.value.description,
                                          hintText:
                                              "Description for Certificate Image"
                                                  .tr,
                                          labelText: "*Description".tr,
                                        ),
                                      ],
                                    );
                                  },
                                );
                              })),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget buildLoader() {
    return Container(
        width: 100,
        height: 100,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Image.asset(
            'assets/img/loading.gif',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 100,
          ),
        ));
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }
}
