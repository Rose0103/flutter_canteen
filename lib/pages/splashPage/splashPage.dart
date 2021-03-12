import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_canteen/common/database_helper.dart';
import 'package:flutter_canteen/model/authorization.dart';
import 'package:flutter_canteen/model/canteenModel.dart';
import 'package:flutter_canteen/model/userandCanteen.dart';
import 'package:flutter_canteen/otherfunction/logutil.dart';
import 'package:flutter_canteen/otherfunction/showDialog.dart';
import 'package:flutter_canteen/pages/HomePage/clientHomePage.dart';
import 'package:flutter_canteen/pages/manager_index_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_canteen/common/shared_preference.dart';
import 'package:flutter_canteen/pages/LoginPage/login.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_canteen/provide/userInfo.dart';
import 'package:flutter_canteen/router/application.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_canteen/model/logindatamodel.dart';
import 'package:flutter_canteen/pages/client_index_page.dart';
import 'package:flutter_canteen/pages/LoginPage/CompletePersonInfoPage.dart';
import 'package:flutter_canteen/model/deadlinemodel.dart';
import 'package:flutter_canteen/model/updateVersion.dart';
import 'package:flutter_canteen/model/baoCanPriceModel.dart';
import 'package:provide/provide.dart';
import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:flutter/services.dart';
import 'package:flutter_canteen/app_info.dart';
import 'dart:io';
import 'dart:convert';

class SplashPage extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<SplashPage> {
  Timer timer;
  bool islogin = false;
  String retLoginMessage = " ";
  String _message = '';
  String _customJson = '';
  String lastesversion = "0";
  var db;//本地数据库
  Autogenerated authoritionData;

