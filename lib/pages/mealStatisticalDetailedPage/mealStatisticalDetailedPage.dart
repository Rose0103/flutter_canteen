import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/model/userListModel.dart';
import 'package:flutter_canteen/pages/mealStatisticalDetailedPage/mealStatisticalDetailed.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_canteen/model/mealDetailModel.dart';

import 'TableModel.dart';
import 'mealStatisticalDetailedModel.dart';

class MealStatisticalDetailedPage extends StatefulWidget {
  String mealtime;
  int mealtype;

  MealStatisticalDetailedPage(this.mealtime, this.mealtype);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MealStatisticalDetailedStates(mealtime, mealtype);
  }
}

class MealStatisticalDetailedStates extends State<MealStatisticalDetailedPage> {
  String mealtime;
  int mealtype;
  mealDetailModel detailModel;
  userListModel dataUserListModel;
  int meal = 0; //报餐用户数
  int mealquatity = 0; //报餐总份数
  int noMeal = 0; //不报餐用户数
  int leaveMeal = 0; //留餐用户数
  int leavequatity = 0; //留餐总份数
  int dingNum = 0; //已用餐用户数
  int noPostMeal = 0; //未报餐用户数
  double zongprice = 0; //总金额

  bool ifload=true;
  List<MealStatisticalDetailed> _data = new List();//全部数据
  List<MealStatisticalDetailed> _datas = new List();//展示的数据

  MealStatisticalDetailedStates(this.mealtime, this.mealtype);
  Map<int, MealStatisticalDetailedModel> mapALL = new Map();
  //普通用户的队列
  Map<int, MealStatisticalDetailedModel> map = new Map();
  MealStatisticalDetailedModel dataMeal;
  static RaisedButton rankUp;
  static RaisedButton rankDown;
  static RaisedButton cancelUserVIP;
  static RaisedButton focusUserVIP;
  static RaisedButton topUserVIP;
  //modify by
  List<DropdownMenuItem> _item = new List();
  String hintStr = "全部机构";
  bool isFrist = true;

  @override
  void initState() {
    rankUp = new RaisedButton(onPressed: ()=>rank_up());
    rankDown = new RaisedButton(onPressed: ()=>rank_down());
    cancelUserVIP = new RaisedButton(onPressed: () => cancel_userVIP());
    focusUserVIP = new RaisedButton(onPressed: () => focus_userVIP());
    topUserVIP = new RaisedButton(onPressed: () => top_userVIP());
    //modify by
    if(usertype=="1"){
      _initItem();
    }
    super.initState();
  }

  //modify by
  void _initItem(){
    _item.clear();
    _item.add(
      new DropdownMenuItem(
          value: -1,
          child: Text(
              '全部机构',
              style: TextStyle(fontWeight:FontWeight.w500, fontSize: ScreenUtil().setSp(36))
          )
      ),
    );
    print(organizeMap.length);
    print(24444444444);
    for(int i=0;i<organizeMap.length;i++){
      _item.add(
        new DropdownMenuItem(
            value: organizeMap.keys.toList()[i],
            child: Text(
                organizeMap[organizeMap.keys.toList()[i]],
                style: TextStyle(fontWeight:FontWeight.w500, fontSize: ScreenUtil().setSp(36))
            )
        ),
      );
    }
  }

  Future _getSumData(mealtime, mealtype) async {

    String params =
        '/' + 0.toString() + '/' + mealtime + '/' + mealtype.toString();

    await requestGet('userMeal', params).then((val) async{
      if (val.toString() == "false") {
        return;
      }
      detailModel = mealDetailModel.fromJson(val);

      //已报餐已用餐的 modify 2020-03-29
      sortByStateAndDiningStatus(1, 1);
      //已留餐已用餐的
      sortByStateAndDiningStatus(3, 1);
      //未报餐，已就餐
      sortByStateAndDiningStatus(0, 1);
      //已报餐未用餐的
      sortByStateAndDiningStatus(1, 0);
      //已留餐未用餐的
      sortByStateAndDiningStatus(3, 0);
      //不报餐的
      sortByStateAndDiningStatus(2, 0);

      //未报餐的
      //modify by
      await _getSumUser();
//      if(usertype=="1"){
//        await _getSumUser(-1);
//      }else if(usertype=="3"){
//        await _getSumUser(organizeid);
//      }
    });
  }

