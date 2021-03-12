import 'package:flutter/material.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_canteen/model/deadlinemodel.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'dart:convert';


import 'package:flutter_canteen/model/baoCanPriceModel.dart';
import 'package:flutter/services.dart';


const String MIN_DATETIME = '2019-12-12 00:00:00';
const String MAX_DATETIME = '2051-11-25 23:59:59';

class postDeadLinePage extends StatefulWidget {
  int orgId = -1;

  postDeadLinePage({this.orgId});

  @override
  _postDeadLinePageState createState() => _postDeadLinePageState();
}

class _postDeadLinePageState extends State<postDeadLinePage> {
  TextEditingController _breakfastController = TextEditingController();
  TextEditingController _lunchController = TextEditingController();
  TextEditingController _superController = TextEditingController();

  FocusNode _commentFocus = FocusNode();//控制输入框焦点

  TextEditingController _startbreakfastController = TextEditingController();
  TextEditingController _endbreakfastController = TextEditingController();

  TextEditingController _startlunchController = TextEditingController();
  TextEditingController _endlunchController = TextEditingController();

  TextEditingController _startsuperController = TextEditingController();
  TextEditingController _endsuperController = TextEditingController();

  String _format = 'H时:mm分';
  DateTime _dateTime;
  bool isfirst = true;

