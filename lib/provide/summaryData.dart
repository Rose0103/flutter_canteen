import 'package:flutter/material.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/model/MonthSummaryDataModel.dart';
import 'package:flutter_canteen/model/dayMealModel.dart';
import 'package:flutter_canteen/model/personalSummaryDataModel.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'dart:convert';

class MonthSummaryDataProvide with ChangeNotifier {
  MonthSummaryDataModel monthSummaryData = null; //月统计信息
  MonthSummaryDataModel quickSummaryData = null; //月统计信息
  DayMealModel dayMealModel = null; //日统计信息

  Future getMonthSummaryData(String startdate, String enddate) async {
    //modify by wanchao 2020-11-23  食堂管理员不传org_id，获取所有人员的数据

     var data = {
//        'organize_id': organizeid,
        'start_date': startdate,
        'end_date': enddate
      };
    print(data);
    print("1");
    await request('getMonthSummaryData', '', formData: data).then((val) {
      var returndata = val;
      print(returndata);
      monthSummaryData = MonthSummaryDataModel.fromJson(returndata);
      notifyListeners();
    });
  }

  Future getQuickSummaryData(String startdate, String enddate) async {
    //modify by wanchao 2020-11-23  食堂管理员不传org_id，获取所有人员的数据
//    var data;
//    if(usertype=="1") {
//      data = {
//        'start_date': startdate,
//        'end_date': enddate
//      };
//    }
//    else {
//      data = {
//        'organize_id': organizeid,
//        'start_date': startdate,
//        'end_date': enddate
//      };
//    }
    var data = {
//        'organize_id': organizeid,
      'start_date': startdate,
      'end_date': enddate
    };
    print("2");
    print(data);
    await request('getMonthSummaryData', '', formData: data).then((val) {
      var returndata = val;
//      print(returndata);
      quickSummaryData = MonthSummaryDataModel.fromJson(returndata);
      notifyListeners();
    });
  }
}


class PersonalSummaryDataProvide with ChangeNotifier {
  personalSummaryDataModel personalSummaryData = null; //个人统计信息

  Future getPersonalSummaryData(String UserID, String startdate,
      String enddate) async {
    await requestGet('getMonthSummaryData', '/$UserID/$startdate/$enddate').then((val) {
      var returndata = val;
      print("3");
      print(returndata);

      personalSummaryData = personalSummaryDataModel.fromJson(returndata);
      notifyListeners();
    });
  }

}