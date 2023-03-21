import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../global_widgets/PortflioTextFieldWidget.dart';
import '../controllers/portfolioController.dart';

class Portfolio extends GetView<PortfolioController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding:
                    EdgeInsets.only(top: 10, bottom: 5, left: 20, right: 20),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Portfolio".tr, style: Get.textTheme.headline5)
                            .paddingOnly(
                                top: 25, bottom: 0, right: 22, left: 22),
                        Text("Upload Multiple images of your Portfolio".tr,
                                style: Get.textTheme.caption)
                            .paddingSymmetric(horizontal: 22, vertical: 5),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 5, left: 20, right: 20),
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
                  height: MediaQuery.of(context).size.height / 100 * 57,
                  child: Obx(() {
                    return Form(
                      key: controller.portfolioForm1.value,
                      child: ListView.builder(
                          itemCount: controller.imagesLength.value,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            controller.controllers
                                .add(new TextEditingController());
                            return Container(
                              padding: EdgeInsets.only(
                                  top: 10, bottom: 0, left: 20, right: 20),
                              margin: EdgeInsets.only(
                                  left: 0, right: 0, top: 0, bottom: 5),
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
                              child: Column(
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
                                              borderRadius: BorderRadius.all(
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
                                                  await controller.pickImage(
                                                    ImageSource.gallery,
                                                    "image",
                                                  );
                                                },
                                                child: Container(
                                                  width: 100,
                                                  height: 100,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: Get
                                                          .theme.focusColor
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Icon(
                                                      Icons
                                                          .add_photo_alternate_outlined,
                                                      size: 42,
                                                      color: Get
                                                          .theme.focusColor
                                                          .withOpacity(0.4)),
                                                ),
                                              ).paddingOnly(top: 10),
                                          MaterialButton(
                                            onPressed: () async {
                                              controller.reset(index);
                                            },
                                            shape: StadiumBorder(),
                                            color: Get.theme.focusColor
                                                .withOpacity(0.1),
                                            child: Text("Reset".tr,
                                                style: Get.textTheme.bodyText1),
                                            elevation: 0,
                                            hoverElevation: 0,
                                            focusElevation: 0,
                                            highlightElevation: 0,
                                          ),
                                        ],
                                      );
                                    }),
                                    PortfolioTextFieldWidget(
                                      controller: controller.controllers[index],
                                      isFirst: false,
                                      // onSaved: (input) {
                                      //   controller.descriptionList.add(input);
                                      // },
                                      validator: (input) => input.isEmpty
                                          ? "Should be more than 3 letters".tr
                                          : null,
                                      keyboardType: TextInputType.multiline,
                                      // initialValue: controller.eProvider.value.description,
                                      hintText:
                                          "Description for Portfolio Image".tr,
                                      labelText: "*Description".tr,
                                    ),
                                  ]),
                            );
                          }),
                    );
                  })),
            ],
          ),
        ));
    // SingleChildScrollView(
    //   child:
    //   Form(
    //     key: controller.portfolioForm,
    //     child: Container(
    //       padding: EdgeInsets.symmetric(vertical: 10),
    //       decoration: BoxDecoration(
    //         color: Get.theme.primaryColor,
    //         // borderRadius: BorderRadius.only(
    //         //     topLeft: Radius.circular(20),
    //         //     topRight: Radius.circular(20)),
    //         boxShadow: [
    //           BoxShadow(
    //               color: Get.theme.focusColor.withOpacity(0.1),
    //               blurRadius: 10,
    //               offset: Offset(0, -5)),
    //         ],
    //       ),
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         children: [
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             children: [
    //               Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Text("Portfolio".tr, style: Get.textTheme.headline5)
    //                       .paddingOnly(
    //                           top: 25, bottom: 0, right: 22, left: 22),
    //                   Text("Upload Multiple images of your Portfolio".tr,
    //                           style: Get.textTheme.caption)
    //                       .paddingSymmetric(horizontal: 22, vertical: 5),
    //                 ],
    //               ),
    //             ],
    //           ),
    //           Container(
    //             padding:
    //                 EdgeInsets.only(top: 0, bottom: 0, left: 20, right: 20),
    //             margin:
    //                 EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
    //             decoration: BoxDecoration(
    //                 color: Get.theme.primaryColor,
    //                 borderRadius: BorderRadius.all(Radius.circular(10)),
    //                 boxShadow: [
    //                   BoxShadow(
    //                       color: Get.theme.focusColor.withOpacity(0.1),
    //                       blurRadius: 10,
    //                       offset: Offset(0, 5)),
    //                 ],
    //                 border: Border.all(
    //                     color: Get.theme.focusColor.withOpacity(0.05))),
    //             child: Column(
    //               children: [
    //                 Container(
    //                     height:
    //                         MediaQuery.of(context).size.height / 100 * 55,
    //                     child: Obx(() {
    //                       return ListView.builder(
    //                         itemCount: controller.imagesLength.value,
    //                         scrollDirection: Axis.vertical,
    //                         itemBuilder: (context, index) {
    //                           return Column(
    //                             crossAxisAlignment:
    //                                 CrossAxisAlignment.stretch,
    //                             children: [
    //                               Obx(() {
    //                                 return Row(
    //                                   mainAxisAlignment:
    //                                       MainAxisAlignment.spaceBetween,
    //                                   children: [
    //                                     if (controller.uploaded.isTrue)
    //                                       ClipRRect(
    //                                         borderRadius: BorderRadius.all(
    //                                             Radius.circular(10)),
    //                                         child: Image.file(
    //                                           controller.images[index],
    //                                           fit: BoxFit.cover,
    //                                           width: 100,
    //                                           height: 100,
    //                                         ),
    //                                       ),
    //                                     if (controller.uploaded.isFalse)
    //                                       if (controller.uploading.isTrue)
    //                                         buildLoader()
    //                                       else
    //                                         GestureDetector(
    //                                           onTap: () async {
    //                                             await controller.pickImage(
    //                                               ImageSource.gallery,
    //                                               "image",
    //                                             );
    //                                           },
    //                                           child: Container(
    //                                             width: 100,
    //                                             height: 100,
    //                                             alignment: Alignment.center,
    //                                             decoration: BoxDecoration(
    //                                                 color: Get
    //                                                     .theme.focusColor
    //                                                     .withOpacity(0.1),
    //                                                 borderRadius:
    //                                                     BorderRadius
    //                                                         .circular(10)),
    //                                             child: Icon(
    //                                                 Icons
    //                                                     .add_photo_alternate_outlined,
    //                                                 size: 42,
    //                                                 color: Get
    //                                                     .theme.focusColor
    //                                                     .withOpacity(0.4)),
    //                                           ),
    //                                         ).paddingOnly(top: 10),
    //                                     MaterialButton(
    //                                       onPressed: () async {
    //                                         controller.reset(index);
    //                                       },
    //                                       shape: StadiumBorder(),
    //                                       color: Get.theme.focusColor
    //                                           .withOpacity(0.1),
    //                                       child: Text("Reset".tr,
    //                                           style:
    //                                               Get.textTheme.bodyText1),
    //                                       elevation: 0,
    //                                       hoverElevation: 0,
    //                                       focusElevation: 0,
    //                                       highlightElevation: 0,
    //                                     ),
    //                                   ],
    //                                 );
    //                               }),
    //                               PortfolioTextFieldWidget(
    //                                 controller: controller.controller,
    //                                 isFirst: false,
    //
    //                                 onSaved: (input) {
    //                                   if (input != "") {
    //                                     if (index <=
    //                                         controller.descriptionList
    //                                                 .length -
    //                                             1) {
    //                                       if (controller
    //                                               .descriptionList[index] !=
    //                                           "") {
    //                                         controller.descriptionList
    //                                             .removeAt(index);
    //                                       }
    //                                     }
    //                                     controller.descriptionList
    //                                         .insert(index, input);
    //                                   }
    //                                 },
    //
    //                                 validator: (input) => input.isEmpty
    //                                     ? "Should be more than 3 letters".tr
    //                                     : null,
    //                                 keyboardType: TextInputType.multiline,
    //                                 // initialValue: controller.eProvider.value.description,
    //                                 hintText:
    //                                     "Description for Portfolio Image"
    //                                         .tr,
    //                                 labelText: "*Description".tr,
    //                               ),
    //                             ],
    //                           );
    //                         },
    //                       );
    //                     })),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // ));
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
