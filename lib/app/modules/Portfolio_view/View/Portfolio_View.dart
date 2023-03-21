import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../controllers/PortfolioViewController.dart';

class PortfolioView extends GetView<PortfolioViewController> {
  @override
  Widget build(BuildContext context) {
    Get.put(PortfolioViewController());
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: new Icon(Icons.edit, size: 28, color: Get.theme.primaryColor),
          onPressed: () => {
            Get.toNamed(Routes.PortfolioAlbum,
                arguments: {'index': 0}, preventDuplicates: false)
            // Get.toNamed(Routes.PortfolioAlbum, preventDuplicates: false),
            // Get.toN,
          },
          backgroundColor: Get.theme.colorScheme.secondary,
        ),
        body: RefreshIndicator(
            onRefresh: () => controller.getGalleries(),
            child: Obx(() => GridView.builder(
                  itemCount: controller.galleries.length,
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5.0),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        print(
                            "this is the discriotion of image ${controller.galleries[index]}");
                        Get.toNamed(Routes.Edit_Portfolio, arguments: {
                          'gallery': controller.galleries[index],
                          'hero': 'portfolio',
                          'eProvider': controller.eProvider.value
                        });
                      },
                      child: Hero(
                        tag: 'portfolio' + controller.galleries[index].id,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: CachedNetworkImage(
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            imageUrl: controller.galleries[index].url,
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
                    );
                  },
                ).paddingOnly(top: 15))));
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
