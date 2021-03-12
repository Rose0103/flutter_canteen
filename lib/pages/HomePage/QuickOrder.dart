import 'package:apifm/apifm.dart';
import 'package:flutter_canteen/common/database_helper.dart';
import 'package:flutter_canteen/model/canteenModel.dart';
import 'package:flutter_canteen/otherfunction/logutil.dart';
import 'package:flutter_canteen/pages/HomePage/selectCanteen.dart';
import 'package:flutter_canteen/provide/userInfo.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/provide/orderstate.dart';
import '../../common/shared_preference.dart';
import 'package:provide/provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'package:flutter_canteen/pages/qrcodepages/qrpage.dart';
import 'package:flutter_canteen/otherfunction/showDialog.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_canteen/model/baoCanPriceModel.dart';
import 'dart:convert';
import 'package:flutter_canteen/model/deadlinemodel.dart';

import '../client_index_page.dart';
import 'loginOrRegister.dart';
/**
 * 快速点餐模块
 */

class QuickOrder extends StatefulWidget {
  @override
  _QuickOrderState createState() => _QuickOrderState();
}

class _QuickOrderState extends State<QuickOrder> {
  var _chooseDate = DateTime.now().toString().split(" ")[0];
  var _currentDate = DateTime.now();
  int status = 0;
  int laststatus = 0;
  int lastnum = 0;
  String diningType = " ";
  int mealtype = 2;
  String mealID = "";
  int num = 1;
  double money = 10;
  int buttonSize = 120;
  int baocanFlag = -1;
  Timer _timer;
  DateTime lastPopTime = null;
  int id = 0;
  String name = "";
  double moneys;
  int ticketNum;

  @override
  void initState() {
    super.initState();
    if ((_currentDate.hour >= 0 && _currentDate.hour < 9)) {
      _currentDate = DateTime.now();
      _chooseDate = DateTime.now().toString().split(" ")[0];
      diningType = "早餐";
      mealtype = 0;
    } else if (_currentDate.hour >= 20 && _currentDate.hour < 24) {
      _currentDate = DateTime.now().add(Duration(days: 1));
      _chooseDate =
          DateTime.now().add(Duration(days: 1)).toString().split(" ")[0];
      diningType = "早餐";
      mealtype = 0;
    } else if (_currentDate.hour >= 9 && _currentDate.hour < 14) {
      _currentDate = DateTime.now();
      _chooseDate = DateTime.now().toString().split(" ")[0];
      diningType = "中餐";
      mealtype = 1;
    } else if (_currentDate.hour >= 14 && _currentDate.hour < 20) {
      _currentDate = DateTime.now();
      _chooseDate = DateTime.now().toString().split(" ")[0];
      diningType = "晚餐";
      mealtype = 2;
    }
    setState(() {
      mealtype == 0
          ? money = num * double.parse(breakfastprice)
          : mealtype == 1
              ? money = num * double.parse(lunchprice)
              : money = num * double.parse(superprice);
      currentprice = money;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initValue();
      //首页点餐状态刷新
      Timer.periodic(Duration(milliseconds: 10000), (timer) {
        if ((_currentDate.hour >= 0 && _currentDate.hour < 9) &&
            mealtype != 0) {
          setState(() {
            _currentDate = DateTime.now();
            _chooseDate = DateTime.now().toString().split(" ")[0];
            diningType = "早餐";
            mealtype = 0;
            currentdate = _chooseDate;
            currentmealtype = mealtype;
          });
        } else if (_currentDate.hour >= 20 &&
            _currentDate.hour < 24 &&
            mealtype != 0) {
          setState(() {
            _currentDate = DateTime.now().add(Duration(days: 1));
            _chooseDate =
                DateTime.now().add(Duration(days: 1)).toString().split(" ")[0];
            diningType = "早餐";
            mealtype = 0;
            currentdate = _chooseDate;
            currentmealtype = mealtype;
          });
        } else if (_currentDate.hour >= 9 &&
            _currentDate.hour < 14 &&
            mealtype != 1) {
          setState(() {
            _currentDate = DateTime.now();
            _chooseDate = DateTime.now().toString().split(" ")[0];
            diningType = "中餐";
            mealtype = 1;
            currentdate = _chooseDate;
            currentmealtype = mealtype;
          });
        } else if (_currentDate.hour >= 14 &&
            _currentDate.hour < 20 &&
            mealtype != 2) {
          setState(() {
            _currentDate = DateTime.now();
            _chooseDate = DateTime.now().toString().split(" ")[0];
            diningType = "晚餐";
            mealtype = 2;
            currentdate = _chooseDate;
            currentmealtype = mealtype;
          });
        }
      });
    });
    //定时任务
    _timer = Timer.periodic(const Duration(milliseconds: 2000), (Void) {
      if (laststatus != currentstatus) {
        laststatus = currentstatus;
        setState(() {
          status = laststatus;
          num = currentnum;
          money = currentprice;
          status == 0 ? buttonSize = 120 : buttonSize = 120;
        });
      }
    });
  }

