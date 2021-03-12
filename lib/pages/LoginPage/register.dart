import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_canteen/otherfunction/logutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_canteen/router/application.dart';
import 'package:flutter_canteen/service/service_method.dart';
import '../../model/registerModel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/pages/LoginPage/login.dart';
import 'package:flutter_canteen/model/logindatamodel.dart';
import 'package:flutter_canteen/pages/client_index_page.dart';
import 'package:flutter_canteen/common/shared_preference.dart';
import 'package:flutter_canteen/provide/userInfo.dart';
import 'package:flutter_canteen/pages/manager_index_page.dart';
import 'package:flutter_canteen/pages/LoginPage/CompletePersonInfoPage.dart';
import 'package:flutter_canteen/model/deadlinemodel.dart';
import 'package:flutter_canteen/model/baoCanPriceModel.dart';
import 'dart:async';
import 'package:provide/provide.dart';
import 'dart:convert';
import 'package:flutter_canteen/otherfunction/showDialog.dart';

/**
 * 注册模块
 */

class RegisterWidget extends StatefulWidget {
  final TextEditingController _controller = new TextEditingController();
  final TextStyle _availableStyle = TextStyle(
    fontSize: 16.0,
    color: const Color(0xFF00CACE),
  );

  final TextStyle _unavailableStyle = TextStyle(
    fontSize: 16.0,
    color: const Color(0xFFCCCCCC),
  );

  @override
  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _repasswordController = TextEditingController();
  TextEditingController _messagecodeController = TextEditingController();
  TextEditingController _invitecodeController = TextEditingController();

  GlobalKey _formKey = GlobalKey();
  bool isregiste = false;
  bool issendmessage = false;
  bool isphoneNumAvilable = false;
  var _isShowPwd = false; //是否显示密码
  var _isShowPwd2 = false; //是否显示密码
  DateTime lastPopTime=null;
  bool islogin = false;

  //返回箭头按钮
  Widget backButtonWidget() {
    return Container(
      child: IconButton(
        icon: ImageIcon(AssetImage("assets/images/btn_back.png")),
        iconSize: ScreenUtil().setSp(100.0),
        onPressed: () {
          Navigator.of(context).pop();
        }
      )
    );
  }



