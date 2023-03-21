import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/booking_controller.dart';

class ReferenceImage extends GetView<BookingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        // title: Text(
        //   "Portfolio".tr,
        //   style: context.textTheme.headline6,
        // ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white70),
          onPressed: () => {Get.back()},
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.booking.value.booking_img.isEmpty) {
            return CircularLoadingWidget(height: 300);
          }
          return Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Hero(
                  tag: controller.booking.value.id,
                  child: InteractiveViewer(
                    scaleEnabled: true,
                    panEnabled: true,
                    // Set it to false to prevent panning.
                    minScale: 0.5,
                    maxScale: 4,
                    child: Container(
                      width: double.infinity,
                      alignment: AlignmentDirectional.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: CachedNetworkImage(
                          width: double.infinity,
                          fit: BoxFit.contain,
                          imageUrl: controller.booking.value.booking_img,
                          placeholder: (context, url) =>
                              CircularLoadingWidget(height: 200),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error_outline),
                        ),
                      ).marginSymmetric(horizontal: 20),
                    ),
                  ))
            ],
          );
        }),
      ),
    );
  }
}
