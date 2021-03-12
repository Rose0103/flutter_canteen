import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_canteen/model/serchCateenNameModel.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'dart:convert';

class searchcanteennameProvide with ChangeNotifier{
  searchcanteennameModel searchcanteennamedata = null; //人员信息
  List<Canteens> canteensdata;
  //从后台模糊匹配餐厅名
  Future searchcanteennameInfo(String cateenName) async{
   // if(cateenName=="") cateenName="999999";
    var formData = {'canteen_name':cateenName};
    print('canteen_name'+cateenName);
    await request('searchcanteenname', '',formData:formData).then((val){
      print(val);
      var responseData= val;
      //var responseData=val;
      print(responseData);
      searchcanteennamedata=searchcanteennameModel.fromJson(responseData);
      if(searchcanteennamedata.data==null)
        canteensdata.clear();
      else
      canteensdata=searchcanteennamedata.data;
      notifyListeners();
    });
  }

}