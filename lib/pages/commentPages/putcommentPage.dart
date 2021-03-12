import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_canteen/provide/menu_data.dart';
import 'package:flutter_canteen/provide/detail_info.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';
import 'package:flutter_canteen/otherfunction/RatingBar.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_canteen/common/shared_preference.dart';
import 'package:flutter_canteen/model/menu_data.dart';
import 'package:flutter_canteen/model/categoryFoodsList.dart';
import 'package:flutter_canteen/otherfunction/showDialog.dart';

class putCommentPage extends StatefulWidget {
  String mealtime;
  int mealtype;
  String ordernumber;
  int ordertype; //订单类型： 1 报餐订单  2. 订餐订单
  String totalnum;
  String totalprice;
  int c_id;//订单食堂id


  putCommentPage(this.mealtime, this.mealtype, this.ordernumber, this.ordertype,
      this.totalnum, this.totalprice,this.c_id);

  @override
  putCommentPageState createState() => putCommentPageState(
      this.mealtime,
      this.mealtype,
      this.ordernumber,
      this.ordertype,
      this.totalnum,
      this.totalprice,
      this.c_id
  );
}

class putCommentPageState extends State<putCommentPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController; //需要定义一个Controller
  List tabs = ["未评价菜品", "已评价菜品"];
  String mealtime;
  int mealtype;
  String ordernumber;
  int ordertype; //订单类型： 1 报餐订单  2. 订餐订单
  String totalnum;
  String totalprice;
  int c_id;
  bool isfirstload = true;
  DateTime lastPopTime = null;
  List<MenuDataDataMenuInfo> personalmenudata = List();
  List<MenuDataDataMenuInfo> personalmenudataCommended = List();
  var scrollController = new ScrollController();
  var scrollController2 = new ScrollController();
  TextEditingController _commentController = TextEditingController();

  putCommentPageState(this.mealtime, this.mealtype, this.ordernumber,
      this.ordertype, this.totalnum, this.totalprice,this.c_id);

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(initialIndex: 0, length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Image.asset(
                "assets/images/btn_backs.png",
                width: ScreenUtil().setSp(84),
                height: ScreenUtil().setSp(84),
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          centerTitle: true,
          title: Text(
            '评论详情',
            style: TextStyle(
                color: Colors.black,
                fontSize: ScreenUtil().setSp(40),
                fontWeight: FontWeight.w500),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          bottom: TabBar(
              labelColor: Theme.of(context).primaryColor,
              indicatorColor: Colors.red,
              unselectedLabelColor: Colors.black,
              controller: _tabController,
              tabs: tabs
                  .map((e) => Tab(
                        text: e,
                      ))
                  .toList()),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // 触摸收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: TabBarView(
            controller: _tabController,
            children: tabs.map((item) {
              return FutureBuilder(
                future: ordertype == 1 ? getFoodsMenu() : getDingCanFoodsMenu(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                        child: Column(
                      children: <Widget>[
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 5.0),
                            child: Column(
                              children: <Widget>[
                                dateAndOrderIDWidget(),
                                ordertypeWidget(),
                                lineView(),
                                item == tabs[0]
                                    ? DishesWidget()
                                    : HaveEvaluationWidget()
                              ],
                            ),
                          ),
                        ),
                        item == tabs[0] ? _commitButtonWidget() : Text(""),
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
              );
            }).toList(),
          ),
        ));
  }

