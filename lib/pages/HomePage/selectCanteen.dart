import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_canteen/common/database_helper.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/model/userandCanteen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../client_index_page.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_canteen/model/baoCanPriceModel.dart';
import 'package:flutter_canteen/model/deadlinemodel.dart';
import 'clientHomePage.dart';
import 'package:flutter_canteen/pages/manager_index_page.dart';


class SelectCanteen extends StatefulWidget{

  List canteenlist;
  String canteenname;
  int canteenid;
  SelectCanteen(this.canteenlist,this.canteenname);

  @override
  State<SelectCanteen> createState() => _SelectCanteenState();

}

class _SelectCanteenState extends State<SelectCanteen>{

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("请选择食堂"),
      content: new Container(
        width: ScreenUtil().setSp(200),
        height: ScreenUtil().setSp(300),
        decoration: new BoxDecoration(
          border: new Border.all(color: Colors.black, width: 0.5),
          boxShadow: [BoxShadow(color: Colors.white)],
        ),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.canteenlist.length,
            itemBuilder: (context,index){
              var descIndex = widget.canteenlist.length - 1 - index;
              var item = widget.canteenlist[descIndex].canteenName ;
              var id = widget.canteenlist[descIndex].canteenId;
              return Container(
                color: item==widget.canteenname?Color.fromRGBO(236, 160, 139, 1.0):Colors.white,
                child: ListTile(
                  title: Text(item,style: TextStyle(fontSize: 18.0),),
                  onTap: (){
                    widget.canteenid = id;
                    widget.canteenname = item;
                    setState(() {});
                    print(widget.canteenid);
                  },
                ),
              );
            }
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('取消',style: TextStyle(color: Colors.white,fontSize: 20.0),),
          color: Colors.black26,
          onPressed: () =>
              Navigator.of(context).pop(false),
        ),
        FlatButton(
          child: Text('确定',style: TextStyle(color: Colors.white,fontSize: 20.0),),
          color: Colors.orangeAccent,
          onPressed: () async {
            if(widget.canteenid.toString()=='null'||widget.canteenname==null){
              Navigator.pop(context);
            }else{
              canteenID = widget.canteenid.toString();
              canteenName = widget.canteenname;
              var db = new DatabaseHelper();
              await db.updateRecord(new UserAndCanteen(user_id: int.parse(userID),canteen_id: int.parse(canteenID),canteen_name: canteenName));
              //modify by wanchao 2020-11-23 添加获取食堂信息
              _getsystemconfig();
              Navigator.pop(context,true);
              //modify by gaoyang 2020-11-24    超级管理员，用户类型3， 首页添加切换食堂功能
              if(usertype == "2") {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ClientIndexPage()));
              }else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ManagerIndexPage()));
              }
            }
          },
        ),
      ],
    );
  }

  _getsystemconfig() async {
    await requestGet('getdeadline', '?canteen_id='+canteenID).then((val) {
      var data = val;
      GetdeadlineModel getdeadlineModel = GetdeadlineModel.fromJson(data);
      if (getdeadlineModel.code == "0") {
        breakfastdeadline = getdeadlineModel.data.breakfastDeadline;
        lunchdeadline = getdeadlineModel.data.lunchDeadline;
        dinnerdeadline = getdeadlineModel.data.dinnerDeadline;
      } else {
        print("获取报餐截止时间失败，启用默认值");
      }
    });

    await requestGet('systemconfig', '?config_desc=报餐&canteen_id=${canteenID}').then((val) {
      sysConfigModel getpriceModelData = sysConfigModel.fromJson(val);
      if (getpriceModelData.code == "0") {
        if(getpriceModelData.data.length!=0){
          for (int i = 0; i < getpriceModelData.data.length; i++) {
            if (getpriceModelData.data[i].configKey == "0")
              breakfastprice = getpriceModelData.data[i].configValue;
            if (getpriceModelData.data[i].configKey == "1")
              lunchprice = getpriceModelData.data[i].configValue;
            if (getpriceModelData.data[i].configKey == "2")
              superprice = getpriceModelData.data[i].configValue;
          }
        } else {
          breakfastprice = '10.0';
          lunchprice = '20.0';
          superprice = '20.0';
        }
      }
    });
    await requestGet('systemconfig', '?config_desc=moreconfig&canteen_id=${canteenID}').then((val) {
      sysConfigModel sysconfModelData = sysConfigModel.fromJson(val);
      if (sysconfModelData.code == "0") {
        if (sysconfModelData.data.length == 0) {
          return;
        } else {
          for (int i = 0; i < sysconfModelData.data.length; i++) {
            //不报餐是否允许吃饭
            if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "noposted_permit") {
              sysconfModelData.data[i].configValue.trim() == "1"
                  ? switchIfnopostEaten = true
                  : switchIfnopostEaten = false;
            } else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifenablesaturday") {
              sysconfModelData.data[i].configValue.trim() == "1"
                  ? switchIfenablesaturday = true
                  : switchIfenablesaturday = false;
            } else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifenablesunday") {
              sysconfModelData.data[i].configValue.trim() == "1"
                  ? switchIfenableSunday = true
                  : switchIfenableSunday = false;
            } else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifenablebreakfast") {
              sysconfModelData.data[i].configValue.trim() == "1"
                  ? switchIfenableBreakfast = true
                  : switchIfenableBreakfast = false;
            } else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifenablelunch") {
              sysconfModelData.data[i].configValue.trim() == "1"
                  ? switchIfenableLunch = true
                  : switchIfenableLunch = false;
            } else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifenablesuper") {
              sysconfModelData.data[i].configValue.trim() == "1"
                  ? switchIfenableSuper = true
                  : switchIfenableSuper = false;
            }
            else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifmoneyinput") {
              sysconfModelData.data[i].configValue.trim() == "1" ?
              switchIftakeMoney = true : switchIftakeMoney = false;
            }
            else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifbringotherswithpost") {
              sysconfModelData.data[i].configValue.trim() == "1"
                  ? switchIfBringOthersWithPost = true
                  : switchIfBringOthersWithPost = false;
            } else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifbringotherswithoutpost") {
              sysconfModelData.data[i].configValue.trim() == "1"
                  ? switchIfBringOthersWithoutPost = true
                  : switchIfBringOthersWithoutPost = false;
            } else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifpaymoneybeforeeat") {
              if (sysconfModelData.data[i].configValue.trim() == "1") {
                switchIftakeMoneyEaten = false;
                switchIftakeMoneyPost = true;
              } else {
                switchIftakeMoneyEaten = true;
                switchIftakeMoneyPost = false;
              }
            }
          }
        }
      }
    });
  }

}