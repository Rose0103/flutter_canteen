import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_canteen/model/foodMenuRelease.dart';
import 'package:flutter_canteen/model/orderstate.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_canteen/config/param.dart';
import 'dart:convert';

class FoodMenuReleaseProvide with ChangeNotifier{
  FoodMenuReleaseModel foodmenudata = null; //菜单信息
  OrderStateBackData orderStateback=null;


  //
  Future postFoodMenuInfo(String canteenID,String menu_date,int menu_type,List<int> dish_data) async{
    var formData = json.encode({ "canteen_id": int.parse(canteenID),
      "menu_date": menu_date,
      "menu_type": menu_type,  //0早餐 1中餐 2晚餐
      "dish_id": dish_data
    });
    print(formData);

    await request('foodMenuRelease', '',formData:formData).then((val){
      var responseData= val;
      //var responseData=val;
      print(responseData);
      foodmenudata=FoodMenuReleaseModel.fromJson(responseData);
      notifyListeners();
    });
  }


  Future postDingCanMenuInfo(int meal_type,int user_id,int quantity,int state,double price,String order_date, List<Map> dish_data) async {
    var formData = { "meal_type": meal_type,
      "user_id": user_id,
      "quantity": quantity, //0早餐 1中餐 2晚餐
      "state": state,
      "price": price,
      "order_date": order_date,
      "order_list": dish_data,
      "canteen_id": canteenID,
      "ticket_num":0,
      "cost_type":0
    };
    print(formData);

    await request('addOrUpdateDingCanState', '',formData:formData).then((val){
      var responseData= val;
      //var responseData=val;
      print(responseData);
      orderStateback=OrderStateBackData.fromJson(responseData);
      notifyListeners();
    });
  }

}