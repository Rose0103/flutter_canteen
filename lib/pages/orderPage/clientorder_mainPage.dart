import 'dart:convert';

import 'package:flutter_canteen/model/jsonModel.dart';
import 'package:flutter_canteen/otherfunction/RatingBar.dart';
import 'package:flutter_canteen/pages/foodManage/menuDataListTwo.dart';
import 'package:flutter_canteen/provide/menu_data.dart';
import 'package:flutter_canteen/router/application.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provide/provide.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter/material.dart';
import 'package:flutter_canteen/pages/foodManage/menuDataList.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_canteen/provide/orderstate.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../common/shared_preference.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_canteen/otherfunction/showDialog.dart';
import 'dart:async';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_canteen/model/baoCanPriceModel.dart';
import 'package:flutter_canteen/model/deadlinemodel.dart';

//报餐点餐
class ClientOrderPage extends StatefulWidget {
  final String functionID;

  ClientOrderPage(this.functionID);

  @override
  _ClientOrderPageState createState() => _ClientOrderPageState();
}

class _ClientOrderPageState extends State<ClientOrderPage> {
  int groupValue = 1;
  @override
  var _chooseDate = DateTime.now().toString().split(" ")[0];

  var _currentDate = DateTime.now();
  int status = 0;
  int laststatus = 0;

  int mealtype = 0;
  String mealID = "";

  int buttonSize = 120;
  int initcount = 0;
  int num = 1;
  int lastnum = 0;
  double money = 10;
  int baocanFlag = -1;
  DateTime lastPopTime = null;

  Timer _timer;
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();
  var scrollController = new ScrollController();
  JsonModel jsonModel = new JsonModel();

