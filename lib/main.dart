import 'package:flutter/material.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/provide/organizeinfo.dart';

//import 'package:flutter/cupertino.dart';  //IOS风格
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_canteen/router/routers.dart';
import 'package:flutter_canteen/router/application.dart';
import 'package:provide/provide.dart';
import 'package:flutter_canteen/provide/child_category.dart';
import 'package:flutter_canteen/provide/category_foods_list.dart';
import 'package:flutter_canteen/provide/detail_info.dart';
import 'package:flutter_canteen/provide/menu_data.dart';
import 'package:flutter_canteen/provide/rating_data.dart';
import 'package:flutter_canteen/provide/serchcateenname.dart';
import 'package:flutter_canteen/provide/userInfo.dart';
import 'package:flutter_canteen/provide/habbit.dart';
import 'package:flutter_canteen/provide/foodMenuRelease.dart';
import 'package:flutter_canteen/provide/orderstate.dart';
import 'package:flutter_canteen/pages/splashPage/splashPage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_canteen/provide/summaryData.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_canteen/delegate.dart';
import 'package:audioplayers/audio_cache.dart';



import 'dart:async';

//import 'package:flutter_tts/flutter_tts.dart';

void main() {
  var childCategory= ChildCategory();
  var categoryFoodsListProvide= CategoryFoodsListProvide();
  var detailsInfoProvide = DetailsInfoProvide();
  var menuDataProvide= MenuDataProvide();
  var ratedataprovide=RatingDataProvide();
  var searchCanteenNameProvide=searchcanteennameProvide();
  var getuserinfoDataProvide=GetUserInfoDataProvide();
  var postuserinfoDataProvide=PostUserInfoDataProvide();
  var providers  =Providers();
  var gethabbitProvide=GetHabbitDataProvide();
  var posthabbitProvde=PostHabbitDataProvide();
  var foodmenureleaseprovide=FoodMenuReleaseProvide();
  var getorderStatusprovice=GetOrderStatusProvide();
  var monthSummaryDataProvide=MonthSummaryDataProvide();
  var organizeDataProvide=GetOrganizeInfoDataProvide();
  WidgetsFlutterBinding.ensureInitialized();
  providers
    ..provide(Provider<ChildCategory>.value(childCategory))
    ..provide(Provider<CategoryFoodsListProvide>.value(categoryFoodsListProvide))
    ..provide(Provider<DetailsInfoProvide>.value(detailsInfoProvide))
    ..provide(Provider<MenuDataProvide>.value(menuDataProvide))
    ..provide(Provider<RatingDataProvide>.value(ratedataprovide))
    ..provide(Provider<searchcanteennameProvide>.value(searchCanteenNameProvide))
    ..provide(Provider<GetUserInfoDataProvide>.value(getuserinfoDataProvide))
    ..provide(Provider<PostUserInfoDataProvide>.value(postuserinfoDataProvide))
    ..provide(Provider<GetHabbitDataProvide>.value(gethabbitProvide))
    ..provide(Provider<PostHabbitDataProvide>.value(posthabbitProvde))
    ..provide(Provider<FoodMenuReleaseProvide>.value(foodmenureleaseprovide))
    ..provide(Provider<GetOrderStatusProvide>.value(getorderStatusprovice))
    ..provide(Provider<MonthSummaryDataProvide>.value(monthSummaryDataProvide))
    ..provide(Provider<GetOrganizeInfoDataProvide>.value(organizeDataProvide));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  //Size uiSize = Size(414, 896);
  //runFxApp(ProviderNode(child:MyApp(),providers:providers), uiSize: uiSize);
  runApp(ProviderNode(child:MyApp(),providers:providers));
  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor:Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String debugLable = 'Unknown'; //错误信息
  final JPush jpush = new JPush(); //初始化极光插件


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        Theme.of(context).brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark);
    final router = Router();
    Routes.configureRoutes(router);
    Appliaction.router = router;
    requestPermission();
    return Container(
      child: MaterialApp(
          localizationsDelegates: [
            CupertinoLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          supportedLocales: [
            const Locale('zh', 'CH'),
            const Locale('en', 'US')
          ],
          title: '阳光食堂',
          onGenerateRoute: Appliaction.router.generator,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            platform: TargetPlatform.iOS,
            //primaryColor: Colors.blue,
            //primaryColor: Color(0xffff9200),
            primaryColor: Color(0xffff9400),
          ),
          home:SplashPage(),
      ),
    );
  }

  /**
   * 极光推送接入
   */
  //FlutterTts flutterTts;

  String registerId = null;
  String myMsg;

  _startupJpush() {
    jPush.setup(
        appKey: "95fef60913d4c8caaf8073e9",
        production: false,
        debug: true,
        channel: "flutter_channel");
  }

  _getRegisterID() async {
    registerId = await jPush.getRegistrationID();
    print('registerid=' + registerId);
    return registerId;
  }

  _setPushAlias() async{
    await jPush.setAlias(userID);
  }

  _setPushTag() {
    List<String> tags = List<String>();
    tags.add("NoPost");
    jPush.setTags(tags);
  }

  playLocal() async {
    AudioCache player = new AudioCache();
    const alarmAudioPath = "voice.mp3";
    player.play(alarmAudioPath,volume:1.0);
  }

  _addEventHandler() {
// Future<dynamic>event;
    jPush.addEventHandler(onReceiveNotification: (Map<String, dynamic> event) {
      print('addOnreceive>>>>>>$event');
      String msg = event.putIfAbsent("alert", () => ("")).toString();
      playLocal();
    }, onOpenNotification: (Map<String, dynamic> event) {
      print('addOpenNoti>>>>>$event'); // 点击通知回调方法。
      print(event.toString());
    }, onReceiveMessage: (Map<String, dynamic> event) {
      print('addReceiveMsg>>>>>$event'); //无效的
      print(event.toString());
    });
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //_initTTs();
    _startupJpush();
    _addEventHandler();
    _getRegisterID();


  }



  Future requestPermission() async {
    // 申请权限
    Map<PermissionGroup, PermissionStatus> permissions =
    await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    // 申请结果
    PermissionStatus permission =
    await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    if (permission == PermissionStatus.granted) {
      //Fluttertoast.showToast(msg: "权限申请通过");
    } else {
      Fluttertoast.showToast(msg: "读取权限申请被拒绝");
    }

    Map<PermissionGroup, PermissionStatus> speechs =
    await PermissionHandler().requestPermissions([PermissionGroup.speech]);
    PermissionStatus speech = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.speech);
    if (speech == PermissionStatus.granted) {
      //Fluttertoast.showToast(msg: "权限申请通过");onReceiveNotification
    } else {
      Fluttertoast.showToast(msg: "通知权限申请被拒绝");
    }

    Map<PermissionGroup, PermissionStatus> cameras =
    await PermissionHandler().requestPermissions([PermissionGroup.camera]);
    PermissionStatus camera = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.camera);
    if (camera == PermissionStatus.granted) {
      //Fluttertoast.showToast(msg: "权限申请通过");onReceiveNotification
    } else {
      Fluttertoast.showToast(msg: "相机权限申请被拒绝");
    }

    Map<PermissionGroup, PermissionStatus> notification2 =
    await PermissionHandler().requestPermissions([PermissionGroup.notification]);
    PermissionStatus notification = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.notification);
    if (notification == PermissionStatus.granted) {
      //Fluttertoast.showToast(msg: "权限申请通过");onReceiveNotification
    } else {
      Fluttertoast.showToast(msg: "通知权限申请被拒绝");
    }
  }

}
