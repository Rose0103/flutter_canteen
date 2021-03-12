import 'package:flutter/material.dart';
import 'package:flutter_canteen/otherfunction/showDialog.dart';
import 'package:flutter_canteen/pages/orderConfirmPage/orderConfirmPage.dart';
import 'package:flutter_canteen/pages/personnelManagement/addnew_person_page1.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_canteen/model/baoCanPriceModel.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter/services.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/otherfunction/moneytext.dart';
import 'personnelTableModel.dart';
import 'existingPersonnelList.dart';
import 'dart:convert';
import 'package:flutter_canteen/config/param.dart';

import 'package:flutter/cupertino.dart';
import 'personnelDetailed.dart';
import 'package:flutter_canteen/model/userListModel.dart';


class AddPersonnel extends StatefulWidget {
  int orgId;

  AddPersonnel(this.orgId);

  @override
  State<StatefulWidget> createState() => _AddPersonnel();
}


List<personnellDetailed> personnelList = new List();
class _AddPersonnel extends State<AddPersonnel> {
  TextEditingController _nameController = TextEditingController();

  List<personnellDetailed> fristpersonListData = new List();
  List<personnellDetailed> searchpersonList = new List();

  @override
  void initState() {
    // TODO: implement initState
    personnelList.clear();
    super.initState();
    _getSumUser(widget.orgId.toString());
  }



