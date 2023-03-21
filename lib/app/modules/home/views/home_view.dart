import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/helper.dart';
import '../../../providers/laravel_provider.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../../global_widgets/tab_bar_widget.dart';
import '../controllers/home_controller.dart';
import '../widgets/bookings_list_widget.dart';
import '../widgets/statistics_carousel_widget.dart';

class HomeView extends GetView<HomeController> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    controller.initScrollController();
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        body: RefreshIndicator(
            onRefresh: () async {
              Get.find<LaravelApiClient>().forceRefresh();
              controller.refreshHome(showMessage: true);
              Get.find<LaravelApiClient>().unForceRefresh();
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: controller.scrollController,
              shrinkWrap: false,
              slivers: <Widget>[
                Obx(() {
                  return SliverAppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    expandedHeight: 290,
                    elevation: 0.5,
                    floating: false,
                    iconTheme: IconThemeData(color: Get.theme.primaryColor),
                    title: Text(
                      Get.find<SettingsService>().setting.value.providerAppName,
                      style: Get.textTheme.headline6,
                    ),
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    leading: new IconButton(
                      icon: new Icon(Icons.sort, color: Colors.black87),
                      onPressed: () => {Scaffold.of(context).openDrawer()},
                    ),
                    actions: [NotificationsButtonWidget()],
                    bottom: controller.bookingStatuses.isEmpty
                        ? TabBarLoadingWidget()
                        : TabBarWidget(
                            tag: 'home',
                            initialSelectedId:
                                controller.bookingStatuses.elementAt(0).id,
                            tabs: List.generate(
                                controller.bookingStatuses.length, (index) {
                              var _status =
                                  controller.bookingStatuses.elementAt(index);

                              if (_status.status.toString() == "Accept - Del") {
                                return SizedBox(
                                  width: 0,
                                );
                              } else if (_status.status.toString() ==
                                  "In Delivery") {
                                return ChipWidget(
                                  tag: 'home',
                                  text: "In Progress",
                                  id: _status.id,
                                  onSelected: (id) {
                                    controller.changeTab(id);
                                  },
                                );
                              } else if (_status.status.toString() ==
                                  "In Progress") {
                                return ChipWidget(
                                  tag: 'home',
                                  text: "In Delivery",
                                  id: _status.id,
                                  onSelected: (id) {
                                    controller.changeTab(id);
                                  },
                                );
                              } else if (_status.status.toString() == "Ready") {
                                return SizedBox(
                                  width: 0,
                                );
                              }
                              return ChipWidget(
                                tag: 'home',
                                text: _status.status,
                                id: _status.id,
                                onSelected: (id) {
                                  controller.changeTab(id);
                                },
                              );
                            }),
                          ),
                    flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.parallax,
                        background: StatisticsCarouselWidget(
                          totalRequestCompleted:
                              controller.totalRequestsCompleted.value,
                          statisticsList: controller.statistics,
                        ).paddingOnly(top: 70, bottom: 50)),
                  );
                }),
                SliverToBoxAdapter(
                  child: Wrap(
                    children: [
                      Container(
                        width: 70,
                        child: Obx(
                          () => MaterialButton(
                            elevation: 0,
                            onPressed: () async {
                              controller.All.value = true;
                              controller.Date.value = "";
                              await controller.refreshHome();
                              print("All value is ${controller.All.value}");
                            },
                            shape: StadiumBorder(),
                            color: controller.All.value
                                ? Get.theme.colorScheme.secondary
                                : Get.theme.colorScheme.secondary
                                    .withOpacity(0.2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("All".tr,
                                    style: Get.textTheme.subtitle1.merge(
                                        TextStyle(
                                            color: controller.All.value
                                                ? Colors.white
                                                : Colors.black))),
                              ],
                            ),
                          ).paddingOnly(left: 17),
                        ),
                      ),
                      Obx(() => MaterialButton(
                            elevation: 0,
                            onPressed: () {
                              controller.All.value = false;
                              print("All value is ${controller.All.value}");
                              controller.showMyDatePicker(context);
                            },
                            shape: StadiumBorder(),
                            color: controller.All.value
                                ? Get.theme.colorScheme.secondary
                                    .withOpacity(0.2)
                                : Get.theme.colorScheme.secondary,
                            child: Container(
                              width:
                                  MediaQuery.of(context).size.width / 100 * 17,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Filter ".tr,
                                      style: Get.textTheme.subtitle1.merge(
                                          TextStyle(
                                              color: controller.All.value
                                                  ? Colors.black
                                                  : Colors.white))),
                                  Icon(Icons.calendar_month),
                                ],
                              ),
                            ),
                          ).paddingOnly(left: 17)),
                      BookingsListWidget(),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
