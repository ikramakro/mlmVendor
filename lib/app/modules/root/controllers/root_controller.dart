/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/custom_page_model.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/message_model.dart';
import '../../../repositories/chat_repository.dart';
import '../../../repositories/custom_page_repository.dart';
import '../../../repositories/e_provider_repository.dart';
import '../../../repositories/notification_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../account/views/account_view.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/views/home_view.dart';
import '../../messages/controllers/messages_controller.dart';
import '../../messages/views/messages_view.dart';
import '../../reviews/views/reviews_view.dart';

class RootController extends GetxController with WidgetsBindingObserver {
  final currentIndex = 0.obs;
  final notificationsCount = 0.obs;
  final customPages = <CustomPage>[].obs;
  var messages = <Message>[].obs;
  AuthService _authService;
  NotificationRepository _notificationRepository;
  CustomPageRepository _customPageRepository;
  final eProviders = <EProvider>[].obs;
  ChatRepository _chatRepository;
  EProviderRepository _eProviderRepository;

  RootController() {
    _notificationRepository = new NotificationRepository();
    _customPageRepository = new CustomPageRepository();
    _chatRepository = new ChatRepository();
    _eProviderRepository = new EProviderRepository();
    _authService = Get.find<AuthService>();
  }
  @override
  void dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      await listenForMessages();
      await statusOffEProvider();
    } else if (state == AppLifecycleState.resumed) {
      await statusEProvider();
      for (int i = 0; i < messages.length; i++) {
        _chatRepository.updateStatus(messages[i]);
      }
    }
  }

  Future getEProviders() async {
    try {
      eProviders.assignAll(await _eProviderRepository.getFull());
      print("this is the eprovider which is fetch to change status$eProviders");
      if (eProviders.isNotEmpty) await statusEProvider();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void statusEProvider() async {
    try {
      EProvider _eprovider = new EProvider(
        id: eProviders[0].id,
        name: eProviders[0].name,
        availabilityRange: eProviders[0].availabilityRange,
        e_provider_type_id: 2,
        status: 1,
      );
      print("check new provider details $_eprovider");

      await _eProviderRepository.status(_eprovider);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {}
  }

  void statusOffEProvider() async {
    try {
      EProvider _eprovider = new EProvider(
        id: eProviders[0].id,
        name: eProviders[0].name,
        availabilityRange: eProviders[0].availabilityRange,
        e_provider_type_id: 2,
        status: 0,
      );
      print("check new provider details $_eprovider");

      await _eProviderRepository.status(_eprovider);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {}
  }

  Future listenForMessages() async {
    final userMessages =
        await _chatRepository.getUserMessagez(_authService.user.value.id);
    if (userMessages.docs.isNotEmpty) {
      userMessages.docs.forEach((element) {
        messages.add(Message.fromDocumentSnapshot(element));
        print("yoooo $messages");
        _chatRepository.updateStatusOff(Message.fromDocumentSnapshot(element));
      });
    }
  }

  @override
  void onInit() async {
    await getCustomPages();
    getEProviders();
    if (Get.arguments != null && Get.arguments is int) {
      changePageInRoot(Get.arguments as int);
    } else {
      changePageInRoot(0);
    }
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  List<Widget> pages = [
    HomeView(),
    ReviewsView(),
    MessagesView(),
    AccountView(),
  ];

  Widget get currentPage => pages[currentIndex.value];

  /**
   * change page in route
   * */
  void changePageInRoot(int _index) {
    currentIndex.value = _index;
  }

  void changePageOutRoot(int _index) {
    currentIndex.value = _index;
    Get.offNamedUntil(Routes.ROOT, (Route route) {
      if (route.settings.name == Routes.ROOT) {
        return true;
      }
      return false;
    }, arguments: _index);
  }

  Future<void> changePage(int _index) async {
    if (Get.currentRoute == Routes.ROOT) {
      changePageInRoot(_index);
    } else {
      changePageOutRoot(_index);
    }
    await refreshPage(_index);
  }

  Future<void> refreshPage(int _index) async {
    switch (_index) {
      case 0:
        {
          await Get.find<HomeController>().refreshHome();
          break;
        }
      case 2:
        {
          await Get.find<MessagesController>().refreshMessages();
          break;
        }
    }
  }

  void getNotificationsCount() async {
    notificationsCount.value = await _notificationRepository.getCount();
  }

  Future<void> getCustomPages() async {
    customPages.assignAll(await _customPageRepository.all());
  }
}
