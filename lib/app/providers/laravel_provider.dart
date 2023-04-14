import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../common/ui.dart';
import '../../common/uuid.dart';
import '../models/Album1_Model.dart';
import '../models/AlbumPortfolio_model.dart';
import '../models/SubAlbum_model.dart';
import '../models/address_model.dart';
import '../models/album_model.dart';
import '../models/availability_hour_model.dart';
import '../models/award_model.dart';
import '../models/booking_model.dart';
import '../models/booking_status_model.dart';
import '../models/category_model.dart';
import '../models/certificates_model.dart';
import '../models/custom_page_model.dart';
import '../models/e_provider_model.dart';
import '../models/e_provider_subscription_model.dart';
import '../models/e_provider_type_model.dart';
import '../models/e_service_model.dart';
import '../models/experience_model.dart';
import '../models/faq_category_model.dart';
import '../models/faq_model.dart';
import '../models/gallery_model.dart';
import '../models/notification_model.dart';
import '../models/option_group_model.dart';
import '../models/option_model.dart';
import '../models/payment_method_model.dart';
import '../models/payment_model.dart';
import '../models/review_model.dart';
import '../models/setting_model.dart';
import '../models/statistic.dart';
import '../models/subscription_package_model.dart';
import '../models/tax_model.dart';
import '../models/user_model.dart';
import '../models/wallet_model.dart';
import '../models/wallet_transaction_model.dart';
import '../routes/app_routes.dart';
import 'api_provider.dart';
import 'dio_client.dart';

class LaravelApiClient extends GetxService with ApiClient {
  DioClient _httpClient;
  dio.Options _optionsNetwork;
  dio.Options _optionsCache;

  LaravelApiClient() {
    this.baseUrl = this.globalService.global.value.laravelBaseUrl;
    _httpClient = DioClient(this.baseUrl, new dio.Dio());
  }

  Future<LaravelApiClient> init() async {
    _optionsNetwork = _httpClient.optionsNetwork;
    _optionsCache = _httpClient.optionsCache;
    return this;
  }

  bool isLoading({String task, List<String> tasks}) {
    return _httpClient.isLoading(task: task, tasks: tasks);
  }

  void setLocale(String locale) {
    _optionsNetwork.headers['Accept-Language'] = locale;
    _optionsCache.headers['Accept-Language'] = locale;
  }

  void forceRefresh() {
    if (!foundation.kIsWeb && !foundation.kDebugMode) {
      _optionsCache = dio.Options(headers: _optionsCache.headers);
      _optionsNetwork = dio.Options(headers: _optionsNetwork.headers);
    }
    final authService = this.authService;
    authService.isRoleChanged().then((value) {
      if (value) {
        authService.removeCurrentUser();
        Get.offAllNamed(Routes.LOGIN);
      }
    });
  }

  void unForceRefresh() {
    if (!foundation.kIsWeb && !foundation.kDebugMode) {
      _optionsNetwork = buildCacheOptions(Duration(days: 3),
          forceRefresh: true, options: _optionsNetwork);
      _optionsCache = buildCacheOptions(Duration(minutes: 10),
          forceRefresh: false, options: _optionsCache);
    }
  }