  void initState() {
    super.initState();
    if (_currentDate.hour >= 0 && _currentDate.hour < 8) {
      groupValue = 1;
      mealtype = 0;
    } else if (_currentDate.hour >= 8 && _currentDate.hour < 12) {
      groupValue = 2;
      mealtype = 1;
    } else if (_currentDate.hour >= 12 && _currentDate.hour < 19) {
      groupValue = 3;
      mealtype = 2;
    } else {
      groupValue = 1;
      mealtype = 0;
    }
    mealtype == 0
        ? money = num * double.parse(breakfastprice)
        : mealtype == 1
            ? money = num * double.parse(lunchprice)
            : money = num * double.parse(superprice);
    currentprice = money;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initValue();
      initcount = initcount + 1;
      updateGroupValue(_currentDate.toString().split(" ")[0], groupValue);
      jsonModel.user_id = userID;
      jsonModel.time = _chooseDate;
      jsonModel.num = num;
      jsonModel.meal_type = (groupValue - 1).toString();
      jsonModel.organize_Id = organizeid.toString();
      jsonModel.root_organize_Id = rootOrgid.toString();
    });
    //定时任务
    _timer = Timer.periodic(const Duration(milliseconds: 2000), (Void) {
      if (currentdate == _chooseDate.toString() &&
          currentmealtype == mealtype &&
          laststatus != currentstatus) {
        laststatus = currentstatus;
        setState(() {
          status = laststatus;
          num = currentnum;
          jsonModel.num = num;
          money = currentprice;
          status == 0 ? buttonSize = 120 : buttonSize = 120;
        });
      }
    });
  }

  void initValue() async {
    jsonModel.time = _chooseDate;
    jsonModel.meal_type = (groupValue - 1).toString();
    Provide.value<GetOrderStatusProvide>(context).orderstatudata = null;
    await _getorderStatus(_chooseDate.toString());
    if (baocanFlag == -1) {
      setState(() {
        mealID = "";
        status = 0;
        num = 1;
        mealtype == 0
            ? money = num * double.parse(breakfastprice)
            : mealtype == 1
                ? money = num * double.parse(lunchprice)
                : money = num * double.parse(superprice);
        laststatus = 0;
        buttonSize = 120;
        jsonModel.num = num;
        print(22222222222);
      });
    } else {
      setState(() {
        if (Provide.value<GetOrderStatusProvide>(context).orderstatudata !=
                null &&
            Provide.value<GetOrderStatusProvide>(context)
                    .orderstatudata
                    .data
                    .length !=
                0 &&
            Provide.value<GetOrderStatusProvide>(context).orderstatudata.data !=
                null &&
            Provide.value<GetOrderStatusProvide>(context)
                    .orderstatudata
                    .data[baocanFlag]
                    .state !=
                null) {
          status = Provide.value<GetOrderStatusProvide>(context)
              .orderstatudata
              .data[baocanFlag]
              .state;
          mealID = Provide.value<GetOrderStatusProvide>(context)
              .orderstatudata
              .data[baocanFlag]
              .mealstatId
              .toString();
          buttonSize = 120;
        }
      });
    }
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
        jsonModel.time = _chooseDate;
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
      updateGroupValue(_currentDate.toString().split(" ")[0], groupValue);
      setState(() {
        this._chooseDate = _currentDate.toString().split(" ")[0];
        jsonModel.time = _chooseDate;
      });
    }
  }

  void _theDayAfter() {
    var _tempDate = _currentDate;
    print("houyitian");
    _tempDate = _tempDate.add(new Duration(days: 1));
    print(_tempDate.toString());
    if ((_tempDate.isAfter(DateTime.now().add(new Duration(days: -1))) ||
            _tempDate.isAtSameMomentAs(
                DateTime.now().add(new Duration(days: -1)))) &&
        (_tempDate.isBefore(DateTime.now().add(new Duration(days: 14))) ||
            _tempDate.isAtSameMomentAs(
                DateTime.now().add(new Duration(days: -1))))) {
      print("aaaaaaaaaaaaaa");
      _currentDate = _tempDate;
      updateGroupValue(_currentDate.toString().split(" ")[0], groupValue);
      setState(() {
        this._chooseDate = _currentDate.toString().split(" ")[0];
        jsonModel.time = _chooseDate;
      });
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
        child: Text(
          "< 前一天",
          style: TextStyle(color: Color(0xFF777777)),
        ),
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
        child: Text(
          "后一天 >",
          style: TextStyle(color: Color(0xFF777777)),
        ),
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
        child: Text(
          _chooseDate.toString(),
          style: TextStyle(color: Color(0xFF777777)),
        ),
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
                  activeColor: Color(0xFF777777),
                  value: 1,
                  groupValue: groupValue,
                  title: Text(
                    '早餐',
                    style: TextStyle(color: Color(0xFF777777)),
                  ),
                  onChanged: (T) {
                    //控制初始化的时候只调用一次查询状态接口
                    initcount = initcount + 1;
                    print("initcount$initcount");
                    if (initcount > 2)
                      updateGroupValue(
                          _currentDate.toString().split(" ")[0], T);
                  })),
          Expanded(
              child: RadioListTile(
                  activeColor: Color(0xFF777777),
                  value: 2,
                  groupValue: groupValue,
                  title: Text(
                    '中餐',
                    style: TextStyle(color: Color(0xFF777777)),
                  ),
                  onChanged: (T) {
                    //控制初始化的时候只调用一次查询状态接口
                    initcount = initcount + 1;
                    print("initcount$initcount");
                    if (initcount > 2)
                      updateGroupValue(
                          _currentDate.toString().split(" ")[0], T);
                  })),
          Expanded(
              child: RadioListTile(
                  activeColor: Color(0xFF777777),
                  value: 3,
                  groupValue: groupValue,
                  title: Text(
                    '晚餐',
                    style: TextStyle(color: Color(0xFF777777)),
                  ),
                  onChanged: (T) {
                    //控制初始化的时候只调用一次查询状态接口
                    initcount = initcount + 1;
                    print("initcount$initcount");
                    if (initcount > 2)
                      updateGroupValue(
                          _currentDate.toString().split(" ")[0], T);
                  })),
        ],
      ),
    );
  }

  updateGroupValue(String time, int v) async {
    //控制初始化的时候只调用一次查询状态接口
    initcount = initcount + 1;
    print(initcount);
    if (initcount < 3) return;
    mealtype = v - 1;
    await _getorderStatus(time);
    setState(() {
      groupValue = v;
      jsonModel.time = _chooseDate;
      jsonModel.meal_type = (groupValue - 1).toString();
      mealtype == 0
          ? money = num * double.parse(breakfastprice)
          : mealtype == 1
              ? money = num * double.parse(lunchprice)
              : money = num * double.parse(superprice);
      print(v);
    });
  }

  ///数量按钮
  Widget btn() {
    return Container(
      margin: EdgeInsets.fromLTRB(
          ScreenUtil().setSp(6), 0.0, ScreenUtil().setSp(6), 0.0),
      padding: EdgeInsets.fromLTRB(
          0, ScreenUtil().setSp(14), 0, ScreenUtil().setSp(14)),
      width: double.infinity,
      alignment: Alignment.bottomRight,
      decoration: new BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Color(0x33333333)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(ScreenUtil().setSp(15)),
            child: Align(
              child: Text(
                '用餐人数',
                style: TextStyle(
                    color: Color(0xff333333), fontSize: ScreenUtil().setSp(30)),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              new GestureDetector(
                child: Container(
                  child: Image.asset(
                    "assets/images/btn_qiyongcp_selected.png",
                    width: ScreenUtil().setSp(80),
                  ),
                ),
                //不写的话点击起来不流畅
                onTap: () {
                  if (!deadlineTips()) return;
                  setState(() {
                    if (num <= 1) {
                      return;
                    }
                    num--;
                    mealtype == 0
                        ? money = num * double.parse(breakfastprice)
                        : mealtype == 1
                            ? money = num * double.parse(lunchprice)
                            : money = num * double.parse(superprice);
                    jsonModel.num = num;
                  });
                },
              ),
              Padding(
                padding: EdgeInsets.all(ScreenUtil().setSp(15)),
                child: Align(
                  child: Text(
                    '$num',
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: ScreenUtil().setSp(30)),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, ScreenUtil().setSp(14), 0),
                child: new GestureDetector(
                  child: Container(
                    child: Image.asset(
                      "assets/images/btn_add_selected.png",
                      width: ScreenUtil().setSp(80),
                    ),
                  ),
                  onTap: () {
                    if (!deadlineTips()) return;
                    setState(() {
                      if (num >= 9999) {
                        return;
                      }
                      if (num >= 1 && !switchIfBringOthersWithPost) {
                        showMessage(context, "食堂未开启多人报餐权限，不能选择多人");
                        return;
                      }
                      num++;
                      mealtype == 0
                          ? money = num * double.parse(breakfastprice)
                          : mealtype == 1
                              ? money = num * double.parse(lunchprice)
                              : money = num * double.parse(superprice);
                      jsonModel.num = num;
                    });
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget moneywidget() {
    return Container(
      margin: EdgeInsets.fromLTRB(ScreenUtil().setSp(6), ScreenUtil().setSp(16),
          ScreenUtil().setSp(6), 0.0),
      padding: EdgeInsets.fromLTRB(
          0, ScreenUtil().setSp(15), 0, ScreenUtil().setSp(15)),
      width: double.infinity,
      alignment: Alignment.bottomRight,
      decoration: new BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Color(0x33333333)),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(ScreenUtil().setSp(20)),
                    child: Align(
                      child: Text(
                        '价格',
                        style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: ScreenUtil().setSp(30)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(ScreenUtil().setSp(20)),
                    child: Align(
                      child: Text(
                        "¥$money",
                        style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: ScreenUtil().setSp(30)),
                      ),
                    ),
                  ),
                ]),
            Padding(
              padding: EdgeInsets.all(ScreenUtil().setSp(20)),
              child: Align(
                child: Text(
                  switchIftakeMoneyEaten ? "(扣款规则：就餐时扣款)" : "(扣款规则：报餐时扣款)",
                  style: TextStyle(
                      color: Color(0xff333333),
                      fontSize: ScreenUtil().setSp(30)),
                ),
              ),
            ),
          ]),
    );
  }

  _weekDay(DateTime date) {
    var weeks = date.weekday.toString();
    switch (weeks) {
      case "1":
        return "周一";
      case "2":
        return "周二";
      case "3":
        return "周三";
      case "4":
        return "周四";
      case "5":
        return "周五";
      case "6":
        return "周六";
      case "7":
        return "周日";
    }
  }

  bool deadlineTips() {
    //_getsystemconfig();
    //周六周日不开启报餐
    if (!switchIfenablesaturday && _weekDay(_currentDate) == "周六") {
      showMessage(context, "食堂未开启周六报餐权限");
      return false;
    }
    if (!switchIfenableSunday && _weekDay(_currentDate) == "周日") {
      showMessage(context, "食堂未开启周日报餐权限");
      return false;
    }
    //早中晚餐开启报餐
    if (!switchIfenableBreakfast && mealtype == 0) {
      showMessage(context, "食堂未开启早餐报餐权限");
      return false;
    }

    if (!switchIfenableLunch && mealtype == 1) {
      showMessage(context, "食堂未开启中餐报餐权限");
      return false;
    }

    if (!switchIfenableSuper && mealtype == 2) {
      showMessage(context, "食堂未开启晚餐报餐权限");
      return false;
    }
    int hour = DateTime.now().hour;
    int minute = DateTime.now().minute;
    int second = DateTime.now().second;
    if (DateTime.now().toString().split(" ")[0] == _chooseDate.toString()) {
      print("$breakfastdeadline,$mealtype,$hour,$minute");
      if (mealtype == 0 &&
          ((hour == int.parse(breakfastdeadline.split(":")[0]) &&
                  minute > int.parse(breakfastdeadline.split(":")[1])) ||
              (hour > int.parse(breakfastdeadline.split(":")[0])))) {
        showMessage(context, "已过早餐报餐截至时间$breakfastdeadline，\n不能报餐或修改");
        return false;
      }

      if (mealtype == 1 &&
          ((hour == int.parse(lunchdeadline.split(":")[0]) &&
                  minute > int.parse(lunchdeadline.split(":")[1])) ||
              (hour > int.parse(lunchdeadline.split(":")[0])))) {
        showMessage(context, "已过中餐报餐截至时间$lunchdeadline，\n不能报餐或修改");
        return false;
      }

      if (mealtype == 2 &&
          ((hour == int.parse(dinnerdeadline.split(":")[0]) &&
                  minute > int.parse(dinnerdeadline.split(":")[1])) ||
              (hour > int.parse(dinnerdeadline.split(":")[0])))) {
        showMessage(context, "已过晚餐报餐截至时间$dinnerdeadline，\n不能报餐或修改");

        return false;
      }
    }
    return true;
  }

  //报餐/留餐等按钮
  Widget choseButtonWidget(String imgName, String funcName) {
    return Container(
        width: 80,
        /*decoration: funcName.contains("已选择")?BoxDecoration(
          color: Colors.white30,
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
          border: Border.all(width: 2, color: Colors.black12),
        ):null,*/
        //padding:EdgeInsets.fromLTRB(ScreenUtil().setSp(10.0), 00.0, 00.0, 00.0),
        child: Column(children: <Widget>[
          IconButton(
              icon: Image.asset(imgName),
              //color: Colors.transparent,
              iconSize: ScreenUtil().setSp(120.0),
              onPressed: () async {
                if(dining_status == "1"){
                  return showMessage(context, "您已经在${dingingCanteenName}食堂用过餐了");
                }
                if (!deadlineTips()) return;
                if (funcName.contains("已选择") && num == lastnum) return;
                if (funcName.contains("已选择不报餐") && num == lastnum) return;
                if (lastPopTime == null ||
                    DateTime.now().difference(lastPopTime) >
                        Duration(seconds: 2)) {
                  lastPopTime = DateTime.now();
                  if (status != 0) {
                    int numtemp = num;
                    if ((funcName.contains("留餐") || funcName.contains("报餐")) &&
                        num == 0) {
                      numtemp = 1;
                    }
                    String tips = "更改报餐状态为:" +
                        (funcName.contains("留餐")
                            ? "留餐,用餐人数：$numtemp人?"
                            : funcName.contains("不报餐")
                                ? "不报餐"
                                : "报餐,用餐人数：$numtemp人?");
                    String result = await chooseDialog(context, tips);
                    if (result == 'cancel') {
                      setState(() {
                        buttonSize = 120;
                      });
                      return;
                    } else {
                      num = numtemp;
                      mealtype == 0
                          ? money = num * double.parse(breakfastprice)
                          : mealtype == 1
                              ? money = num * double.parse(lunchprice)
                              : money = num * double.parse(superprice);
                      jsonModel.num = num;
                    }
                  }
                  laststatus = status;
                  if (funcName == "报餐") status = 1;
                  if (funcName == "不报餐") status = 2;
                  if (funcName == "留餐") status = 3;
                  await _modifyorderStatus(status);
                  setState(() {
                    buttonSize = 120;
                  });
                } else {
                  lastPopTime = DateTime.now();
                  showMessage(context, "请勿重复点击！");
                  return;
                }
              }),
          Text(funcName,
              maxLines: 3,
              style: TextStyle(
                  color: funcName.contains("已选择")
                      ? Theme.of(context).primaryColor
                      : Colors.black54,
                  fontSize: funcName.contains("已选择")
                      ? ScreenUtil.getInstance().setSp(30)
                      : ScreenUtil.getInstance().setSp(25),
                  fontWeight: funcName.contains("已选择")
                      ? FontWeight.w700
                      : FontWeight.w200)),
        ]));
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
            '选时报餐',
            style: TextStyle(
                color: Colors.black,
                fontSize: ScreenUtil().setSp(40),
                fontWeight: FontWeight.w500),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Container(
            child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
              ScreenUtil().setSp(10), 2.0, ScreenUtil().setSp(10), 5.0),
          child: Column(
            children: <Widget>[
              timeChoseWidget(context),
              _mealTimeChoseWidget(),
              btn(),
              moneywidget(),
              selectMeal(),
              status == 2 || status == 0
                  ? Text("        您还未报餐\n无法生成就餐二维码")
                  : QrImageWidget(),
              //    MenuDataListTwo("1"),
            ],
          ),
        )));
  }

  Widget QrImageWidget() {
    return new Offstage(
      offstage: status == 2 || status == 0 ? true : false,
      child: QrImage(
        data: jsonEncode(jsonModel),
        version: QrVersions.auto,
        size: 200.0,
      ),
    );
  }