  @override
  Widget build(BuildContext context) {
    if(personnelRefresh){
      personnelList.clear();
      personnelRefresh = false;
      _getSumUser(widget.orgId.toString());
    }
    personnelRefreshBtn = personnelRefreshAct();
//    getList();
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Image.asset(
                "assets/images/btn_backs.png",
                width: ScreenUtil().setSp(84),
                height: ScreenUtil().setSp(84),
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          centerTitle: true,
          title: Text(
            '查看从属人员',
            style: TextStyle(
                color: Colors.black,
                fontSize: ScreenUtil().setSp(40),
                fontWeight: FontWeight.w500),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          brightness: Brightness.dark,
          /*   elevation: 0.0,*/
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // 触摸收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            alignment: Alignment.topCenter,
            child: Column(
              children: <Widget>[
                searchNameWidget(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        none = true;
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>AddNewPersonPage(widget.orgId)));
                      },
                      child: Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                          padding: EdgeInsets.fromLTRB(18, 3, 18, 3),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.0, color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '添加新人员',
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                              height: 1.4,
                              decoration: TextDecoration.none,
                              decorationStyle: TextDecorationStyle.dashed,
                            ),
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>existingPersonnelList(widget.orgId)));
                      },
                      child: Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                          padding: EdgeInsets.fromLTRB(18, 3, 18, 3),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.0, color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '添加已有人员',
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                              height: 1.4,
                              decoration: TextDecoration.none,
                              decorationStyle: TextDecorationStyle.dashed,
                            ),
                          )),
                    ),
                  ],
                ),
                Expanded(child: SingleChildScrollView(
                  child: PaginatedDataTable(
                      header: Container(
                          child: Text("现有人员",style: TextStyle(fontWeight:FontWeight.w500,color: Colors.red, fontSize: ScreenUtil().setSp(36))),
                        ),
                    rowsPerPage:10,
                    columns: [
                      DataColumn(label: centerText('序号')),
                      DataColumn(label: centerText('姓名')),
                      DataColumn(label: centerText('性别')),
                      DataColumn(label: centerText('手机号码')),
                      DataColumn(label: centerText('是否员工')),
                      DataColumn(label: centerText('操作')),
                      // DataColumn(label: centerText('排序')),
                    ],
                    source: personnTableDataTableSource(personnelList,context),
                  ),
                )
                )
              ],
            ),
          ),
        ));
  }

  Widget searchNameWidget() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(top: ScreenUtil().setSp(5.0)),
        child: Container(
          height: 68.0,
          child: Row(
            children: <Widget>[
              new Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: new Card(
                      child: new Container(
                        width: ScreenUtil().setSp(700),
                        child: new Row(
                          children: <Widget>[
                            SizedBox(width: 10.0,),
                            Icon(Icons.search, color: Colors.grey,),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: TextField(
                                  maxLength:11,
                                  controller: _nameController,
                                  style: TextStyle(fontSize: ScreenUtil().setSp(30.0)),
                                  decoration: new InputDecoration(
                                      contentPadding: EdgeInsets.only(top: 0.0),
                                      hintText: '点我输入搜索', border: InputBorder.none),
                                  onChanged:(v) async{
                                    print(v);
                                    print(v.trim().length);
                                    if(v.trim().length > 0){
                                      searchpersonList.clear();
                                      for(int i = 0 ; i<fristpersonListData.length;i++){
                                        if(fristpersonListData[i].usName.contains(_nameController.text.trim()) || fristpersonListData[i].phoneName.contains(_nameController.text.trim())){
                                          print("**********${fristpersonListData[i].usName}");
                                          searchpersonList.add(personnellDetailed(fristpersonListData[i].usName,fristpersonListData[i].sex,fristpersonListData[i].phoneName,fristpersonListData[i].isemployee,fristpersonListData[i].cID,fristpersonListData[i].userRootOrgId,fristpersonListData[i].isEnabled,fristpersonListData[i].userOrgId,selected:fristpersonListData[i].selected));
                                        }
                                      }
                                      print("###########${searchpersonList.length}");
                                      if(searchpersonList.length>0){
                                        personnelList.clear();
                                        for(int i = 0; i <searchpersonList.length;i++){
                                          personnelList.add(personnellDetailed(searchpersonList[i].usName,searchpersonList[i].sex,searchpersonList[i].phoneName,searchpersonList[i].isemployee,searchpersonList[i].cID,searchpersonList[i].userRootOrgId,searchpersonList[i].isEnabled,searchpersonList[i].userOrgId,selected:searchpersonList[i].selected));
                                        }

                                      }else{
                                        Fluttertoast.showToast(
                                            msg: "没有该用户",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            backgroundColor: Color.fromRGBO(236, 160, 139, 1.0),
                                            textColor: Colors.pink);
                                      }
                                    }else{
                                      personnelList.clear();
                                      for(int i = 0; i <fristpersonListData.length;i++){
                                        personnelList.add(personnellDetailed(fristpersonListData[i].usName,fristpersonListData[i].sex,fristpersonListData[i].phoneName,fristpersonListData[i].isemployee,fristpersonListData[i].cID,fristpersonListData[i].userRootOrgId,fristpersonListData[i].isEnabled,fristpersonListData[i].userOrgId,selected:fristpersonListData[i].selected));
                                      }
                                    }
                                    setState(() {
                                    });
                                  },
                                ),
                              ),
                            ),
                            new IconButton(
                              icon: new Icon(Icons.cancel),
                              color: Colors.grey,
                              iconSize: 18.0,
                              onPressed: () {
                                _nameController.clear();
                                FocusScope.of(context).requestFocus(FocusNode());
                                personnelList.clear();
                                for(int i = 0; i <fristpersonListData.length;i++){
                                  personnelList.add(personnellDetailed(fristpersonListData[i].usName,fristpersonListData[i].sex,fristpersonListData[i].phoneName,fristpersonListData[i].isemployee,fristpersonListData[i].cID,fristpersonListData[i].userRootOrgId,fristpersonListData[i].isEnabled,fristpersonListData[i].userOrgId,selected:fristpersonListData[i].selected));
                                }
                                setState(() {

                                });
                              },
                            ),
                          ],
                        ),
                      )
                  )
              ),
            ],
          ),
        ),
      ),

