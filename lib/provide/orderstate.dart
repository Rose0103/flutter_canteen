import 'package:flutter/material.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/model/orderstate.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'dart:convert';

class GetOrderStatusProvide with ChangeNotifier{
  orderStateModelData orderstatudata = null; //报餐状态信息
  OrderStateBackData orderStateback=null;
  int id = 0;
  String name = "";

  //查询报餐状态信息
  Future getOrderState(String userid ,String time, int type) async{
    orderstatudata=null;
    var param='/$userid/$time/$type';
    //var param='/1/$time/$type';
    await requestGet('getOrderPreState', param).then((val){
      print("laile");
      print(val);

      if(val!=null) {
        orderstatudata = orderStateModelData.fromJson(val);
        if(orderstatudata.data!=null&&orderstatudata.data.length>0){
          diningCanteenID = orderstatudata.data[0].canteenid.toString();
          dining_status = orderstatudata.data[0].diningStatus.toString();
          print(dining_status);
          _getcanteenList();
        }else{
          dining_status = "";
        }
        notifyListeners();
       }

    }
    );
  }


  //修改报餐状态信息
  Future modifyOrderState(List data) async{
    var formData = {'data': data};
    print("-----");
    print(formData);
    diningCanteenID = data[0]['canteen_id'];
    //modify by wanchao 2020-11-23 添加留餐时的提示
    if(data[0]['state']==1||data[0]['state']==3){
      dinging = false;
      print("3333333333");
    }
//    print(diningCanteenID);
    _getcanteenList();
    await request('addOrUpdateOrderState', '',formData:formData).then((val){
      print(val);
      var responseData= val;
      //var responseData=val;
      orderStateback=OrderStateBackData.fromJson(responseData);
      notifyListeners();
    });
  }

  void  _getcanteenList(){
    for(int i = 0;i<canteenlist.length;i++){
      name =canteenlist[i].canteenName;
      id =  canteenlist[i].canteenId;
      if(id.toString() == diningCanteenID){
        dingingCanteenName = name;
      }
    }
  }

  //查询订餐状态信息
  Future getDingCanState(String userid ,String time, int type) async{
    orderstatudata=null;
    var param='/$userid/$time/$type';
    await requestGet('getOrderPreState', param).then((val){
      print(val);
      if(val!=null)
      {
        var responseData= val;
        //var responseData=val;
        print(responseData);
        orderstatudata=orderStateModelData.fromJson(responseData);
        notifyListeners();
      }});
  }

}