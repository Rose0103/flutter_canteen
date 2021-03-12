import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_canteen/common/database_helper.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/model/userandCanteen.dart';
import 'package:flutter_canteen/pages/LoginPage/login.dart';
import 'package:flutter_canteen/pages/LoginPage/register.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../client_index_page.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_canteen/model/baoCanPriceModel.dart';
import 'package:flutter_canteen/model/deadlinemodel.dart';
import 'clientHomePage.dart';
import 'package:flutter_canteen/pages/manager_index_page.dart';


class LoginOrRegister extends StatefulWidget{

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();

}

class _LoginOrRegisterState extends State<LoginOrRegister>{

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("当前为游客用户，请您先注册或登录！"),
      actions: <Widget>[
        FlatButton(
          child: Text('登录',style: TextStyle(color: Colors.lightBlue,fontSize: 20.0),),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(context,MaterialPageRoute(builder: (context) =>LoginWidget()));
          }
        ),
        FlatButton(
          child: Text('注册',style: TextStyle(color: Colors.lightBlue,fontSize: 20.0),),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(context,MaterialPageRoute(builder: (context) =>RegisterWidget()));
          },
        ),
      ],
    );
  }
}