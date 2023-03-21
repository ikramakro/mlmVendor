import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../models/booking_status_model.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/message_model.dart';
import '../../../models/statistic.dart';
import '../../../repositories/booking_repository.dart';
import '../../../repositories/chat_repository.dart';
import '../../../repositories/statistic_repository.dart';
import '../../../services/auth_service.dart';
import '../../../services/global_service.dart';
import '../../root/controllers/root_controller.dart';

class HomeController extends GetxController {
  StatisticRepository _statisticRepository;
  BookingRepository _bookingsRepository;

  final statistics = <Statistic>[].obs;
  final bookings = <Booking>[].obs;
  final totalRequestsCompleted = "0".obs;
  final bookingStatuses = <BookingStatus>[].obs;
  final page = 0.obs;
  final isLoading = true.obs;
  final isDone = false.obs;
  final currentStatus = '1'.obs;
  final Date = "".obs;
  AuthService _authService;
  final InitialDate = DateTime.now().obs;
  final All = true.obs;
  final eProvider = EProvider().obs;
  ChatRepository _chatRepository;
  ScrollController scrollController;
  var messages = <Message>[].obs;

  HomeController() {
    _statisticRepository = new StatisticRepository();
    _bookingsRepository = new BookingRepository();
    _chatRepository = new ChatRepository();
    _authService = Get.find<AuthService>();
  }

  @override
  Future<void> onInit() async {
    await refreshHome();
    await listenForMessages();
    await TotalRequestsCompleted();
    super.onInit();
  }

  @override
  void onClose() {
    print("calling on onclose");
    scrollController?.dispose();
  }

  OnResume() {
    print("this on resume is calling");
    for (int i = 0; i < messages.length; i++) {
      _chatRepository.updateStatus(messages[i]);
    }
  }

  Future listenForMessages() async {
    isLoading.value = true;
    isDone.value = false;
    final userMessages =
        await _chatRepository.getUserMessagez(_authService.user.value.id);
    if (userMessages.docs.isNotEmpty) {
      userMessages.docs.forEach((element) {
        messages.add(Message.fromDocumentSnapshot(element));
        print("yoooo $messages");
        _chatRepository.updateStatus(Message.fromDocumentSnapshot(element));
      });
    }
  }

  Future refreshHome({bool showMessage = false, String statusId}) async {
    bookings.value = [];
    print("this is refresh page");
    await getBookingStatuses();
    await getStatistics();
    await TotalRequestsCompleted();

    Get.find<RootController>().getNotificationsCount();
    changeTab(statusId);
    if (showMessage) {
      Get.showSnackbar(
          Ui.SuccessSnackBar(message: "Home page refreshed successfully".tr));
    }
  }

  void initScrollController() {
    scrollController = ScrollController();
    if (Date.isEmpty) {
      scrollController.addListener(() {
        if (scrollController.position.pixels ==
                scrollController.position.maxScrollExtent &&
            !isDone.value) {
          // loadBookingsOfStatus(statusId: currentStatus.value);
        }
      });
    }
  }

  void changeTab(String statusId) async {
    this.bookings.clear();
    currentStatus.value = statusId ?? currentStatus.value;
    page.value = 0;
    await loadBookingsOfStatus(statusId: currentStatus.value);
  }

  Future<Null> showMyDatePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: InitialDate.value,
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
      var format = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
      Date.value = format;
      await refreshHome();
      print("pick date is${format}");
      // loadBookingsOfStatus();

