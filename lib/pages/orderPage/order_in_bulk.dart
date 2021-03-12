import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_canteen/model/jsonModel.dart';
import 'package:flutter_canteen/config/param.dart';
import 'dart:convert';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provide/provide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_canteen/provide/orderstate.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../common/shared_preference.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_canteen/otherfunction/showDialog.dart';
import 'dart:async';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_canteen/pages/mineOrderPage/mineOrderItem.dart';
import 'package:flutter_canteen/model/autogenerated.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_canteen/otherfunction/showDialog.dart';
import 'package:flutter_canteen/model/baoCanPriceModel.dart';
import 'package:flutter_canteen/model/deadlinemodel.dart';


class OrderInBulk extends StatefulWidget {
  final String functionID;

  OrderInBulk(this.functionID);

  @override
  _OrderInBulkState createState() => new _OrderInBulkState();
}

class _OrderInBulkState extends State<OrderInBulk> {

  //groupValue 选中值 早餐-1，中餐-2，晚餐-3
  int groupValue = 1;
  var _chooseDate = DateTime.now().toString().split(" ")[0];
  var _currentDate = DateTime.now();
  int mealtype = 0;
  DateTime lastPopTime=null;

  int buttonSize = 120;

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  List<MineOrderItem> children = [];
  bool isfirstload = true;

  @override
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
  }

  @override
  Widget build(BuildContext context) {
    if (isfirstload) {
      getList();
      isfirstload = false;
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
          '批量报餐',
          style: TextStyle(color: Colors.black,
              fontSize: ScreenUtil().setSp(40),
              fontWeight:FontWeight.w500),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        child:  Column(
            children: <Widget>[
              _mealTimeChoseWidget(),
              timeChoseWidget(context),
              OrderList(),
            ],
          ),
        ),
    );
  }