//        child: TextFormField(
//            autofocus: false,
//            maxLength: 20,
//            controller: _nameController,
//            decoration: InputDecoration(
//              enabledBorder: outlineborders(Colors.grey),
//              focusedBorder: outlineborders(Theme.of(context).primaryColor),
//              errorBorder: outlineborders(Theme.of(context).primaryColor),
//              focusedErrorBorder:outlineborders(Theme.of(context).primaryColor),
//              fillColor: Theme.of(context).primaryColor,
//              hintStyle: TextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(20.0)),
//              errorStyle:TextStyle(color: Theme.of(context).primaryColor, fontSize: ScreenUtil().setSp(20.0)),
//              //labelText: '手机号码登录',
//              hintText: '搜索人名',
////              icon: Icon(Icons.search,color: Theme.of(context).primaryColor),
//              icon: GestureDetector(
//                onTap: (){
//                  print("=====================${_nameController.text}");
//                  print(_nameController.text.length);
//                  if(_nameController.text.length>0){
//                    searchpersonList.clear();
//                    for(int i = 0 ; i<fristpersonListData.length;i++){
//                      if(fristpersonListData[i].usName.contains(_nameController.text.trim())){
//                        print("**********${fristpersonListData[i].usName}");
//                        searchpersonList.add(personnellDetailed(fristpersonListData[i].usName,fristpersonListData[i].sex,fristpersonListData[i].phoneName,fristpersonListData[i].isemployee,fristpersonListData[i].cID,fristpersonListData[i].userRootOrgId,fristpersonListData[i].isEnabled,fristpersonListData[i].userOrgId,selected:fristpersonListData[i].selected));
//                      }
//                    }
//                    print("###########${searchpersonList.length}");
//                    if(searchpersonList.length>0){
//                      personnelList.clear();
//                      for(int i = 0; i <searchpersonList.length;i++){
//                        personnelList.add(personnellDetailed(searchpersonList[i].usName,searchpersonList[i].sex,searchpersonList[i].phoneName,searchpersonList[i].isemployee,searchpersonList[i].cID,searchpersonList[i].userRootOrgId,searchpersonList[i].isEnabled,searchpersonList[i].userOrgId,selected:searchpersonList[i].selected));
//                      }
//                      setState(() {
//                      });
//                    }else{
//                      Fluttertoast.showToast(
//                          msg: "没有该用户",
//                          toastLength: Toast.LENGTH_SHORT,
//                          gravity: ToastGravity.CENTER,
//                          backgroundColor: Color.fromRGBO(236, 160, 139, 1.0),
//                          textColor: Colors.pink);
//                    }
//                  }else{
//                    personnelList.clear();
//                    for(int i = 0; i <fristpersonListData.length;i++){
//                      personnelList.add(personnellDetailed(fristpersonListData[i].usName,fristpersonListData[i].sex,fristpersonListData[i].phoneName,fristpersonListData[i].isemployee,fristpersonListData[i].cID,fristpersonListData[i].userRootOrgId,fristpersonListData[i].isEnabled,fristpersonListData[i].userOrgId,selected:fristpersonListData[i].selected));
//                    }
//                    setState(() {
//                    });
//                  }
//                },
//                child: Icon(Icons.search,color: Theme.of(context).primaryColor),
//              ),
//              border: OutlineInputBorder(),
//              suffixIcon: GestureDetector(
//                  onTap: () {
//                    _nameController.text="";
//                    personnelList.clear();
//                    for(int i = 0; i <fristpersonListData.length;i++){
//                      personnelList.add(personnellDetailed(fristpersonListData[i].usName,fristpersonListData[i].sex,fristpersonListData[i].phoneName,fristpersonListData[i].isemployee,fristpersonListData[i].cID,fristpersonListData[i].userRootOrgId,fristpersonListData[i].isEnabled,fristpersonListData[i].userOrgId,selected:fristpersonListData[i].selected));
//                    }
//                    setState(() {
//                    });
//                  },
//                  child: Icon(
//                    Icons.clear,
//                    color: Colors.black26,
//                  )
//              ),
//            ),
//            onChanged: (v) {
//
//            }
//        )
    );
  }


  Widget centerText(String text){
    return Center(
      child: Text(
          text,
          style: TextStyle(
              fontSize:ScreenUtil().setSp(26),
              fontWeight: FontWeight.w600
          )
      ),
    );
  }

  Future _getSumUser(String orgId) async {
    await requestGet('managementUserInfo', '?organize_id=${orgId}&root_organize_id=${organizeid}').then((val) {
      if (val.toString() == "false") {
        return;
      }
      if (val != null) {
        setState(() {
          var userData = userListModel.fromJson(val);
          if (userData.data != null && userData.data.length > 0) {
            userData.data.forEach((f) {
              String sexName;
              String isE;
              if(f.sex){
                sexName="男";
              }else{
                sexName="女";
              }
              if(f.isEmployee){
                isE = "是";
              }else{
                isE = "否";
              }
              personnelList.add(personnellDetailed( f.userName.toString(),sexName,f.phoneNum.toString(),"是",f.userId,f.rootOrganizeId,f.isEnabled,f.organizeId));
              fristpersonListData.add(personnellDetailed( f.userName.toString(),sexName,f.phoneNum.toString(),isE,f.userId,f.rootOrganizeId,f.isEnabled,f.organizeId));
            });
          }
        });
      }
    });
  }

  personnelRefreshAct(){
    return FlatButton(
      onPressed: (){
        personnelList.clear();
        personnelRefresh = false;
        _getSumUser(widget.orgId.toString());
        Fluttertoast.showToast(
            msg: "成功",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 2,
            backgroundColor: Color.fromRGBO(236, 160, 139, 1.0),
            textColor: Colors.pink);
        setState(() {
        });
      },
    );
  }
}