  //标题
  Widget titleWidget(String title) {
    return Container(
      //width: ScreenUtil().setSp(200),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setSp(32.0),
          ScreenUtil().setSp(0.0),
          ScreenUtil().setSp(0.0),
          ScreenUtil().setSp(0.0)),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: ScreenUtil().setSp(50),
        ),
      ),
    );
  }




  OutlineInputBorder outlineborders(Color color)
  {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(30), //边角为30
      ),
      borderSide: BorderSide(
        color: color, //边线颜色为黄色
        width: 2, //边线宽度为2
      ),
    );
  }

  //手机号输入
  Widget inputPhoneNumWidget() {
    return Container(
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setSp(84.0),
            ScreenUtil().setSp(0.0),
            ScreenUtil().setSp(84.0),
            ScreenUtil().setSp(0.0)),
        child: TextFormField(
          autofocus: false,
          maxLength: 11,
          controller: _usernameController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              enabledBorder: outlineborders(Colors.grey),
              focusedBorder: outlineborders(Theme.of(context).primaryColor),
              errorBorder: outlineborders(Theme.of(context).primaryColor),
              focusedErrorBorder:outlineborders(Theme.of(context).primaryColor),
              fillColor: Theme.of(context).primaryColor,
              hintStyle: TextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(30.0)),
              errorStyle:TextStyle(color: Theme.of(context).primaryColor, fontSize: ScreenUtil().setSp(25.0)),
              //labelText: '手机号码登录',
              hintText: '请输入手机号码',
              icon: Icon(Icons.person,color: Theme.of(context).primaryColor),
              border: OutlineInputBorder(),
          ),
          validator: (v) {
            if (v.trim().length == 11) {
              if (currentPhoneNum != _usernameController.text.trim()) {
                _checkPhoneNum();
              }
              return currentMassage;
            } else
              return '请输入正确手机号码';
          },
        ));
  }

  //验证码
  Widget sendMassageCodeWidget() {
    return Container(
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setSp(86.0),
            ScreenUtil().setSp(15.0),
            ScreenUtil().setSp(86.0),
            ScreenUtil().setSp(0.0)),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Container(
                      child: TextFormField(
                autofocus: false,
                controller: _messagecodeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    enabledBorder: outlineborders(Colors.grey),
                    focusedBorder: outlineborders(Theme.of(context).primaryColor),
                    errorBorder: outlineborders(Theme.of(context).primaryColor),
                    focusedErrorBorder:outlineborders(Theme.of(context).primaryColor),
                    fillColor: Theme.of(context).primaryColor,
                    hintStyle: TextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(30.0)),
                    errorStyle:TextStyle(color: Theme.of(context).primaryColor, fontSize: ScreenUtil().setSp(25.0)),
                    //labelText: '请输入验证码',
                    hintText: '验证码',
                    icon: Icon(Icons.mail_outline,color: Theme.of(context).primaryColor),
                    border: OutlineInputBorder(),
                ),
                validator: (v) {
                  return v.trim().length > 3 ? null : '验证码长度应在4位以上';
                },
              ))),
              Container(
                  padding: EdgeInsets.fromLTRB(
                      ScreenUtil().setSp(40.0),
                      ScreenUtil().setSp(0.0),
                      ScreenUtil().setSp(0.0),
                      ScreenUtil().setSp(0.0)),
                  child: GestureDetector(
                    onTap: () async {
                      if (!isphoneNumAvilable) {
                        showMessage(context,"请输入正确的手机号码");
                        return;
                      }
                      if (yzmText == '获取验证码') {
                        setState(() {
                          yzmText = "正在获取";
                        });
                        //Http请求发送验证码
                        await getmessageCode();
                        if (issendmessage) {
                          //开始倒计时
                          yzmGet();
                        } else {
                          setState(() {
                            yzmText = "获取验证码";
                          });
                        }
                      }
                    },
                    child: Text(
                      yzmText,
                      style: TextStyle(
                        fontSize: 14,
                        color: yzmText == '获取验证码' ? Colors.blue : Colors.red,
                      ),
                    ),
                  )),
            ]));
  }

  //登录密码输入
  Widget inputPassWDWidget() {
    return Container(
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setSp(86.0),
            ScreenUtil().setSp(15.0),
            ScreenUtil().setSp(86.0),
            ScreenUtil().setSp(0.0)),
        child: TextFormField(
          autofocus: false,
          controller: _passwordController,
          decoration: InputDecoration(
            enabledBorder: outlineborders(Colors.grey),
            focusedBorder: outlineborders(Theme.of(context).primaryColor),
            errorBorder: outlineborders(Theme.of(context).primaryColor),
            focusedErrorBorder:outlineborders(Theme.of(context).primaryColor),
            fillColor: Theme.of(context).primaryColor,
            hintStyle: TextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(30.0)),
            errorStyle:TextStyle(color: Theme.of(context).primaryColor, fontSize: ScreenUtil().setSp(25.0)),
            //labelText: '登录密码',
            hintText: '请输入密码',
            icon: Icon(Icons.lock,color: Theme.of(context).primaryColor),
            border: OutlineInputBorder(),
            // 是否显示密码
            suffixIcon: IconButton(
                icon: Icon(
                    (_isShowPwd) ? Icons.visibility : Icons.visibility_off),
                // 点击改变显示或隐藏密码
                onPressed: () {
                  setState(() {
                    _isShowPwd = !_isShowPwd;
                  });
                }),
          ),
          obscureText: !_isShowPwd,
          validator: (v) {
            return v.trim().length > 5 ? null : '密码长度应在6位以上';
          },
        ));
  }

  //确认密码输入
  Widget makeSurePassWDWidget() {
    return Container(
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setSp(86.0),
            ScreenUtil().setSp(15.0),
            ScreenUtil().setSp(86.0),
            ScreenUtil().setSp(0.0)),
        child: TextFormField(
          controller: _repasswordController,
          decoration: InputDecoration(
            enabledBorder: outlineborders(Colors.grey),
            focusedBorder: outlineborders(Theme.of(context).primaryColor),
            errorBorder: outlineborders(Theme.of(context).primaryColor),
            focusedErrorBorder:outlineborders(Theme.of(context).primaryColor),
            fillColor: Theme.of(context).primaryColor,
            hintStyle: TextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(30.0)),
            errorStyle:TextStyle(color: Theme.of(context).primaryColor, fontSize: ScreenUtil().setSp(25.0)),
            //labelText: '确认密码',
            hintText: '密码确认',
            icon: Icon(Icons.lock,color: Theme.of(context).primaryColor),
            border: OutlineInputBorder(),
            // 是否显示密码
            suffixIcon: IconButton(
                icon: Icon(
                    (_isShowPwd2) ? Icons.visibility : Icons.visibility_off),
                // 点击改变显示或隐藏密码
                onPressed: () {
                  setState(() {
                    _isShowPwd2 = !_isShowPwd2;
                  });
                }),
          ),
          obscureText: !_isShowPwd2,
          validator: (v) {
            return v.trim().length > 5
                ? (v == _passwordController.text.trim() ? null : '两次密码不相同')
                : '密码长度应在6位以上';
          },
        ));
  }

  //注册按钮
  Widget registerButtonWidget() {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setSp(86.0),
            ScreenUtil().setSp(30.0),
            ScreenUtil().setSp(86.0),
            ScreenUtil().setSp(0.0)),
        child: RaisedButton(
          color: Theme.of(context).primaryColor,
          highlightColor: Theme.of(context).primaryColor,
          colorBrightness: Brightness.dark,
          splashColor: Colors.grey,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(44.0)),
          padding: EdgeInsets.all(15.0),
          child: Text("注册"),
          textColor: Colors.white,
          onPressed: () async {
            if(lastPopTime == null || DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
              lastPopTime = DateTime.now();
              if ((_formKey.currentState as FormState).validate()) {
                await register(_usernameController.text.trim(), _passwordController.text.trim(),
                    _repasswordController.text.trim());
                if (isregiste) {
                  Future.delayed(Duration(seconds: 1), () async{
                    showMessage(context,"正在自动登录...");
                    try {
                      await autoLogin();
                      if (!islogin) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushAndRemoveUntil(
                            new MaterialPageRoute(
                                builder: (
                                    BuildContext context) => new LoginWidget()), (
                            Route route) => route == null);
                      }
                    } catch (e) {

                    }
                    //Appliaction.router.navigateTo(context, "/loginPage");
                  });
                }
              } else {
                showMessage(context,"请按提示完善信息");
                return;
              }
            }else{
              lastPopTime = DateTime.now();
              showMessage(context,"请勿重复点击！");
              return;
            }

          },
        ));
  }

  //邀请码输入
  Widget inviteCodeWidget() {
    return Container(
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setSp(86.0),
            ScreenUtil().setSp(10.0),
            ScreenUtil().setSp(86.0),
            ScreenUtil().setSp(0.0)),
        child: TextFormField(
          autofocus: false,
          controller: _invitecodeController,
          decoration: InputDecoration(
            enabledBorder: outlineborders(Colors.grey),
            focusedBorder: outlineborders(Theme.of(context).primaryColor),
            errorBorder: outlineborders(Theme.of(context).primaryColor),
            focusedErrorBorder:outlineborders(Theme.of(context).primaryColor),
            fillColor: Theme.of(context).primaryColor,
            hintStyle: TextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(30.0)),
            errorStyle:TextStyle(color: Theme.of(context).primaryColor, fontSize: ScreenUtil().setSp(25.0)),
            //labelText: '邀请码',
            hintText: '请输入邀请码',
            icon: Icon(Icons.contact_mail,color: Theme.of(context).primaryColor),
            border: OutlineInputBorder(),
          ),
          validator: (v) {
            return v.trim().length > 5 ? null : '邀请码长度应在6位';
          },
        ));
  }

  //已有账号
  Widget haveAccountWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setSp(86.0),
          ScreenUtil().setSp(0.0),
          ScreenUtil().setSp(86.0),
          ScreenUtil().setSp(0.0)),
      alignment: Alignment.centerRight,
      child: FlatButton(
        child: Text("已有账号?登录->"),
        // color: Theme.of(context).primaryColor,
        textColor:  Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginWidget()));
          //Appliaction.router.navigateTo(context, "/loginPage");
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            // 触摸收起键盘
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Form(
            child: Column(children: <Widget>[

             // titleWidget("注册"),
              topBGIMG(),
              titleWidget2("注册",context),
              inputPhoneNumWidget(),
              inputPassWDWidget(),
              makeSurePassWDWidget(),
              sendMassageCodeWidget(),
              inviteCodeWidget(),
              registerButtonWidget(),
              haveAccountWidget()
            ]),
            key: _formKey,
            autovalidate: true,
          ),
        ),
      ),
    );
  }

  //获取验证码
  int retGetMessagecode = -1;
  String retGetMessageCodemassage = " ";
  String yzmText = '获取验证码';

  ///获取验证码
  Timer countDownTimer;

  yzmGet() {
    countDownTimer?.cancel(); //如果已存在先取消置空
    countDownTimer = null;
    countDownTimer = new Timer.periodic(new Duration(seconds: 1), (t) {
      setState(() {
        if (60 - t.tick > 0) {
          //60-t.tick代表剩余秒数，如果大于0，设置yzmText为剩余秒数，否则重置yzmText，关闭countTimer
          yzmText = "${60 - t.tick}秒";
        } else {
          yzmText = '获取验证码';
          countDownTimer.cancel();
          countDownTimer = null;
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    countDownTimer?.cancel();
    countDownTimer = null;
    super.dispose();
  }

  Future getmessageCode() async {
    issendmessage = false;
    String params = '/' + _usernameController.text.trim() + '/register';
    retCheckcode = -1;
    await requestGet('getmessageCode', params).then((val) {
      print(val);
      if (val.toString() == "false") {
        return;
      }
      var data = val;
      if (data != null) {
        setState(() {
          retGetMessagecode = int.parse(data['code'].toString());
          retGetMessageCodemassage = data['message'].toString();
          if (retGetMessagecode == 0) {
            issendmessage = true;
            showMessage(context,"获取验证码成功");
          } else {
            showMessage(context,retGetMessageCodemassage);
          }
        });
      }
    });
  }

//校验手机号
  String currentPhoneNum = " ";
  String currentMassage = " ";
  int retCheckcode = -1;
  String retCheckmessage = " ";

  Future _checkPhoneNum() async {
    isphoneNumAvilable = false;
    String params = '/' + _usernameController.text.trim();
    retCheckcode = -1;
    await requestGet('phomeNumCheck', params).then((val) {
      if (val.toString() == "false") {
        return;
      }
      LogUtil.v("----:"+val.toString());
      var data = val;
      setState(() {
        retCheckcode = int.parse(data['code'].toString());
        retCheckmessage = data['message'].toString();
        if (retCheckcode == 0) {
          currentMassage = null;
          isphoneNumAvilable = true;
          currentPhoneNum = _usernameController.text.trim();
        } else {
          currentMassage = "手机号已注册，请登录";
          currentPhoneNum = _usernameController.text.trim();
        }
      });
    });
  }

  //注册
  void register(String userName, String password, String repassword) async {
    var data = {
      'code': _messagecodeController.text,
      'user_name': "",
      'password': password,
      'phone_num': _usernameController.text.trim(),
      'invitation_code': _invitecodeController.text.trim()
    };

    isregiste = false;
    await request('register', '', formData: data).then((val) {
      if (val.toString() == "false") {
        return;
      }
      var data = val;
      registerModel registermodel = registerModel.fromJson(data);
      if (registermodel.code != 0) {
        showMessage(context,registermodel.message);
      } else {
        showMessage(context,"注册成功");
        isregiste = true;
      }
    });
  }

  void autoLogin () async{
    String userName=_usernameController.text.trim();
    String passwd=_passwordController.text.trim();
    if(null!=userName&&null!=passwd) {

      usertype="2";
      await login(
          userName, passwd);
      if(islogin)
      {
        useInfoBase64="";
        await _getPersonInfo(context);
        if (Provide.value<GetUserInfoDataProvide>(context).userinfodata.data != null &&
            Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.userType.length > 0)
        {
          usertype = Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.userType;
          if(usertype.length==0) usertype="2";
          realName=Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.userName;
          gender=Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.sex;
          birthday=Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.birthday;
          canteenID=Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.canteenId.toString();
          canteenName=Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.canteenName;
          totalMoney=Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.money;
          if (Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.isEmployee != null) {
            if (Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.isEmployee)
              is_employee = 1;
            else
              is_employee = 2;
          }
          useInfoBase64=Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.portraitNew;
          featureBase64=Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.feature;
        }
        else usertype="2";
        //极光推送注册alias
        jPush.setAlias(userID);
      }
      if (islogin && (usertype == "1"||usertype == "3")) {
        isYouKe = false;
        Navigator.of(this.context).pop();
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ManagerIndexPage()));
        //Appliaction.router
        //    .navigateTo(context, "/managerIndexPage");
      }
      else if (islogin && usertype == "2") {
        isYouKe = false;
        if(Provide.value<GetUserInfoDataProvide>(context).userinfodata!=null&&Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.portraitNew.length>0&&Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.userName.length>0)
        {
          Navigator.of(this.context).pop();
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ClientIndexPage()));
          // Appliaction.router
          //     .navigateTo(context, "/userIndexPage");
        }
        else {
          isYouKe = false;
          Navigator.of(context).pop();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CompletePersonInfoPage()));
        }
      }
    }
  }

  Future login(String username, String password) async {
    currentstatus = 0;
    currentnum = 1;
    currentprice = 10;

    var data = {
      'phone_num': username,
      'password': password,
    };
    await request('loginByUsername', '',formData: data).then((val) {
      if(val.toString()=="false")
      {
        return;
      }

      realName="";
      if (val != null) {
        var data = val;
        loginDataModel loginModel = loginDataModel.fromJson(data);
        if (int.parse(loginModel.code) < 0) {
          islogin = false;
        } else if (int.parse(loginModel.code) == 0) {
          realName=loginModel.data.userName;
          canteenName=loginModel.data.canteenName;
          canteenID=loginModel.data.canteenId.toString();

          KvStores.save(KeyConst.USER_NAME, username);
          KvStores.save(KeyConst.PASSWORD, password);
          KvStores.save(KeyConst.LOGIN, true);
          KvStores.save(KeyConst.USERTYPE, loginModel.data.userType);
          KvStores.save(KeyConst.MESSAGE, loginModel.message);
          KvStores.save(KeyConst.USERID, loginModel.data.userId.toString());
          userID=loginModel.data.userId.toString();

          islogin = true;
        } else {
          islogin = false;
        }
      }
    });
  }

  //加载个人信息
  Future _getPersonInfo(BuildContext context )async{
    String userName= await KvStores.get(KeyConst.USER_NAME);
    await  Provide.value<GetUserInfoDataProvide>(context).getUserInfo(userName);
   /* await requestGet('getdeadline',"?canteen_id=" +canteenID).then((val) {
      var data = val;
      GetdeadlineModel getdeadlineModel = GetdeadlineModel.fromJson(data);
      if(getdeadlineModel.code=="0")
      {
        breakfastdeadline=getdeadlineModel.data.breakfastDeadline;
        lunchdeadline=getdeadlineModel.data.lunchDeadline;
        dinnerdeadline=getdeadlineModel.data.dinnerDeadline;
      }
      else
      {
        print("获取报餐截止时间失败，启用默认值");
      }
    });

    await requestGet('systemconfig', '?config_desc=报餐&canteen_id=${canteenID}').then((val) {

      sysConfigModel getpriceModelData = sysConfigModel.fromJson(val);
      if(getpriceModelData.code=="0")
      {
        for(int i=0;i<getpriceModelData.data.length;i++) {
          if(getpriceModelData.data[i].configKey=="0")
            breakfastprice =getpriceModelData.data[i].configValue;
          if(getpriceModelData.data[i].configKey=="1")
            lunchprice=getpriceModelData.data[i].configValue;
          if(getpriceModelData.data[i].configKey=="2")
            superprice=getpriceModelData.data[i].configValue;
        }
        setState(() {
        });
      }
      else
      {
        breakfastprice='10.0';
        lunchprice='20.0';
        superprice='20.0';
      }
    });
    await requestGet('systemconfig', '?config_desc=moreconfig&canteen_id=${canteenID}').then((val) {
      sysConfigModel sysconfModelData = sysConfigModel.fromJson(val);
      if (sysconfModelData.code == "0")
      {
        if (sysconfModelData.data.length == 0)
          initDataToDatabase();
        else {
          for (int i = 0; i < sysconfModelData.data.length; i++) {
            //不报餐是否允许吃饭
            if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "nposted_permit") {
              sysconfModelData.data[i].configValue.trim() == "1" ?
              switchIfnopostEaten = true : switchIfnopostEaten = false;
            }
            else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifenablesaturday") {
              sysconfModelData.data[i].configValue.trim() == "1" ?
              switchIfenablesaturday = true : switchIfenablesaturday = false;
            }
            else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifenablesunday") {
              sysconfModelData.data[i].configValue.trim() == "1" ?
              switchIfenableSunday = true : switchIfenableSunday = false;

            }
            else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifenablebreakfast") {
              sysconfModelData.data[i].configValue.trim() == "1" ?
              switchIfenableBreakfast = true : switchIfenableBreakfast = false;

            }
            else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifenablelunch") {
              sysconfModelData.data[i].configValue.trim() == "1" ?
              switchIfenableLunch = true : switchIfenableLunch = false;

            }
            else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifenablesuper"){
              sysconfModelData.data[i].configValue.trim() == "1" ?
              switchIfenableSuper = true : switchIfenableSuper = false;
            }
            else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifbringotherswithpost") {
              sysconfModelData.data[i].configValue.trim() == "1" ?
              switchIfBringOthersWithPost = true : switchIfBringOthersWithPost =
              false;
            }
            else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifbringotherswithoutpost"){
              sysconfModelData.data[i].configValue.trim() == "1"
                  ? switchIfBringOthersWithoutPost = true
                  : switchIfBringOthersWithoutPost = false;
            }
            else if (sysconfModelData.data[i].configKey.toLowerCase() ==
                "ifpaymoneybeforeeat") {
              if (sysconfModelData.data[i].configValue.trim() ==
                  "1") {
                switchIftakeMoneyEaten = false;
                switchIftakeMoneyPost = true;
              }
              else {
                switchIftakeMoneyEaten = true;
                switchIftakeMoneyPost = false;
              }
            }
          }
        }
      }
    });*/
    return '完成加载';
  }

  Future initDataToDatabase() async {

    List postdata = new List();
    for(int i=1;i<=9;i++) {
      String keyname="";
      String keyvalue="";
      switch(i) {
        case 1:
          keyname="nposted_permit";
          keyvalue="1";
          switchIfnopostEaten=true;
          break;
        case 2:
          keyname="ifenablesaturday";
          keyvalue="1";
          switchIfenablesaturday=true;
          break;
        case 3:
          keyname="ifenablesunday";
          keyvalue="1";
          switchIfenableSunday=true;
          break;
        case 4:
          keyname="ifenablebreakfast";
          keyvalue="1";
          switchIfenableBreakfast=true;
          break;
        case 5:
          keyname="ifenablelunch";
          keyvalue="1";
          switchIfenableLunch=true;
          break;
        case 6:
          keyname="ifenablesuper";
          keyvalue="1";
          switchIfenableSuper=true;
          break;
        case 7:
          keyname="ifbringotherswithpost";
          keyvalue="1";
          switchIfBringOthersWithPost=true;
          break;
        case 8:
          keyname="ifbringotherswithoutpost";
          keyvalue="1";
          switchIfBringOthersWithoutPost=true;
          break;
        case 9:
          keyname="ifpaymoneybeforeeat";
          keyvalue="1";
          switchIftakeMoneyEaten=true;
          break;
      }
      var tempdata = {
        "config_key": keyname,
        "config_value": keyvalue,
        "config_desc": "moreconfig"
      };
      postdata.add(tempdata);
    }


    var formData = {
      'data': postdata,
    };
    await request('systemconfig', '', formData: formData).then((val) {
      setPriceReturnModel postreturnModel = setPriceReturnModel.fromJson(val);
      if (postreturnModel.code == "0")
        Fluttertoast.showToast(msg: "初始化设置成功");
      else
        Fluttertoast.showToast(msg: "初始化设置失败，" + postreturnModel.message);
    });
  }
}
