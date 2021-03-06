import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_canteen/common/database_helper.dart';
import 'package:flutter_canteen/model/authorization.dart';
import 'package:flutter_canteen/model/canteenModel.dart';
import 'package:flutter_canteen/model/userandCanteen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_canteen/common/shared_preference.dart';
import 'package:flutter_canteen/model/logindatamodel.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/provide/userInfo.dart';
import 'package:provide/provide.dart';
import 'package:flutter_canteen/pages/manager_index_page.dart';
import 'package:flutter_canteen/pages/client_index_page.dart';
import 'package:flutter_canteen/pages/LoginPage/CompletePersonInfoPage.dart';
import 'package:flutter_canteen/pages/LoginPage/ResetPassWord.dart';
import 'package:flutter_canteen/pages/LoginPage/register.dart';
import 'package:flutter_canteen/model/deadlinemodel.dart';
import 'package:flutter_canteen/model/baoCanPriceModel.dart';
import 'dart:convert';
import 'package:flutter_canteen/otherfunction/showDialog.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_canteen/back_to_desktop.dart';
import 'dart:ui';
import 'package:path_provider/path_provider.dart';

/*
 * 登录模块
 */
class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool islogin = false;
  bool isCorrectPhoneNum = false;
  bool isCorrectPassWd = false;
  GlobalKey _formKey = GlobalKey();

  String currentPhoneNum = " ";
  String currentMassage = " ";
  int retCheckcode = -1;
  String retCheckmessage = " ";
  String retLoginMessage = " ";
  var _isShowPwd = false; //是否显示密码
  DateTime lastPopTime=null;

  GlobalKey _globalKey = new GlobalKey(); //用来标记控件
  String _version; //版本号
  String _username = ""; //用户名
  String _password = ""; //密码
  bool _expand = false; //是否展示历史账号
  List<User> _users = new List(); //历史账号
  DatabaseHelper db;
  Autogenerated authoritionData;

  @override
  void initState() {
    super.initState();
    db = new DatabaseHelper();
    //modify by lilixia   2020-11-23
    dinging = true;
    _gainUsers();
  }



  Future _checkPhoneNum() async {
    String params = '/' + _usernameController.text.trim();
    retCheckcode = -99;
    await requestGet('phomeNumCheck', params).then((val) {
      if (val.toString() == "false") {
        return;
      }
      var data = val;
      setState(() {
        if (int.parse(data['code'].toString()) != null)
          retCheckcode = int.parse(data['code'].toString());
        if (retCheckcode == -99) {
          currentMassage = "网络连接异常，不能连接到服务器";
          currentPhoneNum = _usernameController.text.trim();
          return;
        }
        retCheckmessage = data['message'].toString();
        if (retCheckcode == 0) {
          currentMassage = retCheckmessage;
          currentPhoneNum = _usernameController.text.trim();
        } else {
          currentMassage = null;
          currentPhoneNum = _usernameController.text.trim();
        }
      });
    });
  }

  //返回箭头按钮
  Widget backButtonWidget() {
    return Container(
      // alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(ScreenUtil().setSp(0.0), 0.00,
          ScreenUtil().setSp(0.0), ScreenUtil().setSp(0.0)),
      child: IconButton(
        icon: ImageIcon(AssetImage("assets/images/btn_back.png")),
        color: Theme.of(context).primaryColor,
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
     // width: ScreenUtil().setSp(126),
     // height: ScreenUtil().setSp(31),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setSp(isYouKe?0:176.0),
          ScreenUtil().setSp(isYouKe?0:56.0),
          ScreenUtil().setSp(0.0),
          ScreenUtil().setSp(0.0)),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: ScreenUtil().setSp(40),
            fontWeight:FontWeight.bold,

        ),
      ),
    );
  }
  //短横线
  Widget titleWidget2(String title) {
    return Container(
      // width: ScreenUtil().setSp(126),
      // height: ScreenUtil().setSp(31),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setSp(isYouKe?0:230.0),
          ScreenUtil().setSp(0.0),
          ScreenUtil().setSp(0.0),
          ScreenUtil().setSp(0.0)),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: ScreenUtil().setSp(28),
          fontWeight:FontWeight.bold,

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
            ScreenUtil().setSp(70.0),
            ScreenUtil().setSp(84.0),
            ScreenUtil().setSp(0.0)),
        //width: ScreenUtil().setSp(686),
        child: TextFormField(
          key: _globalKey,
          autofocus: false,
          maxLength: 11,
          controller: _usernameController,
          keyboardType: TextInputType.number,
          cursorColor: Theme.of(context).primaryColor,
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
            icon: Icon(Icons.person,color:Theme.of(context).primaryColor),
            border: OutlineInputBorder(),
            suffixIcon: GestureDetector(
              onTap: () {
                if (_users!=null&&_users.length > 0)
                  {
                    if(_users.length > 1 ||(_users.length==1&& _users[0] != User( _usernameController.text.trim(),  _passwordController.text.trim()))) {
                  //如果个数大于1个或者唯一一个账号跟当前账号不一样才弹出历史账号
                  setState(() {
                    _expand = !_expand;
                  });
                }
              }},
              child: _expand
                  ? Icon(
                Icons.arrow_drop_up,
                color: Colors.red,
              )
                  : Icon(
                Icons.arrow_drop_down,
                color: Colors.grey,
              ),
            ),
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

  //登录密码输入
  Widget inputPassWDWidget() {
    return Container(
        //width: ScreenUtil().setSp(686),
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setSp(84.0),
            ScreenUtil().setSp(60.0),
            ScreenUtil().setSp(84.0),
            ScreenUtil().setSp(0.0)),
        child: TextFormField(
          autofocus: false,
          controller: _passwordController,
          decoration: InputDecoration(
            enabledBorder: outlineborders(Colors.grey),
            focusedBorder: outlineborders(Theme.of(context).primaryColor),
            errorBorder: outlineborders(Theme.of(context).primaryColor),
            focusedErrorBorder:outlineborders(Theme.of(context).primaryColor),
            //  labelText: '登录密码',
            hintText: '请输入密码',
            icon: Icon(Icons.lock,color: Theme.of(context).primaryColor),
            //hoverColor:  Theme.of(context).primaryColor,
            fillColor: Theme.of(context).primaryColor,
            //focusColor: Theme.of(context).primaryColor,
            hintStyle: TextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(30.0)),
            errorStyle:TextStyle(color: Theme.of(context).primaryColor, fontSize: ScreenUtil().setSp(25.0)),
            border: OutlineInputBorder(),
            //contentPadding: EdgeInsets.all(15.0),
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

  Future _associatecanteen() async {
    await requestGet('getauthorization', '?type=canteen' ).then((val)async{
      if(val.toString() == "false"){
        return;
      }
      if(val != null){
        canteenModel canteenModelData = canteenModel.fromJson(val);
        canteenID = canteenModelData.data[0].canteenId.toString();
        canteenlist = canteenModelData.data;
        canteenName = canteenModelData.data[0].canteenName.toString();
        UserAndCanteen userAndCanteen = new UserAndCanteen(
            user_id: int.parse(userID),
            canteen_id: int.parse(canteenID),
            canteen_name: canteenName
        );
        db.saveRecord(userAndCanteen);
      }
    });
  }

  //登录按钮
  Widget loginButtonWidget() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setSp(84.0),
          ScreenUtil().setSp(116.0),
          ScreenUtil().setSp(84.0),
          ScreenUtil().setSp(0.0)),
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(44.0)),
        padding: EdgeInsets.all(15.0),
        child: Text("登录"),
        textColor: Colors.white,
        onPressed: () async {
          if(lastPopTime == null || DateTime.now().difference(lastPopTime) > Duration(seconds: 4)) {
            lastPopTime = DateTime.now();
            if ((_formKey.currentState as FormState).validate()) {
              await login(_usernameController.text.trim(), _passwordController.text.trim());
              if (islogin) {
                canteenlist.clear();
                useInfoBase64 = "";
                String userName = await KvStores.get(KeyConst.USER_NAME);
                await Provide.value<GetUserInfoDataProvide>(context).getUserInfo(userName);
                if (Provide.value<GetUserInfoDataProvide>(context).userinfodata.data != null &&
                    Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.userType.length > 0) {
                  usertype = Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.userType;
                  if(usertype.length==0) usertype="2";
                  realName=Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.userName;
                  gender=Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.sex;
                  organizeid=Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.organizeId;
                  birthday=Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.birthday;
                  rootOrgid = Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.rootOrgId;
                  if(usertype=="1"||usertype=="3"){
                    canteenID=Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.canteenId.toString();
                    canteenName=Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.canteenName;
                  }
                  totalMoney=Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.money;
                  if (Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.isEmployee != null) {
                    if (Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.isEmployee)
                      is_employee = 1;
                    else
                      is_employee = 2;
                  }
                  useInfoBase64=Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.portraitNew;
                  featureBase64=Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.feature;
                } else {
                  usertype = "2";
                }
//                if(usertype=="1"||usertype=="3"){
                //modify by gaoyang 2020-11-24
                  if(usertype=="1"){
                  await getAuthorization();
                }else{
                  UserAndCanteen userAndCanteen = await db.getCanteenByUserId(int.parse(userID));
                  if(userAndCanteen==null){
                    await _associatecanteen();
                  }else{
                    canteenID = userAndCanteen.canteen_id.toString();
                    canteenName = userAndCanteen.canteen_name;
                  }
                }
                if(canteenID!=null&&canteenID!="null"&&canteenID!=""){
                  await _getPersonInfo(context);
                }
                //极光推送注册alias
                jPush.setAlias(userID);
              }
              if (islogin && (usertype == "1"||usertype == "3")) {
                isYouKe = false;
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ManagerIndexPage()));
                //Appliaction.router
                //    .navigateTo(context, "/managerIndexPage");
              } else if (islogin && usertype == "2") {
                if (Provide.value<GetUserInfoDataProvide>(context).userinfodata !=
                    null &&
                    Provide.value<GetUserInfoDataProvide>(context)
                        .userinfodata
                        .data
                        .portraitNew
                        .length >
                        0 &&
                    Provide.value<GetUserInfoDataProvide>(context)
                        .userinfodata
                        .data
                        .userName
                        .length >
                        0) {
                  isYouKe = false;
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ClientIndexPage()));
                  //Appliaction.router
                  //    .navigateTo(context, "/userIndexPage");
                } else {
                  isYouKe = false;
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CompletePersonInfoPage()));
                  //Appliaction.router
                  //    .navigateTo(context, "/completeInfoPage");
                }
              } else {
                showMessage(context,retLoginMessage);
              }
            }
          }else{
            lastPopTime = DateTime.now();
            showMessage(context,"请勿重复点击！");
            return;
          }
        },
      ),
    );
  }

  Future getAuthorization() async {
    await requestGet(
      'getauthorization',
      '?type=organize',
    ).then((val) async {
      if (val != null) {
        authoritionData = Autogenerated.fromJson(val);
        organizeMap.clear();
        List<AutogeneratedData> list = authoritionData.data;
        list.forEach((f){
          organizeMap[f.organizeId] = f.organizeName;
        });
//        await autoLogin();
      }
      print(
          "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!:${canteenID},canteenName:${canteenName}");

//      notifyListeners();
    });
  }

  //忘记密码
  Widget registeAndforgetPassWDWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setSp(86.0),
          ScreenUtil().setSp(0.0),
          ScreenUtil().setSp(86.0),
          ScreenUtil().setSp(0.0)),
      child: Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       crossAxisAlignment: CrossAxisAlignment.center,
       children: <Widget>[
       FlatButton(
        child: Text("注册",style: TextStyle(
            color: Colors.grey,
            fontSize: ScreenUtil.getInstance().setSp(28))),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => RegisterWidget()));
          //Appliaction.router.navigateTo(context, "/resetPage");
        },
       ),
         FlatButton(
           child: Text("忘记密码",style: TextStyle(
               color: Theme.of(context).primaryColor,
               fontSize: ScreenUtil.getInstance().setSp(28))),
           onPressed: () {
             Navigator.push(
                 context, MaterialPageRoute(builder: (context) => ResetWidget()));
             //Appliaction.router.navigateTo(context, "/resetPage");
           },
         ),
    ]));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: WillPopScope(
        onWillPop: () async {
      if (Platform.isAndroid) {
        AndroidBackTop.backDeskTop(); //设置为返回不退出app
        return false;
      } //一定要return false
    },
    child:SingleChildScrollView(
            child: Padding(
      padding: EdgeInsets.symmetric(
          vertical: 16.0, horizontal: ScreenUtil().setSp(8)),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Form(
          child: Column(children: <Widget>[
            topBGIMG(),
            Row(
              children: <Widget>[
                isYouKe?backButtonWidget():Container(),
                Column(
                  children: <Widget>[
                    titleWidget("账号密码"),
                    titleWidget2("—"),
                  ],
                )
              ],
            ),
            inputPhoneNumWidget(),
            Offstage(
              child: _buildListView(),
              offstage: !_expand,
            ),
            inputPassWDWidget(),
            loginButtonWidget(),
            registeAndforgetPassWDWidget()
          ]),
          key: _formKey,
          autovalidate: true,
        ),
      ),
    ))));
  }

  Widget topBGIMG() {
     return Container(
       height: ScreenUtil().setSp(500),
       decoration: BoxDecoration(
           image: DecorationImage(
             image: AssetImage("assets/images/BG.png"),
             fit: BoxFit.fill,
           )),
     );
  }



  void login(String username, String password) async {
    currentstatus = 0;
    currentnum = 1;
    currentprice = 10;

    var data = {
      'phone_num': username,
      'password': password,
    };
    await request('loginByUsername', '', formData: data).then((val) async{
      if (val.toString() == "false") {
        return;
      }

      realName = "";
      if (val != null) {
        var data = val;
        loginDataModel loginModel = loginDataModel.fromJson(data);
        retLoginMessage = loginModel.message;
        if (int.parse(loginModel.code) < 0) {
          showMessage(context,loginModel.message);
          islogin = false;
        } else if (int.parse(loginModel.code) == 0) {
          realName = loginModel.data.userName;
          // canteenName=loginModel.data.canteenName;
          // canteenID=loginModel.data.canteenId.toString();
          showMessage(context,"登录成功");

          await KvStores.save(KeyConst.USER_NAME, username);
          await KvStores.save(KeyConst.PASSWORD, password);
          await KvStores.save(KeyConst.LOGIN, true);
          await KvStores.save(KeyConst.USERTYPE, loginModel.data.userType);
          await KvStores.save(KeyConst.MESSAGE, loginModel.message);
          await KvStores.save(KeyConst.USERID, loginModel.data.userId.toString());
          await KvStores.saveUser(User(username, password));
          await KvStores.addNoRepeat(_users, User(username, password));
          userID = loginModel.data.userId.toString();
          islogin = true;
        } else {
          islogin = false;
        }
      }
    });
  }

  //加载个人信息
  Future _getPersonInfo(BuildContext context) async {
    await requestGet('systemconfig', '?config_desc=报餐&canteen_id=${canteenID}').then((val) {
      sysConfigModel getpriceModelData = sysConfigModel.fromJson(val);
      if (getpriceModelData.code == "0") {
        String breakfastprices = "";
        String lunchprices = "";
        String superprices = "";
        for (int i = 0; i < getpriceModelData.data.length; i++) {
          if(getpriceModelData.data[i].configKey.contains('_')){
            List str1 =  getpriceModelData.data[i].configKey.split('_');
            if(str1[1]==organizeid.toString()){
              if(str1[0] =="0"){
                breakfastprices =getpriceModelData.data[i].configValue;
              }
              if(str1[0] =="1"){
                lunchprices = getpriceModelData.data[i].configValue;
              }
              if(str1[0] =="2"){
                superprices = getpriceModelData.data[i].configValue;
              }
            }
          }
          if (getpriceModelData.data[i].configKey == "0") {
            breakfastprice = getpriceModelData.data[i].configValue;
          }else if (getpriceModelData.data[i].configKey == "1"){
            lunchprice = getpriceModelData.data[i].configValue;
          }else if (getpriceModelData.data[i].configKey == "2") {
            superprice = getpriceModelData.data[i].configValue;
          }
        }
        if(breakfastprices!=""){
          breakfastprice = breakfastprices;
        }
        if(lunchprices!=""){
          lunchprice = lunchprices;
        }
        if(superprices!=""){
          superprice = superprices;
        }
      } else {
        breakfastprice = '10.0';
        lunchprice = '20.0';
        superprice = '20.0';
      }
    });

    await requestGet('systemconfig', '?config_desc=moreconfig&canteen_id=${canteenID}').then((val) {
      sysConfigModel sysconfModelData = sysConfigModel.fromJson(val);
      if (sysconfModelData.code == "0") {
        if (sysconfModelData.data.length == 0){
          initDataToDatabase();
        }else {
          for (int i = 0; i < sysconfModelData.data.length; i++) {
            if (sysconfModelData.data[i].configKey.toLowerCase() == "nposted_permit") {//不报餐是否允许吃饭
              sysconfModelData.data[i].configValue.trim() == "1"
                  ? switchIfnopostEaten = true
                  : switchIfnopostEaten = false;
            } else if (sysconfModelData.data[i].configKey.toLowerCase() == "ifenablesaturday") {
              sysconfModelData.data[i].configValue.trim() == "1"
                  ? switchIfenablesaturday = true
                  : switchIfenablesaturday = false;
            } else if (sysconfModelData.data[i].configKey.toLowerCase() == "ifenablesunday") {
              sysconfModelData.data[i].configValue.trim() == "1"
                  ? switchIfenableSunday = true
                  : switchIfenableSunday = false;
            } else if (sysconfModelData.data[i].configKey.toLowerCase() == "ifenablebreakfast") {
              sysconfModelData.data[i].configValue.trim() == "1"
                  ? switchIfenableBreakfast = true
                  : switchIfenableBreakfast = false;
            } else if (sysconfModelData.data[i].configKey.toLowerCase() == "ifenablelunch") {
              sysconfModelData.data[i].configValue.trim() == "1"
                  ? switchIfenableLunch = true
                  : switchIfenableLunch = false;
            } else if (sysconfModelData.data[i].configKey.toLowerCase() == "ifenablesuper") {
              sysconfModelData.data[i].configValue.trim() == "1"
                  ? switchIfenableSuper = true
                  : switchIfenableSuper = false;
            } else if (sysconfModelData.data[i].configKey.toLowerCase() == "ifbringotherswithpost") {
              sysconfModelData.data[i].configValue.trim() == "1"
                  ? switchIfBringOthersWithPost = true
                  : switchIfBringOthersWithPost = false;
            } else if (sysconfModelData.data[i].configKey.toLowerCase() == "ifbringotherswithoutpost") {
              sysconfModelData.data[i].configValue.trim() == "1"
                  ? switchIfBringOthersWithoutPost = true
                  : switchIfBringOthersWithoutPost = false;
            } else if (sysconfModelData.data[i].configKey.toLowerCase() == "ifpaymoneybeforeeat") {
              if (sysconfModelData.data[i].configValue.trim() == "1") {
                switchIftakeMoneyEaten = false;
                switchIftakeMoneyPost = true;
              } else {
                switchIftakeMoneyEaten = true;
                switchIftakeMoneyPost = false;
              }
            }
          }
          String breakfastdeadlines = "";
          String lunchdeadlines = "";
          String dinnerdeadlines = "";
          for (int i = 0; i < sysconfModelData.data.length; i++) {
            if(sysconfModelData.data[i].configKey.contains('||')){
              List str1 =  sysconfModelData.data[i].configKey.split('||');
              if(str1[1]==organizeid.toString()){
                if(str1[0] =="breakfastdeadline"){
                  breakfastdeadlines = sysconfModelData.data[i].configValue;
                }
                if(str1[0] =="lunchdeadline"){
                  lunchdeadlines = sysconfModelData.data[i].configValue;
                }
                if(str1[0] =="superdeadline"){
                  dinnerdeadlines = sysconfModelData.data[i].configValue;
                }
                if(str1[0] =="iffirst_money"){
                  iffirstMoney = sysconfModelData.data[i].configValue;
                }
              }
            }
            if (sysconfModelData.data[i].configKey == "breakfastdeadline") {
              breakfastdeadline = sysconfModelData.data[i].configValue;
            }else if (sysconfModelData.data[i].configKey == "lunchdeadline"){
              lunchdeadline = sysconfModelData.data[i].configValue;
            }else if (sysconfModelData.data[i].configKey == "superdeadline") {
              dinnerdeadline = sysconfModelData.data[i].configValue;
            }
          }
          if(breakfastdeadlines!=""){
            breakfastdeadline = breakfastdeadlines;
          }
          if(lunchdeadlines!=""){
            lunchdeadline = lunchdeadlines;
          }
          if(dinnerdeadlines!=""){
            dinnerdeadline = dinnerdeadlines;
          }
        }
      }
    });
    setState(() {});
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

  ///获取历史用户
  void _gainUsers() async {
    _users.clear();
    _users.addAll(await  KvStores.getUsers());
    //默认加载第一个账号
    if (_users!=null&&_users.length > 0) {
      _username = _users[0].username;
      _password = _users[0].password;
    }
  }

  ///构建历史账号ListView
  Widget _buildListView() {
    if (_expand) {
      List<Widget> children = _buildItems();
      if (children.length > 0) {
        RenderBox renderObject = _globalKey.currentContext.findRenderObject();
        final position = renderObject.localToGlobal(Offset.zero);
        double screenW = MediaQuery.of(context).size.width;
        double currentW = renderObject.paintBounds.size.width;
        double currentH = renderObject.paintBounds.size.height;
        double margin = (screenW - currentW) / 2;
        double offsetY = position.dy;
        double itemHeight = 30.0;
        double dividerHeight = 2;
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: ListView(
            itemExtent: itemHeight,
            padding: EdgeInsets.all(0),
            children: children,
          ),
          width: currentW,
          height: (children.length * itemHeight +
              (children.length - 1) * dividerHeight),
          margin: EdgeInsets.fromLTRB(margin, 0, margin, 0),
        );
      }
    }
    else {
      return Container();
    }
  }

  ///构建历史记录items
  List<Widget> _buildItems() {
    List<Widget> list = new List();
    for (int i = 0; i < _users.length; i++) {
      if (!_users[i].toString().contains("null")&&_users[i] != User(_usernameController.text.trim(), _passwordController.text.trim())) {
        //增加账号记录
        list.add(_buildItem(_users[i]));
        //增加分割线
        list.add(Divider(
          color: Colors.grey,
          height: 2,
        ));
      }
    }
    if (list.length > 0) {
      list.removeLast(); //删掉最后一个分割线
    }
    return list;
  }

  ///构建单个历史记录item
  Widget _buildItem(User user) {
    return GestureDetector(
      child: Container(
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(user.username),
              ),
            ),
            GestureDetector(
              child: Padding(
                padding: EdgeInsets.only(right: 5),
                child: Icon(
                  Icons.highlight_off,
                  color: Colors.grey,
                ),
              ),
              onTap: () async{

                  _users.remove(user);
                  await KvStores.delUser(user);
                  setState(() {
                  //处理最后一个数据，假如最后一个被删掉，将Expand置为false
                  if(_users.length==0 ||(_users.length==1&& _users[0] == User( _usernameController.text.trim(),  _passwordController.text.trim()))) {
                    //如果个数大于1个或者唯一一个账号跟当前账号不一样才弹出历史账号
                    _expand = false;
                  }
                  });
              },
            ),
          ],
        ),
      ),
      onTap: () {
        setState(() {
          _username = user.username;
          _password = user.password;
          _usernameController.text=_username;
          _passwordController.text=_password;
          _expand = false;
        });
      },
    );
  }
}