  void sortByStateAndDiningStatus(int state, int diningstatus) {
    for (int i = 0; i < detailModel.data.length; i++) {
      MealStatisticalDetailedModel mealStatisticalDetailedModel =
      new MealStatisticalDetailedModel();
      if (detailModel.data[i].state == state &&
          detailModel.data[i].diningStatus == diningstatus&&detailModel.data[i].canteen_id.toString()==canteenID
      ) {
        mealStatisticalDetailedModel.price = detailModel.data[i].price.toString();
        mealStatisticalDetailedModel.bodyTemperature = detailModel.data[i].bodyTemperature.length==0?"--":detailModel.data[i].bodyTemperature[0].temperature.toString()+"℃";
        print(mealStatisticalDetailedModel.bodyTemperature);
        mealStatisticalDetailedModel.ticketNum = detailModel.data[i].ticket_num.toString();
        mealStatisticalDetailedModel.quantity = detailModel.data[i].quantity.toString();
        mealStatisticalDetailedModel.eatenquantity=detailModel.data[i].eatquantity.toString();
        mealStatisticalDetailedModel.state = detailModel.data[i].state;
        mealStatisticalDetailedModel.mealType = detailModel.data[i].mealType;
        mealStatisticalDetailedModel.diningStatus = detailModel.data[i].diningStatus;
        mapALL[detailModel.data[i].userId]=mealStatisticalDetailedModel;
        if(detailModel.data[i].state == 1){
          meal++;   //报餐用户数
          mealquatity= mealquatity + detailModel.data[i].quantity;    //报餐总份数
        }
        else if (detailModel.data[i].state == 2) {
          noMeal++;           //不报餐用户数
        } else if (detailModel.data[i].state == 3) {
          leaveMeal++;         //留餐用户数
          leavequatity = leavequatity + detailModel.data[i].quantity;        //留餐总份数
        }
        if (detailModel.data[i].diningStatus == 1) {
          dingNum = dingNum+detailModel.data[i].eatquantity;//已就餐用户数
          print("0000000000");
          print(dingNum);
          zongprice = zongprice+detailModel.data[i].price;//就餐总金额
        }
      }
    }
  }