  @override
  void initState() {
    db = new DatabaseHelper();
    autoLogin();
    super.initState();
    initXUpdate();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      timer = new Timer(const Duration(milliseconds: 1000), () async {
        try {
          //更新升级程序
          int version = 121;
          await _getVersion(context);
          if (int.parse(lastesversion.replaceAll(".", "")) > version) {
            if (Platform.isAndroid) {
              String _updateUrl =
                  "http://$resourceUrl/version/update_custom.json";
              FlutterXUpdate.checkUpdate(url: _updateUrl, isCustomParse: true);
            } else {}
          }

//          await autoLogin();

          if (!islogin)
            Navigator.of(context).pushAndRemoveUntil(
                new MaterialPageRoute(
                    builder: (BuildContext context) => new LoginWidget()),
                ( //跳转到登录页
                        Route route) =>
                    route == null);
        } catch (e) {}
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future getAuthorization() async {
    await requestGet(
      'getauthorization',
      '?type=organize',
    ).then((val) async {
      if (val != null) {
        authoritionData = Autogenerated.fromJson(val);
        //modify by
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

  Future _associatecanteen() async {
    await requestGet('getauthorization', '?type=canteen' ).then((val)async{
      if(val.toString() == "false"){
        return;
      }
      print("laile");
      LogUtil.v(val.toString());
      if(val != null){
        canteenModel canteenModelData = canteenModel.fromJson(val);
        canteenlist = canteenModelData.data;
        print(canteenlist.length);
        canteenID = canteenModelData.data[0].canteenId.toString();
        print(canteenID);
        canteenName = canteenModelData.data[0].canteenName.toString();
        print(canteenName);
        UserAndCanteen userAndCanteen = new UserAndCanteen(
            user_id: int.parse(userID),
            canteen_id: int.parse(canteenID),
            canteen_name: canteenName
        );
        db.saveRecord(userAndCanteen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return new Material(
        child:  Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/images/splash.png"),
              fit: BoxFit.fill,
            )),
          ),
        );
  }

  void autoLogin() async {
    String userName = await KvStores.get(KeyConst.USER_NAME);
    String passwd = await KvStores.get(KeyConst.PASSWORD);
    if (userName==null||userName==""||passwd==null||passwd=="") {
      userName = yUserName;
      passwd = yPassword;
      isYouKe = true;
    }
    usertype = "2";
    await login(userName, passwd);
    if (islogin) {
      canteenlist.clear();
      useInfoBase64 = "";
      String userName = await KvStores.get(KeyConst.USER_NAME);
      print(userName);
      await Provide.value<GetUserInfoDataProvide>(context).getUserInfo(userName);
      if (Provide.value<GetUserInfoDataProvide>(context).userinfodata.data !=
          null &&
          Provide.value<GetUserInfoDataProvide>(context)
              .userinfodata
              .data
              .userType
              .length >
              0) {
        usertype = Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.userType;
        if (usertype.length == 0) {usertype = "2";}
        realName = Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.userName;
        gender = Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.sex;
        organizeid = Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.organizeId;
        birthday = Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.birthday;
        rootOrgid = Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.rootOrgId;
        canteenID = Provide.value<GetUserInfoDataProvide>(context)
            .userinfodata
            .data
            .canteenId
            .toString();
        canteenName = Provide.value<GetUserInfoDataProvide>(context)
            .userinfodata
            .data
            .canteenName;
        totalMoney = Provide.value<GetUserInfoDataProvide>(context)
            .userinfodata
            .data
            .money;
        if (Provide.value<GetUserInfoDataProvide>(context)
            .userinfodata
            .data
            .isEmployee !=
            null) {
          if (Provide.value<GetUserInfoDataProvide>(context)
              .userinfodata
              .data
              .isEmployee)
            is_employee = 1;
          else
            is_employee = 2;
        }
        useInfoBase64 = Provide.value<GetUserInfoDataProvide>(context)
            .userinfodata
            .data
            .portraitNew;
        featureBase64 = Provide.value<GetUserInfoDataProvide>(context)
            .userinfodata
            .data
            .feature;
      } else {
        usertype = "2";
      }
//        if(usertype=="1"||usertype=="3"){
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
      print("9999999999999999$canteenID");
      if(canteenID!=null&&canteenID!="null"&&canteenID!=""){
        await _getPersonInfo(context);
      }
      //极光推送注册alias
      print(userID);
      jPush.setAlias(userID);
    }
    if (islogin && (usertype == "1"||usertype == "3")) {
      Navigator.of(this.context).pop();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ManagerIndexPage()));
      //Appliaction.router
      //    .navigateTo(context, "/managerIndexPage");
    } else if (islogin && usertype == "2") {
      print("piclength=${Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.portraitNew.length}");
      if (Provide.value<GetUserInfoDataProvide>(context).userinfodata != null &&
          Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.userName.length>0) {
        Navigator.of(this.context).pop();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ClientIndexPage()));
        // Appliaction.router
        //     .navigateTo(context, "/userIndexPage");
      } else {
        //Navigator.of(context).pop();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CompletePersonInfoPage()));
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
    await request('loginByUsername', '', formData: data).then((val) {
      if (val.toString() == "false") {
        return;
      }
      realName = "";
      if (val != null) {
        print(val.toString());
        var data = val;
        print(data);
        loginDataModel loginModel = loginDataModel.fromJson(data);
        retLoginMessage = loginModel.message;
        print(loginModel.code);
        if (int.parse(loginModel.code) < 0) {
          islogin = false;
          showMessage(context, loginModel.message);
          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginWidget()));
        } else if (int.parse(loginModel.code) == 0) {
          realName = loginModel.data.userName;
          // canteenName = loginModel.data.canteenName;
//          canteenID = loginModel.data.canteenId.toString();
          print(loginModel.message);
          if(!isYouKe){
            KvStores.save(KeyConst.USER_NAME, username);
            KvStores.save(KeyConst.PASSWORD, password);
            KvStores.save(KeyConst.LOGIN, true);
            KvStores.save(KeyConst.USERTYPE, loginModel.data.userType);
            KvStores.save(KeyConst.MESSAGE, loginModel.message);
            KvStores.save(KeyConst.USERID, loginModel.data.userId.toString());
          }
          userID = loginModel.data.userId.toString();
          islogin = true;
        } else {
          islogin = false;
        }
      }
    });
  }

  //版本号获取
  Future _getVersion(BuildContext context) async {
    await requestGet('updateversion', '').then((val) {
      //var data = json.decode(val.toString());
      print("val${val.toString()}");
      updateModel versionModel = updateModel.fromJson(val);
      print("val222${val.toString()}");
      if (versionModel.code == "0") {
        lastesversion = versionModel.data.verison;
        print("获取版本信息成功$lastesversion");
      } else {
        print("获取版本信息失败");
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
    for (int i = 1; i <= 9; i++) {
      String keyname = "";
      String keyvalue = "";
      switch (i) {
        case 1:
          keyname = "nposted_permit";
          keyvalue = "1";
          switchIfnopostEaten = true;
          break;
        case 2:
          keyname = "ifenablesaturday";
          keyvalue = "1";
          switchIfenablesaturday = true;
          break;
        case 3:
          keyname = "ifenablesunday";
          keyvalue = "1";
          switchIfenableSunday = true;
          break;
        case 4:
          keyname = "ifenablebreakfast";
          keyvalue = "1";
          switchIfenableBreakfast = true;
          break;
        case 5:
          keyname = "ifenablelunch";
          keyvalue = "1";
          switchIfenableLunch = true;
          break;
        case 6:
          keyname = "ifenablesuper";
          keyvalue = "1";
          switchIfenableSuper = true;
          break;
        case 7:
          keyname = "ifbringotherswithpost";
          keyvalue = "1";
          switchIfBringOthersWithPost = true;
          break;
        case 8:
          keyname = "ifbringotherswithoutpost";
          keyvalue = "1";
          switchIfBringOthersWithoutPost = true;
          break;
        case 9:
          keyname = "ifpaymoneybeforeeat";
          keyvalue = "1";
          switchIftakeMoneyEaten = true;
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
    print(formData.toString());
    await request('systemconfig', '', formData: formData).then((val) {
      setPriceReturnModel postreturnModel = setPriceReturnModel.fromJson(val);
      if (postreturnModel.code == "0")
        Fluttertoast.showToast(msg: "初始化设置成功");
      else
        Fluttertoast.showToast(msg: "初始化设置失败，" + postreturnModel.message);
    });
  }

  Future<void> loadJsonFromAsset() async {
    _customJson = await rootBundle.loadString('assets/update_custom.json');
  }

  ///初始化
  void initXUpdate() {
    if (Platform.isAndroid) {
      FlutterXUpdate.init(

              ///是否输出日志
              debug: true,

              ///是否使用post请求
              isPost: false,

              ///post请求是否是上传json
              isPostJson: false,

              ///是否开启自动模式
              isWifiOnly: false,

              ///是否开启自动模式
              isAutoMode: false,

              ///需要设置的公共参数
              supportSilentInstall: false,

              ///在下载过程中，如果点击了取消的话，是否弹出切换下载方式的重试提示弹窗
              enableRetry: false)
          .then((value) {
        updateMessage("初始化成功: $value");
      }).catchError((error) {
        print(error);
      });

//      FlutterXUpdate.setErrorHandler(
//          onUpdateError: (Map<String, dynamic> message) async {
//        print(message);
//        //下载失败
//        if (message["code"] == 4000) {
//          FlutterXUpdate.showRetryUpdateTipDialog(
//              retryContent: "Github被墙无法继续下载，是否考虑切换蒲公英下载？",
//              retryUrl: "https://www.pgyer.com/flutter_learn");
//        }
//        setState(() {
//          _message = "$message";
//        });
//      });

//      FlutterXUpdate.setCustomParseHandler(onUpdateParse: (String json) async {
//        //这里是自定义json解析
//        return customParseJson(json);
//      });

      FlutterXUpdate.setUpdateHandler(
          onUpdateError: (Map<String, dynamic> message) async {
        print(message);
        //下载失败
        if (message["code"] == 4000) {
          FlutterXUpdate.showRetryUpdateTipDialog(
              retryContent: "Github被墙无法继续下载，是否考虑切换蒲公英下载？",
              retryUrl: "https://www.pgyer.com/flutter_learn");
        }
        setState(() {
          _message = "$message";
        });
      }, onUpdateParse: (String json) async {
        //这里是自定义json解析
        return customParseJson(json);
      });
    } else {
      updateMessage("ios暂不支持XUpdate更新");
    }
  }

  void updateMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  ///将自定义的json内容解析为UpdateEntity实体类
  UpdateEntity customParseJson(String json) {
    AppInfo appInfo = AppInfo.fromJson(json);
    print(appInfo);
    return UpdateEntity(
        hasUpdate: appInfo.hasUpdate,
        isIgnorable: appInfo.isIgnorable,
        versionCode: appInfo.versionCode,
        versionName: appInfo.versionName,
        updateContent: appInfo.updateLog,
        downloadUrl: appInfo.apkUrl,
        apkSize: appInfo.apkSize);
  }
}