      // booking.update((val) {
      //   val.bookingAt = DateTime(picked.year, picked.month, picked.day,
      //       val.bookingAt.hour, val.bookingAt.minute);
      //   ;
      // });
    }
  }

  void TotalRequestsCompleted() async {
    print("this is running total req");
    await loadTotalRequestsCompleted();
  }

  Future getStatistics() async {
    try {
      statistics.assignAll(await _statisticRepository.getHomeStatistics());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getBookingStatuses() async {
    try {
      bookingStatuses.assignAll(await _bookingsRepository.getStatuses());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  BookingStatus getStatusByOrder(int order) =>
      bookingStatuses.firstWhere((s) => s.order == order, orElse: () {
        Get.showSnackbar(
            Ui.ErrorSnackBar(message: "Booking status not found".tr));
        return BookingStatus();
      });

  Future loadBookingsOfStatus({String statusId}) async {
    try {
      isLoading.value = true;
      isDone.value = false;
      page.value++;
      List<Booking> _bookings = [];
      if (Date.isEmpty) {
        print("date is Empty");
        _bookings = await _bookingsRepository.all(
          statusId,
        );
      } else {
        print("date is $Date");
        _bookings = await _bookingsRepository.BookingWithDate(
          statusId,
          Date.value,
        );
      }

      if (_bookings.isNotEmpty) {
        // bookings.value = [];
        bookings.addAll(_bookings);
      } else {
        isDone.value = true;
      }
    } catch (e) {
      isDone.value = true;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  // Future loadBookingsWithDateOfStatus({String statusId, String date}) async {
  //   try {
  //     isLoading.value = true;
  //     isDone.value = false;
  //     page.value++;
  //     List<Booking> _bookings = [];
  //     if (bookingStatuses.isNotEmpty) {
  //       _bookings = await _bookingsRepository.BookingWithDate(statusId, date,
  //           page: page.value);
  //     }
  //     if (_bookings.isNotEmpty) {
  //       bookings.addAll(_bookings);
  //     } else {
  //       isDone.value = true;
  //     }
  //   } catch (e) {
  //     isDone.value = true;
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future loadTotalRequestsCompleted() async {
    try {
      List<Booking> _bookings = [];

      _bookings = await _bookingsRepository.all("6", page: page.value);

      totalRequestsCompleted.value = _bookings.length.toString();
    } catch (e) {
      isDone.value = true;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changeBookingStatus(
      Booking booking, BookingStatus bookingStatus) async {
    try {
      final _booking = new Booking(
        id: booking.id,
        status: bookingStatus,
      );
      print("check this booking ${_booking.extra}");
      await _bookingsRepository.update(_booking);
      bookings.removeWhere((element) => element.id == booking.id);
      // booking.update((val) {
      //   val.status = bookingStatus;
      // });
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
  // Future<void> changeBookingStatus(
  //     Booking booking, BookingStatus bookingStatus) async {
  //   try {
  //     final _booking = new Booking(id: booking.id, status: bookingStatus);
  //     await _bookingsRepository.update(_booking);
  //     bookings.removeWhere((element) => element.id == booking.id);
  //   } catch (e) {
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   }
  // }

  Future<void> acceptBookingService(Booking booking) async {
    final _status = Get.find<HomeController>()
        .getStatusByOrder(Get.find<GlobalService>().global.value.onTheWay);
    // final _status = Get.find<HomeController>()
    //     .getStatusByOrder(Get.find<GlobalService>().global.value.accepted);
    await changeBookingStatus(booking, _status);
    // await changeBookingStatus(booking, _status);
    Get.showSnackbar(Ui.SuccessSnackBar(
        title: "Status Changed".tr, message: "Booking has been accepted".tr));
  }

  Future<void> declineBookingService(Booking booking) async {
    try {
      if (booking.status.order <
          Get.find<GlobalService>().global.value.onTheWay) {
        final _status =
            getStatusByOrder(Get.find<GlobalService>().global.value.failed);
        print("this is calling when cancle button is pressed $_status");
        final _booking =
            new Booking(id: booking.id, cancel: true, status: _status);
        await _bookingsRepository.update(_booking);
        bookings.removeWhere((element) => element.id == booking.id);
        Get.showSnackbar(Ui.defaultSnackBar(
            title: "Status Changed".tr,
            message: "Booking has been declined".tr));
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
