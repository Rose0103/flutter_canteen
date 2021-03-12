import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_canteen/common/shared_preference.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/pages/commentsSectionPage/commentsSectionPage.dart';
import 'package:flutter_canteen/router/application.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_canteen/pages/LoginPage/login.dart';
import 'package:flutter_canteen/pages/LoginPage/CompletePersonInfoPage.dart';
import 'package:flutter_canteen/pages/mineOrderPage/mineOrderPage.dart';
import 'package:flutter_canteen/pages/HomePage/abourtSoftware.dart';
import 'package:flutter_canteen/pages/LoginPage/ResetPassWord.dart';

class systemSettingPage extends StatefulWidget {
  systemSettingPage();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return systemSettingState();
  }
}

class systemSettingState extends State<systemSettingPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
              '系统设置',
              style: TextStyle(color: Colors.black,
                  fontSize: ScreenUtil().setSp(40),
                  fontWeight:FontWeight.w500),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            /*   elevation: 0.0,*/
          ),
          body: Container(
              child: Column(
            children: <Widget>[
              _myListTile(context, '关于系统', ' ',5),
              isYouKe?Container():_myListTile(context, '修改密码', ' ', 2),
              isYouKe?Container():_myListTile(context, '系统评论区', ' ', 6),
              Expanded(
                flex: 1,
                child: Text(""),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(16, 0,16, 12),
                height: 50,
                width: double.infinity, //宽度为无穷大
                child: isYouKe?Container():FlatButton(
                  color: Theme.of(context).primaryColor,
                  highlightColor:  Theme.of(context).primaryColor,
                  colorBrightness: Brightness.dark,
                  splashColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Text("退出登录"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    isAutoLogin = false;
                    KvStores.save(KeyConst.USER_NAME, "");
                    KvStores.save(KeyConst.PASSWORD, "");
                    KvStores.save(KeyConst.LOGIN, false);
                    KvStores.save(KeyConst.USERTYPE, "");
                    KvStores.save(KeyConst.MESSAGE,"");
                    KvStores.save(KeyConst.USERID, "");
                    KvStores.save(KeyConst.COOKIES, "");
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginWidget()));
                    //Appliaction.router.navigateTo(context, "/welcomePage");
                  },
                ),
              )
            ],
          ))),
    );
  }
}

Widget getSystemSettingWidgetByID(String id){
  if (id == "3")
    return CompletePersonInfoPage();
  else if (id == "5") return AboutSoftWarePage(id);
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
            case 5:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          getSystemSettingWidgetByID(ID.toString())));
              break;
            case 2:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ResetWidget()));
              break;
            case 6:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CommentsSectionPage()));
          }
        }
      },
    ),
  );


}