//  Widget _buildHeaderWidget(BuildContext context, int index) {
//    return Container(
//        child: SingleChildScrollView(
//      padding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 5.0),
//      child: Column(
//        children: <Widget>[
//          timeChoseWidget(context),
//          _mealTimeChoseWidget(),
//          btn(),
//          moneywidget(),
//          selectMeal(),
//        ],
//      ),
//    ));
//  }

  Padding selectMeal() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: status == 1
                ? choseButtonWidget(
                    "assets/images/btn_baocan_press.png", "已选择报餐")
                : choseButtonWidget(
                    "assets/images/btn_baocan_default.png", "报餐"),
          ),
          Expanded(
            flex: 1,
            child: status == 2
                ? choseButtonWidget(
                    "assets/images/btn_bubao_press.png", "已选择不报餐")
                : choseButtonWidget(
                    "assets/images/btn_bubao_default.png", "不报餐"),
          ),
          Expanded(
            flex: 1,
            child: status == 3
                ? choseButtonWidget(
                    "assets/images/btn_liucan_press.png", "已选择留餐")
                : choseButtonWidget(
                    "assets/images/btn_liucan_default.png", "留餐"),
          ),
        ],
      ),
    );
  }

  //查询报餐状态
  Future _getorderStatus(String time) async {
    await Provide.value<GetOrderStatusProvide>(context)
        .getOrderState(userID, time, mealtype);
    if (Provide.value<GetOrderStatusProvide>(context).orderstatudata == null ||
        Provide.value<GetOrderStatusProvide>(context)
                .orderstatudata
                .data
                .length ==
            0 ||
        Provide.value<GetOrderStatusProvide>(context).orderstatudata.code ==
            "2") {
      setState(() {
        mealID = "";
        status = 0;
        num = 1;
        mealtype == 0
            ? money = num * double.parse(breakfastprice)
            : mealtype == 1
                ? money = num * double.parse(lunchprice)
                : money = num * double.parse(superprice);
        laststatus = 0;
        buttonSize = 120;
        lastnum = num;
        jsonModel.num = num;
        print(111111111111);
      });
    } else {
      baocanFlag = -1;
      for (int i = 0;
          i <
              Provide.value<GetOrderStatusProvide>(context)
                  .orderstatudata
                  .data
                  .length;
          i++) {
        if (Provide.value<GetOrderStatusProvide>(context)
                .orderstatudata
                .data[i]
                .state <
            4) baocanFlag = i;
      }
      if (baocanFlag == -1) {
        setState(() {
          mealID = "";
          status = 0;
          num = 1;
          mealtype == 0
              ? money = num * double.parse(breakfastprice)
              : mealtype == 1
                  ? money = num * double.parse(lunchprice)
                  : money = num * double.parse(superprice);
          laststatus = 0;
          buttonSize = 120;
          lastnum = num;
          if (currentdate == _chooseDate.toString() &&
              currentmealtype == mealtype) {
            currentstatus = status;
            currentnum = num;
            currentprice = money;
          }
       });
        print(333333333333);
      } else {
        print("22222222222");
        setState(() {
          mealID = Provide.value<GetOrderStatusProvide>(context)
              .orderstatudata
              .data[baocanFlag]
              .mealstatId
              .toString();
          status = Provide.value<GetOrderStatusProvide>(context)
              .orderstatudata
              .data[baocanFlag]
              .state;
          laststatus = Provide.value<GetOrderStatusProvide>(context)
              .orderstatudata
              .data[baocanFlag]
              .state;
          num = Provide.value<GetOrderStatusProvide>(context)
              .orderstatudata
              .data[baocanFlag]
              .quantity;
          money = Provide.value<GetOrderStatusProvide>(context)
              .orderstatudata
              .data[baocanFlag]
              .price
              .toDouble();
          mealtype == 0
              ? money = num * double.parse(breakfastprice)
              : mealtype == 1
                  ? money = num * double.parse(lunchprice)
                  : money = num * double.parse(superprice);
          buttonSize = 120;
          lastnum = num;
          if (currentdate == _chooseDate.toString() &&
              currentmealtype == mealtype) {
            currentstatus = status;
            currentnum = num;
            currentprice = money;
          }
          jsonModel.num = num;
          print("status$status");
        });
      }
    }
    return '完成加载';
  }

  //修改报餐状态
  Future _modifyorderStatus(int state) async {
    print("444444455555555");
    int quality = num;
    double price = money;
    //不报餐数量和价格为0
    if (state == 2) {
      quality = 0;
      price = 0.0;
    }
    //就餐时扣款
    var pricetemp = price;
    if (switchIftakeMoneyEaten) pricetemp = 0.0;
    var formData = {
      'order_date': _chooseDate.toString(),
      'state': state,
      'meal_type': mealtype,
      'quantity': quality,
      'price': pricetemp,
      "canteen_id":canteenID,
      "ticket_num":0,
      "cost_type":0
    };

    print(formData);
    List data = new List();
    data.add(formData);

    await Provide.value<GetOrderStatusProvide>(context)
        .modifyOrderState(data);

    print("4444444");
    if (Provide.value<GetOrderStatusProvide>(context).orderStateback.code ==
        "0") {
      setState(() {
        if (currentdate == _chooseDate.toString() &&
            currentmealtype == mealtype) {
          currentstatus = state;
          currentnum = quality;
          currentprice = price;
          lastnum = num;
          print("333333333333");
        }
        buttonSize = 120;
      });
    } else {
      showMessage(context,
          Provide.value<GetOrderStatusProvide>(context).orderStateback.message);
      setState(() {
        status = laststatus;
        if (status == 0)
          buttonSize = 120;
        else
          buttonSize = 120;
      });
    }
    return '完成加载';
  }

  _getsystemconfig() async {
    await requestGet('getdeadline', '?canteen_id'+canteenID).then((val) {
      var data = val;
      print(data);
      GetdeadlineModel getdeadlineModel = GetdeadlineModel.fromJson(data);
      if (getdeadlineModel.code == "0") {
        breakfastdeadline = getdeadlineModel.data.breakfastDeadline;
        lunchdeadline = getdeadlineModel.data.lunchDeadline;
        dinnerdeadline = getdeadlineModel.data.dinnerDeadline;
      } else {
        print("获取报餐截止时间失败，启用默认值");
      }
    });

    await requestGet('systemconfig', '?config_desc=报餐&canteen_id=${canteenID}').then((val) {
      sysConfigModel getpriceModelData = sysConfigModel.fromJson(val);
      if (getpriceModelData.code == "0") {
        if(getpriceModelData.data==null||getpriceModelData.data.length==0){
          breakfastprice = '10.0';
          lunchprice = '20.0';
          superprice = '20.0';
          if(getpriceModelData.data.length!=0){
            for (int i = 0; i < getpriceModelData.data.length; i++) {
//              if(rootOrgid==organizeid){
                if (getpriceModelData.data[i].configKey == "0")
                  breakfastprice = getpriceModelData.data[i].configValue;
                if (getpriceModelData.data[i].configKey == "1")
                  lunchprice = getpriceModelData.data[i].configValue;
                if (getpriceModelData.data[i].configKey == "2")
                  superprice = getpriceModelData.data[i].configValue;
//              }else{
                if(getpriceModelData.data[i].configKey.contains('_')){
                  List str1 =  getpriceModelData.data[i].configKey.split('_');
                  if(str1[1]==organizeid.toString()){
                    if(str1[0] =="0"){
                      breakfastprice =getpriceModelData.data[i].configValue;
                    }
                    if(str1[0] =="1"){
                      lunchprice=getpriceModelData.data[i].configValue;
                    }
                    if(str1[0] =="2"){
                      superprice=getpriceModelData.data[i].configValue;
                    }
                  }
//                }
              }
            }
          }
        } else {
          breakfastprice = '10.0';
          lunchprice = '20.0';
          superprice = '20.0';
        }
      }
    });
    await requestGet('systemconfig', '?config_desc=moreconfig&canteen_id=${canteenID}').then((val) {
      sysConfigModel sysconfModelData = sysConfigModel.fromJson(val);
      if (sysconfModelData.code == "0") {
        if (sysconfModelData.data.length == 0) {
          return;
        } else {
          for (int i = 0; i < sysconfModelData.data.length; i++) {
            //不报餐是否允许吃饭
            if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "noposted_permit") {
              sysconfModelData.data[i].configValue.trim() == "1"
                  ? switchIfnopostEaten = true
                  : switchIfnopostEaten = false;
            } else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifenablesaturday") {
              sysconfModelData.data[i].configValue.trim() == "1"
                  ? switchIfenablesaturday = true
                  : switchIfenablesaturday = false;
            } else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifenablesunday") {
              sysconfModelData.data[i].configValue.trim() == "1"
                  ? switchIfenableSunday = true
                  : switchIfenableSunday = false;
            } else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifenablebreakfast") {
              sysconfModelData.data[i].configValue.trim() == "1"
                  ? switchIfenableBreakfast = true
                  : switchIfenableBreakfast = false;
            } else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifenablelunch") {
              sysconfModelData.data[i].configValue.trim() == "1"
                  ? switchIfenableLunch = true
                  : switchIfenableLunch = false;
            } else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifenablesuper") {
              sysconfModelData.data[i].configValue.trim() == "1"
                  ? switchIfenableSuper = true
                  : switchIfenableSuper = false;
            } else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifmoneyinput") {
              sysconfModelData.data[i].configValue.trim() == "1" ?
              switchIftakeMoney = true : switchIftakeMoney = false;
            }
            else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifbringotherswithpost") {
              sysconfModelData.data[i].configValue.trim() == "1"
                  ? switchIfBringOthersWithPost = true
                  : switchIfBringOthersWithPost = false;
            } else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifbringotherswithoutpost") {
              sysconfModelData.data[i].configValue.trim() == "1"
                  ? switchIfBringOthersWithoutPost = true
                  : switchIfBringOthersWithoutPost = false;
            } else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifpaymoneybeforeeat") {
              if (sysconfModelData.data[i].configValue.trim() == "1") {
                switchIftakeMoneyEaten = false;
                switchIftakeMoneyPost = true;
              } else {
                switchIftakeMoneyEaten = true;
                switchIftakeMoneyPost = false;
              }
            }
          }
        }
      }
    });
  }
}
