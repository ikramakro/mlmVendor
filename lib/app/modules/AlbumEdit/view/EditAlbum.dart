import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../EditSubAlbum/widget/EditAlbumTextFieldWidget.dart';
import '../../global_widgets/PortflioTextFieldWidget.dart';
import '../controller/EditAlbumController.dart';

class EditAlbums extends GetView<EditAlbumController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Edit Album".tr,
            style: context.textTheme.headline6,
          ),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
            onPressed: () => Get.back(),
          ),
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
                    controller.createPortfolioAlbum();
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
          key: controller.albumForm1.value,
          child: SingleChildScrollView(
            controller: controller.controller1,
            child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 5, left: 0, right: 0),
              margin: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
              decoration: BoxDecoration(
                  color: Get.theme.primaryColor,
                  // borderRadius: BorderRadius.all(Radius.circular(10)),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Album".tr, style: Get.textTheme.headline5)
                              .paddingOnly(
                                  top: 25, bottom: 0, right: 22, left: 22),
                          Text("Upload New Multiples images of your Album".tr,
                                  style: Get.textTheme.caption)
                              .paddingSymmetric(horizontal: 22, vertical: 5),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Obx(
                        () => Container(
                          padding: EdgeInsets.only(
                              top: 0, bottom: 0, left: 5, right: 20),
                          margin: EdgeInsets.only(
                              left: 5, right: 5, top: 5, bottom: 0),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    top: 0, bottom: 0, left: 20, right: 20),
                                margin: EdgeInsets.only(
                                    left: 0, right: 0, top: 5, bottom: 0),
                                decoration: BoxDecoration(
                                    color: Get.theme.primaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Get.theme.focusColor
                                              .withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: Offset(0, 5)),
                                    ],
                                    border: Border.all(
                                        color: Get.theme.focusColor
                                            .withOpacity(0.05))),
                                child: EditAlbumTextFieldWidget(
                                  // controller: controller.Name.value,
                                  initialValue: controller.album.value.name,
                                  onSaved: (input) =>
                                      controller.albumCoverName.value = input,
                                  validator: (input) => input.length < 3
                                      ? "Should be more than 3 letters".tr
                                      : null,
                                  // initialValue: controller.eProvider.value.name,
                                  hintText: "Album name".tr,
                                  labelText: "*Name".tr,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 0, bottom: 0, left: 20, right: 20),
                                margin: EdgeInsets.only(
                                    left: 0, right: 0, top: 5, bottom: 0),
                                decoration: BoxDecoration(
                                    color: Get.theme.primaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Get.theme.focusColor
                                              .withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: Offset(0, 5)),
                                    ],
                                    border: Border.all(
                                        color: Get.theme.focusColor
                                            .withOpacity(0.05))),
                                child: EditAlbumTextFieldWidget(
                                  isFirst: false,
                                  // controller: controller.Des.value,
                                  initialValue:
                                      controller.album.value.description,
                                  onSaved: (input) =>
                                      controller.albumCoverDes.value = input,
                                  validator: (input) => input.length < 3
                                      ? "Should be more than 3 letters".tr
                                      : null,
                                  keyboardType: TextInputType.multiline,
                                  // initialValue: controller.eProvider.value.description,
                                  hintText:
                                      "Description for Cover Image of your Album"
                                          .tr,
                                  labelText: "*Description".tr,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 0, bottom: 0, left: 20, right: 20),
                                margin: EdgeInsets.only(
                                    left: 0, right: 0, top: 5, bottom: 0),
                                decoration: BoxDecoration(
                                    color: Get.theme.primaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Get.theme.focusColor
                                              .withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: Offset(0, 5)),
                                    ],
                                    border: Border.all(
                                        color: Get.theme.focusColor
                                            .withOpacity(0.05))),
                                height: 300,
                                child: ListView.builder(
                                  controller: controller.controller2,
                                  itemCount: controller.imagesLength.value,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    controller.controllers
                                        .add(new TextEditingController());
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Obx(() {
                                          return Row(
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
                                          );
                                        }),
                                        PortfolioTextFieldWidget(
                                          controller:
                                              controller.controllers[index],
                                          isFirst: false,
                                          validator: (input) => input.length <
                                                      3 &&
                                                  controller.newImages.isTrue
                                              ? "Should be more than 3 letters"
                                                  .tr
                                              : null,
                                          keyboardType: TextInputType.multiline,
                                          // initialValue: controller.eProvider.value.description,
                                          hintText:
                                              "Description for Portfolio Image"
                                                  .tr,
                                          labelText: "*Description".tr,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
