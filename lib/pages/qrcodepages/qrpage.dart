import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_canteen/pages/personnelManagement/existingPersonnelListDetailed.dart';
import 'package:flutter_canteen/pages/shareCountingQrcode/beSharedCountingDetailed.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_canteen/model/jsonModel.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/provide/orderstate.dart';
import 'package:provide/provide.dart';
import 'package:flutter_canteen/pages/orderPage/clientorder_mainPage.dart';
import 'package:flutter_canteen/model/userListModel.dart';
import 'package:flutter_canteen/otherfunction/showDialog.dart';

import 'dart:convert';

class QRpage extends StatefulWidget {
  @override
  _QRpageState createState() => _QRpageState();
}

class _QRpageState extends State<QRpage> {
  var _chooseDate = DateTime.now().toString().split(" ")[0];

  /// 姓名文本字段的控制器。
  TextEditingController _realnameController = TextEditingController();
  var _currentDate = DateTime.now();
  int status = 0;
  int num = 1;
  int mealtype = 0;
  String mealID = "";
  int baocanFlag = -1;
  String diningType = "";
  JsonModel jsonModel = new JsonModel();
  GlobalKey repaintWidgetKey_temp = GlobalKey(); // 绘图key值
  GlobalKey repaintWidgetKey_long = GlobalKey(); // 绘图key值
  GlobalKey repaintWidgetKey_shareCoupons = GlobalKey(); // 绘图key值
  GlobalKey repaintWidgetKey_counting = GlobalKey(); // 绘图key值

  String remainingCoupons = "0";
  List <existingPersonnelListDetailed>sarchList = new List();
  TextEditingController _visitorController = TextEditingController();
  TextEditingController _countController = TextEditingController();
  List<existingPersonnelListDetailed> sarchsList = new List();
  Widget sarchWidget = Text(""); //搜索提示框
  int choseUserId  = -1;
  FocusNode _focusNode1 = new FocusNode();
  FocusNode _focusNode2 = new FocusNode();