//获取订单列表数据
  Future getList() async {
    children.clear();
    DateTime fiftyDaysAgo = _currentDate.add(Duration(days: 7)); //三个月以前的
    print("_currentDate:" + _currentDate.toString());
    print("fiftyDaysAgo:" + fiftyDaysAgo.toString());
    String params = '/' +
        userID +
        '/' +
        _currentDate.toString().split(" ")[0] +
        '/' +
        fiftyDaysAgo.toString().split(" ")[0] +
        '/' +
        0.toString();

    var retCheckcode = -99;
    var currentMassage;
    await requestGet('mealListData', params).then((val) {
      if (val.toString() == "false") {
        return;
      }


      setState(() {
        Autogenerated autogenerated = Autogenerated.fromJson(val);

        bool flag = false;
        for(var i =0;i<7;i++){
          String dataC = _currentDate.add(Duration(days: i)).toString().split(" ")[0];
          MineOrderItem mineOrderState = new MineOrderItem();
          //不为空的时候
          if(autogenerated.data!=null)
         {
          for(var j =0;j<autogenerated.data.length;j++){
            var f = autogenerated.data[j];
            if(dataC==f.orderDate&&mealtype==f.mealType&&f.state<4){
              print("aaaa"+f.orderDate+"  "+f.mealType.toString()+"  "+f.state.toString());
              mineOrderState.int_mealtype = f.mealType + 1;
              mineOrderState.state = 0;
              if (f.state != null) {
                mineOrderState.state = f.state;
                mineOrderState.laststate=f.state;
              }
              f.mealType == 0
                  ? mineOrderState.goMealType = "早餐"
                  : f.mealType == 1
                  ? mineOrderState.goMealType = "中餐"
                  : mineOrderState.goMealType = "晚餐";
              f.diningStatus == 0
                  ? mineOrderState.diningType = "未就餐"
                  : mineOrderState.diningType = "已就餐";
              f.state == 0 || f.state == null
                  ? mineOrderState.mealType = "未报餐"
                  : f.state == 1
                  ? mineOrderState.mealType = "已报餐"
                  : f.state == 2
                  ? mineOrderState.mealType = "不报餐"
                  : f.state == 3
                  ? mineOrderState.mealType = "留餐"
                  : f.state == 4
                  ? mineOrderState.mealType = "订餐未确认"
                  : mineOrderState.mealType = "已订餐";

              mineOrderState.time = f.orderDate;
              f.mealType == 0
                  ? mineOrderState.mealsUnitPrice = breakfastprice
                  : f.mealType == 1
                  ? mineOrderState.mealsUnitPrice = lunchprice
                  : mineOrderState.mealsUnitPrice = superprice;
              mineOrderState.orderNumber = f.mealstatId.toString();

              mineOrderState.mealsPrice = f.price.toString();
              mineOrderState.mealsNum = f.quantity.toString();
              mineOrderState.lastnum=f.quantity.toString();
              f.mealType==0?mineOrderState.mealsPrice = (double.parse(mineOrderState.mealsNum)  * double.parse(breakfastprice)).toString():
              f.mealType==1?mineOrderState.mealsPrice =(double.parse(mineOrderState.mealsNum)  * double.parse(lunchprice)).toString():mineOrderState.mealsPrice = (double.parse(mineOrderState.mealsNum)  * double.parse(superprice)).toString();
              flag = true;
              children.add(mineOrderState);
              break;
            }else{
              flag = false;
            }
          }}
          if(!flag){
            mineOrderState.int_mealtype = mealtype;
            mineOrderState.state=0;
            mineOrderState.laststate=0;
            mealtype == 0
                ? mineOrderState.goMealType = "早餐"
                : mealtype == 1
                ? mineOrderState.goMealType = "中餐"
                : mineOrderState.goMealType = "晚餐";
            mineOrderState.diningType = "";
            mineOrderState.mealType = "未报餐";

            mineOrderState.time = dataC;
            mealtype == 0
                ? mineOrderState.mealsUnitPrice = breakfastprice
                : mealtype == 1
                ? mineOrderState.mealsUnitPrice = lunchprice
                : mineOrderState.mealsUnitPrice = superprice;
            mineOrderState.orderNumber = "";
            mineOrderState.mealsNum = "1";
            mineOrderState.lastnum="1";
            mineOrderState.mealsPrice = (double.parse(mineOrderState.mealsNum)*double.parse(mineOrderState.mealsUnitPrice)).toString();
            children.add(mineOrderState);
          }
        }

        print("*******************:" + children.length.toString());
      });
      _refreshController.refreshCompleted();
    });
  }

  Widget OrderList() {
    return Expanded(
        child:Container(
      margin: EdgeInsets.fromLTRB(
          ScreenUtil().setSp(6), 0.0, ScreenUtil().setSp(6), 0.0),
      padding: EdgeInsets.fromLTRB(
          0, ScreenUtil().setSp(4), 0, ScreenUtil().setSp(10)),
      alignment: Alignment.bottomRight,
      decoration: new BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Color(0x33333333)),
      ),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: children.length, //列表长度
          itemBuilder: (context, index) { //构建item
            return listItem(index);
          }
      ),

    ));
  }

  Widget listItem(int index)
  {
    return Container(
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0x33333333)),
        ),
        child:Column(
          children: <Widget>[
            choseTimeTitle(index),
            btns(index),
            selectMealWidget(index),
          ],
        ));
  }

//显示选餐日期，选餐类型
  Widget choseTimeTitle(int i) {
    var span = Duration(days: i);
    _chooseDate = _currentDate.add(span).toString().split(" ")[0];
    return Container(
      width: ScreenUtil().setSp(600),
      alignment: Alignment.center,
      child: Text(
          _chooseDate + '  ' + _weekDay(_currentDate, i) + ' ' +
              children[i].goMealType,
          style: TextStyle(
              color: Colors.black,
              fontSize: ScreenUtil.getInstance().setSp(36))),
    );
  }


