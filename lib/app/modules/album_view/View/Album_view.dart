import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../Controller/AlbumView_Controller.dart';
import '../Widget/multiSelectImage.dart';

class AlbumView extends GetView<AlbumViewController> {
  @override
  Widget build(BuildContext context) {
    final key1 = GlobalObjectKey<ExpandableFabState>(context);
    return Obx(() => Scaffold(
        floatingActionButtonLocation: controller.isDeletable.isFalse
            ? ExpandableFab.location
            : FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Obx(
          () => controller.isDeletable.isFalse
              ? ExpandableFab(
                  key: key1,
                  overlayStyle: ExpandableFabOverlayStyle(
                    // color: Colors.black.withOpacity(0.5),
                    blur: 5,
                  ),
                  children: [
                    FloatingActionButton.small(
                      heroTag: null,
                      child: const Icon(Icons.edit),
                      onPressed: () {
                        controller.isEditable.value = true;
                        key1.currentState.toggle();
                        // Get.toNamed(Routes.Edit_Album);
                      },
                    ),
                    FloatingActionButton.small(
                      heroTag: null,
                      child: const Icon(Icons.delete),
                      onPressed: () {
                        controller.isDeletable.value = true;
                      },
                    ),
                    FloatingActionButton.small(
                      heroTag: null,
                      child: const Icon(Icons.add),
                      onPressed: () {
                        Get.toNamed(Routes.PortfolioAlbum,
                            arguments: {'index': 1}, preventDuplicates: false);
                        key1.currentState.toggle();
                      },
                    ),
                  ],
                )
              : IconButton(
                  icon: new Icon(Icons.cancel_rounded,
                      size: 35, color: Colors.blueAccent),
                  onPressed: () => controller.isDeletable.value = false,
                ),
        ),
        // new FloatingActionButton(
        //   child: new Icon(Icons.edit, size: 28, color: Get.theme.primaryColor),
        //   onPressed: () => {
        //     // Get.toNamed(Routes.PortfolioAlbum, preventDuplicates: false),
        //     // Get.toN,
        //   },
        //   backgroundColor: Get.theme.colorScheme.secondary,
        // ),
        body: Obx(
          () => controller.isDeletable.isFalse
              ? RefreshIndicator(
                  onRefresh: () => controller.getGalleries(),
                  child: GridView.builder(
                    itemCount: controller.album.length,
                    scrollDirection: Axis.vertical,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5.0,
                        mainAxisSpacing: 5.0),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          print(
                              "this is the Album of image ${controller.album[index].images}");
                          controller.isEditable.isFalse
                              ? Get.toNamed(Routes.View_SubAlbum, arguments: {
                                  'album': controller.album[index].images,
                                  'hero': 'AlbumView',
                                  'eProvider': controller.eProvider.value
                                })
                              : Get.toNamed(Routes.Edit_Album, arguments: {
                                  'album': controller.album[index],
                                });
                          controller.isEditable.value = false;
                        },
                        child: Hero(
                          tag: 'AlbumView' + controller.album[index].id,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: CachedNetworkImage(
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.fill,
                              imageUrl: controller
                                  .album[index].images[0].media[0].url,
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
                  ).paddingOnly(top: 15))
              : GridView.builder(
                  itemCount: controller.album.length,
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 3 / 3.5,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5.0),
                  itemBuilder: (context, index) {
                    return GridItem(
                        item: controller.album[index],
                        isSelected: (bool value) {
                          if (value) {
                            controller.selectedList
                                .add(controller.album[index]);
                          } else {
                            controller.selectedList
                                .remove(controller.album[index]);
                          }

                          print("$index : $value");
                        },
                        key: Key(controller.album[index].images[0].description
                            .toString()));
                  }),
        )));
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
