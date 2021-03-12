import 'package:city_pickers/city_pickers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'OnTabChangeListener.dart';

class mineLoveShopCard extends StatefulWidget {
  int index;
  OnTabChangeListener onTabChangeListener;

  mineLoveShopCard(this.index,this.onTabChangeListener);
  @override
  State<StatefulWidget> createState() {
    return index == 0 ? _MineLoveShoptitleCard() : _MineLoveShopCard(onTabChangeListener);
  }
}

class _MineLoveShoptitleCard extends State<mineLoveShopCard> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.white,
      height: ScreenUtil().setWidth(80),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(40), 0, 0, 0),
            child: Text(
              "本单位爱心点",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: ScreenUtil().setSp(32),
                height: 1.0,
                decoration: TextDecoration.none,
                decorationStyle: TextDecorationStyle.dashed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MineLoveShopCard extends State<mineLoveShopCard> {
  OnTabChangeListener onTabChangeListener;
  Result resultArr = new Result();
  int areaId = 110000;
  _MineLoveShopCard(this.onTabChangeListener);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: ScreenUtil().setWidth(80),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(40), 0, 0, 0),
            child: Text(
              "推荐爱心点",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: ScreenUtil().setSp(32),
                height: 1.0,
                decoration: TextDecoration.none,
                decorationStyle: TextDecorationStyle.dashed,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(40), 0, 0, 0),
            child: Text(
              "定位:  ",
              style: TextStyle(
                color: Colors.black,
                fontSize: ScreenUtil().setSp(24),
                height: 1.0,
                decoration: TextDecoration.none,
                decorationStyle: TextDecorationStyle.dashed,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              _clickEventFunc();
            },
            child: Container(
              child: Text(
                resultArr.cityName == null ? "北京" : resultArr.cityName,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(24),
                  height: 1.0,
                  decoration: TextDecoration.none,
                  decorationStyle: TextDecorationStyle.dashed,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(""),
          ),
          InkWell(
            onTap: () {
              _clickEventFunc();
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 0, ScreenUtil().setWidth(20), 0),
              child: Icon(Icons.arrow_right),
            ),
          ),
        ],
      ),
    );
  }

  void _clickEventFunc() async {
    Result tempResult = await CityPickers.showCitiesSelector(
      context: context,
      theme: Theme.of(context).copyWith(primaryColor: Color(0xfffe1314)),
      // 设置主题
      locationCode: resultArr != null
          ? resultArr.areaId ?? resultArr.cityId ?? resultArr.provinceId
          : null, // 初始化地址信息
    );
    if (tempResult != null) {
      setState(() {
        resultArr = tempResult;
        if(onTabChangeListener!=null){
          onTabChangeListener.onTabChange(resultArr);
        }
      });
    }
  }
}
