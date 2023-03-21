import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../models/booking_status_model.dart';
import '../../../models/charge_model.dart';
import '../../../models/media_model.dart';
import '../../../models/message_model.dart';
import '../../../models/payment_method_model.dart';
import '../../../models/payment_model.dart';
import '../../../models/payment_status_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/booking_repository.dart';
import '../../../repositories/e_provider_repository.dart';
import '../../../repositories/payment_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/global_service.dart';
import '../../home/controllers/home_controller.dart';
import 'package:http/http.dart' as http;

class BookingController extends GetxController {
  BookingRepository _bookingRepository;
  EProviderRepository _eProviderRepository;
  PaymentRepository _paymentRepository;
  final bookingStatuses = <BookingStatus>[].obs;
  Timer timer;
  final booking = Booking().obs;
  final bookingExtra = 0.0.obs;
  final bookingExtraString = ''.obs;
  final InitialDate = DateTime.now().obs;
  final Date = "".obs;
  var messages = <Message>[].obs;
  Rx<DocumentSnapshot> lastDocument = new Rx<DocumentSnapshot>(null);
  // List<Extra> Charges = [].obs as List<Extra>;
  final Charges = <Charge>[].obs;
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final ListCharges = <Charge>[].obs;
  final ChargesName = "".obs;
  final ChargesPrice = "".obs;
  GlobalKey<FormState> ChargeForm = new GlobalKey<FormState>();

  BookingController() {
    _bookingRepository = BookingRepository();
    _eProviderRepository = EProviderRepository();
    _paymentRepository = PaymentRepository();
  }

  @override
  void onInit() async {
    booking.value = Get.arguments as Booking;
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshBooking();
    super.onReady();
  }

