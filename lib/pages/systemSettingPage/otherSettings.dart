import 'package:flutter/material.dart';
import 'package:flutter_canteen/common/shared_preference.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_canteen/model/baoCanPriceModel.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter/services.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/otherfunction/moneytext.dart';
import 'dart:convert';

class otherSettingPage extends StatefulWidget {
  @override
  _otherSettingPageState createState() => _otherSettingPageState();
}

class _otherSettingPageState extends State<otherSettingPage> {

  TextEditingController _PasswordController = TextEditingController();
  bool passwordRight=false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getsystemconfig();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Scaffold(
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
                '更多设置',
                style: TextStyle(color: Colors.black,
                    fontSize: ScreenUtil().setSp(40),
                    fontWeight:FontWeight.w500),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              brightness: Brightness.dark,
              /*   elevation: 0.0,*/
            ),
            body:  SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SwitchListTile(
                          title: Text("不报餐允许就餐"),
                          value: switchIfnopostEaten,
                          onChanged: (value) async {
                             await putSubmit(1,value);
                              setState(() {
                              });
                          }),
                      SwitchListTile(
                          title: Text("周六开启报餐"),
                          value: switchIfenablesaturday,
                          onChanged: (value) async{
                            print(value);
                            await putSubmit(2,value);
                            setState(() {
                            });
                          }),
                      SwitchListTile(
                          title: Text("周日开启报餐"),
                          value: switchIfenableSunday,
                          onChanged: (value) async{
                           await putSubmit(3,value);
                            setState(() {
                            });
                          }),
                      SwitchListTile(
                          title: Text("早餐开启报餐"),
                          value: switchIfenableBreakfast,
                          onChanged: (value) async{
                           await putSubmit(4,value);
                            setState(() {
                            });
                          }),
                      SwitchListTile(
                          title: Text("中餐开启报餐"),
                          value: switchIfenableLunch,
                          onChanged: (value) async{
                           await putSubmit(5,value);
                            setState(() {
                            });
                          }),
                      SwitchListTile(
                          title: Text("晚餐开启报餐"),
                          value: switchIfenableSuper,
                          onChanged: (value) async{
                           await putSubmit(6,value);
                            setState(() {
                            });
                          }),
                      SwitchListTile(
                          title: Text("开启报餐时允许带人吃饭"),
                          value: switchIfBringOthersWithPost,
                          onChanged: (value) async{
                           await putSubmit(7,value);
                            setState(() {
                            });
                          }),
                      SwitchListTile(
                          title: Text("开启不报餐时允许带人吃饭"),
                          value: switchIfBringOthersWithoutPost,
                          onChanged: (value) async{
                           await putSubmit(8,value);
                            setState(() {
                            });
                          }),
                      SwitchListTile(
                          title: Text("就餐时扣款"),
                          value: switchIftakeMoneyEaten,
                          onChanged: (value) async{
                            await putSubmit(9,value);
                            setState(() {
                            });
                          }),
                      SwitchListTile(
                          title: Text("报餐时扣款"),
                          value: switchIftakeMoneyPost,
                          onChanged: (value) async{
                           await putSubmit(10,value);
                            setState(() {
                            });
                          }),
                      SwitchListTile(
                          title: Text("就餐时输入扣款"),
                          value: switchIftakeMoney,
                          onChanged: (value) async{
                            await putSubmit(11,value);
                            setState(() {
                            });
                          }),
                      submitButton(context),
                    ]))));
  }

  void adminPassword() async{
    _PasswordController.clear();
    await showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());//触摸收起键盘
          },
          child: new AlertDialog(
            title: new Text(
              '请输入管理员密码',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(34),
                  fontWeight: FontWeight.w600
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _textWidget(_PasswordController,"密码:"),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _PasswordController.clear();
                  return;
                },
              ),
              new FlatButton(
                child: new Text('确定'),
                onPressed: () async{
                  if(_PasswordController.text.trim().isEmpty){
                    Fluttertoast.showToast(msg: "请输入管理员密码");
                    return;
                  }
                  if (_PasswordController.text.trim().isNotEmpty) {
                    String passwd = await KvStores.get(KeyConst.PASSWORD);
                    if(_PasswordController.text.trim()==passwd) {
                      passwordRight=true;
                      Navigator.of(context).pop();
                    }
                    else{
                      Fluttertoast.showToast(msg: "密码错误");
                      return;
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget submitButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      width: double.infinity,
      child: RaisedButton(
          child: Text("重置为默认设置"),
          color: Theme.of(context).primaryColor,
          highlightColor: Theme.of(context).primaryColor,
          colorBrightness: Brightness.dark,
          splashColor: Colors.grey,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          onPressed: () async {
            initDataToDatabase(passwordRight) ;
            setState(() {
            });
          }),
    );
  }

  _getsystemconfig() async {
    await requestGet('systemconfig', '?config_desc=moreconfig&canteen_id=${canteenID}').then((val) {
      sysConfigModel sysconfModelData = sysConfigModel.fromJson(val);
      if (sysconfModelData.code == "0")
        {
      if (sysconfModelData.data.length == 0)
        initDataToDatabase(passwordRight);
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
                "ifmoneyinput") {
              sysconfModelData.data[i].configValue.trim() == "1" ?
              switchIftakeMoney = true : switchIftakeMoney = false;
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
                "ifmoneyinput"){
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
    setState(() {
    });
  }



  Future putSubmit(int index,bool val) async {
    await adminPassword();
    print(passwordRight);
    if(!passwordRight) return;

    String keyname="";
    String keyvalue="";
    switch(index) {
      case 1:
        keyname="nposted_permit";
        switchIfnopostEaten = val;
        switchIfnopostEaten==true?keyvalue="1":keyvalue="0";
        passwordRight = false;
        break;
      case 2:
        keyname="ifenablesaturday";
        switchIfenablesaturday = val;
        switchIfenablesaturday==true?keyvalue="1":keyvalue="0";
        passwordRight = false;
        break;
      case 3:
        keyname="ifenablesunday";
        switchIfenableSunday = val;
        switchIfenableSunday==true?keyvalue="1":keyvalue="0";
        passwordRight = false;
        break;
      case 4:
        keyname="ifenablebreakfast";
        switchIfenableBreakfast = val;
        switchIfenableBreakfast==true?keyvalue="1":keyvalue="0";
        passwordRight = false;
        break;
      case 5:
        keyname="ifenablelunch";
        switchIfenableLunch = val;
        switchIfenableLunch==true?keyvalue="1":keyvalue="0";
        passwordRight = false;
        break;
      case 6:
        keyname="ifenablesuper";
        switchIfenableSuper = val;
        switchIfenableSuper==true?keyvalue="1":keyvalue="0";
        passwordRight = false;
        break;
      case 7:
        keyname="ifbringotherswithpost";
        switchIfBringOthersWithPost = val;
        switchIfBringOthersWithPost==true?keyvalue="1":keyvalue="0";
        passwordRight = false;
        break;
      case 8:
        keyname="ifbringotherswithoutpost";
        switchIfBringOthersWithoutPost = val;
        switchIfBringOthersWithoutPost==true?keyvalue="1":keyvalue="0";
        passwordRight = false;
        break;
      case 9:
        keyname="ifpaymoneybeforeeat";
        switchIftakeMoneyEaten = val;
        switchIftakeMoneyPost=!switchIftakeMoneyEaten;
        switchIftakeMoneyEaten==true?keyvalue="0":keyvalue="1";
        passwordRight = false;
        break;
      case 10:
        keyname="ifpaymoneybeforeeat";
        switchIftakeMoneyPost = val;
        switchIftakeMoneyEaten=!switchIftakeMoneyPost;
        switchIftakeMoneyPost==true?keyvalue="1":keyvalue="0";
        passwordRight = false;
        break;
      case 11:
        keyname="ifmoneyinput";
        switchIftakeMoney = val;
        switchIftakeMoney==true?keyvalue="1":keyvalue="0";
        passwordRight = false;
        break;

    }

    List postdata = new List();

    var tempdata = {
        "config_key": keyname,
        "config_value": keyvalue,
        "config_desc": "moreconfig"
      };
      postdata.add(tempdata);
      print(tempdata);

    var formData = {
      'data': postdata,
    };

    await request('systemconfig', '', formData: formData).then((val) {
      setPriceReturnModel postreturnModel = setPriceReturnModel.fromJson(val);
      if (postreturnModel.code == "0")
        Fluttertoast.showToast(msg: "提交成功");
      else
        Fluttertoast.showToast(msg: "提交失败" + postreturnModel.message);
    });
  }

  Future initDataToDatabase(bool val) async {
    await adminPassword();
    print(passwordRight);
    if(!passwordRight) return;

    List postdata = new List();
    for(int i=1;i<=10;i++) {
      String keyname="";
      String keyvalue="";
      switch(i) {
        case 1:
          keyname="nposted_permit";
          keyvalue="1";
          switchIfnopostEaten=true;
          break;
        case 2:
          keyname="ifenablesaturday";
          keyvalue="1";
          switchIfenablesaturday=true;
          break;
        case 3:
          keyname="ifenablesunday";
          keyvalue="1";
          switchIfenableSunday=true;
          break;
        case 4:
          keyname="ifenablebreakfast";
          keyvalue="1";
          switchIfenableBreakfast=true;
          break;
        case 5:
          keyname="ifenablelunch";
          keyvalue="1";
          switchIfenableLunch=true;
          break;
        case 6:
          keyname="ifenablesuper";
          keyvalue="1";
          switchIfenableSuper=true;
          break;
        case 7:
          keyname="ifbringotherswithpost";
          keyvalue="1";
          switchIfBringOthersWithPost=true;
          break;
        case 8:
          keyname="ifbringotherswithoutpost";
          keyvalue="1";
          switchIfBringOthersWithoutPost=true;
          break;
        case 9:
          keyname="ifpaymoneybeforeeat";
          keyvalue="0";
          switchIftakeMoneyEaten=true;
          switchIftakeMoneyPost=false;
          break;
        case 10:
          keyname="ifmoneyinput";
          keyvalue="0";
          switchIftakeMoney=false;
          break;
      }
      var tempdata = {
        "config_key": keyname,
        "config_value": keyvalue,
        "config_desc": "moreconfig"
      };
      postdata.add(tempdata);
    }


    var formData = {
      'data': postdata,
    };
    print(formData.toString());
    await request('systemconfig', '', formData: formData).then((val) {
      setPriceReturnModel postreturnModel = setPriceReturnModel.fromJson(val);
      if (postreturnModel.code == "0"){
        Fluttertoast.showToast(msg: "提交成功");
        setState(() {

        });
      }
      else
        Fluttertoast.showToast(msg: "提交失败" + postreturnModel.message);
    });
  }

  Widget _textWidget(TextEditingController controller,String title){
    return Container(
      margin: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(15)),
      child: Row(
        children: <Widget>[
          Container(
            child: Text(
              title,
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(28),
                  fontWeight: FontWeight.w600
              ),
            ),
          ),
          Container(
            width: ScreenUtil().setSp(370),
            child: TextField(
              controller: controller,
              // maxLength: 6,
              maxLines: 1,
              // cursorWidth: 5,
              decoration: InputDecoration(
                hintText: '   请输入',
                hintStyle: TextStyle(
                  fontSize: ScreenUtil().setSp(24),
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              keyboardType: title=="密码:"?TextInputType.text:TextInputType.number,
              obscureText:title=="密码:"?true:false,
            ),
          ),
        ],
      ),
    );
  }
}



