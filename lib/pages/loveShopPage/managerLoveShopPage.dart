import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_canteen/model/managerLoveShopModel.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'dart:convert';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_canteen/model/category.dart';
import 'package:flutter_canteen/model/categoryFoodsList.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import 'package:flutter_canteen/provide/child_category.dart';
import 'package:flutter_canteen/provide/category_foods_list.dart';
import 'package:flutter_canteen/router/application.dart';
import 'package:flutter_canteen/config/param.dart';

class managerLoveShopPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return managerLoveShopState();
  }
}

class managerLoveShopState extends State<managerLoveShopPage> {
  TextEditingController _nameEditingController = new TextEditingController();
  TextEditingController _businessEditingController =
      new TextEditingController();
  TextEditingController _urlEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
            "添加商店",
            style: TextStyle(color: Colors.black,
                fontSize: ScreenUtil().setSp(40),
                fontWeight:FontWeight.w500),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              inputwidgets("名称", _nameEditingController),
              inputwidgets("主营", _businessEditingController),
              inputwidgets("链接", _urlEditingController),
              addButtonWidget(context)
            ],
          ),
        ),
      ),
    );
  }

  Container addButtonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, ScreenUtil().setWidth(20), 0, 0),
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setWidth(20), 0, ScreenUtil().setWidth(20), 0),
      width: double.infinity, //宽度为无穷大
      child: FlatButton(
        color: Theme.of(context).primaryColor,
        highlightColor: Theme.of(context).primaryColor,
        colorBrightness: Brightness.dark,
        splashColor: Colors.grey,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Text("确认添加"),
        onPressed: () {
          commit();
        },
      ),
    );
  }

  Widget inputwidgets(String name, TextEditingController editingController) {
    return Container(
      margin: EdgeInsets.fromLTRB(ScreenUtil().setSp(32),
          ScreenUtil().setSp(32), ScreenUtil().setSp(32), 0.0),
      height: ScreenUtil().setWidth(96),
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
              padding: EdgeInsets.all(ScreenUtil().setWidth(14)),
              child: Align(
                child: Text(
                  name,
                  style: TextStyle(
                      color: Color(0xff333333),
                      fontSize: ScreenUtil().setSp(28)),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(ScreenUtil().setSp(14)),
                  child: Align(
                    child: TextField(
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(
                            0, 0, 0, ScreenUtil().setWidth(24)),
                        border: InputBorder.none, // 去掉下滑线
                        counterText: '', // 去除输入框底部的字符计数
                      ),
                      controller: editingController,
                      style: TextStyle(
                          color: Color(0xff535353),
                          fontSize: ScreenUtil().setSp(28)),
                    ),
                  )),
            )
          ]),
    );
  }

  Future<void> commit() async {
    //Pattern httpPattern = Pattern.compile(pattern);
    if (null != _nameEditingController.text &&
        _nameEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "请输入店名",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: floaststaytime,
          backgroundColor: Theme.of(context).primaryColor,
          textColor: Colors.pink
      );
      return;
    }
    if (null != _businessEditingController.text &&
        _businessEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "请输入主营业务",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: floaststaytime,
          backgroundColor: Theme.of(context).primaryColor,
          textColor: Colors.pink
      );
      return;
    }
    if (null != _urlEditingController.text &&
        _urlEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "请输入url链接",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: floaststaytime,
          backgroundColor: Theme.of(context).primaryColor,
          textColor: Colors.pink
      );
      return;
    }
    var data = {
      'canteen_id': canteenID,
      'area_id': 0.toString(),
      'store_name': _nameEditingController.text,
      'business': _businessEditingController.text,
      'url': _urlEditingController.text
    };

    request('managementStorePutInfo', '', formData: data).then((val) {
      var data = val;
      setState(() {
        managerLoveShopModel model = managerLoveShopModel.fromJson(data);
        if( model.code==0.toString()){
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "添加成功",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: floaststaytime,
              backgroundColor: Theme.of(context).primaryColor,
              textColor: Colors.pink
          );
        }
      });

    });
  }
}
