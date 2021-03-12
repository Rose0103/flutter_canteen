import 'package:flutter/material.dart';
import 'package:flutter_canteen/model/organizemodel.dart';
import 'package:flutter_canteen/otherfunction/logutil.dart';
import 'package:flutter_canteen/service/service_method.dart';

class GetOrganizeInfoDataProvide with ChangeNotifier{

  organizeListModel organizeinfodata = null; //组织机构信息

  //从后台获取组织信息
  Future getOrganizeInfo() async{
    //String param="/"+phoneNum;
    String param="";
    organizeinfodata = null; //组织信息
    await requestGet('getorganizeinfo', param,).then((val){
//      var responseData= json.decode(val.toString());
      LogUtil.v("6666:"+val.toString());
      if(val!=null) {
        organizeinfodata = organizeListModel.fromJson(val);
      }
      notifyListeners();
    });
  }
}
