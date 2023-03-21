import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/global_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/confirm_dialog.dart';
import '../controllers/booking_controller.dart';

class BookingActionsWidget extends GetView<BookingController> {
  const BookingActionsWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _booking = controller.booking;
    return Obx(() {
      if (_booking.value.status == null) {
        return SizedBox(height: 0);
      }
      return Container(
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
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          if (_booking.value.status.order ==
              Get.find<GlobalService>().global.value.received)
            Expanded(
                child: Obx(
              () => BlockButtonWidget(
                  text: Stack(
                    alignment: AlignmentDirectional.centerEnd,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text("Accept".tr,
                            textAlign: TextAlign.center,
                            style: Get.textTheme.headline6.merge(
                              TextStyle(color: Get.theme.primaryColor),
                            )),
                      ),
                      Icon(
                          controller.booking.value.extra == 0.0
                              ? Icons.clear_rounded
                              : Icons.check,
                          color: Get.theme.primaryColor,
                          size: 22)
                    ],
                  ),
                  color: controller.booking.value.extra != 0.0
                      ? Get.theme.colorScheme.secondary
                      : Get.theme.colorScheme.secondary.withOpacity(0.3),
                  onPressed: () async {
                    if (controller.booking.value.extra != 0.0) {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return ConfirmDialog(
                            title: "Accept".tr,
                            content: "Are you sure you want to Accept?".tr,
                            submitText: "Confirm".tr,
                            cancelText: "Cancel".tr,
                          );
                        },
                      );
                      if (confirm) {
                        // controller.acceptBookingService();
                        controller.onTheWayBookingService();
                      }
                    }
                  }),
            )),
          if (_booking.value.status.order ==
              Get.find<GlobalService>().global.value.accepted)
            Expanded(
                child: BlockButtonWidget(
                    text: Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            "On the Way".tr,
                            textAlign: TextAlign.center,
                            style: Get.textTheme.headline6.merge(
                              TextStyle(color: Get.theme.primaryColor),
                            ),
                          ),
                        ),
                        Icon(Icons.airport_shuttle_outlined,
                            color: Get.theme.primaryColor, size: 24)
                      ],
                    ),
                    color: Get.theme.colorScheme.secondary,
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return ConfirmDialog(
                            title: "On the Way".tr,
                            content: "Are you sure ?".tr,
                            submitText: "Confirm".tr,
                            cancelText: "Cancel".tr,
                          );
                        },
                      );
                      if (confirm) {
                        controller.onTheWayBookingService();
                      }
                    })),
          if (_booking.value.status.order ==
              Get.find<GlobalService>().global.value.onTheWay)
            Expanded(
              child: BlockButtonWidget(
                  text: Stack(
                    alignment: AlignmentDirectional.centerEnd,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Delivery".tr,
                          textAlign: TextAlign.center,
                          style: Get.textTheme.headline6.merge(
                            TextStyle(color: Get.theme.primaryColor),
                          ),
                        ),
                      ),
                      Icon(Icons.build_outlined,
                          color: Get.theme.primaryColor, size: 24)
                    ],
                  ),
                  color: Get.theme.hintColor,
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmDialog(
                          title: "Delivery".tr,
                          content: "Are you sure to deliver?".tr,
                          submitText: "Confirm".tr,
                          cancelText: "Cancel".tr,
                        );
                      },
                    );
                    if (confirm) {
                      controller.readyBookingService();
                    }
                  }),
            ),
          if (_booking.value.status.order ==
              Get.find<GlobalService>().global.value.inProgress)
            Expanded(
              child: BlockButtonWidget(
                  text: Stack(
                    alignment: AlignmentDirectional.centerEnd,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Complete".tr,
                          textAlign: TextAlign.center,
                          style: Get.textTheme.headline6.merge(
                            TextStyle(color: Get.theme.primaryColor),
                          ),
                        ),
                      ),
                      Icon(Icons.build_outlined,
                          color: Get.theme.primaryColor, size: 24)
                    ],
                  ),
                  color: Get.theme.hintColor,
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmDialog(
                          title: "Complete".tr,
                          content: "Are you sure to Complete?".tr,
                          submitText: "Confirm".tr,
                          cancelText: "Cancel".tr,
                        );
                      },
                    );
                    if (confirm) {
                      controller.doneBookingService();
                    }
                  }),
            ),
          // if (_booking.value.status.order >=
          //         Get.find<GlobalService>().global.value.done &&
          //     _booking.value.payment == null)
          //   Expanded(
          //     child: Text(
          //       "Waiting for Payment".tr,
          //       textAlign: TextAlign.center,
          //       style: Get.textTheme.bodyText1,
          //     ),
          //   ),
          if (_booking.value.cancel)
            Expanded(
              child: Text(
                "Booking Cancelled".tr,
                textAlign: TextAlign.center,
                style: Get.textTheme.bodyText1,
              ),
            ),
          if (_booking.value.status.order ==
              Get.find<GlobalService>().global.value.done)
            Expanded(
              child: Text(
                "Booking Complete Successfully".tr,
                textAlign: TextAlign.center,
                style: Get.textTheme.bodyText1,
              ),
            ),
          // if (_booking.value.status.order >=
          //         Get.find<GlobalService>().global.value.done &&
          //     _booking.value.payment != null)
          //   // (_booking.value.payment.paymentStatus?.id ?? '') == '1' &&
          //   // (_booking.value.payment.paymentMethod?.route ?? '') == '/Cash')
          //   Expanded(
          //     child: BlockButtonWidget(
          //         text: Stack(
          //           alignment: AlignmentDirectional.centerEnd,
          //           children: [
          //             SizedBox(
          //               width: double.infinity,
          //               child: Text(
          //                 "Confirm Payment".tr,
          //                 textAlign: TextAlign.center,
          //                 style: Get.textTheme.headline6.merge(
          //                   TextStyle(color: Get.theme.primaryColor),
          //                 ),
          //               ),
          //             ),
          //             Icon(Icons.money, color: Get.theme.primaryColor, size: 22)
          //           ],
          //         ),
          //         color: Get.theme.colorScheme.secondary,
          //         onPressed: () async {
          //           final confirm = await showDialog<bool>(
          //             context: context,
          //             builder: (BuildContext context) {
          //               return ConfirmDialog(
          //                 title: "Confirm Payment".tr,
          //                 content:
          //                     "Are you sure you want to Confirm Payment?".tr,
          //                 submitText: "Confirm".tr,
          //                 cancelText: "Cancel".tr,
          //               );
          //             },
          //           );
          //           if (confirm) {
          //             controller.confirmPaymentBookingService();
          //           }
          //         }),
          //   ),
          SizedBox(width: 10),
          if (!_booking.value.cancel &&
              _booking.value.status.order <
                  Get.find<GlobalService>().global.value.onTheWay)
            MaterialButton(
              elevation: 0,
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmDialog(
                      title: "Decline".tr,
                      content: "Are you sure you want to Decline".tr,
                      submitText: "Confirm".tr,
                      cancelText: "Cancel".tr,
                    );
                  },
                );
                if (confirm) {
                  controller.declineBookingService();
                }
              },
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Get.theme.hintColor.withOpacity(0.1),
              child: Text("Decline".tr, style: Get.textTheme.bodyText2),
            ),
        ]).paddingSymmetric(vertical: 10, horizontal: 20),
      );
    });
  }
}
