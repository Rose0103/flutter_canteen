import 'package:flutter/material.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_canteen/model/baoCanPriceModel.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter/services.dart';
import 'package:flutter_canteen/otherfunction/moneytext.dart';
import 'dart:convert';



class setPricePage extends StatefulWidget {
  int orgId = -1;
  setPricePage({this.orgId});
  @override
  _setPricePageState createState() => _setPricePageState();
}

class _setPricePageState extends State<setPricePage> {
  TextEditingController _breakfastPriceController = TextEditingController();
  TextEditingController _lunchPriceController = TextEditingController();
  TextEditingController _superPriceController = TextEditingController();
  bool isfirst=true;


  @override
  Widget build(BuildContext context) {
    if(isfirst) {
      _getPrice();
      isfirst=false;
    }
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
                '设置报餐价格',
                style: TextStyle(color: Colors.black,
                    fontSize: ScreenUtil().setSp(40),
                    fontWeight:FontWeight.w500),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              brightness: Brightness.dark,
              /*   elevation: 0.0,*/
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      inputDeaDline("早餐报餐价格", 0),
                      inputDeaDline("中餐报餐价格", 1),
                      inputDeaDline("晚餐报餐价格", 2),
                      submitButton(context),
                    ]))));
  }

  Widget inputDeaDline(String title, int type) {
    return Container(
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setSp(32.0),
            ScreenUtil().setSp(20.0),
            ScreenUtil().setSp(32.0),
            ScreenUtil().setSp(0.0)),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(title,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                  )),
              TextFormField(
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp("[0-9.]")),
                  LengthLimitingTextInputFormatter(9),
                  MoneyTextInputFormatter()],
                  keyboardType: TextInputType.number,
                  autofocus: false,
                  controller: type == 0
                      ? _breakfastPriceController
                      : type == 1 ? _lunchPriceController : _superPriceController,
                  decoration: InputDecoration(
                      hintText: title,
                      icon: Icon(Icons.attach_money),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(5.0)),)
            ]));
  }



  Widget submitButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      width: double.infinity,
      child: RaisedButton(
          child: Text("提交数据"),
          color: Theme.of(context).primaryColor,
          highlightColor: Theme.of(context).primaryColor,
          colorBrightness: Brightness.dark,
          splashColor: Colors.grey,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          onPressed: () async {
            putSubmit();
          }),
    );
  }

  _getPrice() async{
    print("__________________________：${widget.orgId}");
    if(widget.orgId==null){
      await requestGet('systemconfig', '?config_desc=报餐&canteen_id=${canteenID}').then((val) {
        sysConfigModel getpriceModelData = sysConfigModel.fromJson(val);
        if(getpriceModelData.code=="0")
        {
          for(int i=0;i<getpriceModelData.data.length;i++) {
            if(getpriceModelData.data[i].configKey=="0")
              _breakfastPriceController.text =getpriceModelData.data[i].configValue;
            if(getpriceModelData.data[i].configKey=="1")
              _lunchPriceController.text=getpriceModelData.data[i].configValue;
            if(getpriceModelData.data[i].configKey=="2")
              _superPriceController.text=getpriceModelData.data[i].configValue;
          }
        }
        else
        {
          Fluttertoast.showToast(msg: "获取报餐价格失败");
          _breakfastPriceController.text='10.0';
          _lunchPriceController.text='20.0';
          _superPriceController.text='20.0';
        }
      });
    }else{
      await requestGet('systemconfig', '?config_desc=报餐&canteen_id=${canteenID}').then((val) {
        print(val);

        sysConfigModel getpriceModelData = sysConfigModel.fromJson(val);
        if(getpriceModelData.code=="0")
        {
          for(int i=0;i<getpriceModelData.data.length;i++) {
            if(getpriceModelData.data[i].configKey.contains('_')){
              List str1 =  getpriceModelData.data[i].configKey.split('_');
              if(str1[1]==widget.orgId.toString()){
                if(str1[0] =="0"){
                  _breakfastPriceController.text =getpriceModelData.data[i].configValue;
                }
                if(str1[0] =="1"){
                  _lunchPriceController.text=getpriceModelData.data[i].configValue;
                }
                if(str1[0] =="2"){
                  _superPriceController.text=getpriceModelData.data[i].configValue;
                }
              }
            }
          }
        }
        else
        {
          Fluttertoast.showToast(msg: "获取报餐价格失败");
          _breakfastPriceController.text='10.0';
          _lunchPriceController.text='20.0';
          _superPriceController.text='20.0';
        }
      });
    }

  }

  Future putSubmit() async {
    if (_breakfastPriceController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "请输入早餐报餐价格");
      return;
    }
    if (_lunchPriceController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "请输入中餐报餐价格");
      return;
    }
    if (_superPriceController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "请输入晚餐报餐价格");
      return;
    }
    List postdata=new List();

    if(widget.orgId==null){
      for(int i=0;i<3;i++)
      {
        var tempdata={"config_key":i.toString(),
          "config_value":
          i==0?_breakfastPriceController.text.trim()
              :i==1?_lunchPriceController.text.trim()
              :_superPriceController.text.trim(),
          "config_desc":"报餐"
        };
        postdata.add(tempdata);

        var formData = {
          'data': postdata,

        };
        await request('systemconfig', '', formData: formData).then((val) {

          setPriceReturnModel postreturnModel = setPriceReturnModel.fromJson(val);
          if(postreturnModel.code=="0")
            Fluttertoast.showToast(msg: "提交成功");
          else
            Fluttertoast.showToast(msg: "提交失败"+postreturnModel.message);
        });
      }
    }else{
      for(int i=0;i<3;i++) {
        String keyname="";
        String keyvalue="";
        switch(i) {
          case 0:
            keyname="0_"+widget.orgId.toString();
            keyvalue=_breakfastPriceController.text.trim();
            break;
          case 1:
            keyname="1_"+widget.orgId.toString();
            keyvalue=_lunchPriceController.text.trim();
            switchIfenablesaturday=true;
            break;
          case 2:
            keyname="2_"+widget.orgId.toString();
            keyvalue=_superPriceController.text.trim();
            switchIfenableSunday=true;
            break;
        }
        var tempdata = {
          "config_key": keyname,
          "config_value": keyvalue,
          "config_desc": "报餐",
          'canteen_id':canteenID
        };
        postdata.add(tempdata);
      }
      var formData = {
        'data': postdata,
      };
      print(formData.toString());
      await request('systemconfig', '', formData: formData).then((val) {
        setPriceReturnModel postreturnModel = setPriceReturnModel.fromJson(val);
        if (postreturnModel.code == "0")
          Fluttertoast.showToast(msg: "提交成功");
        else
          Fluttertoast.showToast(msg: "提交失败" + postreturnModel.message);
      });
    }



  }
}