  Future<Null> showMyDatePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: booking.value.bookingAt,
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
      locale: Get.locale,
      builder: (BuildContext context, Widget child) {
        return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: Get.theme.primaryColor,
              accentColor: Get.theme.accentColor,
              colorScheme: Get.theme.colorScheme,
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child.paddingAll(10));
      },
    );
    if (picked != null) {
      InitialDate.value = DateTime(picked.year, picked.month, picked.day);
      String date = DateTime(picked.year, picked.month, picked.day).toString();
      var dateTime = DateTime.parse(date);
      DateTime Datex = DateTime(picked.year, picked.month, picked.day);
      var format = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
      Date.value = format;
      // booking.update((val) {
      //   val.bookingAt = Datex;
      // });
      print("pick date is${format}");

      booking.update((val) {
        val.bookingAt = DateTime(picked.year, picked.month, picked.day,
            val.bookingAt.hour, val.bookingAt.minute);
      });
      DateInBooking(booking.value.bookingAt);
    }
  }

  Future<void> DateInBooking(DateTime bookingDate) async {
    try {
      final _booking = new Booking(
        bookingAt: bookingDate,
      );

      await _bookingRepository.updateDate(_booking, booking.value.id);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  // void AddCharge() async {
  //   Get.focusScope.unfocus();
  //
  //   // ChargeForm.currentState.save();
  //   print("running save");
  //   final _Charges = Charge(
  //     name: ChargesName.value,
  //     price: int.parse(ChargesPrice.value),
  //   );
  //
  //   print("values $Charges");
  //   if (ChargesPrice.value.isNotEmpty) {
  //     await ExtraInBooking(_Charges);
  //   }
  // }

  Future refreshBooking({bool showMessage = false}) async {
    await getBooking();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(
          message: "Booking page refreshed successfully".tr));
    }
  }

  Future<void> getBooking() async {
    try {
      booking.value = await _bookingRepository.get(booking.value.id);
      print("extra is ${booking.value.extra}");
      if (booking.value.status ==
              Get.find<HomeController>().getStatusByOrder(
                  Get.find<GlobalService>().global.value.inProgress) &&
          timer == null) {
        timer = Timer.periodic(Duration(minutes: 1), (t) {
          booking.update((val) {
            val.duration += (1 / 60);
          });
        });
      }
      print("these are the bookings ${booking.value.extra.toString()} ");
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> changeBookingStatus(BookingStatus bookingStatus) async {
    try {
      final _booking = new Booking(
        id: booking.value.id,
        status: bookingStatus,
      );
      print("check this booking ${_booking.extra}");
      await _bookingRepository.update(_booking);
      booking.update((val) {
        val.status = bookingStatus;
      });
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future ExtraInBooking() async {
    print("this is runnning check this booking");
    // print("List ${priceController.text}");
    print("$bookingExtra");
    print("${booking.value.getSubtotal()}");
    bookingExtra.value = double.parse(bookingExtraString.value);
    bookingExtra.value = bookingExtra.value - booking.value.getSubtotal();
    print("extra is this ${bookingExtra.value}");
    try {
      final _booking = new Booking(
        extra: bookingExtra.value,
      );
      print("check extra charges ${_booking.extra}");

      print("check this booking ${bookingExtra}");
      await _bookingRepository.updateExtra(_booking, booking.value.id);
      booking.update((val) {
        val.extra = bookingExtra.value;
      });
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> acceptBookingService() async {
    if (booking.value.status.order ==
        Get.find<GlobalService>().global.value.received) {
      final _status = Get.find<HomeController>()
          .getStatusByOrder(Get.find<GlobalService>().global.value.accepted);
      await changeBookingStatus(_status);
    }
  }

  Future<void> onTheWayBookingService() async {
    final _status = Get.find<HomeController>()
        .getStatusByOrder(Get.find<GlobalService>().global.value.onTheWay);
    await changeBookingStatus(_status);
  }

  Future<void> readyBookingService() async {
    final _status = Get.find<HomeController>()
        .getStatusByOrder(Get.find<GlobalService>().global.value.inProgress);
    await changeBookingStatus(_status);
  }

  Future<void> doneBookingService() async {
    final _status = Get.find<HomeController>()
        .getStatusByOrder(Get.find<GlobalService>().global.value.done);
    await changeBookingStatus(_status);
    await createPaymentBookingService();
  }

  Future<void> confirmPaymentBookingService() async {
    try {
      final _status = Get.find<HomeController>()
          .getStatusByOrder(Get.find<GlobalService>().global.value.done);
      final _payment = new Payment(
          id: booking.value.payment.id, paymentStatus: PaymentStatus(id: '2'));
      print("confirm payment check $_payment"); //Paid
      final result = await _paymentRepository.update(_payment);
      booking.update((val) {
        val.payment = result;
        val.status = _status;
      });
      timer?.cancel();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> createPaymentBookingService() async {
    try {
      final _paymentMethod = PaymentMethod(id: "6", description: "cash");
      final _payment = new Payment(paymentMethod: _paymentMethod);
      final _booking = Booking(id: booking.value.id, payment: _payment); //Paid
      final result = await _paymentRepository.create(_booking);
      print(_booking);
      print("create payment result $result");
      if (result.hasData) {
        booking.update((val) {
          val.payment = result;
          // val.status = _status;
        });
        await confirmPaymentBookingService();
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> declineBookingService() async {
    try {
      if (booking.value.status.order <
          Get.find<GlobalService>().global.value.onTheWay) {
        final _status = Get.find<HomeController>()
            .getStatusByOrder(Get.find<GlobalService>().global.value.failed);
        final _booking =
            new Booking(id: booking.value.id, cancel: true, status: _status);
        await _bookingRepository.update(_booking);
        booking.update((val) {
          val.cancel = true;
          val.status = _status;
        });
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  String getTime({String separator = ":"}) {
    String hours = "";
    String minutes = "";
    int minutesInt =
        ((booking.value.duration - booking.value.duration.toInt()) * 60)
            .toInt();
    int hoursInt = booking.value.duration.toInt();
    if (hoursInt < 10) {
      hours = "0" + hoursInt.toString();
    } else {
      hours = hoursInt.toString();
    }
    if (minutesInt < 10) {
      minutes = "0" + minutesInt.toString();
    } else {
      minutes = minutesInt.toString();
    }
    return hours + separator + minutes;
  }

  Future listenForMessages(Booking booking) async {
    final _userMessages = await getVendorMessagesStartAt(booking);

    if (_userMessages.docs.isNotEmpty) {
      _userMessages.docs.forEach((element) {
        messages.add(Message.fromDocumentSnapshot(element));
        Get.toNamed(Routes.CHAT, arguments: messages[0]);
      });
      lastDocument.value = _userMessages.docs.last;

      return true;
    } else {
      return false;
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getVendorMessagesStartAt(
      Booking booking) {
    return FirebaseFirestore.instance
        .collection("messages")
        .where('bookingID', isEqualTo: booking.id)
        .get();
  }

  Future<void> startChat() async {
    List<User> _employees =
        await _eProviderRepository.getEmployees(booking.value.eProvider.id);
    _employees = _employees
        .map((e) {
          if (booking.value.eProvider.images.isNotEmpty) {
            e.avatar = booking.value.eProvider.images[0];
          } else {
            e.avatar = new Media();
          }
          return e;
        })
        .toSet()
        .toList();
    _employees.insert(0, booking.value.user);
    Message _message = new Message(_employees,
        name: booking.value.eProvider.name, bookingID: booking.value.id);
    Get.toNamed(Routes.CHAT, arguments: _message);
  }

  getDeviceTokenfromfirebase() {
    final fireStore = FirebaseFirestore.instance
        .collection('Device Token')
        .doc(booking.value.id)
        .get();

    print('======================.>>>>>$fireStore');
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void sendNotification(String deviceToken, String title, String body) async {
    const postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "notification": {"body": body, "title": title},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done"
      },
      "to": deviceToken
    };
    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAA1v9SiQw:APA91bGQS4VCsacFk9oycGrDDxMFsymmLX_XyP05TGv9KDLdmLB03Y2JidqeGjHRLMBFAGMZpWWiL7BHj1cuBfiJXvdUrYnbb22GxMSFgTPVQE0X0gJ7r_pu3UMZ7ecXKIephkuPy4_k'
    };

    await http.post(Uri.parse(postUrl),
        body: json.encode(data), headers: headers);
  }
}
