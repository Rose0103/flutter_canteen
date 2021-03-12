import 'package:flutter/material.dart';
import 'package:flutter_canteen/model/menu_data.dart';
import 'package:flutter_canteen/model/orderstate.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_canteen/model/categoryFoodsList.dart';
import 'dart:convert';
import 'package:flutter_canteen/config/param.dart';


class MenuDataProvide with ChangeNotifier{
  MenuData menudata = null; //菜单信息
  MenuData personalmenudata=null;
  orderStateModelData orderstatudata = null; //订餐状态信息
  CategoryFoodsListModel dingdanmenudata=null;
  int dingCanState=0;
  //获取报餐菜单信息
  Future getBaoCanMenuFoodsInfo(String id ,String time, int type,int functiontype) async{
    var formData = { 'canteen_id':id,
      'menu_date':time,
    'menu_type': type};

    await request('foodMenuForDay', '',formData:formData).then((val){
      print("wolaile");
      var responseData= val;
      //var responseData=val;
      print(responseData);
      menudata = null; //菜单信息
      personalmenudata=null;
      functiontype==1?menudata=MenuData.fromJson(responseData):personalmenudata=MenuData.fromJson(responseData);
      notifyListeners();
    });
  }

  //获取订餐菜单信息
  Future getDingCanMenuFoodsInfo(String userid ,String time, int type,int CID) async{
    orderstatudata=null;
    menudata = null; //菜单信息
    personalmenudata=null;
    dingdanmenudata=null;
    dingCanState=0;
    //先查订单信息，获取到菜品list
    var param='/$userid/$time/$type';

    await requestGet('getOrderPreState', param).then((val) async {
      print(val);
      if(val!=null)
      {
        //var responseData= json.decode(val.toString());
        //var responseData=val;
        //print(responseData);
        orderstatudata=orderStateModelData.fromJson(val);
        int baocanFlag=-1;
        for(int i=0;i<orderstatudata.data.length;i++)
        {
          if(orderstatudata.data[i].state>3)
            baocanFlag=i;
        }
        //如果有订单信息，再查询订单所对应的菜品信息
        if(baocanFlag!=-1)
        {
          dingCanState=orderstatudata.data[baocanFlag].state;
          //先获取菜品id队列
            List<int> dish_ids=new List();
            for(int i=0;i<orderstatudata.data[baocanFlag].orderList.length;i++)
              {
                dish_ids.add(orderstatudata.data[baocanFlag].orderList[i].dishId);
              }

            //再调用获取菜品接口
            var data={
              'canteen_id':CID,
              'category':null,
              'dish_id':dish_ids
            };

            print(data);
            await request('getFoodDish', '',formData:data ).then((val){
              var  data = val;
              dingdanmenudata=  CategoryFoodsListModel.fromJson(data);
              for(int i=0;i<orderstatudata.data[baocanFlag].orderList.length;i++)
              {
                for(int j=0;j<dingdanmenudata.data.foodInfoList.length;j++)
                if(dingdanmenudata.data.foodInfoList[j].dishId==orderstatudata.data[baocanFlag].orderList[i].dishId)
                  {
                  dingdanmenudata.data.foodInfoList[j].dingnumber=orderstatudata.data[baocanFlag].orderList[i].amount;
                  break;
              }}

            });
        }
        }
        notifyListeners();
      });
    }
  }