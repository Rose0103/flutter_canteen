import 'package:flutter/material.dart';
import 'package:flutter_canteen/model/habbitModel.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'dart:convert';

class GetHabbitDataProvide with ChangeNotifier{
  habbitModel habbitdata = null; //人员信息

  //从后台获取人员兴趣
  Future gethabbitInfo(String userID) async{
    //var param= '/'+userID;
    var param= '';
    await requestGet('getUserHabbitInfo',param).then((val){
      if(val.toString()=="false")
        {
          notifyListeners();
          return;
        }
      var responseData= val;
      print(responseData);
      habbitdata=habbitModel.fromJson(responseData);
      notifyListeners();
    });
  }

}

class PostHabbitDataProvide with ChangeNotifier{
  String code;
  String message;
  //从后台获取人员兴趣
  Future savehabbitInfo(String userID,String habbit) async{
    var formData = { 'user_id':userID,
    'hobby_code':habbit};

    await request('postUserHabbitInfo', '',formData:formData).then((val){
      var responseData= val;
      //var responseData=val;
      print(responseData);
      code=responseData['code'].toString();
      message=responseData['message'];
      notifyListeners();
    });
  }

}