//选择用餐状态
  Padding selectMealWidget(int index) {
//    print("============:"+index.toString()+"state:"+children[index].state.toString());
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 00.0, 0.0, 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: children[index].state == 1
                ? choseButtonWidget(
                "assets/images/btn_baocan_press.png", "已选择报餐", index)
                : choseButtonWidget(
                "assets/images/btn_baocan_default.png", "报餐", index),
          ),
          Expanded(
            flex: 1,
            child: children[index].state == 2
                ? choseButtonWidget(
                "assets/images/btn_bubao_press.png", "已选择不报餐", index)
                : choseButtonWidget(
                "assets/images/btn_bubao_default.png", "不报餐", index),
          ),
          Expanded(
            flex: 1,
            child: children[index].state == 3
                ? choseButtonWidget(
                "assets/images/btn_liucan_press.png", "已选择留餐", index)
                : choseButtonWidget(
                "assets/images/btn_liucan_default.png", "留餐", index),
          )
        ],
      ),
    );
  }

  ///数量按钮
  Widget btns(int index) {
    return Container(
      width: ScreenUtil().setSp(600),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(ScreenUtil().setSp(16)),
            child: Align(
              child: Text(
                '总价',
                style: TextStyle(
                    color: Color(0xff333333), fontSize: ScreenUtil().setSp(28)),
              ),
            ),
          ),
          Align(
            child: Text(
              "¥${children[index].mealsPrice}",
              style: TextStyle(
                  color: Colors.red, fontSize: ScreenUtil().setSp(28)),
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
                        fontSize: ScreenUtil().setSp(28)),
                  ),
                ),
              ),
              new GestureDetector(
                child: Container(
                  child: Image.asset(
//                    "assets/images/btn_add_selected.png",
                    "assets/images/btn_qiyongcp_selected.png",
                    width: ScreenUtil().setSp(80),
                  ),
                ),
                //不写的话点击起来不流畅
                onTap: () {
                  if (!deadlineTips(index)) return;
                  if (int.parse(children[index].mealsNum) <= 1) {
                    return;
                  }
                  setState(() {
                    children[index].mealsNum =
                        (int.parse(children[index].mealsNum) - 1).toString();
                    children[index].mealsPrice =
                        (int.parse(children[index].mealsNum) *
                            double.parse(breakfastprice)).toString();
                  });
                },
              ),
              Padding(
                padding: EdgeInsets.all(ScreenUtil().setSp(14)),
                child: Align(
                  child: Text(
                    children[index].mealsNum,
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: ScreenUtil().setSp(28)),
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
                    if (!deadlineTips(index)) return;
                    if (int.parse(children[index].mealsNum) >= 9999) {
                      return;
                    }
                    if(int.parse(children[index].mealsNum)>=1&&!switchIfBringOthersWithPost)
                    {
                      showMessage(context,"食堂未开启多人报餐权限，不能选择多人");
                      return ;
                    }
                    setState(() {
                      children[index].mealsNum =
                          (int.parse(children[index].mealsNum) + 1).toString();
                      children[index].mealsPrice =
                          (int.parse(children[index].mealsNum) *
                              double.parse(breakfastprice)).toString();
                    });
                  },
                ),
              )
            ]),
          Padding(
            padding: EdgeInsets.all(ScreenUtil().setSp(20)),
            child: Align(
              child: Text(
                switchIftakeMoneyEaten?"(扣款规则：就餐时扣款)":"(扣款规则：报餐时扣款)",
                style: TextStyle(
                    color: Color(0xff333333),
                    fontSize: ScreenUtil().setSp(30)),
              ),
            ),
          ),
        ]),
    );
  }

  //报餐 不报餐 留餐等选项
  Widget choseButtonWidget(String imgName, String funcName, int index) {
    return Container(
        child: Column(children: <Widget>[
          IconButton(
              icon: Image.asset(imgName),
              //color: Colors.transparent,
              iconSize: ScreenUtil().setSp(20),
              onPressed: () async {
                if(!deadlineTips(index)) return;
                if (funcName.contains("已选择")&&children[index].mealsNum==children[index].lastnum)
                  return;
                if (funcName.contains("已选择不报餐"))
                  return;
                if(lastPopTime == null || DateTime.now().difference(lastPopTime) > Duration(seconds: 1)) {
                  lastPopTime = DateTime.now();
                  if(children[index].state!=0)
                  {

                    if((funcName.contains("留餐")||funcName.contains("报餐"))&&children[index].mealsNum=="0")
                    {
                      children[index].mealsNum="1";
                    }
                    int numtemp=int.parse(children[index].mealsNum);
                    String tips="更改报餐状态为:"+(funcName.contains("留餐")?"留餐,用餐人数：$numtemp人?":funcName.contains("不报餐")?"不报餐":"报餐,用餐人数：$numtemp人?");
                    String result=await chooseDialog(context,tips);
                    if(result=='cancel')
                    {
                      children[index].mealsNum = children[index].lastnum;
                      mealtype==0?children[index].mealsPrice = (int.parse(children[index].mealsNum) * double.parse(breakfastprice)).toString():
                      mealtype==1?children[index].mealsPrice  = (int.parse(children[index].mealsNum) * double.parse(lunchprice)).toString()
                          :children[index].mealsPrice  = (int.parse(children[index].mealsNum) * double.parse(superprice)).toString();
                      setState(() {
                        buttonSize = 120;
                      });
                      return;
                    }
                    else {
                      children[index].mealsNum = numtemp.toString();
                      mealtype==0?children[index].mealsPrice = (double.parse(children[index].mealsNum) * double.parse(breakfastprice)).toString():
                      mealtype==1?children[index].mealsPrice  = (double.parse(children[index].mealsNum) * double.parse(lunchprice)).toString()
                          :children[index].mealsPrice  = (double.parse(children[index].mealsNum) * double.parse(superprice)).toString();
                    }
                  }
                  if (funcName == "报餐") children[index].state = 1;
                  if (funcName == "不报餐") children[index].state = 2;
                  if (funcName == "留餐") children[index].state = 3;
                  await _modifyorderStatus(index);
                  setState(() {
                    buttonSize = 120;
                  });
                }else{
                  lastPopTime = DateTime.now();
                  showMessage(context,"请勿操作太快！");
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

  //早餐，中餐，晚餐等切换
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
                      updateGroupValue(T);
                      getList();
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
                      updateGroupValue(T);
                      getList();
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
                      updateGroupValue(T);
                      getList();
                  })),
        ],
      ),
    );
  }

  _weekDay(DateTime date, int i) {
    var span = Duration(days: i);
    var weeks = date
        .add(span)
        .weekday
        .toString();
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


  void _thisweek() {
    //从今天开始的七天
      _currentDate = DateTime.now();
      getList();
    }

  void _theWeekAfter() {
    _currentDate = DateTime.now().add(Duration(days: 7));
      getList();
    }


  //时间控件
  Widget timeChoseWidget(BuildContext context) {
    return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            theDayBeforeButton(),
            Text("仅开放最近两周报餐"),
            theDayAfterButton(),
          ],
        ));
  }

  //本周按钮
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
        onPressed: _thisweek,
        child: Text(
          "< 本周",
          style: TextStyle(color: Color(0xFF777777)),
        ),
        color: Colors.transparent,
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0)), side: BorderSide(color: Colors.white, style: BorderStyle.solid, width: 21)),
      ),
    );
  }

  //下周按钮
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
        onPressed: _theWeekAfter,
        child: Text(
          "下周 >",
          style: TextStyle(color: Color(0xFF777777)),
        ),
        color: Colors.transparent,
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0)), side: BorderSide(color: Colors.white, style: BorderStyle.solid, width: 21)),
      ),
    );
  }


  updateGroupValue(int v) async {
    setState(() {
      mealtype = v - 1;
      groupValue = v;
    });
  }


  Future _modifyorderStatus(int index) async {
//    print("==================2222222223333333333333333333333==============");
    if (children[index].state == 2) {
      children[index].mealsNum = "0";
      children[index].mealsPrice = "0.0";
    }

    //就餐时扣款
    var pricetemp=children[index].mealsPrice;
    if(switchIftakeMoneyEaten)
      pricetemp="0.0";

    var formData = {'order_date': children[index].time,
      'state': children[index].state,
      'meal_type': mealtype,
      'quantity': children[index].mealsNum,
      'price': pricetemp,
      "canteen_id":canteenID,
      "ticket_num":0,
      "cost_type":0
    };

    List data = new List();
    data.add(formData);

    await Provide.value<GetOrderStatusProvide>(context).modifyOrderState(data);
    if (Provide
        .value<GetOrderStatusProvide>(context)
        .orderStateback
        .code ==
        "0") {

      setState(() {
        if (currentdate == children[index].time && currentmealtype == mealtype) {
          currentstatus = children[index].state;
          currentnum = int.parse(children[index].mealsNum);
          currentprice = double.parse(children[index].mealsPrice);
        }
        children[index].laststate=children[index].state;
        children[index].lastnum=children[index].mealsNum;
        buttonSize = 120;
      });
    } else {
      Fluttertoast.showToast(
        msg: Provide
            .value<GetOrderStatusProvide>(context)
            .orderStateback
            .message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: floaststaytime,
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        textColor: Colors.pink,
      );
      setState(() {
        children[index].state = children[index].laststate;
        children[index].mealsNum=children[index].lastnum;
        buttonSize = 120;
      });
    }
    return '完成加载';
  }



