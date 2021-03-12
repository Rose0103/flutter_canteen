import 'package:flutter/material.dart';
import 'package:flutter_canteen/model/userInfoModel.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'dart:convert';
import 'package:flutter_canteen/common/shared_preference.dart';
import 'package:flutter_canteen/config/param.dart';
class GetUserInfoDataProvide with ChangeNotifier{
  userInfoModel userinfodata = null; //人员信息

  //从后台获取人员信息
  Future getUserInfo(String phoneNum) async{
    //String param="/"+phoneNum;
    String param="";
    userinfodata = null; //人员信息
    await requestGet('getUserInfo', param,).then((val){
      //var responseData= json.decode(val.toString());
      print(val.toString());
      if(val!=null&&val.toString().contains("portrait_new")) {
        userinfodata = userInfoModel.fromJson(val);
      }
      notifyListeners();
    });
  }

}

class PostUserInfoDataProvide with ChangeNotifier{
  String code;
  String message;

  //向后台提交人员信息
  Future postUserInfo(String userName,int sex,int organizeId ,String birthday ,
      String canteenId,String  canteenName,String usertype,int is_employee,String userImage,String featurelast) async{
    code="-1";
    String phone=await KvStores.get(KeyConst.USER_NAME);
    var formData = { 'user_name' :userName,
    'phone_num':phone,
    'sex':sex==1?true:false,
    'organize_id':organizeId,
    'birthday' : birthday,
    'canteen_id' : canteenId,
    'canteen_name' :canteenName,
    'user_type' :int.parse(usertype),
    'is_employee':is_employee==1?true:false,
      'feature': featurelast,
    'portrait_new' : userImage
    };

    await request('postUserInfo', "",formData:formData).then((val){
      var responseData= val;
      print(responseData);
      if(responseData!=null) {
        if (responseData['code'] != null)
        code = responseData['code'].toString();
        if (responseData['message'] != null)
          message = responseData['message'];
      }
      notifyListeners();
    });
  }

}