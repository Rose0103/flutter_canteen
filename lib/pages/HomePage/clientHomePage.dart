import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_canteen/pages/LoginPage/login.dart';
import 'package:flutter_canteen/pages/LoginPage/register.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_canteen/pages/HomePage/SwiperDiy.dart';
import 'package:flutter_canteen/pages/HomePage/TopNavigator.dart';
import 'package:flutter_canteen/pages/HomePage/QuickOrder.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'dart:convert';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/model/manager_homepage_data.dart';

class ClientHomePage extends StatefulWidget {
  @override
  _ClientHomePageState createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage>
    with AutomaticKeepAliveClientMixin {
  var _futureBuilderFuture;
  homePageDataModel homepagedata;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = getHomePageContent('clientHomePage');
  }

  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            body: FutureBuilder(
      future: _futureBuilderFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data;
          homepagedata = homePageDataModel.fromJson(data);
          //更新名称
          //canteenName = homepagedata.data.canteenName;
          //canteenID = homepagedata.data.canteenID;
          //canteenID = "1";
          List<Slides> swiper = homepagedata.data.slides;
          List<Category> navigatorList = homepagedata.data.category;
          return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(ScreenUtil.getInstance().setSp(2.0), ScreenUtil.getInstance().setSp(80.0),ScreenUtil.getInstance().setSp(2.0), 0.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: isYouKe?<Widget>[
                      userNameTitle(context),
                      Container(
                        margin: EdgeInsets.only(left: ScreenUtil().setSp(240)),
                        child: InkWell(
                            child: Text('登录',style: TextStyle(color: Colors.lightBlue,fontSize: 20.0),),
                            onTap: () {
                              Navigator.push(context,MaterialPageRoute(builder: (context) =>LoginWidget()));
                            }
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: ScreenUtil().setSp(20)),
                        child: InkWell(
                          child: Text('注册',style: TextStyle(color: Colors.lightBlue,fontSize: 20.0),),
                          onTap: () {
                            Navigator.push(context,MaterialPageRoute(builder: (context) =>RegisterWidget()));
                          },
                        ),
                      ),
                    ]:<Widget>[
                      userNameTitle(context),
                    ],
                  ),
                  SwiperDiy(swiperDataList: swiper), // 顶部轮播组件数
                  TopNavigator(navigatorList: navigatorList), // 导航组件
                  line(),
                  QuickOrder(),
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

  //姓名标题
  Widget userNameTitle(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, ScreenUtil().setSp(10), 0, 0),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
          left: ScreenUtil.getInstance().setSp(15),
          right: ScreenUtil.getInstance().setSp(10)),
      child: Text(realName == null ? "您好" : realName + "   您好",
          style: TextStyle(
              color: Colors.black,
              fontSize: ScreenUtil.getInstance().setSp(30),
              fontWeight: FontWeight.w400)),
    );
  }

}