//报餐条件
  bool deadlineTips(int index) {
    //_getsystemconfig();
    //周六周日不开启报餐
    if(!switchIfenablesaturday&&_weekDay(_currentDate, index)=="周六")
    {
      showMessage(context,"食堂未开启周六报餐权限");
      return false;
    }
    if(!switchIfenableSunday&&_weekDay(_currentDate, index)=="周日")
    {
      showMessage(context,"食堂未开启周日报餐权限");
      return false;
    }
    //早中晚餐开启报餐
    if(!switchIfenableBreakfast&&mealtype == 0)
    {
      showMessage(context,"食堂未开启早餐报餐权限");
      return false;
    }

    if(!switchIfenableLunch&&mealtype == 1)
    {
      showMessage(context,"食堂未开启中餐报餐权限");
      return false;
    }

    if(!switchIfenableSuper&&mealtype == 2)
    {
      showMessage(context,"食堂未开启晚餐报餐权限");
      return false;
    }
    int hour = DateTime
        .now()
        .hour;
    int minute = DateTime
        .now()
        .minute;
    print("$breakfastdeadline,$mealtype,$hour,$minute");
    if (children[index].time == DateTime.now().toString().split(" ")[0]) {
      if (mealtype == 0 && ((hour == int.parse(breakfastdeadline.split(":")[0])
          && minute > int.parse(breakfastdeadline.split(":")[1]))
          || (hour > int.parse(breakfastdeadline.split(":")[0])))) {
        print(111);
        Fluttertoast.showToast(msg: "已过早餐报餐截至时间$breakfastdeadline，\n不能报餐或修改",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: floaststaytime,
            backgroundColor: Theme
                .of(context)
                .primaryColor,
            textColor: Colors.pink);
        return false;
      }

      if (mealtype == 1 && ((hour == int.parse(lunchdeadline.split(":")[0])
          && minute > int.parse(lunchdeadline.split(":")[1]))
          || (hour > int.parse(lunchdeadline.split(":")[0])))) {
        Fluttertoast.showToast(msg: "已过中餐报餐截至时间$lunchdeadline，\n不能报餐或修改",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: floaststaytime,
            backgroundColor: Theme
                .of(context)
                .primaryColor,
            textColor: Colors.pink);
        return false;
      }

      if (mealtype == 2 && ((hour == int.parse(dinnerdeadline.split(":")[0])
          && minute > int.parse(dinnerdeadline.split(":")[1]))
          || (hour > int.parse(dinnerdeadline.split(":")[0])))) {
        Fluttertoast.showToast(msg: "已过晚餐报餐截至时间$dinnerdeadline，\n不能报餐或修改",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: floaststaytime,
            backgroundColor: Theme
                .of(context)
                .primaryColor,
            textColor: Colors.pink);
        return false;
      }
    }
    return true;
  }

  _getsystemconfig() async {
    await requestGet('getdeadline', '?canteen_id='+canteenID).then((val) {
      var data = val;
      print(data);
      GetdeadlineModel getdeadlineModel = GetdeadlineModel.fromJson(data);
      if(getdeadlineModel.code=="0")
      {
        breakfastdeadline=getdeadlineModel.data.breakfastDeadline;
        lunchdeadline=getdeadlineModel.data.lunchDeadline;
        dinnerdeadline=getdeadlineModel.data.dinnerDeadline;
      }
      else
      {
        print("获取报餐截止时间失败，启用默认值");
      }
    });

    await requestGet('systemconfig', '?config_desc=报餐&canteen_id=${canteenID}').then((val) {

      sysConfigModel getpriceModelData = sysConfigModel.fromJson(val);
      if(getpriceModelData.code=="0")
      {
        breakfastprice = '10.0';
        lunchprice = '20.0';
        superprice = '20.0';
        if(getpriceModelData.data.length!=0){
          for (int i = 0; i < getpriceModelData.data.length; i++) {
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
              }
//            }
          }
        }
        setState(() {
        });
      }
      else
      {
        breakfastprice='10.0';
        lunchprice='20.0';
        superprice='20.0';
      }
    });
    await requestGet('systemconfig', '?config_desc=moreconfig&canteen_id=${canteenID}').then((val) {
      sysConfigModel sysconfModelData = sysConfigModel.fromJson(val);
      if (sysconfModelData.code == "0")
      {
        if (sysconfModelData.data.length == 0)
        {
          return;
        }
        else {
          for (int i = 0; i < sysconfModelData.data.length; i++) {
            //不报餐是否允许吃饭
            if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "nposted_permit") {
              sysconfModelData.data[i].configValue.trim() == "1" ?
              switchIfnopostEaten = true : switchIfnopostEaten = false;
            }
            else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifenablesaturday") {
              sysconfModelData.data[i].configValue.trim() == "1" ?
              switchIfenablesaturday = true : switchIfenablesaturday = false;
            }
            else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifenablesunday") {
              sysconfModelData.data[i].configValue.trim() == "1" ?
              switchIfenableSunday = true : switchIfenableSunday = false;

            }
            else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifenablebreakfast") {
              sysconfModelData.data[i].configValue.trim() == "1" ?
              switchIfenableBreakfast = true : switchIfenableBreakfast = false;

            }
            else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifenablelunch") {
              sysconfModelData.data[i].configValue.trim() == "1" ?
              switchIfenableLunch = true : switchIfenableLunch = false;

            }
            else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifenablesuper"){
              sysconfModelData.data[i].configValue.trim() == "1" ?
              switchIfenableSuper = true : switchIfenableSuper = false;
            }
            else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifmoneyinput") {
              sysconfModelData.data[i].configValue.trim() == "1" ?
              switchIftakeMoney = true : switchIftakeMoney = false;
            }
            else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifbringotherswithpost") {
              sysconfModelData.data[i].configValue.trim() == "1" ?
              switchIfBringOthersWithPost = true : switchIfBringOthersWithPost =
              false;
            }
            else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifbringotherswithoutpost"){
              sysconfModelData.data[i].configValue.trim() == "1"
                  ? switchIfBringOthersWithoutPost = true
                  : switchIfBringOthersWithoutPost = false;
            }
            else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifpaymoneybeforeeat") {
              if (sysconfModelData.data[i].configValue.trim() ==
                  "1") {
                switchIftakeMoneyEaten = false;
                switchIftakeMoneyPost = true;
              }
              else {
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






