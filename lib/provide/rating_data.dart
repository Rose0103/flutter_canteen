import 'package:flutter/material.dart';
import 'package:flutter_canteen/model/ratingdata.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'dart:convert';
import 'package:flutter_canteen/config/param.dart';


class RatingDataProvide with ChangeNotifier{
  RatingData ratedata = null; //菜品排行信息
  List<Score> rateFoodList= [];
  int page=1;  //列表页数，当改变大类或者小类时进行改变
  String noMoreText = ''; //显示更多的表示

  //从后台获取菜品排行信息
  Future getRatingDataInfo(String cateenid ) async{
    var formData = { 'canteen_id':canteenID,
      'page':page};

    await requestGet('foodScore', '?canteen_id='+cateenid).then((val){
      var responseData= val;
      //var responseData=val;
      print(responseData);
      ratedata=RatingData.fromJson(responseData);
      rateFoodList=ratedata.data.score;
      notifyListeners();
    });
  }

  //增加Page的方法f
  addPage(){
    page++;
  }

  //改变noMoreText数据
  changeNoMore(String text){
    noMoreText=text;
    notifyListeners();
  }

  //上拉加载列表
  addRatingList(List<Score> foodratelist){
    rateFoodList.addAll(foodratelist);
    notifyListeners();
  }

}