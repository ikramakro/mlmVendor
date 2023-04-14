// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../Controller/EditPorfolioController.dart';

class EditPortfolio extends GetView<EditPortfolioController> {
  int indx;
  EditPortfolio({
    this.indx,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // floatingActionButton: Obx(
      //   () => new FloatingActionButton(
      //     child: new Icon(
      //         controller.editable.value == true ? Icons.delete : Icons.edit,
      //         size: 28,
      //         color: Get.theme.primaryColor),
      //     onPressed: () => {
      //       controller.editable.value == false
      //           ? controller.editable.value = true
      //           : controller.deletePortfolio(controller.galleries.value.id),
      //       // Get.toNamed(Routes.PortfolioAlbum, preventDuplicates: false),
      //       // Get.toN,
      //     },
      //     backgroundColor: Get.theme.colorScheme.secondary,
      //   ).paddingOnly(bottom: 0),
      // ),
      appBar: AppBar(
        title: Text(
          "Portfolio".tr,
          style: context.textTheme.headline6,
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      bottomNavigationBar: Obx(
        () => controller.editable.value == true
            ? Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Get.theme.primaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
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
                          controller.updatePortfolio();
                        },
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Get.theme.colorScheme.secondary,
                        child: Text("Save".tr,
                            style: Get.textTheme.bodyText2.merge(
                                TextStyle(color: Get.theme.primaryColor))),
                        elevation: 0,
                        highlightElevation: 0,
                        hoverElevation: 0,
                        focusElevation: 0,
                      ),
                    ),
                  ],
                ).paddingSymmetric(vertical: 10, horizontal: 20),
              )
            : SizedBox(
                width: 0,
              ),
      ),
      body: Obx(() {
        controller.galleriess.add(controller.galleries.value);
        return PhotoViewGallery.builder(
          itemCount: controller.galleriess.length,
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
                imageProvider: CachedNetworkImageProvider(
                    controller.galleriess[index].url),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.contained * 5);
          },
        );
      }),
    );
    // body: PageView.builder(
    //   itemCount: controller.galleriess.length,
    //   itemBuilder: (context, index) {
    //     Get.log(controller.galleriess.length.toString());
    //     return SingleChildScrollView(
    //       child: Container(
    //         // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    //         // padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
    //         decoration: Ui.getBoxDecoration(),
    //         child: Column(
    //           children: [
    // Hero(
    //   tag: controller.heroTag + controller.galleries.value.id,
    //   child: Container(
    //     padding: EdgeInsets.only(
    //         top: 10, bottom: 5, left: 20, right: 20),
    //     margin: EdgeInsets.only(
    //         left: 20, right: 20, top: 0, bottom: 5),
    //     decoration: BoxDecoration(
    //       color: Get.theme.primaryColor,
    //       // borderRadius: BorderRadius.all(Radius.circular(10)),
    //       boxShadow: [
    //         BoxShadow(
    //             color: Get.theme.focusColor.withOpacity(0.1),
    //             blurRadius: 10,
    //             offset: Offset(0, 5)),
    //       ],
    //       border: Border.all(
    //         color:
    //             // Colors.black
    //             Get.theme.focusColor.withOpacity(0.05),
    //       ),
    //     ),
    //     child: InteractiveViewer(
    //       panEnabled: true,
    //       boundaryMargin: EdgeInsets.all(20),
    //       minScale: 0.1,
    //       maxScale: 5,
    //       child: ClipRRect(
    //         borderRadius: BorderRadius.all(Radius.circular(10)),
    //         child: CachedNetworkImage(
    //           height:
    //               MediaQuery.of(context).size.height / 100 * 55,
    //           width: double.infinity,
    //           fit: BoxFit.fill,
    //           imageUrl: controller.galleries.value.url,
    //           placeholder: (context, url) => Image.asset(
    //             'assets/img/loading.gif',
    //             fit: BoxFit.cover,
    //             width: double.infinity,
    //             height: 100,
    //           ),
    //           errorWidget: (context, url, error) =>
    //               Icon(Icons.error_outline),
    //         ),
    //       ),
    //     ),
    //               ),
    //             ),
    //             Obx(
    //               () => Form(
    //                 key: controller.portfolioEditForm,
    //                 child: TextFieldWidget(
    //                   readOnly: !controller.editable.value,
    //                   initialValue: controller.galleries.value.name,
    //                   isFirst: false,
    //                   onSaved: (input) {
    //                     controller.description.value = input;
    //                   },
    //                   validator: (input) => input.isEmpty
    //                       ? "Should be more than 3 letters".tr
    //                       : null,
    //                   keyboardType: TextInputType.multiline,
    //                   // initialValue: controller.eProvider.value.description,
    //                   // hintText: "Description for Portfolio Image".tr,
    //                   labelText: "*Description".tr,
    //                 ),
    //               ),
    //             )
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // ));
  }
}
