import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/statistic.dart';
import '../../../providers/laravel_provider.dart';
import 'statistic_carousel_item_widget.dart';
import 'statistics_carousel_loader_widget.dart';

class StatisticsCarouselWidget extends StatelessWidget {
  final List<Statistic> statisticsList;
  String totalRequestCompleted;

  StatisticsCarouselWidget(
      {Key key, this.statisticsList, this.totalRequestCompleted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (Get.find<LaravelApiClient>().isLoading(task: 'getHomeStatistics')) {
        return StatisticsCarouselLoaderWidget();
      } else {
        return Container(
            child: ListView.builder(
          itemCount: statisticsList.length,
          itemBuilder: (context, index) {
            double _marginLeft = 0;
            (index == 0) ? _marginLeft = 20 : _marginLeft = 0;
            print("statsitic are${statisticsList[index].description}");
            if (statisticsList[index].description.toString() ==
                "total_e_providers") {
              return Container(
                margin: EdgeInsetsDirectional.only(
                    start: 0, end: 20, top: 25, bottom: 25),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                decoration: Ui.getBoxDecoration(color: Get.theme.primaryColor),
                width: 110,
                child: Column(
                  children: [
                    Text(
                      totalRequestCompleted,
                      textAlign: TextAlign.center,
                      style:
                          Get.textTheme.headline2.merge(TextStyle(height: 1)),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Total requests completed ".tr,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      style: Get.textTheme.caption,
                    )
                  ],
                ),
              );
            } else {
              StatisticCarouselItemWidget(
                marginLeft: _marginLeft,
                statistic: statisticsList.elementAt(index),
              );
            }
            return StatisticCarouselItemWidget(
              marginLeft: _marginLeft,
              statistic: statisticsList.elementAt(index),
            );
          },
          scrollDirection: Axis.horizontal,
        ));
      }
    });
  }
}