  @override
  Widget build(BuildContext context) {
    if (isfirst) {
     if(widget.orgId == null||widget.orgId<0){
       _getDeadLine();
     }else{
       _getDeadLineByOrganize();
     }
      isfirst = false;
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
                '设置报餐截止时间',
                style: TextStyle(color: Colors.black,
                    fontSize: ScreenUtil().setSp(40),
                    fontWeight:FontWeight.w500),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              brightness: Brightness.dark,
              /*   elevation: 0.0,*/
            ),
            body: Container(
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                  inputDeaDline("早餐报餐截止时间", 0),
                  inputDeaDline("中餐报餐截止时间", 1),
                  inputDeaDline("晚餐报餐截止时间", 2),
                  inputEatingDeaDline("早餐就餐时段", 3, 4),
                  inputEatingDeaDline("中餐就餐时段", 5, 6),
                  inputEatingDeaDline("晚餐就餐时段", 7, 8),
                  submitButton(context),
                ])))));
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
                  autofocus: false,
                  focusNode: _commentFocus,
                  controller: type == 0
                      ? _breakfastController
                      : type == 1 ? _lunchController : _superController,
                  decoration: InputDecoration(
                      hintText: title,
                      icon: Icon(Icons.access_time),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(5.0)),
                  onTap: () {
                    _commentFocus.unfocus();
                    _showTimePicker(title, type);
                  })
            ]));
  }

  Widget inputEatingDeaDline(String title, int typestart, int typeend) {
    return
      Container(
        padding: EdgeInsets.fromLTRB(
        ScreenUtil().setSp(32.0),
    ScreenUtil().setSp(20.0),
    ScreenUtil().setSp(32.0),
    ScreenUtil().setSp(0.0)),
    child:Column(
          children: <Widget>[
          Text(title,
          style: TextStyle(
            fontSize: 20,
            color: Colors.red,
          )),
        Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              width:  ScreenUtil().setSp(320),
              child: TextFormField(
                  focusNode: _commentFocus,
                  autofocus: false,
                  controller: typestart == 3
                      ? _startbreakfastController
                      : typestart == 5
                          ? _startlunchController
                          : _startsuperController,
                  decoration: InputDecoration(
                      hintText: "开始时间",
                      icon: Icon(Icons.access_time),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(5.0)),
                  onTap: () {
                    _commentFocus.unfocus();
                    _showTimePicker(title, typestart);
                  })),
          Text("至",
              style: TextStyle(
                fontSize: 15,
                color: Colors.red,
              )),
          Container(
              width:  ScreenUtil().setSp(320),
              child: TextFormField(
                  focusNode: _commentFocus,
                  autofocus: false,
                  controller: typeend == 4
                      ? _endbreakfastController
                      : typeend == 6
                          ? _endlunchController
                          : _endsuperController,
                  decoration: InputDecoration(
                      hintText: "结束时间",
                      icon: Icon(Icons.access_time),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(5.0)),
                  onTap: () {
                    _commentFocus.unfocus();
                    _showTimePicker(title, typeend);
                  })),
        ]),
          ]));
  }

  void _showTimePicker(String title, int type) {
    _dateTime = DateTime.now();
    DatePicker.showDatePicker(
      context,
      minDateTime: DateTime.parse(MIN_DATETIME),
      maxDateTime: DateTime.parse(MAX_DATETIME),
      initialDateTime: DateTime.now(),
      dateFormat: _format,
      pickerMode: DateTimePickerMode.time,
      // show TimePicker
      pickerTheme: DateTimePickerTheme(
        title: Container(
            decoration: BoxDecoration(color: Color(0xFFEFEFEF)),
            width: double.infinity,
            height: 56.0,
            alignment: Alignment.center,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //modify by gaoyang 2020-11-24   按钮位置互换
                  RaisedButton(
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                      padding: EdgeInsets.all(15.0),
                      child: Text("取消"),
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  Text(
                    title,
                    style: TextStyle(color: Colors.green, fontSize: 18.0),
                  ),
                  RaisedButton(
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                      padding: EdgeInsets.all(15.0),
                      child: Text("确定"),
                      textColor: Colors.white,
                      onPressed: () {
                        String strdateTime =
                            '${_dateTime.hour.toString().padLeft(2, '0')}:${_dateTime.minute.toString().padLeft(2, '0')}:00';
                        switch (type) {
                          case 0:
                            _breakfastController.text = strdateTime;
                            break;
                          case 1:
                            _lunchController.text = strdateTime;
                            break;
                          case 2:
                            _superController.text = strdateTime;
                            break;
                          case 3:
                            _startbreakfastController.text = strdateTime;
                            break;
                          case 4:
                            _endbreakfastController.text = strdateTime;
                            break;
                          case 5:
                            _startlunchController.text = strdateTime;
                            break;
                          case 6:
                            _endlunchController.text = strdateTime;
                            break;
                          case 7:
                            _startsuperController.text = strdateTime;
                            break;
                          case 8:
                            _endsuperController.text = strdateTime;
                            break;
                        }
                        Navigator.pop(context);
                      }),


                ])),
        titleHeight: 56.0,
      ),
      locale: DateTimePickerLocale.zh_cn,
      //选择器种类
      onClose: () {},
      onCancel: () {
        debugPrint('取消选择');
      },
      onChange: (dateTime, List<int> index) {
        _dateTime = dateTime;
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
        });
      },
    );
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

  _getDeadLine() async {
    await requestGet('systemconfig', '?config_desc=moreconfig&canteen_id=${canteenID}').then((val) {
      sysConfigModel sysconfModelData = sysConfigModel.fromJson(val);
      if (sysconfModelData.code == "0") {
        if (sysconfModelData.data.length == 0) {

        } else {
          for (int i = 0; i < sysconfModelData.data.length; i++) {
            if (sysconfModelData.data[i].configKey.toLowerCase() == "breakfasteatingtime") {
              if(sysconfModelData.data[i].configValue.trim().contains("-")) {
                List listtemp=sysconfModelData.data[i].configValue.trim().split("-");
                _startbreakfastController.text=listtemp[0].toString();
                _endbreakfastController.text=listtemp[1].toString();
              }
            } else if (sysconfModelData.data[i].configKey.toLowerCase() == "luncheatingtime") {
              if(sysconfModelData.data[i].configValue.trim().contains("-")) {
                List listtemp=sysconfModelData.data[i].configValue.trim().split("-");
                _startlunchController.text=listtemp[0].toString();
                _endlunchController.text=listtemp[1].toString();
              }
            } else if (sysconfModelData.data[i].configKey.toLowerCase() == "supereatingtime") {
              if(sysconfModelData.data[i].configValue.trim().contains("-")) {
                List listtemp=sysconfModelData.data[i].configValue.trim().split("-");
                _startsuperController.text=listtemp[0].toString();
                _endsuperController.text=listtemp[1].toString();
              }
            }else if (sysconfModelData.data[i].configKey.toLowerCase() == "breakfastdeadline") {
              _breakfastController.text = sysconfModelData.data[i].configValue;
            }else if (sysconfModelData.data[i].configKey.toLowerCase() == "lunchdeadline") {
              _lunchController.text = sysconfModelData.data[i].configValue;
            }else if (sysconfModelData.data[i].configKey.toLowerCase() == "superdeadline") {
              _superController.text = sysconfModelData.data[i].configValue;
            }
          }
        }
      }
    });
  }

  _getDeadLineByOrganize() async {
    await requestGet('systemconfig', '?config_desc=moreconfig&canteen_id=${canteenID}').then((val) {
      sysConfigModel sysconfModelData = sysConfigModel.fromJson(val);
      if (sysconfModelData.code == "0") {
        if (sysconfModelData.data.length == 0) {

        } else {
          for (int i = 0; i < sysconfModelData.data.length; i++) {
            if (sysconfModelData.data[i].configKey.toLowerCase() == "breakfasteatingtime||${widget.orgId}") {
              if(sysconfModelData.data[i].configValue.trim().contains("-")) {
                List listtemp=sysconfModelData.data[i].configValue.trim().split("-");
                _startbreakfastController.text=listtemp[0].toString();
                _endbreakfastController.text=listtemp[1].toString();
              }
            } else if (sysconfModelData.data[i].configKey.toLowerCase() == "luncheatingtime||${widget.orgId}") {
              if(sysconfModelData.data[i].configValue.trim().contains("-")) {
                List listtemp=sysconfModelData.data[i].configValue.trim().split("-");
                _startlunchController.text=listtemp[0].toString();
                _endlunchController.text=listtemp[1].toString();
              }
            } else if (sysconfModelData.data[i].configKey.toLowerCase() == "supereatingtime||${widget.orgId}") {
              if(sysconfModelData.data[i].configValue.trim().contains("-")) {
                List listtemp=sysconfModelData.data[i].configValue.trim().split("-");
                _startsuperController.text=listtemp[0].toString();
                _endsuperController.text=listtemp[1].toString();
              }
            } else if (sysconfModelData.data[i].configKey.toLowerCase() == "breakfastdeadline||${widget.orgId}") {
              _breakfastController.text = sysconfModelData.data[i].configValue;
            } else if (sysconfModelData.data[i].configKey.toLowerCase() == "lunchdeadline||${widget.orgId}") {
              _lunchController.text = sysconfModelData.data[i].configValue;
            } else if (sysconfModelData.data[i].configKey.toLowerCase() == "superdeadline||${widget.orgId}") {
              _superController.text = sysconfModelData.data[i].configValue;
            }
          }
        }
      }
    });
  }

  Future putSubmit() async {
//    if (_breakfastController.text.trim().isEmpty) {
//      Fluttertoast.showToast(msg: "请输入早餐报餐截止时间");
//      return;
//    }
//    if (_lunchController.text.trim().isEmpty) {
//      Fluttertoast.showToast(msg: "请输入中餐报餐截止时间");
//      return;
//    }
//    if (_superController.text.trim().isEmpty) {
//      Fluttertoast.showToast(msg: "请输入晚餐报餐截止时间");
//      return;
//    }

    if (_startbreakfastController.text.trim().isEmpty||_endbreakfastController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "请输入早餐就餐时段");
      return;
    }
    if (_startlunchController.text.trim().isEmpty||_endlunchController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "请输入中餐就餐时段");
      return;
    }
    if (_startsuperController.text.trim().isEmpty||_endsuperController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "请输入晚餐就餐时段");
      return;
    }

    List postdata;

    if(widget.orgId==null||widget.orgId<0){
      postdata = _buildList();
    }else{
      postdata = _buildListByOrganize();
    }
     var formData2 = {
      'data': postdata,
    };
    await request('systemconfig', '', formData: formData2).then((val) {
      setPriceReturnModel postreturnModel = setPriceReturnModel.fromJson(val);
      if (postreturnModel.code == "0") {
        Fluttertoast.showToast(msg: "提交成功");
      }else {
        Fluttertoast.showToast(msg: "提交失败" + postreturnModel.message);
      }
    });
  }

  List _buildList(){
    List postData = new List();
    for(int i=1;i<=6;i++) {
      String keyname="";
      String keyvalue="";
      switch(i) {
        case 1:
          keyname="breakfasteatingtime";
          keyvalue=_startbreakfastController.text.trim()+"-"+_endbreakfastController.text.trim();
          break;
        case 2:
          keyname="luncheatingtime";
          keyvalue=_startlunchController.text.trim()+"-"+_endlunchController.text.trim();
          break;
        case 3:
          keyname="supereatingtime";
          keyvalue=_startsuperController.text.trim()+"-"+_endsuperController.text.trim();
          break;
        case 4:
          keyname="breakfastdeadline";
          keyvalue=_breakfastController.text;
          break;
        case 5:
          keyname="lunchdeadline";
          keyvalue=_lunchController.text;
          break;
        case 6:
          keyname="superdeadline";
          keyvalue=_superController.text;
          break;
      }
      var tempdata = {
        "config_key": keyname,
        "config_value": keyvalue,
        "config_desc": "moreconfig",
        "canteen_id":canteenID,
      };
      postData.add(tempdata);
    }
    return postData;
  }

  List _buildListByOrganize(){
    List postData = new List();
    for(int i=1;i<=6;i++) {
      String keyname="";
      String keyvalue="";
      switch(i) {
        case 1:
          keyname="breakfasteatingtime||${widget.orgId}";
          keyvalue=_startbreakfastController.text.trim()+"-"+_endbreakfastController.text.trim();
          break;
        case 2:
          keyname="luncheatingtime||${widget.orgId}";
          keyvalue=_startlunchController.text.trim()+"-"+_endlunchController.text.trim();
          break;
        case 3:
          keyname="supereatingtime||${widget.orgId}";
          keyvalue=_startsuperController.text.trim()+"-"+_endsuperController.text.trim();
          break;
        case 4:
          keyname="breakfastdeadline||${widget.orgId}";
          keyvalue=_breakfastController.text;
          break;
        case 5:
          keyname="lunchdeadline||${widget.orgId}";
          keyvalue=_lunchController.text;
          break;
        case 6:
          keyname="superdeadline||${widget.orgId}";
          keyvalue=_superController.text;
          break;
      }
      var tempdata = {
        "config_key": keyname,
        "config_value": keyvalue,
        "config_desc": "moreconfig",
        "canteen_id":canteenID
      };
      postData.add(tempdata);
    }
    return postData;
  }
}
