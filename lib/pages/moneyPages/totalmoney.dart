import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_canteen/provide/userInfo.dart';
import 'package:provide/provide.dart';
import 'package:flutter_canteen/common/shared_preference.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_canteen/pages/moneyPages/billdetailPage.dart';
import 'dart:convert';

class totalMoeyAndBill extends StatefulWidget {
  @override
  _totalMoeyAndBillState createState() => _totalMoeyAndBillState();
}

class _totalMoeyAndBillState extends State<totalMoeyAndBill> {
  bool isfirst = true;
  String money="正在查询...";
  String ticketNum="正在查询...";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     _getPersonInfo(context);
  }

  @override
  Widget build(BuildContext context) {
    //if(isfirst) {

    //  isfirst=false;
    //}
    return Container(
        color: Colors.white,
        child: Scaffold(
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
                '支付',
                style: TextStyle(color: Colors.black,
                    fontSize: ScreenUtil().setSp(40),
                    fontWeight:FontWeight.w500),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              brightness: Brightness.dark,
              /*   elevation: 0.0,*/
            ),
            body: Container(
              child: Column(
                children: <Widget>[
                  totalMoneyWidget(),
                  totalTicketNumWidget(),
                  _myListTile(context, '个人账单明细', ' ', 1),
                ],
              ),
            )));
  }

  Widget totalMoneyWidget() {
    return Container(
        color: Theme.of(context).primaryColor,
        margin: EdgeInsets.only(top: 10),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.account_balance_wallet,
              size: ScreenUtil().setSp(90),
              color: Colors.white,
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setSp(30.0),
                    ScreenUtil().setSp(0.0),
                    ScreenUtil().setSp(0.0),
                    ScreenUtil().setSp(0.0)),
                child: Text(
                  '账户可用余额：',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(35), color: Colors.black87),
                )),
            Padding(
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setSp(10.0),
                    ScreenUtil().setSp(0.0),
                    ScreenUtil().setSp(0.0),
                    ScreenUtil().setSp(0.0)),
                child: Text(
                  money,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(40), color: Colors.black87),
                )),
          ],
        ));
  }

  Widget totalTicketNumWidget() {
    return Container(
        color: Theme.of(context).primaryColor,
        margin: EdgeInsets.only(top: 10),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.account_balance_wallet,
              size: ScreenUtil().setSp(90),
              color: Colors.white,
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setSp(30.0),
                    ScreenUtil().setSp(0.0),
                    ScreenUtil().setSp(0.0),
                    ScreenUtil().setSp(0.0)),
                child: Text(
                  '账户可用餐券：',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(35), color: Colors.black87),
                )),
            Padding(
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setSp(10.0),
                    ScreenUtil().setSp(0.0),
                    ScreenUtil().setSp(0.0),
                    ScreenUtil().setSp(0.0)),
                child: Text(
                  ticketNum,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(40), color: Colors.black87),
                )),
          ],
        ));
  }

  //加载个人信息
  Future _getPersonInfo(BuildContext context) async {
    String userName = await KvStores.get(KeyConst.USER_NAME);
    await Provide.value<GetUserInfoDataProvide>(context).getUserInfo(userName);
    setState(() {
      money=Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.money+"元";
      ticketNum=Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.ticket_num.toString()+"张";
    });
    return '完成加载';
  }

  //通用ListTile
  Widget _myListTile(BuildContext context, String title, String name, int ID) {
    IconData iconimage;
    bool hasarrow = false;
    switch (ID) {
      case 1:
        iconimage = Icons.account_balance;
        hasarrow = true;
        break;
      case 2:
        iconimage = Icons.account_box;
        hasarrow = true;
        break;
      case 3:
        iconimage = Icons.perm_identity;
        hasarrow = true;
        break;
      case 4:
        iconimage = Icons.table_chart;
        hasarrow = true;
        break;
      case 5:
        /* iconimage = Icons.settings;*/
        hasarrow = true;
        break;
      case 6:
        /* iconimage = Icons.settings;*/
        hasarrow = true;
        break;
    }
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
      child: ListTile(
        title: Text(title + '   ' + name),
        trailing: hasarrow ? Icon(Icons.arrow_right) : null,
        onTap: () {
          if (hasarrow) {
            switch (ID) {
              case 1:
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => billdetailPage()));
                break;
              case 5:
                //Navigator.push(
                //    context,
                //    MaterialPageRoute(
                //        builder: (context) =>
                //            getSystemSettingWidgetByID(ID.toString())));
                break;
              case 2:
                //Navigator.push(context,
                //    MaterialPageRoute(builder: (context) => ResetWidget()));
                break;
              case 6:
                //Navigator.push(context,
                //    MaterialPageRoute(builder: (context) => CommentsSectionPage()));
                break;
            }
          }
        },
      ),
    );
  }
}
