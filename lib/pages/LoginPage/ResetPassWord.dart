import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/pages/LoginPage/login.dart';
import 'dart:convert';
import 'package:flutter_canteen/otherfunction/showDialog.dart';

/**
 * 修改密码模块
 */

class ResetWidget extends StatefulWidget {
  final TextEditingController _controller = new TextEditingController();

  @override
  _ResetWidgetState createState() => _ResetWidgetState();
}

class _ResetWidgetState extends State<ResetWidget> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _repasswordController = TextEditingController();
  TextEditingController _messagecodeController = TextEditingController();
  GlobalKey _formKey = GlobalKey();
  Timer _timer;
  int _countdownTime = 0;
  bool isresetSuccess = false;
  bool issendmessage = false;
  bool isphoneNumAvilable = false;
  var _isShowPwd = false; //是否显示密码
  var _isShowPwd2 = false; //是否显示密码
  DateTime lastPopTime=null;
  bool noreg = false;

  //返回箭头按钮
  Widget backButtonWidget() {
    return Container(
        alignment: Alignment.bottomLeft,
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setSp(0.0),
            ScreenUtil().setSp(0.0),
            ScreenUtil().setSp(0.0),
            ScreenUtil().setSp(0.0)),
        child: IconButton(
            icon: ImageIcon(AssetImage("assets/images/btn_back.png")),
            iconSize: ScreenUtil().setSp(100.0),
            onPressed: () {
              Navigator.of(context).pop();
            }));
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




  //手机号输入
  Widget inputPhoneNumWidget() {
    return Container(
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setSp(86.0),
            ScreenUtil().setSp(0.0),
            ScreenUtil().setSp(86.0),
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
            //labelText: '用户手机号码',
            hintText: '请输入手机号码',
            icon: Icon(Icons.person,color: Theme.of(context).primaryColor),
            border: OutlineInputBorder(),
          ),
          validator: (v) {
            if (v.trim().length == 11) {
              if (currentPhoneNum != _usernameController.text.trim()) {
                _checkPhoneNum();
              }
              noreg = true;
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
                //obscureText: true,
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
                        if (noreg) {
                          showMessage(context,"该手机号未注册");
                          noreg = false;
                          return;
                        }
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
            return v.trim().length > 0 ? null : '密码不能为空';
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
            return v.trim().length > 0
                ? (v == _passwordController.text.trim() ? null : '两次密码不相同')
                : '密码不能为空';
          },
        ));
  }

  //更改密码按钮
  Widget resetPassWDWidget() {
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
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(44.0)),
            padding: EdgeInsets.all(15.0),
            child: Text("更改密码"),
            textColor: Colors.white,
            onPressed: () async {
              if(lastPopTime == null || DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
                lastPopTime = DateTime.now();
                if ((_formKey.currentState as FormState).validate()) {
                  await resetPass();
                  if (isresetSuccess) {
                    Future.delayed(Duration(seconds: 2), () {
                      Navigator.of(context).pop();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginWidget()));
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

            }));
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
        child: Text("登录->"),
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
            topBGIMG(),
            titleWidget2("密码修改",context),
            inputPhoneNumWidget(),
            inputPassWDWidget(),
            makeSurePassWDWidget(),
            sendMassageCodeWidget(),
            resetPassWDWidget(),
            haveAccountWidget()
          ]),
          key: _formKey,
          autovalidate: true,
        ),
      ),
    ));
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
    String params = '/' + _usernameController.text.trim() + '/reset';
    retCheckcode = -1;
    await requestGet('getmessageCode', params).then((val) {
      //var data = val;
      if (val.toString() == "false") {
        return;
      }
      var data = val;
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
    });
  }

  //手机号校验
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
      //var data = val;
      var data = val;
      setState(() {
        retCheckcode = int.parse(data['code'].toString());
        retCheckmessage = data['message'].toString();
        if (retCheckcode == 0) {
          isphoneNumAvilable = false;
          currentMassage = retCheckmessage;
          currentPhoneNum = _usernameController.text.trim();
        } else {
          isphoneNumAvilable = true;
          currentMassage = null;
          currentPhoneNum = _usernameController.text.trim();
        }
      });
    });
  }

  int retResetcode = -1;
  String retResetmessage = " ";

  //重设密码
  void resetPass() async {
    retResetcode = -1;
    isresetSuccess = false;
    String params = '';
    var data = {
      "phone_num": _usernameController.text.trim(),
      "new_password": _passwordController.text.trim(),
      "code": _messagecodeController.text.trim(),
      "old_password": null
    };
    //var datatemp=json.encode(data);
    await request('resetPasswd', params, formData: data).then((val) {
      if (val.toString() == "false") {
        return;
      }
      var data = val;
      retResetcode = int.parse(data['code'].toString());

      retResetmessage = data['message'].toString();
      if (retResetcode < 0) {
        showMessage(context,retResetmessage);
        isresetSuccess = false;
      } else {
        retResetcode = 0;
        showMessage(context,"修改密码成功");
        isresetSuccess = true;
      }
    });
  }
}