  Future _getSumUser() async {
    String params;
//    if(oid<=0){
//      params = "";
//    }else{
//      params = "?organize_id="+oid.toString();
//    }
    await requestGet('managementUserInfo', "").then((val) {
      if (val.toString() == "false") {
        return;
      }
      //var data = json.decode(val.toString());
      map.clear();
      mapVIP.clear();
      setState(() {
        dataUserListModel = userListModel.fromJson(val);
        for (int i = 0; i < dataUserListModel.data.length; i++) {
          if (mapALL.containsKey(dataUserListModel.data[i].userId)) {
            mapALL[dataUserListModel.data[i].userId].userName =
                dataUserListModel.data[i].userName;
            mapALL[dataUserListModel.data[i].userId].phoneNum =
                dataUserListModel.data[i].phoneNum;
            mapALL[dataUserListModel.data[i].userId].userlevel =
                dataUserListModel.data[i].level;
            mapALL[dataUserListModel.data[i].userId].userId=
                dataUserListModel.data[i].userId;
            //modify by
            mapALL[dataUserListModel.data[i].userId].orgID=
                dataUserListModel.data[i].rootOrganizeId;
            mapALL[dataUserListModel.data[i].userId].organizeName=
                dataUserListModel.data[i].organizeName;
          } else {
            MealStatisticalDetailedModel mealStatisticalDetailedModel =
            new MealStatisticalDetailedModel();
            mealStatisticalDetailedModel.price = "--";
            mealStatisticalDetailedModel.bodyTemperature  = "--" ;
            mealStatisticalDetailedModel.ticketNum = "--";
            mealStatisticalDetailedModel.quantity = "--";
            mealStatisticalDetailedModel.state = 0;
            mealStatisticalDetailedModel.mealType = 0;
            mealStatisticalDetailedModel.diningStatus = 0;
            mealStatisticalDetailedModel.userlevel = 0;
            mapALL[dataUserListModel.data[i].userId] =
                mealStatisticalDetailedModel;
            mapALL[dataUserListModel.data[i].userId].userName =
            dataUserListModel.data[i].userName == null
                ? ""
                : dataUserListModel.data[i].userName;
            mapALL[dataUserListModel.data[i].userId].phoneNum =
                dataUserListModel.data[i].phoneNum;
            mapALL[dataUserListModel.data[i].userId].userlevel =
                dataUserListModel.data[i].level;
            mapALL[dataUserListModel.data[i].userId].userId=
                dataUserListModel.data[i].userId;
            //modify by
            mapALL[dataUserListModel.data[i].userId].orgID=
                dataUserListModel.data[i].rootOrganizeId;
            mapALL[dataUserListModel.data[i].userId].organizeName=
                dataUserListModel.data[i].organizeName;
          }
        }

        for(int i=0;i<mapALL.length;i++)
        {

          if(mapALL[mapALL.keys.toList()[i]].userlevel==0) {
            map[mapALL.keys.toList()[i]] = mapALL[mapALL.keys.toList()[i]];
          }
          else if(mapALL[mapALL.keys.toList()[i]].userlevel>0) {
            mapVIP[mapALL.keys.toList()[i]] =mapALL[mapALL.keys.toList()[i]];
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    noPostMeal = 0; //未报餐用户数
    if(ifload) {
      meal = 0; //报餐用户数
      mealquatity = 0; //报餐总份数
      noMeal = 0; //不报餐用户数
      leaveMeal = 0; //留餐用户数
      leavequatity = 0; //留餐总份数
      dingNum = 0; //已用餐用户数
      zongprice = 0; //总金额
      _getSumData(mealtime, mealtype);
      ifload=false;
    }
    _tableRowList();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Image.asset(
              "assets/images/btn_back.png",
              width: ScreenUtil().setSp(84),
              height: ScreenUtil().setSp(84),
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        centerTitle: true,
        title: Text(
          '报餐统计详细',
          style: TextStyle(color: Colors.black,
              fontSize: ScreenUtil().setSp(40),
              fontWeight:FontWeight.w500),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: Column(
          children: <Widget>[
            // Container(
            //   margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            //   child: Text(
            //       mealtime +
            //           "  " +
            //           (mealtype == 0 ? "早餐" : mealtype == 1 ? "中餐" : "晚餐"),
            //       style: TextStyle(color: Colors.red, fontSize: 18)),
            // ),
            Expanded(
              child: SingleChildScrollView(
                // child: Table(
                //   columnWidths: const {
                //     0: FixedColumnWidth(30.0),
                //     1: FixedColumnWidth(50.0),
                //     2: FixedColumnWidth(55.0),
                //     3: FixedColumnWidth(55.0),
                //     4: FixedColumnWidth(30.0),
                //     5: FixedColumnWidth(35.0),
                //     6: FixedColumnWidth(90.0),
                //     7: FixedColumnWidth(70.0)
                //   },
                //   border: TableBorder.all(
                //       color: Colors.black,
                //       width: 1.0,
                //       style: BorderStyle.solid),
                //   children: _tableRowList(),
                // ),
                child: PaginatedDataTable(
//                  falg: true,
                  header: Row(
                    children: <Widget>[
                      Container(
                        // margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Text(
                            mealtime +
                                "  " +
                                (mealtype == 0 ? "早餐" : mealtype == 1 ? "中餐" : "晚餐"),
                            style: TextStyle(fontWeight:FontWeight.w500,color: Colors.red, fontSize: ScreenUtil().setSp(36))
                        ),
                      ),
                      //modify by
                      usertype=="1"?Container(
                          margin: EdgeInsets.only(left: ScreenUtil().setSp(90)),
                          height: ScreenUtil().setSp(90.0),
                          // width: ScreenUtil().setSp(200.0),
                          decoration: BoxDecoration(
                            // border: Border.all(width: ScreenUtil().setSp(1),color: Colors.black26)
                          ),
                          child: DropdownButton(
                            items: _item,
                            hint: Text(
                                hintStr,
                                style: TextStyle(fontWeight:FontWeight.w500, fontSize: ScreenUtil().setSp(36))
                            ),
                            onChanged: (value){
                              if(value==-1){
                                hintStr = "全部机构";
                                setState(() {
                                  _datas = _data;
                                });
                              }else{
                                hintStr = organizeMap[value];
                                List<MealStatisticalDetailed> _list = new List();
                                for(int i=0;i<_data.length;i++){
                                  if(_data[i].orgID==value){
                                    _list.add(_data[i]);
                                  }
                                }
                                setState(() {
                                  _datas = _list;
                                });
                              }
                            },
                          )
                      ):Container()
                    ],
                  ),
                  rowsPerPage:10,
//                  falg: false,
                  columns: [
                    DataColumn(label: centerText('序号')),
                    DataColumn(label: centerText('姓名')),
                    DataColumn(label: centerText('报餐状态')),
                    DataColumn(label: centerText('用餐状态')),
                    DataColumn(label: centerText('数量')),
                    DataColumn(label: centerText('金额(单位:元)')),
                    DataColumn(label: centerText('餐券(单位:张)')),
                    DataColumn(label: centerText('温度')),
                    DataColumn(label: centerText('现在所属')),
                    DataColumn(label: centerText('联系电话')),
                    // DataColumn(label: centerText('排序')),
                  ],
                  source: TableDataTableSource(_datas,context),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(30, 5, 30, 0),
              child: Row(
                children: <Widget>[
                  sumTextType(
                      "就餐总金额 ：" + zongprice.toStringAsFixed(2) +"元" ,
                      0),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(30, 5, 30, 0),
              child: Row(
                children: <Widget>[
                  sumTextType(
                      "食堂总用户数 ：" +
                          (dataUserListModel == null
                              ? 0.toString()
                              : dataUserListModel.data.length.toString()) +
                          "人,就餐总份数:" +
                          (dingNum).toString() +
                          "份",
                      0),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(30, 5, 30, 0),
              alignment: Alignment.topCenter,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: sumTextType(
                        "报餐用户数 ：" +
                            meal.toString() +
                            "人,报餐份数:" +
                            mealquatity.toString() +
                            "份",
                        1),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(30, 5, 30, 0),
              child: Row(
                children: <Widget>[
                  sumTextType("不报餐用户数 ：" + noMeal.toString() + "人", 2),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(30, 5, 30, 0),
              alignment: Alignment.topCenter,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: sumTextType(
                        "留餐用户数 ：" +
                            leaveMeal.toString() +
                            "人,留餐份数:" +
                            leavequatity.toString() +
                            "份",
                        3),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(30, 5, 30, 0),
              child: Row(
                children: <Widget>[
                  sumTextType(
                      "未报餐用户数 ：" +
                          (dataUserListModel != null && detailModel != null
                              ? (noPostMeal)
                              .toString()
                              : "0") +
                          "人",
                      4),
                ],
              ),
            ),
          ],
        ),
      ),
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

  Text sumTextType(String text, int type) => Text(
    text,
    style: TextStyle(
        color: type == 0
            ? Colors.black
            : type == 1
            ? Colors.green
            : type == 2
            ? Colors.blue
            : type == 3 ? Colors.purple : Colors.red,
        fontSize: 13),
  );

  /*
   * 拨打手机号码
   */
  _launchPhone(phone) async {
    String url = 'tel:$phone';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _tableRowList() {
    _data.clear();
    if (map.keys.toList().length != 0||mapVIP.keys.toList().length!=0) {
      Map<int, MealStatisticalDetailedModel> maptemp = new Map();
      //mapVIP排序展示
      for (int i = 0; i < mapVIP.length; i++) {
        for (int j = 0; j < mapVIP.length; j++) {
          if (mapVIP[mapVIP.keys.toList()[j]].userlevel == (i + 1))
            maptemp.putIfAbsent(
                mapVIP.keys.toList()[j], () => mapVIP[mapVIP.keys.toList()[j]]);
        }
      }
      maptemp.addAll(map);
      var count = maptemp.keys
          .toList()
          .length;
      print("count$count");
      for (int i = 0; i < count; i++) {
        dataMeal = maptemp[maptemp.keys.toList()[i]];
        if((dataMeal.orgID==organizeid&&usertype=="3")||usertype=="1"){
          if(dataMeal.state == 0){
            noPostMeal++;
          }
          int bodyTemperatureState = 0;
          String abc;
          if (dataMeal.bodyTemperature != "--") {
            abc = dataMeal.bodyTemperature.split('℃')[0];
            if (double.parse(abc) < 37.3) {
              bodyTemperatureState = 1;
            }
          }
          _data.add(new MealStatisticalDetailed(
              dataMeal.userlevel,
              dataMeal.userName,
              dataMeal.state == 2
                  ? "不报餐"
                  : dataMeal.state == 1
                  ? "已报餐"
                  : dataMeal.state == 3
                  ? "已留餐"
                  : dataMeal.state == 0 ? "未报餐" : "已订餐",
              dataMeal.diningStatus == 0 ? "未用餐" : "已用餐",
              dataMeal.quantity,
              dataMeal.eatenquantity,
              dataMeal.price,
              dataMeal.phoneNum,
              dataMeal.state,
              //modify by
              dataMeal.orgID,
              dataMeal.ticketNum,
              dataMeal.bodyTemperature ,
              dataMeal.organizeName,
              bodyTemperatureState
          ));
        }
        //modify by
        if(isFrist){
          _datas = _data;
          isFrist = false;
        }
        // content = TableRow(
        //   //特殊用户设置颜色
        //     decoration:data.userlevel>0?BoxDecoration(color: Colors.amberAccent):null ,
        //     children: [
        //       data.userlevel>0?centerText("*"+(i + 1).toString(), typeColor(data.state))
        //           :centerText((i + 1).toString(), typeColor(data.state)),
        //       centerText(data.userName, typeColor(data.state)),
        //       centerText(
        //           data.state == 2
        //               ? "不报餐"
        //               : data.state == 1
        //               ? "已报餐"
        //               : data.state == 3
        //               ? "已留餐"
        //               : data.state == 0 ? "未报餐" : "已订餐",
        //           typeColor(data.state)),
        //       data.diningStatus == 0
        //           ? centerText("未用餐", typeColor(0))
        //           : centerText("已用餐", typeColor(1)),
        //       centerText(data.quantity.toString(), typeColor(data.state)),
        //       centerText(data.price.toString(), typeColor(data.state)),
        //       GestureDetector(
        //         child: centerText(data.phoneNum, typeColor(data.state)),
        //         onTap: () {
        //           setState(() {
        //             _launchPhone(data.phoneNum);
        //           });
        //         },
        //       ),
        //       data.userlevel>0?Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //           crossAxisAlignment: CrossAxisAlignment.end,
        //           children: <Widget>[
        //             data.userlevel==1?Text(""):
        //             GestureDetector(
        //               child: centerText("↑", typeColor(1)),
        //               onTap: () {
        //                 rank_up(data);
        //               },
        //             ),
        //             data.userlevel==mapVIP.length?Text(""):
        //             GestureDetector(
        //               child: centerText("↓", typeColor(2)),
        //               onTap: () {
        //                 rank_down(data);
        //               },
        //             ),
        //             GestureDetector(
        //               child: centerText("取关", typeColor(3)),
        //               onTap: () {
        //                 cancel_userVIP(data);
        //               },
        //             ),
        //           ]):Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           //crossAxisAlignment: CrossAxisAlignment.center,
        //           children: <Widget>[
        //             GestureDetector(
        //               child: centerText("关注 ", typeColor(1)),
        //               onTap: () {
        //                 focus_userVIP(data);
        //               },
        //             ),
        //             GestureDetector(
        //               child: centerText(" 置顶 ", typeColor(3)),
        //               onTap: () {
        //                 top_userVIP(data);
        //               },
        //             ),
        //           ]),
        //     ]);
        // Tlist.add(content);
      }
    }
  }

  //说明：userleve 为0时是普通用户， 大于0时是特别关注用户，特别关注用户的优先级按数字从小到大依次降低

  //排名向上移
  Future rank_up() async{
    if(dataMeal.userlevel==1) return;
    List list=new List();
    int templevel=dataMeal.userlevel;
    int goallevel=dataMeal.userlevel-1;
    for(int i=0;i<mapVIP.length;i++) {
      if(mapVIP[mapVIP.keys.toList()[i]].userlevel==goallevel) {
        mapVIP[mapVIP.keys.toList()[i]].userlevel = templevel;
        break;
      }
    }
    mapVIP[dataMeal.userId].userlevel=goallevel;
    int len=mapVIP.length;
    for(int i=0;i<len;i++)
    {
      List userIdListtemp= new List();
      userIdListtemp.add(mapVIP.keys.toList()[i]);
      var userdatatemp={'user_id':userIdListtemp,'level':mapVIP[mapVIP.keys.toList()[i]].userlevel};
      list.add(userdatatemp);
    }
    await postUserLevel(list);
    ifload=true;
    setState(() {

    });
  }

  //排名向下移
  Future rank_down() async{
    if(dataMeal.userlevel>=mapVIP.length) return;
    List list=new List();
    int templevel=dataMeal.userlevel;
    int goallevel=dataMeal.userlevel+1;
    for(int i=0;i<mapVIP.length;i++) {
      if(mapVIP[mapVIP.keys.toList()[i]].userlevel==goallevel) {
        mapVIP[mapVIP.keys.toList()[i]].userlevel = templevel;
        break;
      }
    }
    mapVIP[dataMeal.userId].userlevel=goallevel;
    int len=mapVIP.length;
    for(int i=0;i<len;i++)
    {
      List userIdListtemp= new List();
      userIdListtemp.add(mapVIP.keys.toList()[i]);
      var userdatatemp={'user_id':userIdListtemp,'level':mapVIP[mapVIP.keys.toList()[i]].userlevel};
      list.add(userdatatemp);
    }
    await postUserLevel(list);
    ifload=true;
    setState(() {

    });
  }

  //取消关注
  Future cancel_userVIP() async{
    int templevel=dataMeal.userlevel;
    //该用户后面的依次前移
    List templist=new List();
    for(int i=0;i<mapVIP.length;i++)
    {
      for(int j=0;j<mapVIP.length;j++) {
        if (mapVIP[mapVIP.keys.toList()[j]].userlevel>templevel) {
          if(!templist.contains(mapVIP.keys.toList()[j])) {
            mapVIP[mapVIP.keys.toList()[j]].userlevel = mapVIP[mapVIP.keys.toList()[j]].userlevel - 1;
            templist.add(mapVIP.keys.toList()[j]);
          }
        }
      }
    }
    dataMeal.userlevel=0;
    List userIdList= new List();
    userIdList.add(dataMeal.userId);
    List list=new List();
    var userdata={'user_id':userIdList,'level':0};
    list.add(userdata);

    int len=mapVIP.length;
    for(int i=0;i<len;i++)
    {
      if(mapVIP[mapVIP.keys.toList()[i]].userId!=dataMeal.userId) {
        List userIdListtemp = new List();
        userIdListtemp.add(mapVIP[mapVIP.keys.toList()[i]].userId);
        var userdatatemp = {
          'user_id': userIdListtemp,
          'level': mapVIP[mapVIP.keys.toList()[i]].userlevel
        };
        list.add(userdatatemp);
      }
    }
    await postUserLevel(list);
    ifload=true;
    setState(() {

    });
  }

  //关注
  Future focus_userVIP() async{
    dataMeal.userlevel=mapVIP.length+1;
    List userIdList= new List();
    userIdList.add(dataMeal.userId);
    List list=new List();
    var userdata={'user_id':userIdList,'level':dataMeal.userlevel};
    list.add(userdata);
    await postUserLevel(list);
    ifload=true;
    setState(() {

    });
  }

  //置顶
  Future top_userVIP() async{
    List list=new List();
    dataMeal.userlevel=1;
    List userIdList= new List();
    userIdList.add(dataMeal.userId);
    var userdata={'user_id':userIdList,'level':dataMeal.userlevel};
    list.add(userdata);
    int len=mapVIP.length;
    for(int i=0;i<len;i++)
    {
      List userIdListtemp= new List();
      userIdListtemp.add(mapVIP.keys.toList()[i]);
      var userdatatemp={'user_id':userIdListtemp,'level':mapVIP[mapVIP.keys.toList()[i]].userlevel+1};
      list.add(userdatatemp);
    }
    await postUserLevel(list);
    ifload=true;
    setState(() {

    });
  }


  Future postUserLevel(List datalist) async {
    var data = {
      'data': datalist
    };
    await request('userlevel', '', formData: data).then((val) {
      if (val != null) {
        //var data = json.decode(val.toString());
        //print(data);
        //loginDataModel loginModel = loginDataModel.fromJson(data);
        //retLoginMessage = loginModel.message;
      }
    });
  }
}
