import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_canteen/model/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_canteen/pages/categoryPage/categorypage.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_canteen/model/categoryFoodsList.dart';
import 'package:provide/provide.dart';
import 'package:flutter_canteen/provide/child_category.dart';
import 'package:flutter_canteen/provide/category_foods_list.dart';
import 'package:flutter_canteen/provide/menu_data.dart';
import 'package:flutter_canteen/provide/foodMenuRelease.dart';
import 'package:flutter_canteen/router/application.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/model/menu_data.dart';
import 'package:badges/badges.dart';
import 'package:dio/dio.dart';
import '../../common/shared_preference.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_canteen/pages/photo_view_page/photo_view_page.dart';
import 'package:flutter_canteen/otherfunction/showDialog.dart';
import 'package:flutter_canteen/otherfunction/showDialog.dart';

Map<int, int> mapdishnum = Map();

//订餐就餐界面
class orderMealPage extends StatefulWidget {
  final String functionID;

  orderMealPage(this.functionID);

  @override
  _orderMealPageState createState() => _orderMealPageState();
}

class _orderMealPageState extends State<orderMealPage> {
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();

  var scrollController = new ScrollController();

  int groupValue = 1;
  DateTime lastPopTime=null;

  @override
  var _chooseDate = DateTime.now().toString().split(" ")[0];

  var _currentDate = DateTime.now();
  double money = 0;
  CategoryFoodsListModel caidanitems = null;
  int dishsize = 0;
  GlobalKey<_TextWidgetState> textsumKey = GlobalKey();
  String sumtext = "0";
  Map<int, GlobalKey<_TextWidgetDishState>> keymap = Map();


