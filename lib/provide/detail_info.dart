import 'package:flutter/material.dart';
import 'package:flutter_canteen/model/details.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'dart:convert';

class DetailsInfoProvide with ChangeNotifier{

  foodDetails foodsInfo =null;
  List<foodDetailsDataFoodComments> commentlist=[];
  bool isLeft = false;
  bool isRight = true;
  int page=0;  //列表页数，当改变大类或者小类时进行改变
  String noMoreText = ''; //显示更多的表示

  //从后台获取商品信息,加载所有评论，
  getFoodsInfo(String id ) async{
    page=1;
    print("page:"+'$page');
    var formData = { 'dish_id':id,
    'start_position':(page-1)*10,
    'end_position':(page-1)*10+9,
      'user_id':null,
      'meal_type':null,
      'order_date':null,
      "mealstat_id":null
    };

    await request('foodEvaluation', '',formData:formData).then((val){
      var responseData= val;
      foodsInfo=foodDetails.fromJson(responseData);
      commentlist=foodsInfo.data.foodComments;
      notifyListeners();
    });
  }

  //从后台获取商品信息,加载用户单独评论，
  getUserFoodsInfo(String user_id,String ordernumber) async{
    var formData = {'dish_id':null,
      'start_position':0,
      'end_position':200,
      'user_id':user_id,
      "mealstat_id":ordernumber
      //'meal_type':meal_type,
      //'order_date':order_date
    };

    await request('foodEvaluation', '',formData:formData).then((val){
      print("aaaa");
      var responseData= val;
      //var responseData=val;
      print(responseData);
      foodsInfo=foodDetails.fromJson(responseData);
      commentlist=foodsInfo.data.foodComments;

      notifyListeners();
    });
  }

  //改变tabBar的状态
  changeLeftAndRight(String changeState){
    if(changeState=='left'){
      isLeft=true;
      isRight=false;
    }else{
      isLeft=false;
      isRight=true;
    }
    notifyListeners();

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
  addCommentsList(foodDetails details){
    commentlist.addAll(details.data.foodComments);
    notifyListeners();
  }

}