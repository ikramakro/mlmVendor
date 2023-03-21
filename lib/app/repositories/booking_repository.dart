import 'package:get/get.dart';

import '../models/booking_model.dart';
import '../models/booking_status_model.dart';
import '../providers/laravel_provider.dart';

class BookingRepository {
  LaravelApiClient _laravelApiClient;

  BookingRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<List<Booking>> all(String statusId, {int page}) {
    return _laravelApiClient.getBookings(statusId, page);
  }

  Future<List<Booking>> BookingWithDate(String statusId, String date,
      {int page}) {
    return _laravelApiClient.getBookingsWithDate(statusId, date, page);
  }

  Future<List<BookingStatus>> getStatuses() {
    return _laravelApiClient.getBookingStatuses();
  }

  Future<Booking> get(String bookingId) {
    return _laravelApiClient.getBooking(bookingId);
  }

  Future<Booking> update(Booking booking) {
    return _laravelApiClient.updateBooking(booking);
  }

  Future<Booking> updateExtra(Booking booking, String bookingID) {
    return _laravelApiClient.updateExtraBooking(booking, bookingID);
  }

  Future<Booking> updateDate(Booking booking, String bookingID) {
    return _laravelApiClient.updateExtraBooking(booking, bookingID);
  }

  // Future<PortfolioAlbum> portfolioAlbum(Booking booking, String bookingID) {
  //   return _laravelApiClient.portfolioAlbumCreate(booking, bookingID);
  // }
}