  void initState() {
    super.initState();
    if (_currentDate.hour >= 0 && _currentDate.hour < 9) {
      mealtype = 0;
      diningType = "早餐";
    } else if (_currentDate.hour >= 9 && _currentDate.hour < 14) {
      mealtype = 1;
      diningType = "中餐";
    } else if (_currentDate.hour >= 14 && _currentDate.hour < 20) {
      mealtype = 2;
      diningType = "晚餐";
    } else {
      mealtype = 0;
      diningType = "早餐";
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initValue();
      jsonModel.user_id = userID;
      jsonModel.time = _chooseDate;
      jsonModel.num = num;
      jsonModel.meal_type = mealtype.toString();
      jsonModel.organize_Id = organizeid.toString();
      jsonModel.root_organize_Id = rootOrgid.toString();
    });
    _geuserInfo();
  }

  void initValue() async {
    jsonModel.time = _chooseDate;
    jsonModel.meal_type = mealtype.toString();
    Provide.value<GetOrderStatusProvide>(context).orderstatudata = null;
    await _getorderStatus(_chooseDate.toString());
    if (baocanFlag == -1) {
      setState(() {
        mealID = "";
        status = 0;
        num = 1;
        jsonModel.num = num;
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
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          '就餐二维码',
          style: TextStyle(
              color: Colors.black,
              fontSize: ScreenUtil().setSp(40),
              fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());//触摸收起键盘
        },
        child: DefaultTabController(
          length: 4,
          child: Scaffold(
              appBar: TabBar(
                labelColor: Colors.black, //字体颜色
                tabs: <Widget>[
                  //选项卡内容
                  Tab(
                    text: "临时码",
                  ),
                  Tab(
                    text: "长期码",
                  ),
                  Tab(
                    text: "分享餐券",
                  ),
                  Tab(
                    text: "餐券明细",
                  ),
                ],
              ),
              body: TabBarView(
                //选项卡 切换的内容信息展示和调用
                children: <Widget>[
                  tempQRcodeWidget(),
                  longPeridQRcodeWidget(),
                  shareCoupons(),
                  countingDetailedWidget(),
                ],
              )),
        ),
      ),
    );
  }

  Widget shareCoupons() {
    return RepaintBoundary(
      key: repaintWidgetKey_shareCoupons,
      child: SingleChildScrollView(
          child: Stack(children: <Widget>[
            Positioned(
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  ScreenUtil.getInstance().setSp(0.0),
                  ScreenUtil.getInstance().setSp(120.0),
                  ScreenUtil.getInstance().setSp(0.0),
                  ScreenUtil.getInstance().setSp(0.0)),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          ScreenUtil().setSp(0.0),
                          ScreenUtil().setSp(22.0),
                          ScreenUtil().setSp(0.0),
                          ScreenUtil().setSp(40.0)
                      ),
                      child: Text(
                        "剩余餐券数：${remainingCoupons}张",
                        style: TextStyle(fontSize: ScreenUtil().setSp(32)),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '被分享人：',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(32),
                            color: Colors.black38,
                          ),
                        ),
                        Container(
                          width: ScreenUtil.getInstance().setSp(360),
                          height: ScreenUtil.getInstance().setSp(100),
                          child: TextFormField(
                            autofocus: false,
                            focusNode: _focusNode1,
                            controller: _visitorController,
                            onTap: () {

                            },
                            onChanged: (e) {
                              sarchList.clear();
                              print(e);
                              if(e.length==0){
                                sarchWidget = Container();
                                setState(() {});
                                return;
                              }
                              for(int i = 0 ;i<sarchsList.length;i++){
                                if(sarchsList[i].usName.contains(_visitorController.text)){
                                  sarchList.add(sarchsList[i]);
                                }
                              }
                              // print(sarchList.length);
                              if(sarchList.length>0){
                                sarchWidget = getSarchWidget();
                              }
                              if(sarchList.length==0){
                                sarchWidget = Container();
                              }
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              errorBorder: outlineborders(Theme.of(context).primaryColor),
                              focusedErrorBorder: outlineborders(Theme.of(context).primaryColor),
                              fillColor: Theme.of(context).primaryColor,
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: ScreenUtil().setSp(30.0)),
                              errorStyle: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: ScreenUtil().setSp(25.0)),
                              hintText: '请输入被人分享人姓名',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:ScreenUtil().setSp(40)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '分享张数：',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(32),
                            color: Colors.black38,
                          ),
                        ),
                        Container(
                          width: ScreenUtil.getInstance().setSp(360),
                          height: ScreenUtil.getInstance().setSp(100),
                          child: TextFormField(
                            autofocus: false,
                            focusNode: _focusNode2,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(6), WhitelistingTextInputFormatter.digitsOnly
                            ],
                            controller: _countController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              errorBorder: outlineborders(Theme.of(context).primaryColor),
                              focusedErrorBorder: outlineborders(Theme.of(context).primaryColor),
                              fillColor: Theme.of(context).primaryColor,
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: ScreenUtil().setSp(30.0)),
                              errorStyle: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: ScreenUtil().setSp(25.0)),
                              hintText: '请输入分享张数',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(top:ScreenUtil().setSp(40)),
                      width: ScreenUtil().setSp(270),
                      height: ScreenUtil().setSp(120),
                      child: RaisedButton(
                        onPressed: () async {
                          if(_visitorController.text.length==0){
                            showMessage(context, '被分享人姓名不能为空!');
                            return;
                          }
                          if(_countController.text.length==0){
                            showMessage(context, '分享张数不能为空!');
                            return;
                          }
                          if(int.parse(_countController.text)>int.parse(remainingCoupons)){
                            showMessage(context,"点券余额不足");
                            return;
                          }
                          bool nameFlag = false;
                          sarchList.clear();
                          for(int i = 0 ;i<sarchsList.length;i++){
                            if(sarchsList[i].usName==_visitorController.text){
                              nameFlag = true;
                            }
                          }
                          if(!nameFlag){
                            showMessage(context,"被分享人不存在");
                            return;
                          }
                          await _sharecoupon(choseUserId,int.parse(_countController.text));
                        },
                        child: Text(
                          '确认分享',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(32)
                          ),
                        ),
                        color: Colors.orange,
                        shape: StadiumBorder(),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: ScreenUtil().setSp(324),
              left: ScreenUtil().setSp(275),
              child: sarchWidget,
            )
          ])),
    );
  }

  //搜索功能
  Widget getSarchWidget() {
    double h = sarchList.length * 50.0 + 10;
    if (h > 165.0) {
      h = 165.0;
    }
    print("================h:${h}");
    print(sarchList.length);
    return Container(
        decoration: new BoxDecoration(
          color: Colors.white,
          border: Border.all(width: ScreenUtil().setSp(3),color: Colors.orange)
        ),
        child: SizedBox(
            height: ScreenUtil().setSp(h),
            width: ScreenUtil().setSp(354),
            child: ListView.builder(
                itemExtent: ScreenUtil().setSp(50),
                itemCount: sarchList.length,
                itemBuilder: (BuildContext context, int index) {
                  return FlatButton(
                      onPressed: () {
                        choseUserId = sarchList[index].cID;
                        _visitorController.text = sarchList[index].usName;
                        FocusScope.of(context).requestFocus(FocusNode());
                        sarchWidget = Text("");
                        setState(() {});
                      },
                      child: Container(
                        width: ScreenUtil().setSp(225),
                        height: ScreenUtil().setSp(45),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          sarchList[index].usName,
                          style: TextStyle(fontSize: ScreenUtil().setSp(34)),
                        ),
                      )
                  );
                }
            )
        )
    );
  }

  //餐券明细
  Widget countingDetailedWidget() {
    return RepaintBoundary(
        key: repaintWidgetKey_counting,
        child: Container(
            padding: EdgeInsets.fromLTRB(
                ScreenUtil.getInstance().setSp(0.0),
                ScreenUtil.getInstance().setSp(0.0),
                ScreenUtil.getInstance().setSp(0.0),
                0.0),
            child: beSharedCountingDetailedPage(_focusNode1,_focusNode2)
        )
    );
  }

  Widget tempQRcodeWidget() {
    return RepaintBoundary(
        key: repaintWidgetKey_temp,
        child: Container(
            padding: EdgeInsets.fromLTRB(
                ScreenUtil.getInstance().setSp(0.0),
                ScreenUtil.getInstance().setSp(100.0),
                ScreenUtil.getInstance().setSp(0.0),
                0.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(ScreenUtil().setSp(50.0),
                      ScreenUtil().setSp(22.0), 00.0, ScreenUtil().setSp(22.0)),
                  child: Text(
                    _chooseDate +
                        '  ' +
                        _weekDay(_currentDate) +
                        '  ' +
                        diningType,
                    style: TextStyle(fontSize: 22, color: Colors.black54),
                  ),
                ),
                status == 2 || status == 0 ? todingcanPage() : QrImageWidget(),
              ],
            )));
  }

  Widget todingcanPage() {
    return Column(children: <Widget>[
      Text("        您还未报餐\n无法生成就餐二维码"),
      RaisedButton(
          color: Theme.of(context).primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
          child: Text("马上报餐"),
          textColor: Colors.white,
          onPressed: () async {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ClientOrderPage("")));
            return;
          })
    ]);
  }

  Widget longPeridQRcodeWidget() {
    JsonModel jsonModellong = new JsonModel();
    jsonModellong.user_id = userID;
    jsonModellong.time = DateTime.now().toString().split(" ")[0] +
        "||" +
        DateTime.now()
            .add(new Duration(
                days: _realnameController.text.isEmpty
                    ? 30
                    : int.parse(_realnameController.text)))
            .toString()
            .split(" ")[0];
    jsonModellong.num = 1;
    jsonModellong.meal_type = "all";
    jsonModellong.organize_Id = organizeid.toString();
    jsonModellong.root_organize_Id = rootOrgid.toString();
    return RepaintBoundary(
        key: repaintWidgetKey_long,
        child: Container(
          padding: EdgeInsets.fromLTRB(
              ScreenUtil.getInstance().setSp(0.0),
              ScreenUtil.getInstance().setSp(100.0),
              ScreenUtil.getInstance().setSp(0.0),
              0.0),
          child: SingleChildScrollView(
              child: Column(children: <Widget>[
            Text(
                "此二维码有效期:${DateTime.now().toString().split(" ")[0]}至${DateTime.now().add(new Duration(days: _realnameController.text.isEmpty ? 30 : int.parse(_realnameController.text))).toString().split(" ")[0]}"),
            QrImage(
              data: jsonEncode(jsonModellong),
              version: QrVersions.auto,
              size: 300.0,
            ),
            Container(
              width: ScreenUtil.getInstance().setSp(510),
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Container(
                    width: ScreenUtil.getInstance().setSp(360),
                    height: ScreenUtil.getInstance().setSp(100),
                    child: TextFormField(
                      autofocus: false,
                      controller: _realnameController,
                      inputFormatters: [
                        WhitelistingTextInputFormatter(RegExp("[0-9]"))
                      ],
                      decoration: InputDecoration(
                        enabledBorder: outlineborders(Colors.grey),
                        focusedBorder:
                            outlineborders(Theme.of(context).primaryColor),
                        errorBorder:
                            outlineborders(Theme.of(context).primaryColor),
                        focusedErrorBorder:
                            outlineborders(Theme.of(context).primaryColor),
                        fillColor: Theme.of(context).primaryColor,
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: ScreenUtil().setSp(30.0)),
                        errorStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: ScreenUtil().setSp(25.0)),
                        //labelText: '姓名',
                        hintText: '请输入有效天数',
                        //icon: Icon(Icons.perm_identity),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    width: ScreenUtil.getInstance().setSp(10),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      setState(() {});
                    },
                    child: Text('生成就餐码'),
                    color: Colors.orange,
                    shape: StadiumBorder(),
                  )
                ],
              ),
            )
          ])),
        ));
  }

  Widget QrImageWidget() {
    return new Offstage(
      offstage: status == 2 || status == 0 ? true : false,
      child: QrImage(
        data: jsonEncode(jsonModel),
        version: QrVersions.auto,
        size: 300.0,
      ),
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

  //分享点券
  Future _sharecoupon(int userId,int tichetNum) async {
    var data = {
      'receiver_id': userId,
      'ticket_num': tichetNum
    };
    print(data.toString());
    await request('tichetGive', '', formData: data).then((val) {
      if (val.toString() == "false") {
        return;
      }
      if( val['code'] =="0"){
        _geuserInfo();
        showMessage(context,"分享成功");
        _visitorController.text = "";
        _countController.text ="";
        setState(() {

        });
      }

    });
  }

//查询用户列表
  Future _geuserInfo() async {
    print("organizeid:${rootOrgid}");
    await requestGet('managementUserInfo', '?root_organize_id=${rootOrgid}')
        .then((val) {
          print("gaole");
          print(val);
      if (val.toString() == "false") {
        return;
      }
      if (val != null) {
        setState(() {
          sarchsList.clear();
          var userData = userListModel.fromJson(val);
          if (userData.data != null && userData.data.length > 0) {
            userData.data.forEach((f) {
              if (f.userId.toString() != userID) {
                String sexName;
                if (f.sex) {
                  sexName = "男";
                } else {
                  sexName = "女";
                }
                sarchsList.add(existingPersonnelListDetailed(
                    f.userName.toString(),
                    sexName,
                    f.phoneNum.toString(),
                    f.organizeName.toString(),
                    f.userId,
                    f.money
                ));
              }else{
                remainingCoupons = f.ticket_num.toString();
              }
            });
            setState(() {

            });
          }
        });
      }
    });
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
        jsonModel.num = num;
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
          num = Provide.value<GetOrderStatusProvide>(context)
              .orderstatudata
              .data[baocanFlag]
              .quantity;
          jsonModel.num = num;
          print("status$status");
        });
      }
    }
    return '完成加载';
  }

  OutlineInputBorder outlineborders(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(30), //边角为30
      ),
      borderSide: BorderSide(
        color: color, //边线颜色为黄色
        width: 2, //边线宽度为2
      ),
    );
  }
}
