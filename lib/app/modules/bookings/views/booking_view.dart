import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../common/map.dart';
import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../global_widgets/NumTextFieldWidget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/booking_controller.dart';
import '../widgets/booking_actions_widget.dart';
import '../widgets/booking_row_widget.dart';
import '../widgets/booking_til_widget.dart';
import '../widgets/booking_title_bar_widget.dart';

class BookingView extends GetView<BookingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BookingActionsWidget(),
      body: RefreshIndicator(
          onRefresh: () async {
            Get.find<LaravelApiClient>().forceRefresh();
            controller.refreshBooking(showMessage: true);
            Get.find<LaravelApiClient>().unForceRefresh();
          },
          child: CustomScrollView(
            primary: true,
            shrinkWrap: false,
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                expandedHeight: 370,
                elevation: 0,
                // pinned: true,
                floating: true,
                iconTheme: IconThemeData(color: Get.theme.primaryColor),
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back_ios,
                      color: Get.theme.hintColor),
                  onPressed: () async {
                    Get.find<HomeController>().refreshHome();
                    Get.back();
                  },
                ),
                actions: [
                  Obx(() {
                    if (controller.booking.value.address == null)
                      return SizedBox();
                    else
                      return MaterialButton(
                        elevation: 0,
                        onPressed: () async {
                          MapsUtil.openMapsSheet(
                              context,
                              controller.booking.value.address?.getLatLng(),
                              controller.booking.value.id);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Get.theme.colorScheme.secondary,
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 5,
                          children: [
                            Icon(Icons.map_outlined,
                                color: Get.theme.primaryColor),
                            Text("On Maps".tr,
                                style: Get.textTheme.bodyText2.merge(
                                    TextStyle(color: Get.theme.primaryColor))),
                          ],
                        ),
                      );
                  }).paddingSymmetric(horizontal: 20, vertical: 8),
                ],
                bottom: buildBookingTitleBarWidget(controller.booking),
                flexibleSpace: Obx(() {
                  if (controller.booking.value.address == null)
                    return SizedBox();
                  else
                    return FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: MapsUtil.getStaticMaps(
                          [controller.booking.value.address.getLatLng()],
                          height: 600, size: '700x600', zoom: 14),
                    );
                }).marginOnly(bottom: 60),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Obx(() {
                      return buildContactCustomer(controller.booking.value);
                    }),
                    Obx(() {
                      if (controller.booking.value.status == null)
                        return SizedBox();
                      else
                        return BookingTilWidget(
                          title: Text("Booking Details".tr,
                              style: Get.textTheme.subtitle2),
                          actions: [
                            Text("#" + controller.booking.value.id,
                                style: Get.textTheme.subtitle2)
                          ],
                          content: Column(
                            children: [
                              BookingRowWidget(
                                  descriptionFlex: 1,
                                  valueFlex: 2,
                                  description: "Status".tr,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                            right: 12,
                                            left: 12,
                                            top: 6,
                                            bottom: 6),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          color: Get.theme.focusColor
                                              .withOpacity(0.1),
                                        ),
                                        child: Text(
                                          controller
                                              .booking.value.status.status,
                                          overflow: TextOverflow.clip,
                                          maxLines: 1,
                                          softWrap: true,
                                          style: TextStyle(
                                              color: Get.theme.hintColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  hasDivider: true),
                              BookingRowWidget(
                                  description: "Payment Status".tr,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                            right: 12,
                                            left: 12,
                                            top: 6,
                                            bottom: 6),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          color: Get.theme.focusColor
                                              .withOpacity(0.1),
                                        ),
                                        child: Text(
                                          controller.booking.value.payment
                                                  ?.paymentStatus?.status ??
                                              "Not Paid".tr,
                                          style: TextStyle(
                                              color: Get.theme.hintColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  hasDivider: true),
                              if (controller
                                      .booking.value.payment?.paymentMethod !=
                                  null)
                                BookingRowWidget(
                                    description: "Payment Method".tr,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(
                                              right: 12,
                                              left: 12,
                                              top: 6,
                                              bottom: 6),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            color: Get.theme.focusColor
                                                .withOpacity(0.1),
                                          ),
                                          child: Text(
                                            controller.booking.value.payment
                                                ?.paymentMethod
                                                ?.getName(),
                                            style: TextStyle(
                                                color: Get.theme.hintColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                    hasDivider: true),
                              BookingRowWidget(
                                description: "Hint".tr,
                                child: Ui.removeHtml(
                                    controller.booking.value.hint,
                                    alignment: Alignment.centerRight),
                              ),
                            ],
                          ),
                        );
                    }),
                    Obx(() {
                      if (controller.booking.value.booking_img.isEmpty)
                        return SizedBox();
                      else
                        return Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          decoration: Ui.getBoxDecoration(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Reference Image"),
                              SizedBox(
                                height: 15,
                              ),
                              Obx(() {
                                return Container(
                                  alignment: AlignmentDirectional.center,
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    child: FullScreenWidget(
                                      disposeLevel: DisposeLevel.Low,
                                      child: CachedNetworkImage(
                                        width: 250,
                                        fit: BoxFit.contain,
                                        imageUrl: controller
                                            .booking.value.booking_img,
                                        placeholder: (context, url) =>
                                            CircularLoadingWidget(height: 200),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error_outline),
                                      ),
                                    ),
                                  ).marginSymmetric(horizontal: 20),
                                );
                              }),
                            ],
                          ),
                        );
                    }),
                    Obx(() {
                      if (controller.booking.value.duration == null)
                        return SizedBox();
                      else
                        return BookingTilWidget(
                          title: Text("Booking Date & Time".tr,
                              style: Get.textTheme.subtitle2),
                          actions: [
                            Obx(
                              () => (!controller.booking.value.cancel)
                                  ? MaterialButton(
                                      elevation: 0,
                                      onPressed: () {
                                        _showMyDialog(
                                          context,
                                        );
                                      },
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      color:
                                          Get.theme.hintColor.withOpacity(0.1),
                                      child: Text("Edit".tr,
                                          style: Get.textTheme.bodyText2),
                                    )
                                  : SizedBox(),
                            ),
                          ],
                          content: Obx(() {
                            return Column(
                              children: [
                                if (controller.booking.value.bookingAt != null)
                                  BookingRowWidget(
                                      description: "Booking At".tr,
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            DateFormat('d, MMMM y  HH:mm',
                                                    Get.locale.toString())
                                                .format(controller
                                                    .booking.value.bookingAt),
                                            style: Get.textTheme.caption,
                                            textAlign: TextAlign.end,
                                          )),
                                      hasDivider:
                                          controller.booking.value.startAt !=
                                                  null ||
                                              controller.booking.value.endsAt !=
                                                  null),
                                if (controller.booking.value.startAt != null)
                                  BookingRowWidget(
                                      description: "Started At".tr,
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            DateFormat('d, MMMM y  HH:mm',
                                                    Get.locale.toString())
                                                .format(controller
                                                    .booking.value.startAt),
                                            style: Get.textTheme.caption,
                                            textAlign: TextAlign.end,
                                          )),
                                      hasDivider: false),
                                if (controller.booking.value.endsAt != null)
                                  BookingRowWidget(
                                    description: "Ended At".tr,
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          DateFormat('d, MMMM y  HH:mm',
                                                  Get.locale.toString())
                                              .format(controller
                                                  .booking.value.endsAt),
                                          style: Get.textTheme.caption,
                                          textAlign: TextAlign.end,
                                        )),
                                  ),
                                Obx(() {
                                  if (controller.booking.value.eService == null)
                                    return SizedBox();
                                  else
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Divider(
                                          thickness: 2,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text("Pricing".tr,
                                            style: Get.textTheme.subtitle2),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        BookingRowWidget(
                                            descriptionFlex: 2,
                                            valueFlex: 1,
                                            description: controller
                                                .booking.value.eService.name,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Ui.getPrice(
                                                  controller.booking.value
                                                      .eService.getPrice,
                                                  style:
                                                      Get.textTheme.subtitle2),
                                            ),
                                            hasDivider: true),
                                        Column(
                                          children: List.generate(
                                              controller.booking.value.options
                                                  .length, (index) {
                                            var _option = controller
                                                .booking.value.options
                                                .elementAt(index);
                                            return BookingRowWidget(
                                                descriptionFlex: 2,
                                                valueFlex: 1,
                                                description: _option.name,
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Ui.getPrice(
                                                      _option.price,
                                                      style: Get
                                                          .textTheme.bodyText1),
                                                ),
                                                hasDivider: (controller
                                                            .booking
                                                            .value
                                                            .options
                                                            .length -
                                                        1) ==
                                                    index);
                                          }),
                                        ),
                                        if (controller.booking.value.eService
                                                .priceUnit ==
                                            'fixed')
                                          BookingRowWidget(
                                              description: "Quantity".tr,
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  "x" +
                                                      controller.booking.value
                                                          .quantity
                                                          .toString() +
                                                      " " +
                                                      controller
                                                          .booking
                                                          .value
                                                          .eService
                                                          .quantityUnit
                                                          .tr,
                                                  style:
                                                      Get.textTheme.bodyText2,
                                                ),
                                              ),
                                              hasDivider: true),
                                        // Column(
                                        //   children: List.generate(
                                        //       controller.booking.value.taxes.length,
                                        //       (index) {
                                        //     var _tax = controller.booking.value.taxes
                                        //         .elementAt(index);
                                        //     return BookingRowWidget(
                                        //         description: _tax.name,
                                        //         child: Align(
                                        //           alignment: Alignment.centerRight,
                                        //           child: _tax.type == 'percent'
                                        //               ? Text(_tax.value.toString() + '%',
                                        //                   style: Get.textTheme.bodyText1)
                                        //               : Ui.getPrice(
                                        //                   _tax.value,
                                        //                   style: Get.textTheme.bodyText1,
                                        //                 ),
                                        //         ),
                                        //         hasDivider: (controller
                                        //                     .booking.value.taxes.length -
                                        //                 1) ==
                                        //             index);
                                        //   }),
                                        // ),
                                        // Obx(() {
                                        //   return BookingRowWidget(
                                        //     description: "Tax Amount".tr,
                                        //     child: Align(
                                        //       alignment: Alignment.centerRight,
                                        //       child: Ui.getPrice(
                                        //           controller.booking.value
                                        //               .getTaxesValue(),
                                        //           style: Get.textTheme.subtitle2),
                                        //     ),
                                        //     hasDivider: false,
                                        //   );
                                        // }),
                                        // if (controller.booking.value.extra?.isNotEmpty)
                                        //   Container(
                                        //     height: controller.ChargeSize(),
                                        //     child: ListView.builder(
                                        //         scrollDirection: Axis.vertical,
                                        //         itemCount:
                                        //             controller.booking.value.extra.length,
                                        //         itemBuilder: (context, index) {
                                        //           return Obx(() {
                                        //             return Column(
                                        //               children: [
                                        //                 BookingRowWidget(
                                        //                   description: controller.booking
                                        //                       .value.extra[index].name,
                                        //                   child: Align(
                                        //                     alignment:
                                        //                         Alignment.centerRight,
                                        //                     child: Ui.getPrice(
                                        //                         controller.booking.value
                                        //                             .extra[index].price
                                        //                             .toDouble(),
                                        //                         style: Get
                                        //                             .textTheme.subtitle2),
                                        //                   ),
                                        //                 ),
                                        //                 SizedBox(
                                        //                   height: 5,
                                        //                 )
                                        //               ],
                                        //             );
                                        //           });
                                        //         }),
                                        //   ),
                                        // Obx(() {
                                        //   return BookingRowWidget(
                                        //       description: "Subtotal".tr,
                                        //       child: Align(
                                        //         alignment: Alignment.centerRight,
                                        //         child: Ui.getPrice(
                                        //             controller.booking.value
                                        //                 .getSubtotal(),
                                        //             style: Get.textTheme.subtitle2),
                                        //       ),
                                        //       hasDivider: true);
                                        // }),
                                        // if ((controller.booking.value.coupon?.discount ??
                                        //         0) >
                                        //     0)
                                        //   BookingRowWidget(
                                        //       description: "Coupon".tr,
                                        //       child: Align(
                                        //         alignment: Alignment.centerRight,
                                        //         child: Wrap(
                                        //           children: [
                                        //             Text(' - ',
                                        //                 style: Get.textTheme.bodyText1),
                                        //             Ui.getPrice(
                                        //                 controller.booking.value.coupon
                                        //                     .discount,
                                        //                 style: Get.textTheme.bodyText1,
                                        //                 unit: controller
                                        //                             .booking
                                        //                             .value
                                        //                             .coupon
                                        //                             .discountType ==
                                        //                         'percent'
                                        //                     ? "%"
                                        //                     : null),
                                        //           ],
                                        //         ),
                                        //       ),
                                        //       hasDivider: true),
                                        Obx(() {
                                          return BookingRowWidget(
                                            description: "Total Amount".tr,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Ui.getPrice(
                                                  controller.booking.value
                                                      .getTotal(),
                                                  style:
                                                      Get.textTheme.headline6),
                                            ),
                                          );
                                        })
                                      ],
                                    );
                                })
                              ],
                            );
                          }),
                        );
                    }),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Future<void> _showMyDialog(
    BuildContext context,
  ) async {
    bool isOpen = false;
    return showDialog(
        context: context,
        builder: (_) => new Dialog(
              child: SizedBox(
                height: 280,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    const Text('Edit Price & Date '),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text('Booking Date')),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.picked.toString()
                          // DateFormat('d, MMMM y ', Get.locale.toString())
                          //     .format(controller.booking.value.bookingAt),
                          ,
                          style: Get.textTheme.caption,
                          textAlign: TextAlign.start,
                        ),
                        IconButton(
                            onPressed: () {
                              controller.showMyDatePicker(context);
                              isOpen = true;
                            },
                            icon: Icon(
                              Icons.edit,
                            ))
                      ],
                    ),
                    Form(
                      key: controller.ChargeForm,
                      child: Container(
                        height: 60,
                        child: Container(
                          child: NumTextFieldWidget(
                            keyboardType: TextInputType.phone,
                            // controller: priceController,
                            validator: (input) => input.length < 2
                                ? "Should be more than 3 letters".tr
                                : null,
                            onSaved: (input) =>
                                controller.bookingExtraString.value = input,
                            // initialValue: "",
                            // hintText: "Price".tr,
                            // labelText: "Price".tr,
                            hintText: 'Prices'.tr,
                            // iconData: Icons.person_outline,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        TextButton(
                          child: const Text('Save'),
                          onPressed: () {
                            if (isOpen &&
                                !controller.ChargeForm.currentState
                                    .validate()) {
                              controller.updateBookingDate();
                              isOpen = false;
                              Navigator.of(context).pop();
                              Get.log('Date is run ');
                              Get.log('picked value${controller.picked}');
                            }
                            // if (!controller.ChargeForm.currentState
                            //     .validate()) {
                            //   controller.ChargeForm.currentState.save();
                            //   controller.ExtraInBooking();
                            //   Navigator.of(context).pop();
                            // }

                            // controller.ChargeForm.currentState.save();
                            // controller.ExtraInBooking();
                            // controller.updateBookingDate();

                            // Navigator.of(context).pop();
                            // controller.AddCharge();

                            else if (!isOpen &&
                                controller.ChargeForm.currentState.validate()) {
                              controller.ChargeForm.currentState.save();
                              controller.ExtraInBooking();
                              Get.log('price is run ');
                              // controller.AddCharge();
                              Navigator.of(context).pop();
                            } else {
                              controller.ChargeForm.currentState.save();
                              controller.ExtraInBooking();
                              controller.updateBookingDate();
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                        TextButton(
                          child: const Text('Close'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ],
                ).paddingOnly(left: 15),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
            ));
  }

  BookingTitleBarWidget buildBookingTitleBarWidget(Rx<Booking> _booking) {
    return BookingTitleBarWidget(
      title: Obx(() {
        return Row(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AutoSizeText(
                    _booking.value.eService?.name ?? '',
                    style:
                        Get.textTheme.headline5.merge(TextStyle(height: 1.1)),
                    overflow: TextOverflow.fade,
                  ),
                  Row(
                    children: [
                      Icon(Icons.person_outline, color: Get.theme.focusColor),
                      SizedBox(width: 8),
                      AutoSizeText(
                        _booking.value.user?.name ?? '',
                        style: Get.textTheme.bodyText1,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.place_outlined, color: Get.theme.focusColor),
                      SizedBox(width: 8),
                      Expanded(
                        child: AutoSizeText(
                            _booking.value.address?.address ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Get.textTheme.bodyText1),
                      ),
                    ],
                    // spacing: 8,
                    // crossAxisAlignment: WrapCrossAlignment.center,
                  ),
                ],
              ),
            ),
            if (_booking.value.bookingAt == null)
              Container(
                width: 80,
                child: SizedBox.shrink(),
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
              ),
            if (_booking.value.bookingAt != null)
              Container(
                width: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        DateFormat('HH:mm', Get.locale.toString())
                            .format(_booking.value.bookingAt),
                        maxLines: 1,
                        style: Get.textTheme.bodyText2.merge(
                          TextStyle(
                              color: Get.theme.colorScheme.secondary,
                              height: 1.4),
                        ),
                        softWrap: false,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade),
                    Text(
                        DateFormat('dd', Get.locale.toString())
                            .format(_booking.value.bookingAt ?? ''),
                        maxLines: 1,
                        style: Get.textTheme.headline3.merge(
                          TextStyle(
                              color: Get.theme.colorScheme.secondary,
                              height: 1),
                        ),
                        softWrap: false,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade),
                    Text(
                        DateFormat('MMM', Get.locale.toString())
                            .format(_booking.value.bookingAt ?? ''),
                        maxLines: 1,
                        style: Get.textTheme.bodyText2.merge(
                          TextStyle(
                              color: Get.theme.colorScheme.secondary,
                              height: 1),
                        ),
                        softWrap: false,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
              ),
          ],
        );
      }),
    );
  }

  Container buildContactCustomer(Booking _booking) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: Ui.getBoxDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Contact Customer".tr, style: Get.textTheme.subtitle2),
                Text(_booking.user?.phoneNumber ?? '',
                    style: Get.textTheme.caption),
              ],
            ),
          ),
          Obx(() => (!controller.booking.value.cancel)
              ? Wrap(
                  spacing: 5,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        print("phone number ${_booking.user.phoneNumber}");
                        launchUrlString(
                            "tel:${_booking.user?.phoneNumber ?? ''}");
                      },
                      height: 44,
                      minWidth: 44,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                      child: Icon(
                        Icons.phone_android_outlined,
                        color: Get.theme.colorScheme.secondary,
                      ),
                      elevation: 0,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        controller.messages.value = [];
                        bool chatExist =
                            await controller.listenForMessages(_booking);

                        if (chatExist == false) {
                          controller.startChat();
                        }
                        controller.startChat();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                      padding: EdgeInsets.zero,
                      height: 44,
                      minWidth: 44,
                      child: Icon(
                        Icons.chat_outlined,
                        color: Get.theme.colorScheme.secondary,
                      ),
                      elevation: 0,
                    ),
                  ],
                )
              : SizedBox())
        ],
      ),
    );
  }
}