//订单类型
  Container ordertypeWidget() {
    return (Container(
      child: Row(
        children: <Widget>[
          Text(
            '订单类型:  ',
            maxLines: 1,
            style: TextStyle(
              color: Color(0xFF6D7278),
              fontSize: 12.0,
              height: 1.2,
              decoration: TextDecoration.none,
              decorationStyle: TextDecorationStyle.dashed,
            ),
          ),
          Container(
            child: ordertype == 1
                ? Text(
                    "报餐订单",
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 12.0,
                      height: 1.0,
                      decoration: TextDecoration.none,
                      decorationStyle: TextDecorationStyle.dashed,
                    ),
                  )
                : Text(
                    "订餐订单",
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12.0,
                      height: 1.0,
                      decoration: TextDecoration.none,
                      decorationStyle: TextDecorationStyle.dashed,
                    ),
                  ),
          ),
        ],
      ),
    ));
  }

  Future getFoodsMenu() async {
    if (!isfirstload) return "second";
    isfirstload = false;
    await Provide.value<MenuDataProvide>(context)
        .getBaoCanMenuFoodsInfo(canteenID, mealtime, mealtype - 1, 2);
    //personalmenudata=Provide.value<MenuDataProvide>(context).personalmenudata.data.menuInfo;
    int size = Provide.value<MenuDataProvide>(context)
        .personalmenudata
        .data
        .menuInfo
        .length;
    if (size > 0) {
      await Provide.value<DetailsInfoProvide>(context)
          .getUserFoodsInfo(userID, ordernumber);
      personalmenudataCommended.clear();
      personalmenudata.clear();
      //modify by lilixia   2020-11-23
      if(Provide.value<DetailsInfoProvide>(context).commentlist !=
          null){
      if (Provide.value<DetailsInfoProvide>(context).commentlist.length > 0) {
        for (int i = 0;
            i < Provide.value<DetailsInfoProvide>(context).commentlist.length;
            i++) {
          for (int j = 0;
              j <
                  Provide.value<MenuDataProvide>(context)
                      .personalmenudata
                      .data
                      .menuInfo
                      .length;
              j++) {
            if (Provide.value<DetailsInfoProvide>(context)
                    .commentlist[i]
                    .dish_id ==
                Provide.value<MenuDataProvide>(context)
                    .personalmenudata
                    .data
                    .menuInfo[j]
                    .dishId) {
              Provide.value<MenuDataProvide>(context)
                      .personalmenudata
                      .data
                      .menuInfo[j]
                      .dishScore =
                  Provide.value<DetailsInfoProvide>(context)
                      .commentlist[i]
                      .dish_score
                      .toDouble();
              Provide.value<MenuDataProvide>(context)
                      .personalmenudata
                      .data
                      .menuInfo[j]
                      .dishFlavor =
                  Provide.value<DetailsInfoProvide>(context)
                      .commentlist[i]
                      .comment_details;
              personalmenudataCommended.add(
                  Provide.value<MenuDataProvide>(context)
                      .personalmenudata
                      .data
                      .menuInfo[j]);
              break;
            }
          }
        }
      }}

      personalmenudata = Provide.value<MenuDataProvide>(context)
          .personalmenudata
          .data
          .menuInfo;
      for (int j = 0; j < personalmenudataCommended.length; j++) {
        for (int i = 0; i < personalmenudata.length; i++) {
          if (personalmenudata[i].dishId ==
              personalmenudataCommended[j].dishId) {
            personalmenudata.removeAt(i);
            break;
          }
        }
      }
    }
    return "success";
  }

  Future getDingCanFoodsMenu() async {
    if (!isfirstload) return "second";
    isfirstload = false;
    await Provide.value<MenuDataProvide>(context)
        .getDingCanMenuFoodsInfo(userID, mealtime, mealtype - 1,c_id);
    int size = Provide.value<MenuDataProvide>(context)
        .dingdanmenudata
        .data
        .foodInfoList
        .length;
    if (size > 0) {
      await Provide.value<DetailsInfoProvide>(context)
          .getUserFoodsInfo(userID, ordernumber);

      personalmenudataCommended.clear();
      personalmenudata.clear();
      if (Provide.value<DetailsInfoProvide>(context).commentlist != null) {
        if (Provide.value<DetailsInfoProvide>(context).commentlist.length > 0) {
          for (int i = 0;
              i < Provide.value<DetailsInfoProvide>(context).commentlist.length;
              i++) {
            for (int j = 0;
                j <
                    Provide.value<MenuDataProvide>(context)
                        .dingdanmenudata
                        .data
                        .foodInfoList
                        .length;
                j++) {
              if (Provide.value<DetailsInfoProvide>(context)
                      .commentlist[i]
                      .dish_id ==
                  Provide.value<MenuDataProvide>(context)
                      .dingdanmenudata
                      .data
                      .foodInfoList[j]
                      .dishId) {
                Provide.value<MenuDataProvide>(context)
                        .dingdanmenudata
                        .data
                        .foodInfoList[j]
                        .dishFlavor =
                    Provide.value<DetailsInfoProvide>(context)
                        .commentlist[i]
                        .comment_details;
                Provide.value<MenuDataProvide>(context)
                        .dingdanmenudata
                        .data
                        .foodInfoList[j]
                        .dishScore =
                    Provide.value<DetailsInfoProvide>(context)
                        .commentlist[i]
                        .dish_score
                        .toDouble();

                CategoryFoodsListModelDataFoodInfoList tmp =
                    Provide.value<MenuDataProvide>(context)
                        .dingdanmenudata
                        .data
                        .foodInfoList[j];
                MenuDataDataMenuInfo menuinfo = MenuDataDataMenuInfo(
                  dishId: tmp.dishId,
                  canteenId: tmp.canteenId,
                  dishName: tmp.dishName,
                  dishDesc: tmp.dishDesc,
                  dishFlavor: tmp.dishFlavor,
                  dishPrice: tmp.dishPrice,
                  dishPhoto: tmp.dishPhoto,
                  createTime: tmp.createTime,
                  updateTime: tmp.updateTime,
                  dishScore: tmp.dishScore,
                  menuId: 12345,
                  menuDate: mealtime,
                  menuType: mealtype,
                  category: tmp.category,
                );
                personalmenudataCommended.add(menuinfo);
              }
            }
          }
        }
      }

      for (int j = 0;
          j <
              Provide.value<MenuDataProvide>(context)
                  .dingdanmenudata
                  .data
                  .foodInfoList
                  .length;
          j++) {
        CategoryFoodsListModelDataFoodInfoList tmp =
            Provide.value<MenuDataProvide>(context)
                .dingdanmenudata
                .data
                .foodInfoList[j];
        MenuDataDataMenuInfo menuinfo = MenuDataDataMenuInfo(
          dishId: tmp.dishId,
          canteenId: tmp.canteenId,
          dishName: tmp.dishName,
          dishDesc: tmp.dishDesc,
          dishFlavor: tmp.dishFlavor,
          dishPrice: tmp.dishPrice,
          dishPhoto: tmp.dishPhoto,
          createTime: tmp.createTime,
          updateTime: tmp.updateTime,
          dishScore: tmp.dishScore,
          menuId: 12345,
          menuDate: mealtime,
          menuType: mealtype,
          category: tmp.category,
        );
        personalmenudata.add(menuinfo);
      }
      for (int j = 0; j < personalmenudataCommended.length; j++) {
        for (int i = 0; i < personalmenudata.length; i++) {
          if (personalmenudata[i].dishId ==
              personalmenudataCommended[j].dishId) {
            personalmenudata.removeAt(i);
            break;
          }
        }
      }
    }
    return "success";
  }

  Widget dateAndOrderIDWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, ScreenUtil().setSp(20), 0, 0),
      child: Row(
        children: <Widget>[
          Text(
            mealtime +
                "  " +
                (mealtype == 1 ? "早餐" : mealtype == 2 ? "中餐" : "晚餐"),
            maxLines: 1,
            style: TextStyle(
              color: Color(0xFF6D7278),
              fontSize: 12.0,
              height: 1.0,
              decoration: TextDecoration.none,
              decorationStyle: TextDecorationStyle.dashed,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(""),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Text(
              '订单编号：' + ordernumber,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(0xFF6D7278),
                fontSize: 12.0,
                height: 1.0,
                decoration: TextDecoration.none,
                decorationStyle: TextDecorationStyle.dashed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /**
   * 分割线
   */
  Container lineView() {
    return Container(
      height: ScreenUtil().setSp(40),
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Divider(
        height: 1.0,
        indent: 0.0,
        color: Colors.grey,
      ),
    );
  }

  Widget DishesWidget() {
    return Provide<MenuDataProvide>(
      builder: (context, child, data) {
        if ((ordertype == 1
                ? data.personalmenudata != null
                : data.dingdanmenudata != null) &&
            personalmenudata.length != 0) {
          return Column(children: <Widget>[
            personalmenudata.length == 0
                ? Container()
                : Column(children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.fromLTRB(0, 0, 0, ScreenUtil().setSp(10)),
                      child: Text("未评价菜品"),
                    ),
                    Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: new NeverScrollableScrollPhysics(),
                        controller: scrollController,
                        itemCount: personalmenudata.length,
                        itemBuilder: (context, index) {
                          return _ListWidget(personalmenudata, index, 1);
                        },
                      ),
                    ),
                    // _commitButtonWidget(),
                  ]),
            /* personalmenudataCommended.length == 0 ? Text("") : Text("已评价菜品"),
            Container(
              width: ScreenUtil().setSp(730),
              height: ScreenUtil().setHeight(800),
              child: ListView.builder(
                controller: scrollController2,
                itemCount: personalmenudataCommended.length,
                itemBuilder: (context, index) {
                  return _ListWidget(personalmenudataCommended, index, 2);
                },
              ),
            ),*/
          ]);
        } else {
          return Text('没有未评论的菜品');
        }
      },
    );
  }

  Widget HaveEvaluationWidget() {
    return Provide<MenuDataProvide>(
      builder: (context, child, data) {
        if ((ordertype == 1
                ? data.personalmenudata != null
                : data.dingdanmenudata != null) &&
            personalmenudataCommended.length != 0) {
          return Column(children: <Widget>[
            personalmenudataCommended.length == 0
                ? Text("")
                : Container(
                    margin:
                        EdgeInsets.fromLTRB(0, 0, 0, ScreenUtil().setSp(10)),
                    child: Text("已评价菜品"),
                  ),
            Container(
              child: ListView.builder(
                shrinkWrap: true,
                physics: new NeverScrollableScrollPhysics(),
                controller: scrollController2,
                itemCount: personalmenudataCommended.length,
                itemBuilder: (context, index) {
                  return _ListWidget(personalmenudataCommended, index, 2);
                },
              ),
            ),
          ]);
        } else {
          return Text('没有已评论的菜品');
        }
      },
    );
  }

  Widget _ListWidget(List newList, int index, int type) {
    return Container(
      //height: ScreenUtil().setSp(180),
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 1.0, color: Colors.black12))),

      child: Column(
        children: <Widget>[
          _foodsNameAndPrice(newList, index),
          _foodsScore(newList, index, type),
          emptyline(),
          _foodsComment(newList, index, type),
        ],
      ),
    );
  }

  //提交按钮
  Widget _commitButtonWidget() {
    return Container(
        width: ScreenUtil().setSp(686),
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setSp(32.0),
            ScreenUtil().setSp(40.0),
            ScreenUtil().setSp(32.0),
            ScreenUtil().setSp(40.0)),
      child: personalmenudata.length == 0? Text(""):RaisedButton(
          padding: EdgeInsets.all(15.0),
          child: Text("确认发布"),
          color: Theme.of(context).primaryColor,
          highlightColor: Theme.of(context).primaryColor,
          colorBrightness: Brightness.dark,
          splashColor: Colors.grey,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)),
          onPressed: () async {
            if (lastPopTime == null ||
                DateTime.now().difference(lastPopTime) >
                    Duration(seconds: 2)) {
              lastPopTime = DateTime.now();
              setState(() {
                postComment();
              });
            } else {
              lastPopTime = DateTime.now();
              showMessage(context, "请勿重复点击！");
              return;
            }
          }),
    );
  }

  //商品名称和价格
  Widget _foodsNameAndPrice(List newList, int index) {
    return Container(
        padding: EdgeInsets.only(
            top: ScreenUtil().setSp(15), bottom: ScreenUtil().setSp(15)),
        alignment: Alignment.centerLeft,
        child: Row(children: <Widget>[
          Text(
            newList[index].dishName + "    ",
            //maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.w900),
          ),
          Text(
            newList[index].dishPrice.toString(),
            //maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(28),
                color: Colors.orange,
                fontWeight: FontWeight.w700),
          ),
          Text(
            "  元",
            //maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(28), fontWeight: FontWeight.w900),
          ),
        ]));
  }

  //菜品分数
  Widget _foodsScore(List newList, int index, int type) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setSp(15),
          ScreenUtil().setSp(20),
          ScreenUtil().setSp(0),
          ScreenUtil().setSp(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        //设置四周圆角 角度
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        //设置四周边框
        border: Border.all(width: 1, color: Colors.black12),
      ),
      child: Row(
        children: <Widget>[
          Text(
            "评分：",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: ScreenUtil().setSp(28)),
          ),
          RatingBar(
              clickable: type == 1 ? true : false,
              size: 45,
              color: Colors.yellow,
              padding: 5,
              value: type == 1
                  ? personalmenudata[index].dishScore
                  : personalmenudataCommended[index].dishScore,
              onValueChangedCallBack: (value) {
                if (type == 1) personalmenudata[index].dishScore = value;
              }),
        ],
      ),
    );
  }

  //空条
  Container emptyline() {
    return Container(
      height: ScreenUtil().setSp(30),
    );
  }

  //菜品评论
  Widget _foodsComment(List newList, int index, int type) {
    return Container(
      height: ScreenUtil().setSp(150),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        //设置四周圆角 角度
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        //设置四周边框
        border: Border.all(width: 1, color: Colors.black12),
      ),
      child: type == 1
          ? TextField(
              decoration: InputDecoration(
                //labelText: '评论',
                border: InputBorder.none,
              ),
              onChanged: (str) {
                personalmenudata[index].dishFlavor = str;
              },
              maxLines: 1,
              autofocus: false,
              style: TextStyle(fontSize: ScreenUtil().setSp(28)),
            )
          : Text(
              personalmenudataCommended[index].dishFlavor,
              maxLines: 20,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: ScreenUtil().setSp(28)),
            ),
    );
  }

  Future postComment() async {
    int length = personalmenudata.length;
    for (int i = 0; i < length; i++) {
      if (personalmenudata[i].dishScore == 0) {
        showMessage(context, "请先选择评分");
        continue;
      }
      var commentData = {
        "dish_id": personalmenudata[i].dishId,
        "comment_details": personalmenudata[i].dishFlavor,
        "user_id": int.parse(userID),
        "dish_score": personalmenudata[i].dishScore,
        "mealstat_id": ordernumber,
        //"meal_type": mealtype,
        //"order_date": mealtime
      };
      await request('postComment', '', formData: commentData).then((val) {
        if (val.toString() == "false") {
          return;
        }
        if (val != null) {
          //var responseData = json.decode(val.toString());
          isfirstload = true;
          setState(() {
            showMessage(context, "发布成功");
          });
        }
      });
    }
  }
}
