import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_canteen/pages/LoginPage/habitChosePage/habitChosePage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_canteen/router/application.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/back_to_desktop.dart';
import 'package:flutter_canteen/pages/LoginPage/register.dart';
import 'package:flutter_canteen/pages/LoginPage/login.dart';
import 'dart:io';
import 'dart:ui';

class WelcomPage extends StatefulWidget {
  @override
  _WelcomPageState createState() => _WelcomPageState();
}


class _WelcomPageState extends State<WelcomPage> {
  @override
  Widget build(BuildContext context) {
    var s = window.physicalSize;
    print(s);
    return Scaffold(
        body: WillPopScope(
            onWillPop: () async {
              if (Platform.isAndroid) {
                AndroidBackTop.backDeskTop(); //设置为返回不退出app
                return false;
              } //一定要return false
            },
            child: SingleChildScrollView(
              child: Container(
                  //height: ScreenUtil().setHeight(1624),
                  //width: ScreenUtil().setSp(750),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/img_welcome.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: ScreenUtil().setSp(588),
                        padding: EdgeInsets.fromLTRB(
                            ScreenUtil().setSp(52.0),
                            ScreenUtil().setSp(950.0),
                            ScreenUtil().setSp(110.0),
                            ScreenUtil().setSp(0.0)),
                        child: Text(
                          "您好",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(45),
                          ),
                        ),
                      ),
                      Container(
                        width: ScreenUtil().setSp(588),
                        padding: EdgeInsets.fromLTRB(
                            ScreenUtil().setSp(52.0),
                            ScreenUtil().setSp(0.0),
                            ScreenUtil().setSp(110.0),
                            ScreenUtil().setSp(0.0)),
                        child: Text(
                          "欢迎使用我们的APP",
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: ScreenUtil().setSp(35),
                          ),
                        ),
                      ),
                      //autoLoginflagWidget(),
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            0, 0, 0, ScreenUtil().setSp(100)),
                        child: registerOrLogin(context),
                      )
                    ],
                  )),
            )));
  }

  /**
   * 注册和登录按钮
   */
  Row registerOrLogin(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: ScreenUtil().setSp(250),
          //height: ScreenUtil().setSp(96),
          padding: EdgeInsets.fromLTRB(
              ScreenUtil().setSp(25.0),
              ScreenUtil().setSp(60.0),
              ScreenUtil().setSp(0.0),
              ScreenUtil().setSp(0.0)),
          child: RaisedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterWidget()));
              //Appliaction.router.navigateTo(context, "/register");
            },
            child: Text("注册"),
            color: Theme.of(context).primaryColor,
            colorBrightness: Brightness.light,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        Container(
          width: ScreenUtil().setSp(250),
          //height: ScreenUtil().setSp(96),
          padding: EdgeInsets.fromLTRB(
              ScreenUtil().setSp(30.0),
              ScreenUtil().setSp(60.0),
              ScreenUtil().setSp(0.0),
              ScreenUtil().setSp(0.0)),
          child: RaisedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginWidget()));
              //Appliaction.router.navigateTo(context, "/loginPage");
            },
            child: Text("登录"),
            color: Theme.of(context).primaryColor,
            colorBrightness: Brightness.light,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        )
      ],
    );
  }

  Widget autoLoginflagWidget() {
    return Container(
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setSp(100.0),
            ScreenUtil().setSp(0.0),
            ScreenUtil().setSp(0.0),
            ScreenUtil().setSp(0.0)),
        //width: ScreenUtil().setSp(100),
        child: CheckboxListTile(
          title: const Text('自动登录'),
          value: isAutoLogin,
          onChanged: (isCheck) => {
            isAutoLogin = isCheck,
            setState(() {
              print("isChcek=====$isAutoLogin");
            })
          },
        ));
  }
}