  Future<User> getUser(User user) async {
    var _queryParameters = {
      'api_token': user.apiToken,
    };
    Uri _uri = getApiBaseUri("user").replace(queryParameters: _queryParameters);
    var response = await _httpClient.getUri(
      _uri,
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      response.data['data']['auth'] = true;
      return User.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<String> getUserPhone(String num) async {
    print("check num in fuction $num");
    Uri _uri = Uri.parse('https://admin.mylocalmesh.co.uk/api/check_number');
    var response = await _httpClient.postUri(
      _uri,
      data: {'phone': '$num'},
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<String> getUserEmail(String email) async {
    print("check num in fuction $email");
    Uri _uri = Uri.parse('https://admin.mylocalmesh.co.uk/api/check_email');
    var response = await _httpClient.postUri(
      _uri,
      data: {'email': '$email'},
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<User> login(User user) async {
    Uri _uri = getApiBaseUri("provider/login");
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(user.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      response.data['data']['auth'] = true;
      if (response.data['data']['email_verified_at'] != null) {
        return User.fromJson(response.data['data']);
      } else {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Please Verify your Email"));
        return null;
      }
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<User> register(User user) async {
    Uri _uri = getApiBaseUri("provider/register");

    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(user.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      response.data['data']['auth'] = true;
      return User.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> sendResetLinkEmail(User user) async {
    //When user not varify email and the email is expired and send again Add Like this
    // Uri _uri = getApiBaseUri("provider/send_reset_link_email");
    Uri _uri = getApiBaseUri("send_reset_link_email");

    // to remove other attributes from the user object
    user = new User(email: user.email);
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(user.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<User> updateUser(User user) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };

    Uri _uri = user.isProvider
        ? getApiBaseUri("provider/users/${user.id}")
        : getApiBaseUri("users/${user.id}")
            .replace(queryParameters: _queryParameters);

    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(user.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      response.data['data']['auth'] = true;
      return User.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Statistic>> getHomeStatistics() async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("provider/dashboard")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Statistic>((obj) => Statistic.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteUser(User user) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ deleteUser() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("users").replace(queryParameters: _queryParameters);
    var response = await _httpClient.deleteUri(
      _uri,
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Address>> getAddresses() async {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
    };
    Uri _uri =
        getApiBaseUri("addresses").replace(queryParameters: _queryParameters);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Address>((obj) => Address.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Address> createAddress(Address address) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("addresses").replace(queryParameters: _queryParameters);
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(address.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return Address.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Address> updateAddress(Address address) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("addresses/${address.id}")
        .replace(queryParameters: _queryParameters);
    var response = await _httpClient.putUri(
      _uri,
      data: json.encode(address.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return Address.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Address> deleteAddress(Address address) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("addresses/${address.id}")
        .replace(queryParameters: _queryParameters);
    var response = await _httpClient.deleteUri(
      _uri,
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return Address.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> searchEServices(
      String keywords, List<String> categories, int page) async {
    // TODO Pagination
    var _queryParameters = {
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'categories.id:${categories.join(',')};name:$keywords',
      'searchFields': 'categories.id:in;name:like',
      'searchJoin': 'and',
    };
    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<EService> getEService(String id) async {
    var _queryParameters = {
      'with': 'eProvider;categories',
    };
    if (authService.isAuth) {
      _queryParameters['api_token'] = authService.apiToken;
    }
    Uri _uri = getApiBaseUri("e_services/$id")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return EService.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<EService> createEService(EService eService) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("e_services").replace(queryParameters: _queryParameters);

    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(eService.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return EService.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<EService> updateEService(EService eService) async {
    if (!authService.isAuth || !eService.hasData) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ updateEService(EService eService) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("e_services/${eService.id}")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.patchUri(
      _uri,
      data: json.encode(eService.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return EService.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteEService(String eServiceId) async {
    if (!authService.isAuth || eServiceId == null) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ deleteEService(String eServiceId) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("e_services/${eServiceId}")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.deleteUri(
      _uri,
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Option> createOption(Option option) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("options").replace(queryParameters: _queryParameters);
    print(option.toJson());

    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(option.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return Option.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Option> updateOption(Option option) async {
    if (!authService.isAuth || !option.hasData) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ updateOption(Option option) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("options/${option.id}")
        .replace(queryParameters: _queryParameters);

    print(option.toJson());
    var response = await _httpClient.patchUri(
      _uri,
      data: json.encode(option.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return Option.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteOption(String optionId) async {
    if (!authService.isAuth || optionId == null) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ deleteOption(String optionId) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("options/${optionId}")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.deleteUri(
      _uri,
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<EProvider> getEProvider(String eProviderId) async {
    var _queryParameters = {
      'with': 'eProviderType;availabilityHours;users;addresses;taxes',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("provider/e_providers/$eProviderId")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return EProvider.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future statusEProvider(EProvider _eProvider) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("e_providers/${_eProvider.id}")
        .replace(queryParameters: _queryParameters);
    var response = await _httpClient.putUri(_uri,
        data: _eProvider.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      print("successfully status changes to active");
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<EProvider> createEProvider(EProvider _eProvider) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("e_providers").replace(queryParameters: _queryParameters);
    // print("create provider accept ${_eProvider.accepted}");
    print("create provider accept ${_eProvider}");
    var response = await _httpClient.postUri(_uri,
        data: _eProvider.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return EProvider.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future SendEmail(String email) async {
    print("send email is trigger");
    try {
      var map = new Map<String, dynamic>();
      map['email'] = '$email';
      Uri _uri = getApiBaseUri("providr/send_verification_link");
      var response =
          await _httpClient.postUri(_uri, data: map, options: _optionsNetwork);
      if (response.data['success'] == true) {
        Get.showSnackbar(Ui.SuccessSnackBar(
            message:
                "E-Mail verification link was sent successfully to your MailBox"));
        return true;
      } else {
        throw new Exception(response.data['message']);
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<EProvider> updateEProvider(EProvider _eProvider) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("e_providers/${_eProvider.id}")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.putUri(_uri,
        data: _eProvider.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return EProvider.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<EProvider> deleteEProvider(EProvider _eProvider) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("e_providers/${_eProvider.id}")
        .replace(queryParameters: _queryParameters);
    var response = await _httpClient.deleteUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return EProvider.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  // Future<AvailabilityHour> createAvailabilityHour(
  //     AvailabilityHour availabilityHour, String providerID) async {
  //   var _queryParameters = {
  //     'with': 'eProviderType;availabilityHours;users'
  //     // 'api_token': authService.apiToken,
  //   };
  //   Uri _uri = getApiBaseUri("e_providers/$providerID?")
  //       .replace(queryParameters: _queryParameters);
  //   var response = await _httpClient.postUri(
  //     _uri,
  //     data: json.encode(availabilityHour.toJson()),
  //     options: _optionsNetwork,
  //   );
  //   if (response.data['success'] == true) {
  //     print("availability method is calling and eprovider id is $providerID");
  //     return AvailabilityHour.fromJson(response.data['data']);
  //   } else {
  //     throw new Exception(response.data['message']);
  //   }
  // }

  Future<AvailabilityHour> createAvailabilityHour(
      AvailabilityHour availabilityHour) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("provider/availability_hours")
        .replace(queryParameters: _queryParameters);
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(availabilityHour.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return AvailabilityHour.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }
  // Future<AvailabilityHour> createAvailabilityHour(
  //     AvailabilityHour availabilityHour) async {
  //   var _queryParameters = {
  //     'api_token': authService.apiToken,
  //   };
  //   Uri _uri = getApiBaseUri("provider/35?/availability_hours")
  //       .replace(queryParameters: _queryParameters);
  //   var response = await _httpClient.postUri(
  //     _uri,
  //     data: json.encode(availabilityHour.toJson()),
  //     options: _optionsNetwork,
  //   );
  //   if (response.data['success'] == true) {
  //     return AvailabilityHour.fromJson(response.data['data']);
  //   } else {
  //     throw new Exception(response.data['message']);
  //   }
  // }

  Future<AvailabilityHour> deleteAvailabilityHour(
      AvailabilityHour availabilityHour) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("provider/availability_hours/${availabilityHour.id}")
            .replace(queryParameters: _queryParameters);
    var response = await _httpClient.deleteUri(
      _uri,
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return AvailabilityHour.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<AvailabilityHour>> getAvailabilityHours(
      EProvider _eProvider) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("availability_hours/${_eProvider.id}")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<AvailabilityHour>((obj) => AvailabilityHour.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EProvider>> getEProviders(int page) async {
    var _queryParameters = {
      'only': 'id;name;cat_id;addresses',
      'with': 'addresses',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'api_token': authService.apiToken,
    };
    if (page != null) {
      _queryParameters['only'] =
          'id;name;description;eProviderType;eProviderType.name;media';
      _queryParameters['with'] = 'eProviderType;media';

      _queryParameters['limit'] = '4';
      _queryParameters['offset'] = ((page - 1) * 4).toString();
    }
    Uri _uri = getApiBaseUri("provider/e_providers")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<EProvider>((obj) => EProvider.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EProvider>> getEProvidersForStatus(int page) async {
    var _queryParameters = {
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'api_token': authService.apiToken,
    };

    Uri _uri = getApiBaseUri("provider/e_providers")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<EProvider>((obj) => EProvider.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EProvider>> getAcceptedEProviders(int page) async {
    print("calling load provider");
    var _queryParameters = {
      'only': 'id;name;description;eProviderType;eProviderType.name;media',
      'with': 'eProviderType;media',
      'search': 'accepted:1',
      'searchFields': 'accepted:=',
      'searchJoin': 'and',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'api_token': authService.apiToken,
    };
    if (page != null) {
      _queryParameters['limit'] = '4';
      _queryParameters['offset'] = ((page - 1) * 4).toString();
    }
    Uri _uri = getApiBaseUri("provider/e_providers")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<EProvider>((obj) => EProvider.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EProvider>> getFeaturedEProviders(int page) async {
    var _queryParameters = {
      'only': 'id;name;description;eProviderType;eProviderType.name;media',
      'with': 'eProviderType;media',
      'search': 'featured:1',
      'searchFields': 'accepted:=',
      'searchJoin': 'and',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'api_token': authService.apiToken,
    };
    if (page != null) {
      _queryParameters['limit'] = '4';
      _queryParameters['offset'] = ((page - 1) * 4).toString();
    }
    Uri _uri = getApiBaseUri("provider/e_providers")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<EProvider>((obj) => EProvider.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EProvider>> getPendingEProviders(int page) async {
    var _queryParameters = {
      'only': 'id;name;description;eProviderType;eProviderType.name;media',
      'with': 'eProviderType;media',
      'search': 'accepted:0',
      'searchFields': 'accepted:=',
      'searchJoin': 'and',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'api_token': authService.apiToken,
    };
    if (page != null) {
      _queryParameters['limit'] = '4';
      _queryParameters['offset'] = ((page - 1) * 4).toString();
    }
    Uri _uri = getApiBaseUri("provider/e_providers")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<EProvider>((obj) => EProvider.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EProviderType>> getEProviderTypes() async {
    var _queryParameters = {
      'only': 'id;name',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      // 'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("provider_types")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<EProviderType>((obj) => EProviderType.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Review>> getVendorReviews(String userId) async {
    var _queryParameters = {
      'with':
          'eProviderReviews;eProviderReviews.user;eProviderReviews.eService',
      'only':
          'eProviderReviews.id;eProviderReviews.review;eProviderReviews.rate;eProviderReviews.created_at;eProviderReviews.user;eProviderReviews.eService;',
    };
    Uri _uri = getApiBaseUri("e_providers/$userId?")
        .replace(queryParameters: _queryParameters);
    final response = await http.get(
      _uri,
      headers: {'Content-Type': 'application/json'},
    );
    String jsonString = response.body;
    Map<String, dynamic> jsonResponse = jsonDecode(jsonString);
    Map<String, dynamic> data = jsonResponse['data'];
    List<dynamic> reviews = data['e_provider_reviews'];
    List<Review> review = [];
    for (var json in reviews) {
      Review reviewz = Review.fromJson(json);
      review.add(reviewz);
    }
    // var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (jsonResponse['success'] == true) {
      return review;
      // return response.data['data']
      //     .map<Review>((obj) => Review.fromJson(obj))
      //     .toList();
    } else {
      throw new Exception(jsonResponse['message']);
    }
  }

  Future<List<Review>> getEProviderReviews(String userId) async {
    var _queryParameters = {
      'with': 'eService;user',
      'only': 'id;review;rate;user;eService;created_at',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      // 'limit': '10',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("e_service_reviews")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Review>((obj) => Review.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> DeleteOnePortfolioImage(String Id) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("del_album_img/$Id")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return true;
      Get.showSnackbar(
          Ui.SuccessSnackBar(message: "Image SuccessFully Removed"));
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future updateOneAlbumDes(String Id, String des, String providerId) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("update_album_img/$Id")
        .replace(queryParameters: _queryParameters);
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['description'] = des;
    // data['e_provider_id'] = providerId;
    var response =
        await _httpClient.postUri(_uri, data: data, options: _optionsCache);
    if (response.data['success'] == true) {
      Get.showSnackbar(
          Ui.SuccessSnackBar(message: "Description SuccessFully Updated"));
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future updateOnePortfolioDes(String Id, String des, String providerId) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("update_des/$Id")
        .replace(queryParameters: _queryParameters);
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['description'] = des;
    data['e_provider_id'] = providerId;
    var response =
        await _httpClient.postUri(_uri, data: data, options: _optionsCache);
    if (response.data['success'] == true) {
      Get.showSnackbar(
          Ui.SuccessSnackBar(message: "Description SuccessFully Updated"));
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Review> getEProviderReview(String reviewId) async {
    var _queryParameters = {
      'with': 'eService;user',
      'only': 'id;review;rate;user;eService',
    };
    Uri _uri = getApiBaseUri("e_service_reviews/$reviewId")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return Review.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  // Future<Review> getEProviderReview(String reviewId) async {
  //   var _queryParameters = {
  //     'with': 'eService;user',
  //     'only': 'id;review;rate;user;eService',
  //   };
  //   Uri _uri = getApiBaseUri("e_service_reviews/$reviewId")
  //       .replace(queryParameters: _queryParameters);
  //
  //   var response = await _httpClient.getUri(_uri, options: _optionsCache);
  //   if (response.data['success'] == true) {
  //     return Review.fromJson(response.data['data']);
  //   } else {
  //     throw new Exception(response.data['message']);
  //   }
  // }
  Future<bool> deleteAlbum(String id) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("albums/$id?").replace(queryParameters: _queryParameters);

    var response = await _httpClient.deleteUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<AlbumModel1>> fetchAlbum(String eProviderId) async {
    final response = await http.get(Uri.parse(
        'https://admin.mylocalmesh.co.uk/api/albums/?with=Images%3BImages.media&search=e_provider_id:$eProviderId&orderBy=updated_at&sortedBy=desc'));

    if (response.statusCode == 200) {
      print("gallery is fetched");
      var json = jsonDecode(response.body)['data'] as List;
      List<AlbumModel1> eProviderAlbumGallery = json
          .map((providerJson) => AlbumModel1.fromJson(providerJson))
          .toList();

      print("fetch album $eProviderAlbumGallery");
      // Gallery.value = eProviderAlbumGallery;
      return eProviderAlbumGallery;
    } else {
      print("gallery is failed");
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print(response.body);
      throw Exception('Failed to load Gallery');
    }
  }

  Future<List<SubAlbum>> fetchSubAlbum(String albumID) async {
    final response = await http
        .get(Uri.parse('https://admin.mylocalmesh.co.uk/api/albums/$albumID'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print("gallery is fetched");
      var json = jsonDecode(response.body)['data'] as List;
      List<SubAlbum> eProviderAlbumGallery =
          json.map((providerJson) => SubAlbum.fromJson(providerJson)).toList();
      // Gallery.value = eProviderAlbumGallery;
      return eProviderAlbumGallery;
    } else {
      print("gallery is failed");
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print(response.body);
      throw Exception('Failed to load Gallery');
    }
  }

  Future<List<Gallery>> getEProviderGalleries(String eProviderId) async {
    var _queryParameters = {
      'with': 'media',
      'search': 'e_provider_id:$eProviderId',
      'searchFields': 'e_provider_id:=',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
    };
    Uri _uri =
        getApiBaseUri("galleries").replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Gallery>((obj) => Gallery.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Award>> getEProviderAwards(String eProviderId) async {
    var _queryParameters = {
      'search': 'e_provider_id:$eProviderId',
      'searchFields': 'e_provider_id:=',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
    };
    Uri _uri =
        getApiBaseUri("awards").replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Award>((obj) => Award.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Experience>> getEProviderExperiences(String eProviderId) async {
    var _queryParameters = {
      'search': 'e_provider_id:$eProviderId',
      'searchFields': 'e_provider_id:=',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
    };
    Uri _uri =
        getApiBaseUri("experiences").replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Experience>((obj) => Experience.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getEProviderFeaturedEServices(
      String eProviderId, int page) async {
    var _queryParameters = {
      'with': 'eProvider;eProvider.addresses;categories',
      'search': 'featured:1',
      'searchFields': 'featured:=',
      'limit': '4',
      'offset': ((page - 1) * 4).toString(),
      'api_token': authService.apiToken,
    };
    if (eProviderId != null) {
      _queryParameters['search'] += ';e_provider_id:$eProviderId';
      _queryParameters['searchFields'] += ';e_provider_id:=';
      _queryParameters['searchJoin'] = 'and';
    }
    Uri _uri = getApiBaseUri("provider/e_services")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getEProviderPopularEServices(
      String eProviderId, int page) async {
    // TODO popular eServices
    var _queryParameters = {
      'with': 'eProvider;eProvider.addresses;categories',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString(),
      'api_token': authService.apiToken,
    };
    if (eProviderId != null) {
      _queryParameters['search'] = 'e_provider_id:$eProviderId';
      _queryParameters['searchFields'] = 'e_provider_id:=';
      _queryParameters['searchJoin'] = 'and';
    }
    Uri _uri = getApiBaseUri("provider/e_services")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getEProviderAvailableEServices(
      String eProviderId, int page) async {
    var _queryParameters = {
      'with': 'eProvider;eProvider.addresses;categories',
      'available_e_provider': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString(),
      'api_token': authService.apiToken
    };
    if (eProviderId != null) {
      _queryParameters['search'] = 'e_provider_id:$eProviderId';
      _queryParameters['searchFields'] = 'e_provider_id:=';
      _queryParameters['searchJoin'] = 'and';
    }
    Uri _uri = getApiBaseUri("provider/e_services")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getEProviderMostRatedEServices(
      String eProviderId, int page) async {
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with': 'eProvider;eProvider.addresses;categories',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString(),
      'api_token': authService.apiToken
    };
    if (eProviderId != null) {
      _queryParameters['search'] = 'e_provider_id:$eProviderId';
      _queryParameters['searchFields'] = 'e_provider_id:=';
      _queryParameters['searchJoin'] = 'and';
    }
    Uri _uri = getApiBaseUri("provider/e_services")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<User>> getEProviderEmployees(String eProviderId) async {
    var _queryParameters = {
      'with': 'users',
      'only':
          'users;users.id;users.name;users.email;users.phone_number;users.device_token'
    };
    Uri _uri = getApiBaseUri("e_providers/$eProviderId")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']['users']
          .map<User>((obj) => User.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<User>> getAllEmployees() async {
    var _queryParameters = {
      'only': 'id;name;email',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("provider/employees")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<User>((obj) => User.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Tax>> getTaxes() async {
    var _queryParameters = {
      'only': 'id;name;value;type',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("provider/taxes")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Tax>((obj) => Tax.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getEProviderEServices(
      String eProviderId, int page) async {
    var _queryParameters = {
      'with': 'eProvider;eProvider.addresses;categories',
      'limit': '4',
      'offset': ((page - 1) * 4).toString(),
      'api_token': authService.apiToken,
    };
    if (eProviderId != null) {
      _queryParameters['search'] = 'e_provider_id:$eProviderId';
      _queryParameters['searchFields'] = 'e_provider_id:=';
      _queryParameters['searchJoin'] = 'and';
    }
    Uri _uri = getApiBaseUri("provider/e_services")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getEServices(
    String eProviderId,
  ) async {
    var _queryParameters = {
      'with': 'eProvider;eProvider.addresses;categories',
      'api_token': authService.apiToken,
    };
    if (eProviderId != null) {
      _queryParameters['search'] = 'e_provider_id:$eProviderId';
      _queryParameters['searchFields'] = 'e_provider_id:=';
      _queryParameters['searchJoin'] = 'and';
    }
    Uri _uri = getApiBaseUri("provider/e_services")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Review>> getEServiceReviews(String eServiceId) async {
    var _queryParameters = {
      'with': 'user',
      'only': 'created_at;review;rate;user',
      'search': "e_service_id:$eServiceId",
      'orderBy': 'created_at',
      'sortBy': 'desc',
      'limit': '10',
    };
    Uri _uri = getApiBaseUri("e_service_reviews")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Review>((obj) => Review.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<OptionGroup>> getEServiceOptionGroups(String eServiceId) async {
    var _queryParameters = {
      'with': 'options;options.media',
      'only':
          'id;name;allow_multiple;options.id;options.name;options.description;options.price;options.option_group_id;options.e_service_id;options.media',
      'search': "options.e_service_id:$eServiceId",
      'searchFields': 'options.e_service_id:=',
      'orderBy': 'name',
      'sortBy': 'desc'
    };
    Uri _uri = getApiBaseUri("option_groups")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<OptionGroup>((obj) => OptionGroup.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<OptionGroup>> getOptionGroups() async {
    var _queryParameters = {
      'with': 'options',
      'only':
          'id;name;allow_multiple;options.id;options.name;options.description;options.price;options.option_group_id;options.e_service_id',
      'orderBy': 'name',
      'sortBy': 'desc'
    };
    Uri _uri = getApiBaseUri("option_groups")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<OptionGroup>((obj) => OptionGroup.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getAllCategories() async {
    const _queryParameters = {
      'parent': 'true',
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri =
        getApiBaseUri("categories").replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Category>((obj) => Category.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<String> getOneCategories(String id) async {
    const _queryParameters = {
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri = getApiBaseUri("categories/$id")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      String CatagoryName = response.data["data"]["name"]['en'];
      // var data = response.data['data'];
      // Category category = Category.fromJson(jsonDecode(response.data['data']));
      // print("this is backend data ${category.name}");
      return CatagoryName;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getAllParentCategories() async {
    const _queryParameters = {
      'parent': 'true',
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri =
        getApiBaseUri("categories").replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Category>((obj) => Category.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getAllWithSubCategories(catId) async {
    const _queryParameters = {
      'with': 'subCategories',
      'parent': 'true',
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    print("cat in last $catId");
    Uri _uri = getApiBaseUri("categories/$catId")
        .replace(queryParameters: _queryParameters);
    final response = await http.get(
      _uri,
      headers: {'Content-Type': 'application/json'},
    );

    String jsonString = response.body;
    Map<String, dynamic> jsonResponse = jsonDecode(jsonString);
    Map<String, dynamic> data = jsonResponse['data'];
    List<dynamic> subCategories = data['sub_categories'];
    List<Category> subCategoryList = [];
    for (var json in subCategories) {
      Category subCategory = Category.fromJson(json);
      subCategoryList.add(subCategory);
    }
//     List<dynamic> data = jsonResponse['data'];
    return subCategoryList;
  }

  // Future<List<Category>> getAllWithSubCategories(catId) async {
  //   const _queryParameters = {
  //     'with': 'subCategories',
  //     'parent': 'true',
  //     'orderBy': 'order',
  //     'sortBy': 'asc',
  //   };
  //   Uri _uri = getApiBaseUri("categories/4?")
  //       .replace(queryParameters: _queryParameters);
  //   Get.log(_uri.toString());
  //   var response = await _httpClient.getUri(_uri, options: _optionsCache);
  //   if (response.data['success'] == true) {
  //     return response.data['data']
  //         .map<Category>((obj) => Category.fromJson(obj))
  //         .toList();
  //   } else {
  //     throw new Exception(response.data['message']);
  //   }
  // }

  Future<List<Booking>> getBookings(String statusId, int page) async {
    var _queryParameters = {
      'with': 'bookingStatus;user;payment;payment.paymentStatus',
      'api_token': authService.apiToken,
      'search': 'booking_status_id:${statusId}',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      // 'limit': '4',
      // 'offset': ((page - 1) * 4).toString()
    };
    Uri _uri =
        getApiBaseUri("bookings").replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Booking>((obj) => Booking.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Booking>> getBookingsWithDate(
      String statusId, String date, int page) async {
    var _queryParameters = {
      'with': 'bookingStatus;payment;payment.paymentStatus',
      'api_token': authService.apiToken,
      'status': '${statusId}',
      'date': '$date',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
    };
    Uri _uri = getApiBaseUri("bookings_date")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Booking>((obj) => Booking.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<BookingStatus>> getBookingStatuses() async {
    var _queryParameters = {
      'only': 'id;status;order',
      'orderBy': 'order',
      'sortedBy': 'asc',
    };
    Uri _uri = getApiBaseUri("booking_statuses")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<BookingStatus>((obj) => BookingStatus.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Booking> getBooking(String bookingId) async {
    var _queryParameters = {
      'with':
          'bookingStatus;user;payment;payment.paymentMethod;payment.paymentStatus',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("bookings/${bookingId}")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      Booking _booking = Booking.fromJson(response.data['data']);
      return _booking;
      // print("response to get booking ${response.data['data']['extra']}");
      // if (response.data['data']['extra'] != null) {
      //   print("extra is not null");
      //   var extra = json.decode(response.data['data']['extra']);
      //   List<Charge> items = [];
      //   for (var item in extra) {
      //     Charge _charge = Charge(name: item['name'], price: item['price']);
      //     items.add(_charge);
      //     Booking _booking = Booking.fromJson(response.data['data']);
      //     _booking.extra = items;
      //     return _booking;
      //   }
      // } else {
      //   Booking _booking = Booking.fromJson(response.data['data']);
      //   return _booking;
      // }
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Booking> updateBooking(Booking booking) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("bookings/${booking.id}")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.putUri(_uri,
        data: booking.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Booking.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Booking> updateExtraBooking(Booking booking, String id) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    print("booking id is $id");
    Uri _uri = getApiBaseUri("bookings/$id?")
        .replace(queryParameters: _queryParameters);
    var response = await _httpClient.putUri(_uri,
        data: booking.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Booking.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future portfolioAlbumCreate(PortfolioAlbum portfolioData) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    // print("booking id is $id");
    Uri _uri = getApiBaseUri("uploads/portfolio?")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.postUri(_uri,
        data: portfolioData.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      print("this is response of portfolio successfull");
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Uploaded Successfully"));
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future AlbumEdit(AlbumModelNew portfolioData, String id) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    // print("booking id is $id");
    Uri _uri =
        getApiBaseUri("albums/$id").replace(queryParameters: _queryParameters);

    var response = await _httpClient.putUri(_uri,
        data: portfolioData.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      print("this is response of update Album successfull");
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Updated Successfully"));
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future AlbumCreate(AlbumModelNew portfolioData) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    // print("booking id is $id");
    Uri _uri =
        getApiBaseUri("albums?").replace(queryParameters: _queryParameters);

    var response = await _httpClient.postUri(_uri,
        data: portfolioData.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      print("this is response of portfolio successfull");
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Uploaded Successfully"));
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future certificateCreate(Certificate certificate) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };

    Uri _uri = getApiBaseUri("provider/experiences?")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.postUri(_uri,
        data: certificate.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      print("this is response of portfolio successfull");
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Uploaded Successfully"));
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Payment> createPayment(Booking _booking) async {
    print("final payment check $_booking");
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ createPayment() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("payments/cash")
        .replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.postUri(_uri,
        data: _booking.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Payment.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Payment> updatePayment(Payment payment) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("provider/payments/${payment.id}")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.putUri(_uri,
        data: payment.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Payment.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<PaymentMethod>> getPaymentMethods() async {
    var _queryParameters = {
      'with': 'media',
      'search': 'enabled:1',
      'searchFields': 'enabled:=',
      'orderBy': 'order',
      'sortBy': 'asc',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("payment_methods")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<PaymentMethod>((obj) => PaymentMethod.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Wallet>> getWallets() async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("wallets").replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Wallet>((obj) => Wallet.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Wallet> createWallet(Wallet _wallet) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri =
        getApiBaseUri("wallets").replace(queryParameters: _queryParameters);

    var response = await _httpClient.postUri(_uri,
        data: _wallet.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Wallet.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Wallet> updateWallet(Wallet _wallet) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("wallets/${_wallet.id}")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.putUri(_uri,
        data: _wallet.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Wallet.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteWallet(Wallet _wallet) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("wallets/${_wallet.id}")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.deleteUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<WalletTransaction>> getWalletTransactions(Wallet wallet) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'with': 'user',
      'search': 'wallet_id:${wallet.id}',
      'searchFields': 'wallet_id:=',
    };
    Uri _uri = getApiBaseUri("wallet_transactions")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<WalletTransaction>((obj) => WalletTransaction.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  String getPayPalUrl(EProviderSubscription eProviderSubscription) {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'subscription_package_id': eProviderSubscription.subscriptionPackage.id,
      'e_provider_id': eProviderSubscription.eProvider.id,
    };
    Uri _uri = getBaseUri("subscription/payments/paypal/express-checkout")
        .replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getRazorPayUrl(EProviderSubscription eProviderSubscription) {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'subscription_package_id': eProviderSubscription.subscriptionPackage.id,
      'e_provider_id': eProviderSubscription.eProvider.id,
    };
    Uri _uri = getBaseUri("subscription/payments/razorpay/checkout")
        .replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getStripeUrl(EProviderSubscription eProviderSubscription) {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'subscription_package_id': eProviderSubscription.subscriptionPackage.id,
      'e_provider_id': eProviderSubscription.eProvider.id,
    };
    Uri _uri = getBaseUri("subscription/payments/stripe/checkout")
        .replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getPayStackUrl(EProviderSubscription eProviderSubscription) {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'subscription_package_id': eProviderSubscription.subscriptionPackage.id,
      'e_provider_id': eProviderSubscription.eProvider.id,
    };
    Uri _uri = getBaseUri("subscription/payments/paystack/checkout")
        .replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getPayMongoUrl(EProviderSubscription eProviderSubscription) {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'subscription_package_id': eProviderSubscription.subscriptionPackage.id,
      'e_provider_id': eProviderSubscription.eProvider.id,
    };
    Uri _uri = getBaseUri("subscription/payments/paymongo/checkout")
        .replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getFlutterWaveUrl(EProviderSubscription eProviderSubscription) {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'subscription_package_id': eProviderSubscription.subscriptionPackage.id,
      'e_provider_id': eProviderSubscription.eProvider.id,
    };
    Uri _uri = getBaseUri("subscription/payments/flutterwave/checkout")
        .replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getStripeFPXUrl(EProviderSubscription eProviderSubscription) {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'subscription_package_id': eProviderSubscription.subscriptionPackage.id,
      'e_provider_id': eProviderSubscription.eProvider.id,
    };
    Uri _uri = getBaseUri("subscription/payments/stripe-fpx/checkout")
        .replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  Future<List<Notification>> getNotifications() async {
    var _queryParameters = {
      'search': 'notifiable_id:${authService.user.value.id}',
      'searchFields': 'notifiable_id:=',
      'searchJoin': 'and',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'limit': '50',
      'only': 'id;type;data;read_at;created_at',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("notifications")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Notification>((obj) => Notification.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Notification> markAsReadNotification(Notification notification) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("notifications/${notification.id}")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.patchUri(_uri,
        data: notification.markReadMap(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Notification.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> sendNotification(
      List<User> users, User from, String type, String text, String id) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    var data = {
      'users': users.map((e) => e.id).toList(),
      'from': from.id,
      'type': type,
      'text': text,
      'id': id,
    };
    Uri _uri = getApiBaseUri("notifications")
        .replace(queryParameters: _queryParameters);

    Get.log(data.toString());
    var response =
        await _httpClient.postUri(_uri, data: data, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Notification> removeNotification(Notification notification) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("notifications/${notification.id}")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.deleteUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Notification.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<int> getNotificationsCount() async {
    if (!authService.isAuth) {
      return 0;
    }
    var _queryParameters = {
      'search': 'notifiable_id:${authService.user.value.id}',
      'searchFields': 'notifiable_id:=',
      'searchJoin': 'and',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("notifications/count")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<FaqCategory>> getFaqCategories() async {
    var _queryParameters = {
      'orderBy': 'created_at',
      'sortedBy': 'asc',
    };
    Uri _uri = getApiBaseUri("faq_categories")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<FaqCategory>((obj) => FaqCategory.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Faq>> getFaqs(String categoryId) async {
    var _queryParameters = {
      'search': 'faq_category_id:${categoryId}',
      'searchFields': 'faq_category_id:=',
      'searchJoin': 'and',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
    };
    Uri _uri = getApiBaseUri("faqs").replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<Faq>((obj) => Faq.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Setting> getSettings() async {
    Uri _uri = getApiBaseUri("provider/settings");

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Setting.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List> getModules() async {
    Uri _uri = getApiBaseUri("modules");

    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Map<String, String>> getTranslations(String locale) async {
    var _queryParameters = {
      'locale': locale,
    };
    Uri _uri = getApiBaseUri("provider/translations")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return Map<String, String>.from(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<String>> getSupportedLocales() async {
    Uri _uri = getApiBaseUri("provider/supported_locales");

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return List.from(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<CustomPage>> getCustomPages() async {
    var _queryParameters = {
      'only': 'id;title',
      'search': 'published:1',
      'orderBy': 'created_at',
      'sortedBy': 'asc',
    };
    Uri _uri = getApiBaseUri("custom_pages")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<CustomPage>((obj) => CustomPage.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<CustomPage> getCustomPageById(String id) async {
    Uri _uri = getApiBaseUri("custom_pages/$id");

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return CustomPage.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<String> uploadReferenceImage(File file, String field) async {
    if (!authService.isAuth) {
      throw new Exception(
          "You don't have the permission to access to this area!".tr +
              "[ uploadImage() ]");
    }
    String fileName = file.path.split('/').last;
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("uploads/referimage")
        .replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    dio.FormData formData = dio.FormData.fromMap({
      "file": await dio.MultipartFile.fromFile(file.path, filename: fileName),
      "uuid": Uuid().generateV4(),
      "field": field,
    });
    var response = await _httpClient.postUri(_uri, data: formData);
    print(response.data);
    if (response.data['data'] != false) {
      // Media media = new Media.fromJson(json.decode(response.data['data'][0]));
      // final Map<Media, dynamic> data = json.decode(response.data['data']);
      print("this is the uploadResponse ${response.data['data']['url']}");
      return response.data['data']['url'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<String> uploadImage(File file, String field) async {
    String fileName = file.path.split('/').last;
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("uploads/store")
        .replace(queryParameters: _queryParameters);

    dio.FormData formData = dio.FormData.fromMap({
      "file": await dio.MultipartFile.fromFile(file.path, filename: fileName),
      "uuid": Uuid().generateV4(),
      "field": field,
    });
    var response = await _httpClient.postUri(_uri, data: formData);
    print(response.data);
    if (response.data['data'] != false) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteUploaded(String uuid) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("uploads/clear")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.postUri(_uri, data: {'uuid': uuid});
    print(response.data);
    if (response.data['data'] != false) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteAllUploaded(List<String> uuids) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("uploads/clear")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.postUri(_uri, data: {'uuid': uuids});
    print(response.data);
    if (response.data['data'] != false) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteOneUploaded(String uuids) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("uploads/clear")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.postUri(_uri, data: {'uuid': uuids});
    print(response.data);
    if (response.data['data'] != false) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<SubscriptionPackage>> getSubscriptionPackages() async {
    var _queryParameters = {
      'orderBy': 'duration_in_days',
      'sortedBy': 'asc',
    };
    Uri _uri = getApiBaseUri("subscription/subscription_packages")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<SubscriptionPackage>((obj) => SubscriptionPackage.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<EProviderSubscription> cashEProviderSubscription(
      EProviderSubscription eProviderSubscription) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("subscription/e_provider_subscriptions/cash")
        .replace(queryParameters: _queryParameters);
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(eProviderSubscription.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return EProviderSubscription.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<EProviderSubscription> walletEProviderSubscription(
      EProviderSubscription eProviderSubscription, Wallet _wallet) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'wallet_id': _wallet.id,
    };
    Uri _uri = getApiBaseUri("subscription/e_provider_subscriptions/wallet")
        .replace(queryParameters: _queryParameters);
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(eProviderSubscription.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return EProviderSubscription.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EProviderSubscription>> getEProviderSubscriptions() async {
    var _queryParameters = {
      'with': 'eProvider;subscriptionPackage;payment;payment.paymentMethod',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("subscription/e_provider_subscriptions")
        .replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data']
          .map<EProviderSubscription>(
              (obj) => EProviderSubscription.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }
}
