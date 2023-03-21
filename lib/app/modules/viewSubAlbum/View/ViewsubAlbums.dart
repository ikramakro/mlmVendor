import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../routes/app_routes.dart';
import '../Controller/ViewSubAlbumController.dart';

class ViewSubAlbums extends GetView<ViewSubAlbumsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "SubAlbums".tr,
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
        body: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
            decoration: Ui.getBoxDecoration(),
            child: GridView.builder(
              itemCount: controller.album.length,
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0),
              itemBuilder: (context, index) {
                return Obx(() => GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.Edit_SubAlbum, arguments: {
                          'subAlbum': controller.album[index],
                          'hero': '${controller.heroTag}',
                          'eProvider': controller.eProvider.value
                        });
                        print(controller.album[index]);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: CachedNetworkImage(
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.fill,
                          imageUrl: controller.album[index].media[0].url,
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
                    ));
                return SizedBox();
              },
            ).paddingOnly(top: 15)));
  }
}
