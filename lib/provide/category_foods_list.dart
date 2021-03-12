import 'package:flutter/material.dart';
import 'package:flutter_canteen/model/categoryFoodsList.dart';


class CategoryFoodsListProvide with ChangeNotifier{

  List<CategoryFoodsListModelDataFoodInfoList> foodsList = [ ];

  //点击大类时更换商品列表
  getFoodsList(List<CategoryFoodsListModelDataFoodInfoList> list){

    foodsList=list;
    notifyListeners();
  }
  //上拉加载列表
  addFoodsList(List<CategoryFoodsListModelDataFoodInfoList> list){
    foodsList.addAll(list);
    notifyListeners();
  }
}