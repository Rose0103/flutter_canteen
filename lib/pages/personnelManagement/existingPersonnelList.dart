import 'package:flutter/material.dart';
import 'package:flutter_canteen/otherfunction/showDialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter/services.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/otherfunction/moneytext.dart';
import 'existingPersonnelListDetailed.dart';
import 'existingPersonnelListTableModel.dart';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_canteen/model/userListModel.dart';


class existingPersonnelList extends StatefulWidget {
  int orgId;

  existingPersonnelList(this.orgId);

  @override
  State<StatefulWidget> createState() => _existingPersonnelList();
}
List<existingPersonnelListDetailed> existingPersonnelAddList = new List();
List<existingPersonnelListDetailed> ListBak = new List();
List<existingPersonnelListDetailed> ListBakIndex = new List();
List<existingPersonnelListDetailed> ListAdd = new List();
List<existingPersonnelListDetailed> searchList = new List();
List<existingPersonnelListDetailed> fristListData = new List();





class _existingPersonnelList extends State<existingPersonnelList> {


  bool isFlag = false;
  bool currenFlag = true;
  int pageIndex = 1;
  int pageSize = 10;
  TextEditingController _nameController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    existingPersonnelAddList.clear();
    print("%%%%%%%%%%%%%%%isFlag:${isFlag}");
    fristListData.clear();
    _getSumUser(isFlag);
  }
  Future onGoBack(dynamic value) {
    setState(() {
      personnelRefresh = true;

    });
  }
  @override
  Widget build(BuildContext context) {
//    ListBak.clear();
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
                personnelRefresh = true;
                Navigator.pop(context,onGoBack);
              }),
          centerTitle: true,
          title: Text(
            '添加已有人员',
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
                        isFlag = !isFlag;
                        print("##############isFlag:${isFlag}");
                        existingPersonnelAddList.clear();
                        fristListData.clear();
                        _getSumUser(isFlag);
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
                            '全选',
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
                        ListBakIndex.clear();
                        for(int i = 0 ; i<existingPersonnelAddList.length;i++){
                          ListBakIndex.add(existingPersonnelListDetailed(existingPersonnelAddList[i].usName,existingPersonnelAddList[i].sex,existingPersonnelAddList[i].phoneName,existingPersonnelAddList[i].department,existingPersonnelAddList[i].cID,'',selected:!existingPersonnelAddList[i].selected));
                        }
                        existingPersonnelAddList.clear();
                        for(int i = 0; i <ListBakIndex.length;i++){
                          existingPersonnelAddList.add(existingPersonnelListDetailed(ListBakIndex[i].usName,ListBakIndex[i].sex,ListBakIndex[i].phoneName,ListBakIndex[i].department,ListBakIndex[i].cID,'',selected:ListBakIndex[i].selected));
                        }
                        setState(() {

                        });
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
                            '反选',
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
                        ListAdd.clear();
                        int eLength = existingPersonnelAddList.length-1;
                        for(int i = 0 ; i<existingPersonnelAddList.length;i++){
                          if(existingPersonnelAddList[i].selected){
                          ListAdd.add(existingPersonnelListDetailed(existingPersonnelAddList[i].usName,existingPersonnelAddList[i].sex,existingPersonnelAddList[i].phoneName,existingPersonnelAddList[i].department,existingPersonnelAddList[i].cID,'',selected:currenFlag));
                          }
                        }
                        for(int i = 0 ; i<ListAdd.length;i++){
                          _updateUserOrg(widget.orgId,ListAdd[i].cID,i,ListAdd.length-1);
                        }
//
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
                            '确认添加',
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
               Row(
                 children: <Widget>[
                   Expanded(
                     flex: 1,
                     child: Text(""),
                   ),
                 ],
               ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        ListBakIndex.clear();
                        int index_i = pageIndex-1;
                        for(int i = 0 ; i<existingPersonnelAddList.length;i++){

                          if(i<pageIndex*pageSize&&i>=index_i*pageSize){
                            print("!!!!!!!!!!:${i},${existingPersonnelAddList[i].usName}");
                            ListBakIndex.add(existingPersonnelListDetailed(existingPersonnelAddList[i].usName,existingPersonnelAddList[i].sex,existingPersonnelAddList[i].phoneName,existingPersonnelAddList[i].department,existingPersonnelAddList[i].cID,'',selected:currenFlag));
                          }else{
                            ListBakIndex.add(existingPersonnelListDetailed(existingPersonnelAddList[i].usName,existingPersonnelAddList[i].sex,existingPersonnelAddList[i].phoneName,existingPersonnelAddList[i].department,existingPersonnelAddList[i].cID,'',selected:existingPersonnelAddList[i].selected));
                          }
                        }
                        currenFlag = !currenFlag;
                        existingPersonnelAddList.clear();
                        for(int i = 0; i <ListBakIndex.length;i++){
                          existingPersonnelAddList.add(existingPersonnelListDetailed(ListBakIndex[i].usName,ListBakIndex[i].sex,ListBakIndex[i].phoneName,ListBakIndex[i].department,ListBakIndex[i].cID,'',selected:ListBakIndex[i].selected));
                        }
                        setState(() {

                        });
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
                            '当前页全选',
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
                        ListBakIndex.clear();
                        int index_i = pageIndex-1;
                        for(int i = 0 ; i<existingPersonnelAddList.length;i++){
                          if(i<pageIndex*pageSize&&i>=index_i*pageSize){
                            ListBakIndex.add(existingPersonnelListDetailed(existingPersonnelAddList[i].usName,existingPersonnelAddList[i].sex,existingPersonnelAddList[i].phoneName,existingPersonnelAddList[i].department,existingPersonnelAddList[i].cID,'',selected:!existingPersonnelAddList[i].selected));
                          }else{
                            ListBakIndex.add(existingPersonnelListDetailed(existingPersonnelAddList[i].usName,existingPersonnelAddList[i].sex,existingPersonnelAddList[i].phoneName,existingPersonnelAddList[i].department,existingPersonnelAddList[i].cID,'',selected:existingPersonnelAddList[i].selected));
                          }
                        }
                        existingPersonnelAddList.clear();
                        for(int i = 0; i <ListBakIndex.length;i++){
                          existingPersonnelAddList.add(existingPersonnelListDetailed(ListBakIndex[i].usName,ListBakIndex[i].sex,ListBakIndex[i].phoneName,ListBakIndex[i].department,ListBakIndex[i].cID,'',selected:ListBakIndex[i].selected));
                        }
                        setState(() {

                        });
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
                            '当前页反选',
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
                    onPageChanged: (page){
                      pageIndex = ((page+1)/pageSize).ceil();
                      currenFlag = true;
                    },
//                  initialFirstRowIndex:1,
                      header: Container(
                          child: Text("现有人员",style: TextStyle(fontWeight:FontWeight.w500,color: Colors.red, fontSize: ScreenUtil().setSp(36))),
                        ),
                    actions: <Widget>[

                    ],
                    rowsPerPage:pageSize,
                    columns: [
                      DataColumn(label: centerText('勾选')),
                      DataColumn(label: centerText('姓名')),
                      DataColumn(label: centerText('性别')),
                      DataColumn(label: centerText('手机号码')),
                      DataColumn(label: centerText('现在所属')),
                    ],
                    source: existingPersonnTableDataTableSource(existingPersonnelAddList,context),
                  ),
                ))
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
                                       searchList.clear();
                                        for(int i = 0 ; i<fristListData.length;i++){
                                          if(fristListData[i].usName.contains(_nameController.text.trim()) || fristListData[i].phoneName.contains(_nameController.text.trim())){
                                            print("**********${fristListData[i].usName}");
                                            searchList.add(existingPersonnelListDetailed(fristListData[i].usName,fristListData[i].sex,fristListData[i].phoneName,fristListData[i].department,fristListData[i].cID,'',selected:fristListData[i].selected));
                                          }
                                        }
                                       print("###########${searchList.length}");
                                        if(searchList.length>0){
                                          existingPersonnelAddList.clear();
                                          for(int i = 0; i <searchList.length;i++){
                                            existingPersonnelAddList.add(existingPersonnelListDetailed(searchList[i].usName,searchList[i].sex,searchList[i].phoneName,searchList[i].department,searchList[i].cID,'',selected:searchList[i].selected));
                                          }
                                          setState(() {
                                          });
                                        }else{
                                          Fluttertoast.showToast(
                                              msg: "没有该用户",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              backgroundColor: Color.fromRGBO(236, 160, 139, 1.0),
                                              textColor: Colors.pink);
                                        }
                                      }else{
                                        existingPersonnelAddList.clear();
                                        for(int i = 0; i <fristListData.length;i++){
                                          existingPersonnelAddList.add(existingPersonnelListDetailed(fristListData[i].usName,fristListData[i].sex,fristListData[i].phoneName,fristListData[i].department,fristListData[i].cID,'',selected:fristListData[i].selected));
                                        }
                                        setState(() {
                                        });
                                      }
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
                                 existingPersonnelAddList.clear();
                                  for(int i = 0; i <fristListData.length;i++){
                                    existingPersonnelAddList.add(existingPersonnelListDetailed(fristListData[i].usName,fristListData[i].sex,fristListData[i].phoneName,fristListData[i].department,fristListData[i].cID,'',selected:fristListData[i].selected));
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
//                    searchList.clear();
//                    for(int i = 0 ; i<fristListData.length;i++){
//                      if(fristListData[i].usName.contains(_nameController.text.trim())){
//                        print("**********${fristListData[i].usName}");
//                        searchList.add(existingPersonnelListDetailed(fristListData[i].usName,fristListData[i].sex,fristListData[i].phoneName,fristListData[i].department,fristListData[i].cID,selected:fristListData[i].selected));
//                      }
//                    }
//                    print("###########${searchList.length}");
//                    if(searchList.length>0){
//                      existingPersonnelAddList.clear();
//                      for(int i = 0; i <searchList.length;i++){
//                        existingPersonnelAddList.add(existingPersonnelListDetailed(searchList[i].usName,searchList[i].sex,searchList[i].phoneName,searchList[i].department,searchList[i].cID,selected:searchList[i].selected));
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
//                    existingPersonnelAddList.clear();
//                    for(int i = 0; i <fristListData.length;i++){
//                      existingPersonnelAddList.add(existingPersonnelListDetailed(fristListData[i].usName,fristListData[i].sex,fristListData[i].phoneName,fristListData[i].department,fristListData[i].cID,selected:fristListData[i].selected));
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
//                    existingPersonnelAddList.clear();
//                    for(int i = 0; i <fristListData.length;i++){
//                      existingPersonnelAddList.add(existingPersonnelListDetailed(fristListData[i].usName,fristListData[i].sex,fristListData[i].phoneName,fristListData[i].department,fristListData[i].cID,selected:fristListData[i].selected));
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

  Future _getSumUser(bool flag) async {
    await requestGet('managementUserInfo', '?root_organize_id=${organizeid}').then((val) {
      if (val.toString() == "false") {
        return;
      }
      if (val != null) {
        setState(() {
          var userData = userListModel.fromJson(val);
          if (userData.data != null && userData.data.length > 0) {
            userData.data.forEach((f) {
              if(f.organizeId!=widget.orgId){
                String sexName;
                if(f.sex){
                  sexName="男";
                }else{
                  sexName="女";
                }
                existingPersonnelAddList.add(existingPersonnelListDetailed(f.userName.toString(),sexName,f.phoneNum.toString(),f.organizeName.toString(),f.userId,'',selected: flag));
                fristListData.add(existingPersonnelListDetailed(f.userName.toString(),sexName,f.phoneNum.toString(),f.organizeName.toString(),f.userId,'',selected: flag));
              }

            });
          }
        });
      }
    });
  }


  Future _updateUserOrg(int orgId,int userId,int index,int length) async {
    var formData = {
      "organize_id":orgId,
      "user_id":userId
    };
    print("object:${formData.toString()}");
    await request('managementUserInfo', '',formData: formData).then((val) {
      if (val.toString() == "false") {
        return;
      }
      if (val != null) {
        String code = val['code'].toString();
        if(code=="0"){
            if(index==length){
              existingPersonnelAddList.clear();
              _getSumUser(isFlag);
              Fluttertoast.showToast(
                  msg: "添加完成",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIos: 2,
                  backgroundColor: Color.fromRGBO(236, 160, 139, 1.0),
                  textColor: Colors.pink);
              setState(() {
              });
            }
        }
      }
    });
  }


}
