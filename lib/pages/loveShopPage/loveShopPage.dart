import 'dart:convert';

import 'package:city_pickers/city_pickers.dart';
import 'package:city_pickers/modal/result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_canteen/common/shared_preference.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/model/loveShopModel.dart';
import 'package:flutter_canteen/pages/loveShopPage/OnTabChangeListener.dart';
import 'package:flutter_canteen/pages/mineOrderPage/mineOrderItem.dart';
import 'package:flutter_canteen/router/application.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_canteen/pages/loveShopPage/managerLoveShopPage.dart';

import 'loveShopCard.dart';
import 'loveShopPageItem.dart';
import 'mineLoveShopCard.dart';

class loveShopPage extends StatefulWidget {
  final String functionID;

  loveShopPage(this.functionID);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return loveShopState();
  }
}

class loveShopState extends State<loveShopPage> implements OnTabChangeListener {
  bool isfirstload = true;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<loveShopPageItem> children = [];
  List<loveShopPageItem> gpsChildren = [];
  Result resultArr = new Result();
  int areaId = 110000;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isfirstload) {
      getList(areaId);
      isfirstload = false;
    }
    // TODO: implement build
    return Container(
      color: Colors.white,
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Image.asset(
                  "assets/images/btn_backs.png",
                  width: ScreenUtil().setWidth(84),
                  height: ScreenUtil().setWidth(84),
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            centerTitle: true,
            title: Text(
              '爱心商店',
              style: TextStyle(color: Colors.black,
                  fontSize: ScreenUtil().setSp(40),
                  fontWeight:FontWeight.w500),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: usertype=="1"?<Widget>[
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => managerLoveShopPage()));
                   // Appliaction.router
                   //     .navigateTo(context, "/managerLoveShopPage");
                  },
                  child: Container(
                    margin:
                        EdgeInsets.fromLTRB(0, 0, ScreenUtil().setWidth(30), 0),
                    child: Center(
                      child: Text(
                        '管理',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ))
            ]:null,
          ),
          body: SmartRefresher(
            controller: _refreshController,
            enablePullUp: children.length + gpsChildren.length == 0,
            enablePullDown: true,
            onLoading: () async {
              await _onLoading();
            },
            onRefresh: () async {
              await getList(areaId);
            },
            child: (children.length + gpsChildren.length) == 0
                ? buildEmpty()
                : ListView.builder(
                    itemBuilder: (context, index) {
                      if (index == 0 && children.length != 0) {
                        return Container(
                          child: mineLoveShopCard(0, null),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Color(0xffe5e5e5)))),
                        );
                        ;
                      } else if (index == children.length + 1) {
                        return Container(
                          child: mineLoveShopCard(1, this),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Color(0xffe5e5e5)))),
                        );
                      } else {
                        loveShopPageItem mLiveShoe;
                        if (children.length != 0) {
                          if (index <= children.length) {
                            mLiveShoe = children[index - 1];
                          } else if (gpsChildren.length != 0) {
                            mLiveShoe =
                                gpsChildren[index - children.length - 1 - 1];
                          }
                        } else if (children.length == 0) {
                          mLiveShoe = gpsChildren[index - 1];
                        }
                        return Container(
                          child: loveShopCard(mLiveShoe),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Color(0xffe5e5e5)))),
                        );
                      }
                    },
                    itemCount:
                        (children.length == 0 ? 0 : children.length + 1) +
                            (gpsChildren.length == 0
                                ? (children.length == 0 ? 0 : 1)
                                : gpsChildren.length + 1),
                  ),
          )),
    );
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) setState(() {});
    _refreshController.loadNoData();

    // _refreshController.loadComplete();
  }

  Future getList(int areaId) async {
    var param = '/' + 0.toString() + '/' + canteenID;
    await requestGet('managementStoreList', param).then((val) async {
      var data = val;
      setState(() {
        loveShopModel shopModel = loveShopModel.fromJson(data);
        children.clear();
        for (int i = 0; i < shopModel.data.length; i++) {
          loveShopPageItem mLoveShopPageItem = new loveShopPageItem();
          mLoveShopPageItem.url = shopModel.data[i].url;
          mLoveShopPageItem.loveShop = shopModel.data[i].storeName;
          mLoveShopPageItem.business = shopModel.data[i].business;
          children.add(mLoveShopPageItem);
        }
      });
      await getRegionIdRequest(areaId);
    });
  }

  Future getRegionIdRequest(int areaId) async {
    var mParam = '/' + 0.toString() + '/' + areaId.toString();
    await requestGet('managementStoreList', mParam).then((val) {
      _refreshController.refreshCompleted();
      var data = val;
      setState(() {
        loveShopModel shopModel = loveShopModel.fromJson(data);
        gpsChildren.clear();
        for (int i = 0; i < shopModel.data.length; i++) {
          loveShopPageItem mLoveShopPageItem = new loveShopPageItem();
          mLoveShopPageItem.url = shopModel.data[i].url;
          mLoveShopPageItem.loveShop = shopModel.data[i].storeName;
          mLoveShopPageItem.business = shopModel.data[i].business;
          gpsChildren.add(mLoveShopPageItem);
        }
      });
    });
  }

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
  void onTabChange(Result resultArr) {
    var parse = int.parse(resultArr.cityId);
    getRegionIdRequest(parse);
  }

  @override
  void deactivate() {
    var bool = ModalRoute.of(context).isCurrent;
    if (bool) {
      getList(areaId);
    }
  }
}