  void initState() {
    super.initState();
    _getCategory();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_currentDate.hour > 20 && _currentDate.hour < 9)
        groupValue = 1;
      else if (_currentDate.hour > 9 && _currentDate.hour < 14)
        groupValue = 2;
      else if (_currentDate.hour > 14 && _currentDate.hour < 20) groupValue = 3;
      Future.delayed(Duration(seconds: 0), () async {
        dishsize = 0;
        await getDingCanFoodsMenu();
        setState(() {
          if (Provide.value<MenuDataProvide>(context).dingdanmenudata != null &&
              Provide.value<MenuDataProvide>(context).dingdanmenudata.data !=
                  null)
            dishsize = Provide.value<MenuDataProvide>(context)
                .dingdanmenudata
                .data
                .foodInfoList
                .length;
          caidanitems = Provide.value<MenuDataProvide>(context).dingdanmenudata;
          sumtext = getSum();
          refreshmap();
        });
        if(categoryList.length>0){
          textsumKey.currentState.onPressed(getSum());
        }
      });
    });
  }

  void _getCategory() async{
    categoryList.clear();
    await requestGet('Category', '?canteen_id='+canteenID).then((val) async{
      if(val.toString()=="false") {
        return;
      }
      //var  data = json.decode(val.toString());
      //print(data);
      CategoryBigModel category=CategoryBigModel.fromJson(val);
      setState(() {
        categoryList = category.data;
      });
      if(categoryList==null||categoryList.length==0){
        return;
      }
      //modify by wanchao 2020-11-23
      if(categoryList[0].secondaryCategoryList.length>0)
        {
      Provide.value<ChildCategory>(context).changeCategory(categoryList[0].secondaryCategoryList[0].categoryId, 0);
      LeftCategoryNavState.getFoodList(context,categoryList[0].secondaryCategoryList[0].categoryId);
      Provide.value<ChildCategory>(context).getChildCategory( categoryList[0].secondaryCategoryList,categoryList[0].secondaryCategoryList[0].categoryId);
      }
      else
        {
          //清空子类
          Provide.value<ChildCategory>(context).childCategoryList=[];
          //清空商品列表
          Provide.value<CategoryFoodsListProvide>(context).foodsList=[];
        }

    });
  }

  Widget build(BuildContext context) {
    if(Provide.value<MenuDataProvide>(context).dingCanState<4||Provide.value<MenuDataProvide>(context).dingCanState==5||Provide.value<MenuDataProvide>(context).dingCanState==7){
      dishsize = 0;
    }
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
          '订餐就餐',
          style: TextStyle(color: Colors.black,
              fontSize: ScreenUtil().setSp(40),
              fontWeight:FontWeight.w500),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 0.0),
          child: Column(
            children: <Widget>[
              timeChoseWidget(context),
              _mealTimeChoseWidget(),
              categoryList.length>0?Column(
                children: <Widget>[
                  orderContentPage(context),
                  isYouKe ? Container() : _buttonsWidget(context),
                ],
              ):buildEmpty(),
            ],
          ),
        )
      ),
    );
  }

  Widget buildEmpty() {
    return Container(
      width: double.infinity, //宽度为无穷大
      height: ScreenUtil().setSp(850),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "assets/images/empty1.png",
            fit: BoxFit.cover,
          ),
          Text(
            "暂时没有数据",
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

  _showDatePicker() async {
    var date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().add(new Duration(days: -1)),
        lastDate: DateTime.now().add(new Duration(days: 14)),
        locale: Locale('zh'));
    if (date == null) {
      return;
    }
    if (!_currentDate.isAtSameMomentAs(date)) {
      _currentDate = date;
      updateGroupValue(_currentDate.toString().split(" ")[0], groupValue);
      setState(() {
        this._chooseDate = _currentDate.toString().split(" ")[0];
      });
    }
  }

  void _theDayBefor() {
    var _tempDate = _currentDate;
    _tempDate = _tempDate.add(new Duration(days: -1));
    if ((_tempDate.isAfter(DateTime.now().add(new Duration(days: -1))) ||
            _tempDate.isAtSameMomentAs(
                DateTime.now().add(new Duration(days: -1)))) &&
        (_tempDate.isBefore(DateTime.now().add(new Duration(days: 14))) ||
            _tempDate.isAtSameMomentAs(
                DateTime.now().add(new Duration(days: -1))))) {
      _currentDate = _tempDate;
      this._chooseDate = _currentDate.toString().split(" ")[0]; //不可删
      updateGroupValue(_currentDate.toString().split(" ")[0], groupValue);
    }
  }

  void _theDayAfter() {
    var _tempDate = _currentDate;
    _tempDate = _tempDate.add(new Duration(days: 1));
    if ((_tempDate.isAfter(DateTime.now().add(new Duration(days: -1))) ||
            _tempDate.isAtSameMomentAs(
                DateTime.now().add(new Duration(days: -1)))) &&
        (_tempDate.isBefore(DateTime.now().add(new Duration(days: 14))) ||
            _tempDate.isAtSameMomentAs(
                DateTime.now().add(new Duration(days: -1))))) {
      _currentDate = _tempDate;
      this._chooseDate = _currentDate.toString().split(" ")[0];
      updateGroupValue(_currentDate.toString().split(" ")[0], groupValue);
    }
  }

  //前一天按钮
  Widget theDayBeforeButton() {
    return Container(
      width: ScreenUtil.getInstance().setSp(200),
      height: ScreenUtil.getInstance().setSp(68),
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
            image: AssetImage("assets/images/btn_qianyt_default.png"),
            fit: BoxFit.fill),
      ),
      alignment: Alignment.center,
      child: FlatButton(
        onPressed: _theDayBefor,
        child: Text("< 前一天"),
        color: Colors.transparent,
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0)), side: BorderSide(color: Colors.white, style: BorderStyle.solid, width: 21)),
      ),
    );
  }

  //后一天按钮
  Widget theDayAfterButton() {
    return Container(
      width: ScreenUtil.getInstance().setSp(200),
      height: ScreenUtil.getInstance().setSp(68),
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
            image: AssetImage("assets/images/btn_houyt_default.png"),
            fit: BoxFit.fill),
      ),
      alignment: Alignment.center,
      child: FlatButton(
        onPressed: _theDayAfter,
        child: Text("后一天 >"),
        color: Colors.transparent,
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0)), side: BorderSide(color: Colors.white, style: BorderStyle.solid, width: 21)),
      ),
    );
  }

  //时间选择按钮
  Widget timeChoseButton(BuildContext context) {
    return Container(
      width: ScreenUtil.getInstance().setSp(300),
      height: ScreenUtil.getInstance().setSp(60),
      decoration: BoxDecoration(
        border: Border.all(width: 2.0, color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      alignment: Alignment.center,
      child: FlatButton(
        child: Text(_chooseDate.toString()),
        color: Colors.transparent,
        onPressed: _showDatePicker,
      ),
    );
  }

  //时间控件
  Widget timeChoseWidget(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: ScreenUtil.getInstance().setSp(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            theDayBeforeButton(),
            timeChoseButton(context),
            theDayAfterButton(),
          ],
        ));
  }

  Widget _mealTimeChoseWidget() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: RadioListTile(
                  value: 1,
                  groupValue: groupValue,
                  title: Text('早餐'),
                  onChanged: (T) {
                    updateGroupValue(_currentDate.toString().split(" ")[0], T);
                  })),
          Expanded(
              child: RadioListTile(
                  value: 2,
                  groupValue: groupValue,
                  title: Text('中餐'),
                  onChanged: (T) {
                    updateGroupValue(_currentDate.toString().split(" ")[0], T);
                  })),
          Expanded(
              child: RadioListTile(
                  value: 3,
                  groupValue: groupValue,
                  title: Text('晚餐'),
                  onChanged: (T) {
                    updateGroupValue(_currentDate.toString().split(" ")[0], T);
                  })),
        ],
      ),
    );
  }

  updateGroupValue(String time, int v) async {
    dishsize = 0;
    groupValue = v;
    await getDingCanFoodsMenu();

    setState(() {
      if (Provide.value<MenuDataProvide>(context).dingdanmenudata != null &&
          Provide.value<MenuDataProvide>(context).dingdanmenudata.data != null)
        dishsize = Provide.value<MenuDataProvide>(context)
            .dingdanmenudata
            .data
            .foodInfoList
            .length;
      caidanitems = Provide.value<MenuDataProvide>(context).dingdanmenudata;
      sumtext = getSum();
      refreshmap();
    });
    textsumKey.currentState.onPressed(getSum());
    keymap.forEach((k, v) {
      if (v != null && v.currentState != null) v.currentState.onPressed("0");
    });

    if (caidanitems != null && caidanitems.data != null) {
      for (int i = 0; i < caidanitems.data.foodInfoList.length; i++) {
        if (keymap.containsKey(caidanitems.data.foodInfoList[i].dishId)) {
          if (keymap[caidanitems.data.foodInfoList[i].dishId] != null &&
              keymap[caidanitems.data.foodInfoList[i].dishId].currentState !=
                  null)
            keymap[caidanitems.data.foodInfoList[i].dishId]
                .currentState
                .onPressed(
                    caidanitems.data.foodInfoList[i].dingnumber.toString());
        }
      }
    }
  }

  Widget _caiDanlistView(setBottomSheetState) {
    if (caidanitems != null) {
      return Container(
          height: (ScreenUtil().setSp(caidanitems.data.foodInfoList.length*160.0))<ScreenUtil().setSp(650.0)?(ScreenUtil().setSp(caidanitems.data.foodInfoList.length*160.0)):ScreenUtil().setSp(650.0),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: caidanitems.data.foodInfoList.length,
            itemBuilder: (context, index) {
              var descIndex = caidanitems.data.foodInfoList.length - 1 - index;
              final item = caidanitems.data.foodInfoList[descIndex].dishName +
                  '$descIndex';
              return Column(children: <Widget>[
                Container(
                  height: ScreenUtil().setSp(160.0),
                  child: Row(
                    children: <Widget>[
                      _foodsImage(caidanitems.data.foodInfoList, descIndex),
                      Column(children: <Widget>[
                        _foodsName(caidanitems.data.foodInfoList, descIndex),
                        _foodSum(caidanitems.data.foodInfoList, descIndex),
                      ]),
                      Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                      selectNumPage(setBottomSheetState, descIndex)
                    ],
                  ),
                ),
                Divider(
                  height: 2.0,
                  indent: 0.0,
                  color: Colors.red,
                ),
              ]);
            },
          ));
    } else {
      return Text('暂时没有数据');
    }
  }

  Row selectMainNumPage(newList, index, textKey) {
    return Row(
      children: <Widget>[
        new GestureDetector(
          child: Container(
            child: Image.asset(
              "assets/images/btn_qiyongcp_selected.png",
              width: ScreenUtil().setSp(72),
            ),
          ),
          //不写的话点击起来不流畅
          onTap: () {
            if (dishsize > 0) {
              showMessage(context, "订单已提交，不可修改");
              return;
            }
            String caipin = newList[index].dishName;
            for (int i = 0; i < caidanitems.data.foodInfoList.length; i++) {
              if (caidanitems.data.foodInfoList[i].dishName == caipin &&
                  caidanitems.data.foodInfoList[i].dingnumber > 0) {
                caidanitems.data.foodInfoList[i].dingnumber =
                    caidanitems.data.foodInfoList[i].dingnumber - 1;
                if (caidanitems.data.foodInfoList[i].dingnumber == 0) {
                  caidanitems.data.foodInfoList.removeAt(i);
                }
              }
            }
            refreshmap();
            textKey.currentState.onPressed(menuNum(newList, index));
            textsumKey.currentState.onPressed(getSum());
            sumtext = getSum();
          },
        ),
        Padding(
          padding: EdgeInsets.all(ScreenUtil().setSp(14)),
          child: Align(
            child: TextWidgetDish(textKey, menuNum(newList, index),
                newList[index].dishId), //需要更新的Text,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, ScreenUtil().setSp(14), 0),
          child: new GestureDetector(
            child: Container(
              child: Image.asset(
                "assets/images/btn_add_selected.png",
                width: ScreenUtil().setSp(72),
              ),
            ),
            onTap: () {
              addMenu(newList, index, textKey);
            },
          ),
        )
      ],
    );
  }

  Row selectNumPage(setBottomSheetState, descIndex) {
    return Row(
      children: <Widget>[
        new GestureDetector(
          child: Container(
            child: Image.asset(
              "assets/images/btn_qiyongcp_selected.png",
              width: ScreenUtil().setSp(72),
            ),
          ),
          //不写的话点击起来不流畅
          onTap: () {
            if (dishsize > 0) {
              showMessage(context, "订单已提交，不可修改");
              return;
            }
            int dishId = caidanitems.data.foodInfoList[descIndex].dishId;
            setBottomSheetState(() {
              caidanitems.data.foodInfoList[descIndex].dingnumber--;
              if (caidanitems.data.foodInfoList[descIndex].dingnumber == 0) {
                if (keymap[dishId] != null &&
                    keymap[dishId].currentState != null)
                  keymap[dishId].currentState.onPressed("0");
                textsumKey.currentState.onPressed(getSum());
                sumtext = getSum();
                caidanitems.data.foodInfoList.removeAt(descIndex);
                refreshmap();
                return;
              }
              if (keymap[dishId] != null && keymap[dishId].currentState != null)
                keymap[dishId].currentState.onPressed(
                    menuNum(caidanitems.data.foodInfoList, descIndex));
              textsumKey.currentState.onPressed(getSum());
              sumtext = getSum();
              refreshmap();
            });
          },
        ),
        Padding(
          padding: EdgeInsets.all(ScreenUtil().setSp(14)),
          child: Align(
            child: Text(
              caidanitems.data.foodInfoList[descIndex].dingnumber.toString(),
              style: TextStyle(
                  color: Color(0xff333333), fontSize: ScreenUtil().setSp(20)),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, ScreenUtil().setSp(14), 0),
          child: new GestureDetector(
            child: Container(
              child: Image.asset(
                "assets/images/btn_add_selected.png",
                width: ScreenUtil().setSp(72),
              ),
            ),
            onTap: () {
              if (dishsize > 0) {
                showMessage(context, "订单已提交，不可修改");
                return;
              }
              int dishId = caidanitems.data.foodInfoList[descIndex].dishId;
              setBottomSheetState(() {
                if (caidanitems.data.foodInfoList[descIndex].dingnumber >=
                    9999) {
                  return;
                }
                caidanitems.data.foodInfoList[descIndex].dingnumber++;
              });
              if (keymap[dishId] != null && keymap[dishId].currentState != null)
                keymap[dishId].currentState.onPressed(
                    menuNum(caidanitems.data.foodInfoList, descIndex));
              textsumKey.currentState.onPressed(getSum());
              sumtext = getSum();
              refreshmap();
            },
          ),
        )
      ],
    );
  }

  Widget _buttonsWidget(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Badge(
                    showBadge: true,
                    position: BadgePosition.topRight(
                        top: -12, right: ScreenUtil().setSp(0)),
                    badgeColor: Colors.red,
                    badgeContent: TextWidget(textsumKey, sumtext),
                    animationType: BadgeAnimationType.slide,
                    child: Container(
                      height: ScreenUtil().setSp(80.0),
                      width: ScreenUtil().setSp(200.0),
                      child: RaisedButton(
                        onPressed: () {
                          _showModalBottomSheet(context);
                        },
                        //tooltip: '详情',
                        child: caidanitems == null
                            ? Text('详情')
                            : caidanitems.data == null
                                ? Text('详情')
                                : Text('详情'),
                        /* Text('详情(' + (getSum()) + ")")*/

                        color: Colors.orange,
                        shape: StadiumBorder(),
                      ),
                    )),
              ),
              Provide.value<MenuDataProvide>(context).dingCanState<4||Provide.value<MenuDataProvide>(context).dingCanState==5||Provide.value<MenuDataProvide>(context).dingCanState==7||dingdanID == canteenID?
              Container(
                      height: ScreenUtil().setSp(80.0),
                      width: ScreenUtil().setSp(200.0),
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      child: RaisedButton(
                        onPressed: () async {
                          if(caidanitems == null||caidanitems.data == null||caidanitems.data.foodInfoList.length==0)
                            {
                              showMessage(context, "您还未选择菜品");
                              return;
                            }
                          if(lastPopTime == null || DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
                            lastPopTime = DateTime.now();
                            var ret=await _foodMenuRelease();
                            if(ret=="ok")
                            {
                              await getDingCanFoodsMenu();
                              setState(() {
                                dishsize = 1;
                                showMessage(context, "确认订单成功");
                              });
                            }
                          }else{
                            lastPopTime = DateTime.now();
                            showMessage(context,"请勿重复点击！");
                            return;
                          }
                        },
                        child:  Text('确定订单'),
                        color: Colors.orange,
                        shape: StadiumBorder(),
                      )):Container(),
              Provide.value<MenuDataProvide>(context).dingCanState==4||dingdanID == canteenID?Container(
                  height: ScreenUtil().setSp(80.0),
                  width: ScreenUtil().setSp(200.0),
                  margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                  child: RaisedButton(
                    onPressed: () async {
                      if(caidanitems == null||caidanitems.data == null||caidanitems.data.foodInfoList.length==0)
                      {
                        showMessage(context,"您还未选择菜品");
                        return;
                      }

                      if(lastPopTime == null || DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
                        lastPopTime = DateTime.now();
                        String result=await closeDialog(context);
                        if(result=='cancel')
                        {
                          return;
                        }
                        var ret=await _foodCloseMenuRelease();
                        if(ret=="ok") {
                          await getDingCanFoodsMenu();
                          setState(() {
                            if (Provide
                                .value<MenuDataProvide>(context)
                                .dingdanmenudata !=
                                null &&
                                Provide
                                    .value<MenuDataProvide>(context)
                                    .dingdanmenudata
                                    .data !=
                                    null)
                              dishsize = Provide
                                  .value<MenuDataProvide>(context)
                                  .dingdanmenudata
                                  .data
                                  .foodInfoList
                                  .length;
                            caidanitems =
                                Provide
                                    .value<MenuDataProvide>(context)
                                    .dingdanmenudata;
                            textsumKey.currentState.onPressed(getSum());
                            sumtext = getSum();
                            showMessage(context, "取消订单成功");
                            setState(() {
                              dishsize = 0;
                            });
                          });
                        }
                      }else{
                        lastPopTime = DateTime.now();
                        showMessage(context,"请勿重复点击！");
                        return;
                      }

                    },
                    child: Text('取消订单'),
                    color: Colors.orange,
                    shape: StadiumBorder(),
                  )):Container()
            ]));
  }

  String getSum() {
    int sum = 0;
    if (caidanitems != null &&
        caidanitems.data != null &&
        caidanitems.data.foodInfoList != null) {
      for (var i = 0; i < caidanitems.data.foodInfoList.length; i++) {
        sum = sum + caidanitems.data.foodInfoList[i].dingnumber;
      }
    }
    return sum.toString();
  }

  _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context1, setBottomSheetState) {
            return Container(
                height: ScreenUtil().setSp(800),
                child: Column(
                  children: <Widget>[
                    gobackButton(context1),
                    _caiDanlistView(setBottomSheetState),
                    totalNumAndPrice()
                  ],
                ));
          },
        );
      },
    );
  }

  Container orderContentPage(BuildContext context) {
    return Container(
      width: ScreenUtil().setSp(680),
      child: Row(
        children: <Widget>[
          LeftCategoryNav(),
          Column(
            children: <Widget>[
              //gobackButton(context),
              Container(
                width: ScreenUtil().setSp(500),
                child: RightCategoryNav(),
              ),
              dishsList(),
            ],
          )
        ],
      ),
      height: MediaQuery.of(context).size.height * 0.65 ,
    );
  }

  Widget dishsList() {
    return Provide<CategoryFoodsListProvide>(
      builder: (context, child, data) {
        try {
          if (Provide.value<ChildCategory>(context).page == 1) {
            if (scrollController.hasClients) {
              scrollController.animateTo(
                0.0,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300),
              );
            }
          }
        } catch (e) {
          print('进入页面第一次初始化：${e}');
        }

        if (data.foodsList != null) {
          return Expanded(
            child: Container(
                width: ScreenUtil().setSp(530),
                child: EasyRefresh(
                  refreshFooter: ClassicsFooter(
                      key: _footerKey,
                      bgColor: Colors.white,
                      textColor: Colors.pink,
                      moreInfoColor: Colors.pink,
                      showMore: true,
                      noMoreText:
                          Provide.value<ChildCategory>(context).noMoreText,
                      moreInfo: '加载中',
                      loadReadyText: '上拉加载'),
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: data.foodsList.length,
                    itemBuilder: (context, index) {
                      return _ListWidget(data.foodsList, index);
                    },
                  ),
                  loadMore: () async {
                    if (Provide.value<ChildCategory>(context).noMoreText ==
                        '没有更多了') {
                      showMessage(context, "已经到底了");
                    } else {
                      // _getMoreList();
                    }
                  },
                )),
          );
        } else {
          return Text('暂时没有数据');
        }
      },
    );
  }

  Widget _ListWidget(List newList, int index) {
    GlobalKey<_TextWidgetDishState> textKey = GlobalKey();
    keymap.remove(newList[index].dishId);
    keymap.putIfAbsent(newList[index].dishId, () => textKey);
    return Container(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 1.0, color: Colors.black12))),
      child: Row(
        children: <Widget>[
          Expanded(
            child: newList[index].dishPhoto[0]!=staticimageurl?_foodsImage(newList,index):_nullImage(),
          ),
          Expanded(
            child: _foodsName(newList, index),
          ),
          selectMainNumPage(newList, index, keymap[newList[index].dishId])
        ],
      ),
    );
  }

  //没有图片
  Widget _nullImage(){
    return Container(
        width: ScreenUtil().setSp(200),
        child: Column(
          children: <Widget>[
            Icon(Icons.image,color: Colors.black26,size: ScreenUtil().setSp(80),),
            Container(
              child: Text("暂无图片",style: TextStyle(color:Colors.black26,fontWeight:FontWeight.w500,fontSize: ScreenUtil().setSp(28)),),
              height: ScreenUtil().setSp(40),
            )
          ],
        )
    );
  }

  String menuNum(List newList, int index) {
    if (newList.length == 0) return "0";
    String caipin = newList[index].dishName;
    if (caidanitems != null &&
        caidanitems.data != null &&
        caidanitems.data.foodInfoList != null) {
      for (int i = 0; i < caidanitems.data.foodInfoList.length; i++) {
        if (caidanitems.data.foodInfoList[i].dishName == caipin) {
          return caidanitems.data.foodInfoList[i].dingnumber.toString();
        }
      }
    }
    return "0";
  }

  /**
   * 添加菜单
   */
  void addMenu(List newList, int index, textKey) {
    if (dishsize > 0) {
      showMessage(context, "订单已提交，不可修改");
      return;
    }
    String caipin = newList[index].dishName;
    bool iscontain = false;
    if (caidanitems != null && caidanitems.data != null) {
      for (int i = 0; i < caidanitems.data.foodInfoList.length; i++) {
        if (caidanitems.data.foodInfoList[i].dishName == caipin) {
          iscontain = true;
          caidanitems.data.foodInfoList[i].dingnumber =
              caidanitems.data.foodInfoList[i].dingnumber + 1;
          break;
        }
      }
    }
    if (!iscontain) {
      CategoryFoodsListModelDataFoodInfoList menuItem =
          new CategoryFoodsListModelDataFoodInfoList(
              dishPhoto: newList[index].dishPhoto,
              dishPrice: newList[index].dishPrice,
              dishScore: newList[index].dishScore,
              dishName: newList[index].dishName,
              dishId: newList[index].dishId,
              dingnumber: 0);
      if (caidanitems == null || caidanitems.data == null) {
        List<CategoryFoodsListModelDataFoodInfoList> foodInfoListtemp = List();
        menuItem.dingnumber = menuItem.dingnumber + 1;
        foodInfoListtemp.add(menuItem);
        CategoryFoodsListModelData tempdata =
            new CategoryFoodsListModelData(foodInfoList: foodInfoListtemp);
        CategoryFoodsListModel tempitems = new CategoryFoodsListModel(
            code: "0", message: "success", data: tempdata);
        caidanitems = tempitems;
      } else {
        menuItem.dingnumber = menuItem.dingnumber + 1;
        caidanitems.data.foodInfoList.add(menuItem);
      }
    }
    textKey.currentState.onPressed(menuNum(newList, index));
    sumtext = getSum();
    refreshmap();
    textsumKey.currentState.onPressed(getSum());
  }

  //商品图片
  Widget _foodsImage(List newList, int index) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PhotoViewSimpleScreen(
                        imageProvider:
                            NetworkImage(newList[index].dishPhoto[0]),
                        heroTag: "",
                      )));
          //Appliaction.router.navigateTo(context,"/detail?id=${newList[index].dishId}");
        },
        child: Container(
            width: ScreenUtil().setSp(200),
            child: Image.network(
              newList[index].dishPhoto[0],
              height: ScreenUtil().setSp(140), //设置高度
              width: ScreenUtil().setSp(210), //设置宽度
              fit: BoxFit.fill, //填充
              gaplessPlayback: true, //防止重绘),
            )));
  }

  //商品名称和价格方法
  Widget _foodsName(List newList, int index) {
    return Container(
        padding: EdgeInsets.all(1.0),
        width: ScreenUtil().setSp(350),
        child: Column(children: <Widget>[
          Text(
            newList[index].dishName,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: ScreenUtil().setSp(28)),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "单价：",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(23), color: Colors.black),
                ),
                Text(
                  newList[index].dishPrice.toString(),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(23), color: Colors.red),
                ),
              ])
        ]));
  }

  //单项菜品小计
  Widget _foodSum(List newList, int index) {
    return Container(
        padding: EdgeInsets.all(1.0),
        width: ScreenUtil().setSp(350),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "小计：",
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(23), color: Colors.black),
              ),
              Text(
                (newList[index].dishPrice * newList[index].dingnumber)
                    .toStringAsFixed(2),
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(23), color: Colors.red),
              )
            ]));
  }

  String getTotalNumOrPrice(String flag) {
    int quantity = 0;
    double price = 0.0;
    if (caidanitems != null && caidanitems.data != null) {
      for (int i = 0; i < caidanitems.data.foodInfoList.length; i++) {
        quantity = quantity + caidanitems.data.foodInfoList[i].dingnumber;
        price = price +
            caidanitems.data.foodInfoList[i].dingnumber *
                caidanitems.data.foodInfoList[i].dishPrice;
      }
    }
    if (flag == "num")
      return quantity.toString();
    else if (flag == "price") return price.toStringAsFixed(2);
  }

  //滑动listview会导致textwidget刷新，数据初始为0，用map保存状态
  void refreshmap() {
    int count = 0;
    mapdishnum.forEach((k, v) {
      mapdishnum[k] = 0;
      count = count + 1;
      print(count.toString());
    });
    if (caidanitems == null ||
        caidanitems.data == null ||
        caidanitems.data.foodInfoList.length == 0) {
      print("caidanitems nulll");
      return;
    }
    for (int i = 0; i < caidanitems.data.foodInfoList.length; i++) {
      mapdishnum.remove(caidanitems.data.foodInfoList[i].dishId);
      mapdishnum.putIfAbsent(caidanitems.data.foodInfoList[i].dishId,
          () => caidanitems.data.foodInfoList[i].dingnumber);
    }
  }

  Widget totalNumAndPrice() {
    return Column(children: <Widget>[
      Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              '菜品数量： ',
              maxLines: 1,
              style: TextStyle(
                color: Color(0xFF6D7278),
                fontSize: 15.0,
                height: 1.2,
                decoration: TextDecoration.none,
                decorationStyle: TextDecorationStyle.dashed,
              ),
            ),
            Text(
              getTotalNumOrPrice("num"),
              maxLines: 1,
              style: TextStyle(
                color: Color(0xFFEC3939),
                fontSize: 15.0,
                height: 1.2,
                decoration: TextDecoration.none,
                decorationStyle: TextDecorationStyle.dashed,
              ),
            ),
          ],
        ),
      ),
      Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              '价格总计:  ',
              maxLines: 1,
              style: TextStyle(
                color: Color(0xFF6D7278),
                fontSize: 15.0,
                height: 1.2,
                decoration: TextDecoration.none,
                decorationStyle: TextDecorationStyle.dashed,
              ),
            ),
            Text(
              getTotalNumOrPrice("price") + "元",
              maxLines: 1,
              style: TextStyle(
                color: Color(0xFFEC3939),
                fontSize: 15.0,
                height: 1.2,
                decoration: TextDecoration.none,
                decorationStyle: TextDecorationStyle.dashed,
              ),
            ),
          ],
        ),
      )
    ]);
  }

  Widget gobackButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
          padding: EdgeInsets.all(5.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(""),
              ),
              Text("<<返回",
                  style: TextStyle(color: Theme.of(context).primaryColor)),
            ],
          )),
    );
  }

  //获取订单信息
  Future getDingCanFoodsMenu() async {
    await Provide.value<MenuDataProvide>(context).getDingCanMenuFoodsInfo(
      userID,
      _chooseDate.toString(),
      groupValue - 1,
        int.parse(canteenID)

    );
  }

  //取消订餐
  Future _foodCloseMenuRelease() async {
    int quantity = 0;
    double price = 0;
    int state = 4; //订餐标志 4
    List<Map> dish_id = new List();
    quantity=dingpersonnum;//就餐人数
    for (int i = 0; i < caidanitems.data.foodInfoList.length; i++) {
      Map data = {
        "dish_id": caidanitems.data.foodInfoList[i].dishId,
        "amount": caidanitems.data.foodInfoList[i].dingnumber,
        "price": caidanitems.data.foodInfoList[i].dishPrice
      };
      // quantity = quantity + caidanitems.data.foodInfoList[i].dingnumber;
      price = price +
          caidanitems.data.foodInfoList[i].dingnumber *
              caidanitems.data.foodInfoList[i].dishPrice;
      dish_id.add(data);
    }
    await Provide.value<FoodMenuReleaseProvide>(context).postDingCanMenuInfo(
        groupValue - 1,
        int.parse(userID),
        quantity,
        5,
        0,
        _chooseDate.toString(),
        dish_id);
    if(Provide.value<FoodMenuReleaseProvide>(context).orderStateback.message!='success'){
      showMessage(context, Provide.value<FoodMenuReleaseProvide>(context).orderStateback.message);
    }
    if(Provide.value<FoodMenuReleaseProvide>(context).orderStateback.code=="0")
    return 'ok';
  }

  //发布订餐
  Future _foodMenuRelease() async {
    int quantity = 0;
    double price = 0;
    int state = 4; //订餐标志 4
    List<Map> dish_id = new List();
    quantity=dingpersonnum;//就餐人数
    for (int i = 0; i < caidanitems.data.foodInfoList.length; i++) {
      Map data = {
        "dish_id": caidanitems.data.foodInfoList[i].dishId,
        "amount": caidanitems.data.foodInfoList[i].dingnumber,
        "price": caidanitems.data.foodInfoList[i].dishPrice
      };
     // quantity = quantity + caidanitems.data.foodInfoList[i].dingnumber;
      price = price +
          caidanitems.data.foodInfoList[i].dingnumber *
              caidanitems.data.foodInfoList[i].dishPrice;
      dish_id.add(data);
    }
    await Provide.value<FoodMenuReleaseProvide>(context).postDingCanMenuInfo(
        groupValue - 1,
        int.parse(userID),
        quantity,
        state,
        price,
        _chooseDate.toString(),
        dish_id);
    if(Provide.value<FoodMenuReleaseProvide>(context).orderStateback.message!='success'){
      showMessage(context, Provide.value<FoodMenuReleaseProvide>(context).orderStateback.message);
    }
    if(Provide.value<FoodMenuReleaseProvide>(context).orderStateback.code=="0")
      return 'ok';
  }
}

