import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../album_view/Controller/AlbumView_Controller.dart';
import '../../album_view/View/Album_view.dart';
import '../../portfolio_view/View/Portfolio_View.dart';

class PortfolioAndAlbumView extends GetView<AlbumViewController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: new FloatingActionButton(
      //   child: new Icon(Icons.add, size: 28, color: Get.theme.primaryColor),
      //   onPressed: () => {
      //     Get.toNamed(Routes.PortfolioAlbum, preventDuplicates: false),
      //     // Get.toN,
      //   },
      //   backgroundColor: Get.theme.colorScheme.secondary,
      // ).paddingOnly(bottom: 90, right: 11),
      appBar: AppBar(
        actions: [
          Obx(
            () => controller.isDeletable.isTrue
                ? IconButton(
                    icon: new Icon(Icons.delete, color: Colors.blueAccent),
                    onPressed: () => controller.delAlbum(),
                  )
                : SizedBox(),
          )
        ],
        title: Text(
          "Portfolio and Album".tr,
          style: context.textTheme.headline6,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
          decoration: Ui.getBoxDecoration(),
          // width: 200,

          child: DefaultTabController(
            length: 2,
            child: Scaffold(
                appBar: new PreferredSize(
                  preferredSize: Size.fromHeight(20),
                  child: new Container(
                    // color: Colors.green,
                    width: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Get.theme.primaryColor,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new TabBar(
                            indicatorColor: Color(0xffE5E7EB),
                            indicator: UnderlineTabIndicator(
                                borderSide: BorderSide(width: 0.5),
                                insets: EdgeInsets.symmetric(
                                    vertical:
                                        MediaQuery.of(context).size.height /
                                            100 *
                                            -1.4,
                                    horizontal:
                                        MediaQuery.of(context).size.width /
                                            100 *
                                            10)),
                            tabs: [
                              Text(
                                "Portfolio",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width /
                                            100 *
                                            3.7,
                                    color: Get.theme.colorScheme.secondary),
                              ),
                              Text(
                                "Albums",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width /
                                            100 *
                                            3.7,
                                    color: Get.theme.colorScheme.secondary),
                              ),
                              // SizedBox(),
                              // SizedBox(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                body: TabBarView(
                  children: <Widget>[
                    PortfolioView(),
                    AlbumView(),
                  ],
                )),
          )),
    );
  }
}
