import 'package:flutter/material.dart';
import 'package:flutter_canteen/model/foodscoreModel.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'dart:convert';

class GetScoreDataProvide with ChangeNotifier{
  foodscoreModel foodscoredata = null; //菜品排行信息

  //从后台获取菜品排行信息
  Future gethabbitInfo(String userID) async{
    var formData = { 'userId':userID};

    await requestGet('getUserHabbitInfo', '').then((val){
      var responseData= val;
      //var responseData=val;
      print(responseData);
      foodscoredata=foodscoreModel.fromJson(responseData);
      notifyListeners();
    });
  }

}