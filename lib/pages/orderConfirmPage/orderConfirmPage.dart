import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_canteen/common/shared_preference.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/model/autogenerated.dart';
import 'package:flutter_canteen/model/orderstate.dart';
import 'package:flutter_canteen/otherfunction/logutil.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'orderConfirmCard.dart';
import 'orderConfirmItem.dart';

import 'package:flutter_canteen/model/userListModel.dart';

class orderConfirmPage extends StatefulWidget {
  orderConfirmPage();

  @override
  _orderConfirmState createState() => _orderConfirmState();
}

class _orderConfirmState extends State<orderConfirmPage> {
  int mealtype = 2;
  var _chooseDate = DateTime.now().toString().split(" ")[0];
  var _currentDate = DateTime.now();
  List<OrderConfirmItem> children = [];
  List<userInfo>userInfoData= [];
  Future listData;
  bool isfirstload = true;
  var lastday = DateTime.now().add(Duration(days: 20)); //最前日期
  var outTime = DateTime.now().add(Duration(days: -10)); //提前10天
  int i = 0;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Autogenerated autogenerated = null;

  Widget buildEmpty() {
    return Container(
      width: double.infinity, //宽度为无穷大
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "assets/images/empty1.png",
            fit: BoxFit.cover,
          ),
          Text(
            "没数据,请下拉刷新",
            maxLines: 1,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              height: 1.2,
              decoration: TextDecoration.none,
              decorationStyle: TextDecorationStyle.dashed,
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (_currentDate.hour >= 0 && _currentDate.hour < 8) {
      mealtype = 0;
    } else if (_currentDate.hour >= 8 && _currentDate.hour < 12) {
      mealtype = 1;
    } else if (_currentDate.hour >= 12 && _currentDate.hour < 19) {
      mealtype = 2;
    } else {
      mealtype = 0;
    }

  }

  @override
  Widget build(BuildContext context) {
    if (isfirstload) {
      _getSumUser();
      isfirstload = false;
    }

    return Container(
        color: Colors.white,
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: Image.asset("assets/images/btn_backs.png",
                      width: ScreenUtil().setSp(84),
                      height: ScreenUtil().setSp(84),
                      color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text(
                '订单确认',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: ScreenUtil().setSp(40),
                    fontWeight: FontWeight.w500),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              /*   elevation: 0.0,*/
            ),
            body: SmartRefresher(
              controller: _refreshController,
              enablePullUp: children.length == 0,
              enablePullDown: true,
              onLoading: () async {
                await _onLoading();
              },
              onRefresh: () async {
                await getList(_chooseDate.toString(), mealtype);
              },
              child: children.length == 0
                  ? buildEmpty()
                  : ListView.builder(
                      itemBuilder: (c, i) => new orderConfirmCard(
                          category:
                              children.elementAt(children.length - i - 1)),
                      itemCount: children.length,
                    ),
            )));
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  String  _getcanteenList(int id_new){
    for(int i = 0;i<canteenlist.length;i++){
      if(canteenlist[i].canteenId.toString() == id_new.toString()){
        return canteenlist[i].canteenName;
      }
    }
    return "无名食堂";
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) setState(() {});
    _refreshController.loadNoData();

    // _refreshController.loadComplete();
  }


  Future _getSumUser() async {
    String params = usertype=="1"?"?canteen_id="+canteenID:"?organize_id="+organizeid.toString();
    await requestGet('managementUserInfo', params).then((val) {
      if (val.toString() == "false") {
        return;
      }
      if (val != null) {
        setState(() {
          var userData = userListModel.fromJson(val);
          if (userData.data != null && userData.data.length > 0) {
            userData.data.forEach((f) {
              var userIndfo = new userInfo();
              userIndfo.userId = f.userId.toString();
              userIndfo.userName = f.userName.toString();
              userIndfo.userPhone = f.phoneNum.toString();
              userInfoData.add(userIndfo);
            });
          }
        });
      }
      getList(_chooseDate.toString(), mealtype);
    });
  }

  /*
 查询报餐状态信息
 usertype=1,list后面跟user_id或0
 usertype=3,list后面跟canteen_id或0
*/

  Future getList(String time, int type) async {
    autogenerated = null;
    String params = '/' +
       '0' +
        '/' +
        outTime.toString().split(" ")[0] +
        '/' +
        lastday.toString().split(" ")[0] +
        '/4';
    await requestGet('mealListData', params).then((val) {

      if (val.toString() == "false") {
        return;
      }
      if (val != null) {
        setState(() {
          children.clear();
          autogenerated = Autogenerated.fromJson(val);
          if (autogenerated.data != null && autogenerated.data.length > 0) {
            autogenerated.data.forEach((f) {
              userInfoData.forEach((u) {
                if(u.userId==f.userId.toString()){
                  var orderConfirmItem = new OrderConfirmItem();
                  orderConfirmItem.int_mealtype = f.mealType + 1;
                  orderConfirmItem.state = 0;
                  if (f.state != null) orderConfirmItem.state = f.state;
                  f.mealType == 0
                      ? orderConfirmItem.goMealType = "早餐"
                      : f.mealType == 1
                      ? orderConfirmItem.goMealType = "中餐"
                      : orderConfirmItem.goMealType = "晚餐";
                  f.diningStatus == 0
                      ? orderConfirmItem.diningType = "未就餐"
                      : orderConfirmItem.diningType = "已就餐";
                  f.state == 0 || f.state == null
                      ? orderConfirmItem.mealType = "未报餐"
                      : f.state == 1
                      ? orderConfirmItem.mealType = "已报餐"
                      : f.state == 2
                      ? orderConfirmItem.mealType = "不报餐"
                      : f.state == 3
                      ? orderConfirmItem.mealType = "留餐"
                      : f.state == 4
                      ? orderConfirmItem.mealType = "订餐未确认"
                      : f.state == 5
                      ? orderConfirmItem.mealType = "用户已取消"
                      : f.state == 6
                      ? orderConfirmItem.mealType = "食堂已确认"
                      : orderConfirmItem.mealType = "食堂已拒绝";
                  orderConfirmItem.time = f.orderDate;
                  orderConfirmItem.mealsPrice = f.price.toString();
                  orderConfirmItem.orderNumber = f.mealstatId.toString();
                  orderConfirmItem.mealsNum = f.quantity.toString();
                  orderConfirmItem.mUserId = f.userId.toString();
                  orderConfirmItem.mealName = u.userName;
                  orderConfirmItem.mealPhone = u.userPhone;
                  orderConfirmItem.canteenID = f.canteenID;
                  if(usertype=="1"){
                    orderConfirmItem.caName = canteenName;
                  }else{
                    orderConfirmItem.caName = _getcanteenList(f.canteenID);
                  }
                  children.add(orderConfirmItem);
                }
              });
            });
          }
        });
        _refreshController.refreshCompleted();
      }
    });
  }

}

class userInfo{
  String userId ;
  String userName;
  String userPhone;
}
