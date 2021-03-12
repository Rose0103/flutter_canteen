import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'SwiperDiy.dart';
import 'TopNavigator.dart';
import 'QuickSummaryData.dart';
import 'dart:convert';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/model/manager_homepage_data.dart';
import 'dart:async';
import 'package:flutter_canteen/config/param.dart';
class ManagerHomePage extends StatefulWidget {
  @override
  _ManagerHomePageState createState() => _ManagerHomePageState();
}

class _ManagerHomePageState extends State<ManagerHomePage> with AutomaticKeepAliveClientMixin{
  var _futureBuilderFuture;
  homePageDataModel homepagedata;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    _futureBuilderFuture= getHomePageContent('managerHomePageContext');

  }

  String homePageContent = ' ';
  void _setTitleTap(String title) {
    setState(() {
      homePageContent = title;
    });
  }

  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            body: FutureBuilder(
              future:_futureBuilderFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData ) {
                  var data = snapshot.data;
                  homepagedata = homePageDataModel.fromJson(data);
                  //更新名称
                  //canteenName =homepagedata.data.canteenName;
                  //canteenID = homepagedata.data.canteenID;
                  //canteenID="1";
                  List<Slides> swiper = homepagedata.data.slides;
                  List<Category> navigatorList = homepagedata.data.category;
                  if(usertype=="3"){
                    navigatorList.removeRange(0, 2);
                  }
                  return SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(ScreenUtil.getInstance().setSp(2.0), ScreenUtil.getInstance().setSp(80.0),ScreenUtil.getInstance().setSp(2.0), 0.0),
                      child: Column(
                        children: <Widget>[
                          SwiperDiy(swiperDataList: swiper), // 顶部轮播组件数
                          TopNavigator(navigatorList: navigatorList), // 导航组件
                          line(),
                          QuickSummaryData(context),
                        ],
                      ));
                } else {
                  return Center(
                      child: Text('加载中……',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil.getInstance().setSp(24))));
                }
              },
            )));
  }

  /**
   * 分割线
   */
  Container line() {
    return Container(
      width: double.infinity,
      height: ScreenUtil().setSp(10),
    );
  }
}
