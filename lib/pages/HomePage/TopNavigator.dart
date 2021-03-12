import 'package:flutter/material.dart';
import 'package:flutter_canteen/pages/HomePage/loginOrRegister.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_canteen/router/application.dart';
import 'package:flutter_canteen/model/manager_homepage_data.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/pages/foodManage/addCaiPin.dart';
import 'package:flutter_canteen/pages/foodManage/lostPage.dart';
import 'package:flutter_canteen/pages/foodManage/publishCaiPin.dart';
import 'package:flutter_canteen/pages/foodManage/totalCaiPin.dart';
import 'package:flutter_canteen/pages/foodManage/historyCaiDan.dart';
import 'package:flutter_canteen/pages/Ratingpages/Ratingrankpage.dart';
import 'package:flutter_canteen/pages/HomePage/abourtSoftware.dart';
import 'package:flutter_canteen/pages/loveShopPage/loveShopPage.dart';
import 'package:flutter_canteen/pages/orderMealPage/orderMealPage.dart';
import 'package:flutter_canteen/pages/commentsSectionPage/commentsSectionPage.dart';
import 'package:flutter_canteen/pages/orderConfirmPage/orderConfirmPage.dart';
import 'package:flutter_canteen/pages/orderPage/order_in_bulk.dart';
import 'package:flutter_canteen/pages/orderPage/clientorder_mainPage.dart';
import 'package:flutter_canteen/provide/detail_info.dart';
import 'package:provide/provide.dart';


import 'package:flutter_canteen/pages/webViewPage/myWebViewpage.dart';
//首页导航组件编写
class TopNavigator extends StatelessWidget {
  final List<Category> navigatorList;

  TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget getManagerWidgetByID(String id,BuildContext context){
        if (id == '00001') {
          Provide.value<DetailsInfoProvide>(context).foodsInfo=null;
          return PublishCaiPinPage(id);
        }
        else if (id == '00002')
          return AddCaiPinPage(id);
        else if (id == '00003')
          return TotalCaiPinPage(id);
        else if (id == '00004')
          return HistoryCaiDanPage(id);
        else if (id == '00005')
          return RatingrankPage(id);
        else if (id == '00006')
          return loveShopPage(id);
        else if (id == '00007')
          return orderConfirmPage();
        else if (id == '00008')
          return CommentsSectionPage();
        else
          return LostPage(id);
      }


  Widget getClientWidgetByID(String id){
        if (id == '00001') {
          return orderMealPage('00001');
        }else if (id == '00002') {
          return TotalCaiPinPage(id);
        }else if (id == '00003'){
          return RatingrankPage(id);
        }else if (id == '00004') {
//          return loveShopPage(id);
          return HistoryCaiDanPage(id);
        }else if (id == '00005') {
          return ClientOrderPage("");
        }else if (id == '00006') {
          return OrderInBulk("");
        }else if (id == '00007') {
          return CommentsSectionPage();
        }else {
          return LostPage(id);
        }
      }

  Widget _gridViewItemUI(BuildContext context, item) {
    return InkWell(
        onTap: () {
          if (usertype == "1"||usertype == "3") {//管理端{
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                    getManagerWidgetByID(item.functionId,context)));
           }
            //Appliaction.router.navigateTo(
            //    context, "/managerhomepagenavigator?funcID=${item.functionId}");
          else if (usertype == "2") {//客户端
            if(isYouKe){
              if(item.functionId=='00005'||item.functionId=='00006'){
                showDialog(
                    context: context,
                    builder: (context){
                      return LoginOrRegister();
                    }
                );
              }else{
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            getClientWidgetByID(item.functionId)));
              }
            }else{
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          getClientWidgetByID(item.functionId)));
            }
          }
            //Appliaction.router.navigateTo(
            //    context, "/clienthomepagenavigator?funcID=${item.functionId}");
        },
        child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.network(item.image, width: ScreenUtil().setSp(100),
                  height: ScreenUtil().setSp(100)),
                Text(item.categoryName)
              ],
            ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: ScreenUtil().setSp(420),
      padding: EdgeInsets.fromLTRB(ScreenUtil().setSp(40), 0, ScreenUtil().setSp(40), 0),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        mainAxisSpacing:ScreenUtil().setSp(1),
        padding: EdgeInsets.all(1.0),
        children: navigatorList.map((item) {
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}
