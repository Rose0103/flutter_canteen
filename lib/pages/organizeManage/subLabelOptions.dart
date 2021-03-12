import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_canteen/pages/deadlineAndPricePage/postDeadLinePage.dart';
import 'package:flutter_canteen/pages/deadlineAndPricePage/setPricePage.dart';
import 'package:flutter_canteen/pages/orderPage/clientorder_mainPage.dart';
import 'package:flutter_canteen/pages/organizeManage/countingClearing.dart';
import 'package:flutter_canteen/pages/personnelManagement/addPersonnel.dart';
import 'package:flutter_canteen/pages/personnelManagement/addnew_person_page1.dart';
import 'package:flutter_canteen/pages/systemSettingPage/otherSettings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class subLabelOpions extends StatefulWidget{
  String name;
  int cID;
  subLabelOpions(this.name,this.cID);
  @override
  State<StatefulWidget> createState() =>_subLabelOpionsState();

}

class _subLabelOpionsState extends State<subLabelOpions>{
  List subData = [
    {"id":0,"name":"早中晚价格设置"},
    {"id":1,"name":"就餐时间设置"},
    {"id":3,"name":"扣款优先级设置"},
    {"id":4,"name":"人员管理"},
  ];
  var descIndex = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  AlertDialog(
      title: Text(widget.name,maxLines: 1, overflow: TextOverflow.ellipsis,),
      content: new Container(
        width: ScreenUtil().setSp(200),
        height: ScreenUtil().setSp(300),
        decoration: new BoxDecoration(
          border: new Border.all(color: Colors.black, width: 0.5),
          boxShadow: [BoxShadow(color: Colors.white)],
        ),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: subData.length,
            itemBuilder: (context,index){
              return Container(
                  color: descIndex==subData[index]['id']?Color.fromRGBO(236, 160, 139, 1.0):Colors.white,
                  child: ListTile(
                    title: Text(subData[index]['name'],style: TextStyle(fontSize: 18.0),),
                    onTap: (){
                      descIndex = subData[index]['id'];
                      setState(() {});
                    },
                  )
              );
            }
        ),

      ),
      actions: <Widget>[
        FlatButton(
          child: Text('取消'),
          onPressed: () =>
              Navigator.of(context).pop(false),
        ),
        FlatButton(
            child: Text('确认'),
            onPressed: () {
              choseBtn(descIndex,widget.cID,widget.name);
            }
        ),
      ],
    );;
  }

 void choseBtn(int id,int orgId,String orgName){
    print("##############id:${id},orgID:${orgId},orgName:${orgName}");
    if(id==0){//早中晚价格设置
      Navigator.push(context, MaterialPageRoute(builder: (context)=>setPricePage(orgId: orgId,)));
    }else if(id==1){//就餐时间设置
      Navigator.push(context, MaterialPageRoute(builder: (context)=>postDeadLinePage(orgId: orgId,)));
    }
    else if(id==3){//扣款优先级设置
      Navigator.push(context, MaterialPageRoute(builder: (context)=>CountingClearing(orgName,orgId)));
    }
    else if(id==4){//扣款优先级设置
      Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPersonnel(orgId)));
    }
  }
}

