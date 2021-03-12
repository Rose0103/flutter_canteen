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

class CountingClearing extends StatefulWidget {
  String orgname;
  int orgId;
  CountingClearing(this.orgname,this.orgId);
  @override
  State<StatefulWidget> createState() =>_CountingClearing();

}

class _CountingClearing extends State<CountingClearing> {
  TextEditingController _PasswordController = TextEditingController();
  bool password=false;

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
                widget.orgname + '设置',
                style: TextStyle(color: Colors.black,
                    fontSize: ScreenUtil().setSp(40),
                    fontWeight: FontWeight.w500),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              brightness: Brightness.dark,
              /*   elevation: 0.0,*/
            ),
            body: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SwitchListTile(
                          title: Text("点券月底清零"),
                          value: switchCountingMonthClear,
                          onChanged: (value) {
                            switchCountingMonthClear = value;
                            setState(() {});
                          }),
                      SwitchListTile(
                          title: Text("优先扣点券"),
                          value: switchPreferentialDeduction,
                          onChanged: (value) {
                            switchPreferentialDeduction = value;
                            if(switchPreferentialDeduction = true){
                              switchPreferentialDeductionMoney = false;
                              switchOnlyMoney = false;
                            }
                            setState(() {});
                          }),
                      SwitchListTile(
                          title: Text("优先扣余额"),
                          value: switchPreferentialDeductionMoney,
                          onChanged: (value) {
                            switchPreferentialDeductionMoney = value;
                            if(switchPreferentialDeductionMoney = true){
                              switchPreferentialDeduction = false;
                              switchOnlyMoney = false;
                            }
                            setState(() {});
                          }),
                      SwitchListTile(
                          title: Text("只扣余额"),
                          value: switchOnlyMoney,
                          onChanged: (value) {
                            switchOnlyMoney = value;
                            if(switchOnlyMoney = true){
                              switchPreferentialDeduction = false;
                              switchPreferentialDeductionMoney = false;
                            }
                            setState(() {});
                          }),
                      Row(
                        children: <Widget>[
                          submitButton(context),
                          ConfirmButton(context),
                        ],
                      )
                    ]
                )
            ))
    );
  }
  Widget submitButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 30.0,top: 30.0),
      child: RaisedButton(
          child: Text("重置为默认设置"),
          color: Theme.of(context).primaryColor,
          highlightColor: Theme.of(context).primaryColor,
          colorBrightness: Brightness.dark,
          splashColor: Colors.grey,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          onPressed: () async {
            initDataToDatabase(password) ;
            setState(() {
            });
          }),
    );
  }
  Widget ConfirmButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 30.0,top: 30.0),
      child: RaisedButton(
          child: Text("提交为更改设置"),
          color: Theme.of(context).primaryColor,
          highlightColor: Theme.of(context).primaryColor,
          colorBrightness: Brightness.dark,
          splashColor: Colors.grey,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          onPressed: () async {
            putSubmit(password);
            setState(() {
            });
          }),
    );
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
                      password=true;
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

  _getsystemconfig() async {
    await requestGet('systemconfig', '?config_desc=moreconfig&canteen_id=${canteenID}').then((val) {
      sysConfigModel sysconfModelData = sysConfigModel.fromJson(val);
      if (sysconfModelData.code == "0") {
        if (sysconfModelData.data.length == 0)
          initDataToDatabase(password);
        else {
          for (int i = 0; i < sysconfModelData.data.length; i++) {
            if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifmonthclear||${widget.orgId}") {
              sysconfModelData.data[i].configValue.trim() == "1" ?
              switchCountingMonthClear = true : switchCountingMonthClear = false;
            } else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "iffirst_money||${widget.orgId}") {
              if (sysconfModelData.data[i].configValue.trim() == "1") {
                switchPreferentialDeduction = true;
                switchPreferentialDeductionMoney = false;
                switchOnlyMoney = false;
              }else if (sysconfModelData.data[i].configValue.trim() == "2") {
                switchPreferentialDeduction = false;
                switchPreferentialDeductionMoney = true;
                switchOnlyMoney = false;
              } else if (sysconfModelData.data[i].configValue.trim() == "3") {
                switchPreferentialDeduction = false;
                switchPreferentialDeductionMoney = false;
                switchOnlyMoney = true;
              }
            }
          }
        }
      }
    });
    setState(() {
    });
  }

  //重置
  Future initDataToDatabase(bool val) async {
    await adminPassword();
    print(password);
    if(!password) return;

    List postdata = new List();
    for(int i=1;i<=4;i++) {
      String keyname="";
      String keyvalue="";
      switch(i) {
        case 1:
          keyname = "ifmonthclear"+ "||" + "${widget.orgId}";
          keyvalue = "1";
          switchCountingMonthClear = true;
          break;
        case 2:
          keyname = "iffirst_money"+ "||" + "${widget.orgId}";
          keyvalue = "2";
          switchPreferentialDeduction = false;
          switchPreferentialDeductionMoney = true;
          switchOnlyMoney = false;
          break;
      }
     if(keyvalue != "") {
       var tempdata = {
         "config_key": keyname,
         "config_value": keyvalue,
         "config_desc": "moreconfig",
         "canteen_id": canteenID,
       };
       postdata.add(tempdata);
     }
    }
    var formData = {
      'data': postdata,
    };
    print("laile");
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

//  提交
  Future putSubmit(bool val) async {
    await adminPassword();
    print(password);
    if(!password) return;


    List postdata = new List();
    for(int i=1;i<=4;i++) {
      String keyname = "";
      String keyvalue = "";
      switch (i) {
        case 1:
          keyname = "ifmonthclear" + "||" + "${widget.orgId}";
          switchCountingMonthClear == true ? keyvalue = "1" : keyvalue = "0";
          password = false;
          break;
        case 2:
          keyname = "iffirst_money" + "||" + "${widget.orgId}";
          if(switchPreferentialDeduction == true ){
            keyvalue = "1";
          }
          password = false;
          break;
        case 3:
          keyname = "iffirst_money" + "||" + "${widget.orgId}";
          if(switchPreferentialDeductionMoney == true){
            keyvalue = "2";
          }
          password = false;
          break;
        case 4:
          keyname = "iffirst_money" + "||" + "${widget.orgId}";
          if(switchOnlyMoney == true){
            keyvalue = "3";
          }
          password = false;
          break;
      }

      if(keyvalue != ""){
        var tempdata = {
          "config_key": keyname,
          "config_value": keyvalue,
          "config_desc": "moreconfig",
          "canteen_id": canteenID,
        };
        postdata.add(tempdata);
      }
    }
    var formData = {
      'data': postdata,
    };
    print("99999");
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