  Future _associatecanteen() async {
    await requestGet('getauthorization', '?type=canteen' ).then((val)async{
      if(val.toString() == "false"){
        return;
      }
      if(val != null){
        canteenModel canteenModelData = canteenModel.fromJson(val);
        canteenlist = canteenModelData.data;
      }
    });


  }





  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  void initValue() async {
    print(312312312);
    await _getsystemconfig();
    if(canteenlist==null||canteenlist.length==0){
      await _associatecanteen();
    }
    //中间值为了同步快速点餐页面和报餐页面的状态
    currentdate = _chooseDate;
    currentmealtype = mealtype;
    Provide.value<GetOrderStatusProvide>(context).orderstatudata = null;
    await _getorderStatus();
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

  //快速点餐标题
  Widget quickOrderTitleWidget() {
    return Container(
      child: Row(
        //mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(ScreenUtil().setSp(10.0),
                  ScreenUtil().setSp(22.0), 00.0, ScreenUtil().setSp(22.0)),
              child: Image.asset("assets/images/icon_lbiao.png")),
          Padding(
            padding: EdgeInsets.fromLTRB(ScreenUtil().setSp(10.0),
                ScreenUtil().setSp(22.0), 00.0, ScreenUtil().setSp(22.0)),
            child: Text(
              '快速点餐',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(34.0), color: Colors.black,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(""),
          ),
        ],
      ),
    );
  }

  //食堂名标题
  Widget cattenNameTitle() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(ScreenUtil().setSp(45.0),
                  ScreenUtil().setSp(20.0), 00.0, ScreenUtil().setSp(10.0)),
              child: Image.asset("assets/images/logo.png",width: ScreenUtil().setSp(80))),
          Container(
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setSp(0),
                ScreenUtil().setSp(0),
                ScreenUtil().setSp(0),
                ScreenUtil().setSp(0)),
            child: FlatButton(
              onPressed: (){
                return  showDialog(
                    context: context,
                    builder: (context){
                      return SelectCanteen(canteenlist,canteenName);
                    }
                );
              },
              child: Container(
                child: Row(
                  children: <Widget>[
                    Text(
                        canteenName==null?"":canteenName,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil.getInstance().setSp(36),
                            fontWeight: FontWeight.w400)
                    ),
                    Icon(Icons.keyboard_arrow_right),
                  ],
                ),
              ),
            ),
          ),
          Container(
            child: Text(
              _chooseDate + '  ' + _weekDay(_currentDate) + '  ' + diningType,
              style: TextStyle(fontSize: ScreenUtil().setSp(25), color: Colors.black54),
            ),
          )
        ]);
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
    if (currentdate == DateTime.now().toString().split(" ")[0]) {
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
        /*decoration: funcName.contains("已选择")
            ? BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                border: Border.all(width: 2, color: Colors.black12),
              )
            : null,*/
        //padding: EdgeInsets.fromLTRB(ScreenUtil().setSp(10.0), ScreenUtil().setSp(30.0), ScreenUtil().setSp(10.0), ScreenUtil().setSp(10.0)),
        child: Column(children: <Widget>[
          IconButton(
              icon: Image.asset(imgName),
              //color: Colors.transparent,
              iconSize: ScreenUtil().setSp(buttonSize),
              onPressed: () async {
                if(isYouKe){
                  showDialog(
                      context: context,
                      builder: (context){
                        return LoginOrRegister();
                      }
                  );
                  return;
                }
                if (funcName.contains("二维码")) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => QRpage()));
                  return;
                }
//                if(dining_status == "1"){
//                  return showMessage(context, "您已经在${dingingCanteenName}食堂用过餐了");
//                }
                if (!deadlineTips()) return;
                if (funcName.contains("已选择") && num == lastnum) return;
                if (funcName.contains("已选择不报餐")) return;

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
                    }
                  }
                  laststatus = status;
                  if (funcName == "报餐"){status = 1;}
                  if (funcName == "不报餐"){status = 2;dinging =true;}
                  //modify by wanchao 2020-11-23
                  //if (funcName == "留餐"){status = 3;dinging =true;}
                  if (funcName == "留餐"){status = 3;}
                  setState(() {
                    buttonSize = 120;
                  });
                  await _modifyorderStatus(status,false);
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
              style: TextStyle(
                  color: funcName.contains("已选择") ? Theme.of(context).primaryColor : Colors.black54,
                  fontSize: funcName.contains("已选择") ?ScreenUtil.getInstance().setSp(30):ScreenUtil.getInstance().setSp(25),
                  fontWeight:funcName.contains("已选择") ?FontWeight.w700:FontWeight.w200
              )),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.fromLTRB(ScreenUtil.getInstance().setSp(20.0), 0.0, ScreenUtil.getInstance().setSp(20.0), 0.0),
      //color: Colors.white,

      child: Column(
        children: <Widget>[quickOrderTitleWidget(), quickOrderContent(context)],
      ),
    );
  }

  /**
   * 快读点餐内容
   */
  Container quickOrderContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/mainpageBG.png"),
            fit: BoxFit.fill,
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          cattenNameTitle(),
          btns(),
          //  moneywidgets(),
          selectMealWidget(),
        ],
      ),
    );
  }

  ///数量按钮
  Widget btns() {
    String text1 = switchIftakeMoneyEaten?"就餐时扣款":"报餐时扣款";
    String text2 = iffirstMoney=="1"?"优先扣餐券":iffirstMoney=="2"?"优先扣余额":"只扣余额";
    return Container(
        width: ScreenUtil().setSp(600),
        margin: EdgeInsets.fromLTRB(
            ScreenUtil().setSp(6), 0.0, ScreenUtil().setSp(6), 0.0),
        padding: EdgeInsets.fromLTRB(
            0, ScreenUtil().setSp(4), 0, ScreenUtil().setSp(20)),
        alignment: Alignment.bottomRight,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(ScreenUtil().setSp(16)),
                      child: Align(
                        child: Text(
                          '总价',
                          style: TextStyle(
                              color: Color(0xff333333),
                              fontSize: ScreenUtil().setSp(30)),
                        ),
                      ),
                    ),
                    Align(
                      child: Text(
                        "¥$money",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: ScreenUtil().setSp(38)),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(""),
                    ),
                    Padding(
                      padding: EdgeInsets.all(ScreenUtil().setSp(16)),
                      child: Align(
                        child: Text(
                          '用餐人数',
                          style: TextStyle(
                              color: Color(0xff333333),
                              fontSize: ScreenUtil().setSp(30)),
                        ),
                      ),
                    ),
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
                        });
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.all(ScreenUtil().setSp(14)),
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
                      margin:
                          EdgeInsets.fromLTRB(0, 0, ScreenUtil().setSp(14), 0),
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
                          });
                        },
                      ),
                    ),
                  ]),
              Padding(
                padding: EdgeInsets.all(ScreenUtil().setSp(0)),
                child: Align(
                  child: Text(
                    "(扣款规则：$text1,$text2)",
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: ScreenUtil().setSp(30)),
                  ),
                ),
              ),
              SizedBox(height: 15.0,),
              Padding(
                padding: EdgeInsets.all(ScreenUtil().setSp(0)),
                child: Align(
                  child: diningCanteenID == canteenID?Container():
//                    dinging ? "" : "已在${dingingCanteenName}报餐",
                  dinging ? Text("") :Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      //modify by lilixia   2020-11-23   start
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("已在 ",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                            Text(
                              "${dingingCanteenName}",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.red,
                                  fontSize: ScreenUtil().setSp(36)),
                            ),
                            Text(" 报餐 /留餐  ",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                                onTap: (){
                                  showDialog<bool>(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('确定修改？'),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text('取消'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            FlatButton(
                                              child: Text('确定'),
                                              onPressed: () {
                                               if(dining_status == "1"){
                                                 Navigator.pop(context);
                                                 return showMessage(context, "您已经在${dingingCanteenName}食堂用过餐了");
                                               }else{
                                                _modifyorderStatus(status,true);
                                               }
                                              },
                                            ),
                                          ],
                                        );
                                      }
                                  );
                                },
                                child: Text(
                                  "修改为当前食堂",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: ScreenUtil().setSp(30),
                                      color: Colors.orangeAccent
                                  ),
                                )
                            )
                          ],
                        ),
                      ],
                    ),
                    ),
                ),
              ),
            ]));
  }



  //选择报餐
  Padding selectMealWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 5.0),
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
          Expanded(
            flex: 1,
            child: choseButtonWidget("assets/images/QRcode.png", "就餐二维码"),
          ),
          //choseButtonWidget("assets/images/btn_caipin_default.png", "菜品"),
        ],
      ),
    );
  }

  //查询报餐状态
  Future _getorderStatus() async {
    await Provide.value<GetOrderStatusProvide>(context)
        .getOrderState(userID, _chooseDate.toString(), mealtype);
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
        lastnum = num;
        laststatus = 0;
        buttonSize = 120;
      });
    } else {
      baocanFlag = -1;
      for (int i = 0; i < Provide.value<GetOrderStatusProvide>(context).orderstatudata.data.length; i++) {
        if (Provide.value<GetOrderStatusProvide>(context).orderstatudata.data[i].state < 4) baocanFlag = i;
      }
//沒有報餐記錄
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
          lastnum = num;
          laststatus = 0;
          buttonSize = 120;
          if (currentdate == _chooseDate.toString() &&
              currentmealtype == mealtype) {
            currentstatus = status;
            currentnum = num;
            currentprice = money;
          }
        });
      } else {
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
          //modify by wanchao 2020-11-23  给报餐标志赋值
          if(status==1||status==3){
            dinging = false;
          }
          if (currentdate == _chooseDate.toString() &&
              currentmealtype == mealtype) {
            currentstatus = status;
            currentnum = num;
            currentprice = money;
          }
        });
      }
    }
    return '完成加载';
  }

  //修改报餐状态
  Future _modifyorderStatus(int state, bool flag) async {
    int quality = num;
    double price = money;
    int ticket_nums = 1;
    int cost_type = 0;
    if (state == 2) {
      quality = 0;
      price = 0.0;
      ticket_nums = 0;
    }
    //就餐时扣款
    double pricetemp = price;
    if (switchIftakeMoneyEaten){
      pricetemp = 0.0;
      ticket_nums = 0;
    }else{
      await _getPersonInfoMoney();
      switch (iffirstMoney) {
        case "1": //优先扣餐券
          if (ticketNum >= 1) {
            pricetemp = 0.0;
            cost_type = 1;
          } else if (moneys >= pricetemp) {
            ticket_nums = 0;
            cost_type = 0;
          } else {
            showMessage(context, "余额不足");
            return;
          }
          break;
        case "2": //优先扣余额
          if (moneys >= price) {
            ticket_nums = 0;
            cost_type = 0;
          } else if (ticketNum >= 1) {
            pricetemp = 0.0;
            cost_type = 1;
          } else {
            showMessage(context, "余额不足");
            return;
          }
          break;
        default://只扣余额
          if (moneys >= price) {
            ticket_nums = 0;
            cost_type = 0;
          } else {
            showMessage(context, "余额不足");
            return;
          }
          break;
      }
    }
    var formData = {
      'order_date': _chooseDate.toString(),
      'state': state,
      'meal_type': mealtype,
      'quantity': quality,
      'price': pricetemp,
      "canteen_id":canteenID,
      "ticket_num":ticket_nums,
      "cost_type":cost_type
    };
    List data = new List();
    data.add(formData);
    await Provide.value<GetOrderStatusProvide>(context)
        .modifyOrderState(data);
    if (Provide.value<GetOrderStatusProvide>(context).orderStateback.code ==
        "0") {
      setState(() {
        currentstatus = state;
        currentnum = quality;
        currentprice = price;
        lastnum = num;
        buttonSize = 120;
        if(flag){
          showMessage(context, "修改成功");
          Navigator.pop(context);
        }
      });
    } else {
      showMessage(context,
          Provide.value<GetOrderStatusProvide>(context).orderStateback.message);
      if(flag){
        Navigator.pop(context);
      }else{
        setState(() {
          currentstatus = laststatus;
          status = laststatus;
          if (status == 0) {
            buttonSize = 120;
          }else {
            buttonSize = 120;
          }
        });
      }
    }
    return '完成加载';
  }

  //加载个人信息
  Future _getPersonInfoMoney() async {
    String userName = await KvStores.get(KeyConst.USER_NAME);
    await Provide.value<GetUserInfoDataProvide>(context).getUserInfo(userName);
    setState(() {
      moneys = double.parse(Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.money);
      ticketNum = Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.ticket_num;
    });
    return '完成加载';
  }

  _getsystemconfig() async {
    await requestGet('getdeadline', '?canteen_id='+canteenID).then((val) {
      var data = val;
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
          breakfastprice = '10.0';
          lunchprice = '20.0';
          superprice = '20.0';
        if(getpriceModelData.data.length!=0){
          for (int i = 0; i < getpriceModelData.data.length; i++) {
            print("#####################:${rootOrgid},${organizeid},${getpriceModelData.data[i].configKey},${getpriceModelData.data[i].configValue}");
//            if(rootOrgid==organizeid){
              if (getpriceModelData.data[i].configKey == "0")
                breakfastprice = getpriceModelData.data[i].configValue;
              if (getpriceModelData.data[i].configKey == "1")
                lunchprice = getpriceModelData.data[i].configValue;
              if (getpriceModelData.data[i].configKey == "2")
                superprice = getpriceModelData.data[i].configValue;
//            }else{
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
//              }
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
                "nposted_permit") {
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
            }  else if (sysconfModelData.data[i].configKey.toLowerCase() ==
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
