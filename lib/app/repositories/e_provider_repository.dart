import 'package:get/get.dart';

import '../models/Album1_Model.dart';
import '../models/AlbumPortfolio_model.dart';
import '../models/SubAlbum_model.dart';
import '../models/address_model.dart';
import '../models/album_model.dart';
import '../models/availability_hour_model.dart';
import '../models/award_model.dart';
import '../models/certificates_model.dart';
import '../models/e_provider_model.dart';
import '../models/e_provider_type_model.dart';
import '../models/e_service_model.dart';
import '../models/experience_model.dart';
import '../models/gallery_model.dart';
import '../models/review_model.dart';
import '../models/tax_model.dart';
import '../models/user_model.dart';
import '../providers/laravel_provider.dart';

class EProviderRepository {
  LaravelApiClient _laravelApiClient;

  EProviderRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<EProvider> get(String eProviderId) {
    return _laravelApiClient.getEProvider(eProviderId);
  }

  Future<List<EProvider>> getAll({int page}) {
    return _laravelApiClient.getEProviders(page);
  }

  Future<List<EProvider>> getFull({int page}) {
    return _laravelApiClient.getEProvidersForStatus(page);
  }

  Future<List<Review>> getReviews(String userId) {
    return _laravelApiClient.getEProviderReviews(userId);
  }

  Future<List<Review>> getProviderReviews(String userId) {
    return _laravelApiClient.getVendorReviews(userId);
  }

  Future<Review> getReview(String reviewId) {
    return _laravelApiClient.getEProviderReview(reviewId);
  }

  Future<bool> deletePortfolioImage(String id) {
    return _laravelApiClient.DeleteOnePortfolioImage(id);
  }

  Future updatePortfolioImageDes(String id, String des, String providerId) {
    return _laravelApiClient.updateOnePortfolioDes(id, des, providerId);
  }

  Future updateAlbumImageDes(String id, String des, String providerId) {
    return _laravelApiClient.updateOneAlbumDes(id, des, providerId);
  }

  Future<List<Gallery>> getGalleries(String eProviderId) {
    return _laravelApiClient.getEProviderGalleries(eProviderId);
  }

  Future<List<SubAlbum>> getSubAlbums(String albumId) {
    return _laravelApiClient.fetchSubAlbum(albumId);
  }

  Future<List<AlbumModel1>> getAlbum(String eProviderId) {
    return _laravelApiClient.fetchAlbum(eProviderId);
  }

  Future<bool> delAlbum(String Id) {
    return _laravelApiClient.deleteAlbum(Id);
  }

  Future<List<Award>> getAwards(String eProviderId) {
    return _laravelApiClient.getEProviderAwards(eProviderId);
  }

  Future<List<Experience>> getExperiences(String eProviderId) {
    return _laravelApiClient.getEProviderExperiences(eProviderId);
  }

  Future<List<EService>> getEServices({String eProviderId, int page}) {
    return _laravelApiClient.getEProviderEServices(eProviderId, page);
  }

  Future<List<EService>> getServices({String eProviderId}) {
    return _laravelApiClient.getEServices(eProviderId);
  }

  Future<List<User>> getAllEmployees() {
    return _laravelApiClient.getAllEmployees();
  }

  Future<List<Tax>> getTaxes() {
    return _laravelApiClient.getTaxes();
  }

  Future<List<User>> getEmployees(String eProviderId) {
    return _laravelApiClient.getEProviderEmployees(eProviderId);
  }

  Future<List<EService>> getPopularEServices({String eProviderId, int page}) {
    return _laravelApiClient.getEProviderPopularEServices(eProviderId, page);
  }

  Future<List<EService>> getMostRatedEServices({String eProviderId, int page}) {
    return _laravelApiClient.getEProviderMostRatedEServices(eProviderId, page);
  }

  Future<List<EService>> getAvailableEServices({String eProviderId, int page}) {
    return _laravelApiClient.getEProviderAvailableEServices(eProviderId, page);
  }

  Future<List<EService>> getFeaturedEServices({String eProviderId, int page}) {
    return _laravelApiClient.getEProviderFeaturedEServices(eProviderId, page);
  }

  Future<List<EProvider>> getEProviders({int page}) {
    return _laravelApiClient.getEProviders(page);
  }

  Future portfolioAlbum(
    PortfolioAlbum portfolio,
  ) {
    return _laravelApiClient.portfolioAlbumCreate(portfolio);
  }

  Future AlbumCreate(
    AlbumModelNew portfolio,
  ) {
    return _laravelApiClient.AlbumCreate(portfolio);
  }

  Future AlbumEdit(AlbumModelNew portfolio, String id) {
    return _laravelApiClient.AlbumEdit(portfolio, id);
  }

  Future certificate(
    Certificate certificate,
  ) {
    return _laravelApiClient.certificateCreate(certificate);
  }

  Future<List<EProviderType>> getEProviderTypes() {
    return _laravelApiClient.getEProviderTypes();
  }

  /**
   * Get the User's address
   */
  Future<List<Address>> getAddresses() {
    return _laravelApiClient.getAddresses();
  }

  /**
   * Create a User's address
   */
  Future<Address> createAddress(Address address) {
    return _laravelApiClient.createAddress(address);
  }

  Future<Address> updateAddress(Address address) {
    return _laravelApiClient.updateAddress(address);
  }

  Future<Address> deleteAddress(Address address) {
    return _laravelApiClient.deleteAddress(address);
  }

  Future<List<AvailabilityHour>> getAvailabilityHours(EProvider eProvider) {
    return _laravelApiClient.getAvailabilityHours(eProvider);
  }

  Future<AvailabilityHour> createAvailabilityHour(
      AvailabilityHour availabilityHour) {
    return _laravelApiClient.createAvailabilityHour(availabilityHour);
  }

  Future<AvailabilityHour> deleteAvailabilityHour(
      AvailabilityHour availabilityHour) {
    return _laravelApiClient.deleteAvailabilityHour(availabilityHour);
  }

  Future<List<EProvider>> getAcceptedEProviders({int page}) {
    return _laravelApiClient.getAcceptedEProviders(page);
  }

  Future<List<EProvider>> getFeaturedEProviders({int page}) {
    return _laravelApiClient.getFeaturedEProviders(page);
  }

  Future<List<EProvider>> getPendingEProviders({int page}) {
    return _laravelApiClient.getPendingEProviders(page);
  }

  Future<EProvider> create(EProvider eProvider) {
    return _laravelApiClient.createEProvider(eProvider);
  }

  Future status(EProvider eProvider) {
    return _laravelApiClient.statusEProvider(eProvider);
  }

  Future sendEmail(String email) {
    return _laravelApiClient.SendEmail(email);
  }

  Future<EProvider> update(EProvider eProvider) {
    return _laravelApiClient.updateEProvider(eProvider);
  }

  Future<EProvider> delete(EProvider eProvider) {
    return _laravelApiClient.deleteEProvider(eProvider);
  }
}
