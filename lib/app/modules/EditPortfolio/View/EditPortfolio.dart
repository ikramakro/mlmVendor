import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../global_widgets/text_field_widget.dart';
import '../Controller/EditPorfolioController.dart';

class EditPortfolio extends GetView<EditPortfolioController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Obx(
        () => new FloatingActionButton(
          child: new Icon(
              controller.editable.value == true ? Icons.delete : Icons.edit,
              size: 28,
              color: Get.theme.primaryColor),
          onPressed: () => {
            controller.editable.value == false
                ? controller.editable.value = true
                : controller.deletePortfolio(controller.galleries.value.id),
            // Get.toNamed(Routes.PortfolioAlbum, preventDuplicates: false),
            // Get.toN,
          },
          backgroundColor: Get.theme.colorScheme.secondary,
        ).paddingOnly(bottom: 0),
      ),
      appBar: AppBar(
        title: Text(
          "Portfolio".tr,
          style: context.textTheme.headline6,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
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
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
          decoration: Ui.getBoxDecoration(),
          child: Column(
            children: [
              Hero(
                tag: controller.heroTag + controller.galleries.value.id,
                child: Container(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 5, left: 20, right: 20),
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 5),
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: CachedNetworkImage(
                      height: MediaQuery.of(context).size.height / 100 * 50,
                      width: double.infinity,
                      fit: BoxFit.fill,
                      imageUrl: controller.galleries.value.url,
                      placeholder: (context, url) => Image.asset(
                        'assets/img/loading.gif',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 100,
                      ),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error_outline),
                    ),
                  ),
                ),
              ),
              Obx(
                () => Form(
                  key: controller.portfolioEditForm,
                  child: TextFieldWidget(
                    readOnly: !controller.editable.value,
                    initialValue: controller.galleries.value.name,
                    isFirst: false,
                    onSaved: (input) {
                      controller.description.value = input;
                    },
                    validator: (input) => input.isEmpty
                        ? "Should be more than 3 letters".tr
                        : null,
                    keyboardType: TextInputType.multiline,
                    // initialValue: controller.eProvider.value.description,
                    // hintText: "Description for Portfolio Image".tr,
                    labelText: "*Description".tr,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
