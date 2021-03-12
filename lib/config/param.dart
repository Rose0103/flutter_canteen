//import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_canteen/model/canteenModel.dart';
import 'package:flutter_canteen/model/category.dart';
import 'package:flutter_canteen/model/organizemodel.dart';
import 'package:flutter_canteen/pages/mealStatisticalDetailedPage/mealStatisticalDetailedModel.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

//const String serverIP="106.12.144.158";
//const String serverIP="106.13.88.69";
//const String serverIP="192.168.65.236";
const String serverIP="canteen.yangguangshitang.com";
const String resourceUrl="source.yangguangshitang.com";
double painterWidgetWidth=400;
double painterWidgetHeiht=780;
String fullPicPath;
String facePicPath;
String fullLight;
String leftfaceLight;
String rightfaceLight;
//Face detectFace;
String featurelast;

String cookie;
String canteenID;
String userID;
String canteenName;
String usertype="2";  //初始值
String realName;
String totalMoney="0.0";
int gender;
int is_employee;
int organizeid;
int rootOrgid;
String birthday;
String useInfoBase64;
String featureBase64;
String dishPicpath;
String paths;
int Contentfontsize=25;
bool loadNetImage=false;
bool isAutoLogin=true;
int currentstatus=0;  //当前最新状态，用于两个订餐页面的刷新
int currentnum=1;
double currentprice=10.0;
String currentdate;
int currentmealtype;
int floaststaytime=3;
String breakfastdeadline='07:00:00';
String lunchdeadline='10:00:00';
String dinnerdeadline='16:30:00';
String breakfastprice="10";
String lunchprice="20";
String superprice="20";
int dingpersonnum=1;
String searchkey = ""; //搜索的关键字
bool isupdateorganize = false;//判断是否更改了组织
List<OrganizeData> organizelist = new List<OrganizeData>();//组织机构信息
List items = new List();//listview子组件
List<Data> canteenlist = [];//食堂
List<CategoryBigModelData> categoryList = [];
String diningCanteenID ;  //已报餐食堂id
String dingingCanteenName; //已报餐食堂name
bool dinging = true;
int dingdanID; //订单id
String dining_status;

String baiduToken ;//百度token
bool isFaceDetection = true;
String faceDetectionMsg ;


FlatButton personnelRefreshBtn;//人员管理页面刷新按钮
bool personnelRefresh = false;//人员管理页面刷新


bool switchIfnopostEaten = true; //不报餐是否允许吃饭 ,人脸终端判断
bool switchIfenablesaturday = true; //周六是否开启报餐
bool switchIfenableSunday = true; //周六是否开启报餐
bool switchIfenableBreakfast = true; //早餐是否开启报餐
bool switchIfenableLunch = true; //中餐是否开启报餐
bool switchIfenableSuper = true; //晚餐是否开启报餐
bool switchIfBringOthersWithPost = true; //是否开启报餐允许带人开饭，客户端限制数量，人脸终端判断
bool switchIfBringOthersWithoutPost = true; //是否开启不报餐允许带人开饭，人脸终端判断
bool switchIftakeMoneyEaten = true; //就餐时扣钱
bool switchIftakeMoneyPost = false; //报餐时扣钱
bool switchPreferentialDeduction = false; //优先扣点券
bool switchPreferentialDeductionMoney = true; //优先扣余额
bool switchOnlyMoney = false; //只扣余额
bool switchCountingMonthClear = true; //点券月底清零
String iffirstMoney = "2";//扣款顺序
bool switchIftakeMoney = false; //就餐时输入扣款金额
bool none = true;
bool counting = true;
int startIndexs = 0;
int endIndexs = 10;
List listss = new List();



bool isfirst = true;
//特别关注的队列
Map<int, MealStatisticalDetailedModel> mapVIP = new Map();
JPush jPush = new JPush();
String staticimageurl = "http://source.yangguangshitang.com/";//图片静态地址
Map<int,String> organizeMap = new Map();//食堂关联下的所有机构
bool isYouKe = false;//是否为游客账号
final String yUserName = "12345678910";
final String yPassword = "asd12345";
int categoryIndex = 0;
String categoryBigModelDataSecondaryCategoryId;
int counts ;
//String imageshead = "http://riyugo.com/i/2020/12/08/sfsjej.jpg";