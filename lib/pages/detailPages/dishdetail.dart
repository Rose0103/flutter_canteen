import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_canteen/model/categoryFoodsList.dart';
import 'package:flutter_canteen/pages/detailPages/details_tabbar.dart';
import 'package:flutter_canteen/provide/category_foods_list.dart';
import 'package:flutter_canteen/provide/child_category.dart';
import 'package:flutter_canteen/provide/detail_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import 'package:flutter_canteen/pages/detailPages/details_top_area.dart';
import 'package:flutter_canteen/pages/detailPages/detail_web.dart';
import 'package:flutter_canteen/config/param.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_canteen/pages/foodManage/addCaiPin.dart';
import 'package:flutter_canteen/otherfunction/showDialog.dart';

class DetailsPage extends StatelessWidget {
  final String foodsId;

  DetailsPage(this.foodsId);

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
              Provide.value<DetailsInfoProvide>(context).foodsInfo = null;
              Navigator.pop(context);
            },
          ),
          actions: usertype == "1"
              ? <Widget>[
                  FlatButton(
                    onPressed: () async{
                      String tips="是否确认编辑该菜品?";
                      String result=await chooseDialog(context,tips);
                      if(result=='cancel')
                      {
                        return;
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddCaiPinPage("00002")));
                      //Appliaction.router.navigateTo(context, "/addcaipin");
                    },
                    child: new Text(
                      '编辑菜品',
                      style: new TextStyle(color: Colors.black),
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      String tips="是否确认删除该菜品?";
                    String result=await chooseDialog(context,tips);
                     if(result=='cancel')
                     {
                       return;
                     }
                      _deletecaipin(context);
                      Provide.value<DetailsInfoProvide>(context).foodsInfo =
                          null;
                      Navigator.of(context).pop();
                    },
                    child: new Text(
                      '删除菜品',
                      style: new TextStyle(color: Colors.black),
                    ),
                  )
                ]
              : null,
          title: Text(
            '菜品详细',
            style: TextStyle(color: Colors.black,
                fontSize: ScreenUtil().setSp(40),
                fontWeight:FontWeight.w500),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
        ),
        body: FutureBuilder(
            future: _getBackInfo(context),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                    child: ListView(
                  children: <Widget>[
                    DetailsTopArea(),
                    DetailsTabBar(),
                    DetailsWeb()
                  ],
                ));
              } else {
                return Text('加载中........');
              }
            }));
  }

  Future _getBackInfo(BuildContext context) async {
    await Provide.value<DetailsInfoProvide>(context).getFoodsInfo(foodsId);
    return '完成加载';
  }

  void _deletecaipin(BuildContext context) async {
    List<int> dish_id = new List();
    dish_id.add(Provide.value<DetailsInfoProvide>(context)
        .foodsInfo
        .data
        .foodInfo
        .dishId);
    var datatext = {"canteen_id": 1, "type": "delete", "dish_id": dish_id};
    FormData data = FormData.fromMap({"dish_content": jsonEncode(datatext)});
    await request('foodEntry', '', formData: data).then((val) {
      if(val.toString()=="false")
      {
        return;
      }
      var data = val;
      if (data == null) {
        Fluttertoast.showToast(
            msg: "提交失败，网络或服务器错误",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: floaststaytime,
            backgroundColor: Theme.of(context).primaryColor,
            textColor: Colors.pink);
        return;
      }
      String code = data['code'].toString();
      String message = data['message'].toString();
      if (code == "0") {
        Fluttertoast.showToast(
            msg: "删除成功",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: floaststaytime,
            backgroundColor: Theme.of(context).primaryColor,
            textColor: Colors.pink);
          Provide.value<ChildCategory>(context).changeChildIndex(
              categoryIndex, categoryBigModelDataSecondaryCategoryId);
          _getFoodList(context, categoryBigModelDataSecondaryCategoryId);
        } else {
        Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: floaststaytime,
            backgroundColor: Theme.of(context).primaryColor,
            textColor: Colors.pink);
      }
    });
  }

  //得到商品列表数据
  void _getFoodList(context,String categorySubId) {

    var data={
      'canteen_id':canteenID,
      'category':categorySubId,
      'dish_id':null
    };
    /*if(categorySubId.trim().length==0||categorySubId==null)
    data={
      'canteen_id':canteenID,
      'category':null,
      'dish_id':null
    };*/

    request('getFoodDish', '',formData:data ).then((val){
      if(val.toString()=="false")
      {
        return;
      }
      var  data = val;
      CategoryFoodsListModel foodsList=  CategoryFoodsListModel.fromJson(data);
      Provide.value<CategoryFoodsListProvide>(context).getFoodsList(foodsList.data.foodInfoList);
    });
  }
}