//封装的widget
class TextWidget extends StatefulWidget {
  Key key;
  String textfirst;

  TextWidget(this.key, this.textfirst);

  @override
  _TextWidgetState createState() => _TextWidgetState(this.key, this.textfirst);
}

class _TextWidgetState extends State<TextWidget> {
  String text = "0";

  Key key;
  String textfirst;
  bool isfirst = true;

  _TextWidgetState(this.key, this.textfirst);

  void onPressed(String count) {
    setState(() {
      text = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isfirst) {
      isfirst = false;
      return new Text(textfirst);
    }
    return new Text(text);
  }
}

//封装的widget
class TextWidgetDish extends StatefulWidget {
  Key key;
  String textfirst;
  int dishid;

  TextWidgetDish(this.key, this.textfirst, this.dishid);

  @override
  _TextWidgetDishState createState() =>
      _TextWidgetDishState(this.key, this.textfirst, this.dishid);
}

class _TextWidgetDishState extends State<TextWidgetDish> {
  String text = "0";

  Key key;
  String textfirst;
  bool isfirst = true;
  int dishid;

  _TextWidgetDishState(this.key, this.textfirst, this.dishid);

  void onPressed(String count) {
    setState(() {
      text = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isfirst) {
      isfirst = false;
      return new Text(mapdishnum.containsKey(dishid)
          ? mapdishnum[dishid].toString()
          : textfirst);
    }
    return new Text(text);
  }
}
