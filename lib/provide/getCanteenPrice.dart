import 'package:flutter/material.dart';
import 'package:flutter_canteen/model/canteenPrice.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'dart:convert';

class GetScoreDataProvide with ChangeNotifier{
  canteenPriceModel pricedata = null; //菜品排行信息

  //从后台获取菜品排行信息
  Future getCanteenPrice(String canteenID) async{

    await requestGet('getUserHabbitInfo', '/'+canteenID).then((val){
      var responseData= val;
      //var responseData=val;
      print(responseData);
      pricedata=canteenPriceModel.fromJson(responseData);
      notifyListeners();
    });
  }

}