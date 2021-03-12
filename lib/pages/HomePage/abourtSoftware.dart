import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


//菜品总评价
class AboutSoftWarePage extends StatefulWidget {
  final String functionID;
  AboutSoftWarePage(this.functionID);
  @override
  _AboutSoftWarePageState createState() => _AboutSoftWarePageState();
}

class _AboutSoftWarePageState extends State<AboutSoftWarePage> {
  String aboutText="阳光食堂" ;
  String versionText="V1.2.1+1";
  @override

  void initState() {
    super.initState();
  }


  Widget build(BuildContext context) {
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
          '关于软件',
          style: TextStyle(color: Colors.black,
              fontSize: ScreenUtil().setSp(40),
              fontWeight:FontWeight.w500),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
          child:Container(
            padding: EdgeInsets.fromLTRB(10.0, 200.0, 10.0, 5.0),
            child: Column(
              children: <Widget>[
                 Image.asset(
                  "assets/images/logo.png",
                  width: ScreenUtil().setSp(200),
                ),
              Text(aboutText,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil.getInstance().setSp(40))),
                Text("当前版本$versionText",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: ScreenUtil.getInstance().setSp(30))),
              ],
            ),
          )),
    );
  }
}
