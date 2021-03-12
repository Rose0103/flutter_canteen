import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/pages/foodManage/addCaiPin.dart';
import 'package:flutter_canteen/pages/foodManage/lostPage.dart';
import 'package:flutter_canteen/pages/foodManage/publishCaiPin.dart';
import 'package:flutter_canteen/pages/foodManage/totalCaiPin.dart';
import 'package:flutter_canteen/pages/foodManage/historyCaiDan.dart';
import 'package:flutter_canteen/pages/Ratingpages/Ratingrankpage.dart';
import 'package:flutter_canteen/pages/HomePage/abourtSoftware.dart';
import 'package:flutter_canteen/pages/detailPages/dishdetail.dart';
import 'package:flutter_canteen/pages/loveShopPage/loveShopPage.dart';
import 'package:flutter_canteen/pages/loveShopPage/managerLoveShopPage.dart';
import 'package:flutter_canteen/pages/mealStatisticalDetailedPage/mealStatisticalDetailedPage.dart';
import 'package:flutter_canteen/pages/mineOrderPage/mineOrderPage.dart';
import 'package:flutter_canteen/pages/orderMealPage/orderMealPage.dart';
import 'package:flutter_canteen/pages/summaryPage/clientMonthSummary.dart';
import 'package:flutter_canteen/pages/supportingPoorShopPage/supportingpoorshop.dart';
import 'package:flutter_canteen/pages/LoginPage/login.dart';
import 'package:flutter_canteen/pages/LoginPage/register.dart';
import 'package:flutter_canteen/pages/LoginPage/ResetPassWord.dart';
import 'package:flutter_canteen/pages/manager_index_page.dart';
import 'package:flutter_canteen/pages/client_index_page.dart';
import 'package:flutter_canteen/pages/LoginPage/habitChosePage/habitChosePage.dart';
import 'package:flutter_canteen/pages/LoginPage/CompletePersonInfoPage.dart';
import 'package:flutter_canteen/pages/orderPage/clientorder_mainPage.dart';
import 'package:flutter_canteen/pages/facedetect/facedetectPage.dart';
import 'package:flutter_canteen/pages/commentPages/showcommentPage.dart';
import 'package:flutter_canteen/pages/commentPages/putcommentPage.dart';
import 'package:flutter_canteen/pages/systemSettingPage/systemSettingPage.dart';
import 'package:flutter_canteen/pages/webViewPage/myWebViewpage.dart';
import 'package:flutter_canteen/pages/commentsSectionPage/commentsSectionPage.dart';

Handler managerHomePageNavigatorHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String id = params['funcID'].first;
  if (id == '00001')
    return PublishCaiPinPage(id);
  else if (id == '00002')
    return AddCaiPinPage(id);
  else if (id == '00003')
    return TotalCaiPinPage(id);
  else if (id == '00004')
    return HistoryCaiDanPage(id);
  else if (id == '00005')
    return RatingrankPage(id);
  else if (id == '00006')
    return loveShopPage(id);
  else if (id == '00007')
    return CommentsSectionPage();
  else
    return LostPage(id);
});

Handler clientHomePageNavigatorHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      String id = params['funcID'].first;
      if (id == '00001')
        return orderMealPage('00001');
      else if (id == '00002')
        return TotalCaiPinPage(id);
      else if (id == '00003')
        return RatingrankPage(id);
      else if (id == '00004')
        return loveShopPage(id);
      else if (id == '00005')
        return CommentsSectionPage();
      else
        return LostPage(id);
    });

Handler detailsHander = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String foodsId = params['id'].first;
  print('index>details foodsID is ${foodsId}');
  return DetailsPage(foodsId);
});

Handler LoginHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return LoginWidget();
});

Handler RegisterHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return RegisterWidget();
});

Handler ResetHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ResetWidget();
});

Handler ManagerIndexHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ManagerIndexPage();
});

Handler ClientIndexHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ClientIndexPage();
});

Handler completeInfoPageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return CompletePersonInfoPage();
});

Handler habitchosePageHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return MyChoicePage();
});



Handler addCaiPinPageHander= Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return AddCaiPinPage("00002");
    });

Handler systemHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String id = params['id'].first;
  print('index>details ID is ${id}');
  if (id == "3")
    return CompletePersonInfoPage();
  else if (id == "4")
    return mineOrderPage();
  else if (id == "5") return AboutSoftWarePage(id);
});

Handler userCenterDetaieHander = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String id = params['id'].first;
  print('index>details ID is ${id}');
  if (id == "3")
    return CompletePersonInfoPage();
  else if (id == "4")
    return mineOrderPage();
  else if (id == "5") return systemSettingPage();
});

Handler facepageHander = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
//      return FaceDetectPage();
    });

Handler showcommentpageHander=Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print(params);
      String mealtime = params['mealtime'].first;
      int mealtype = int.parse(params['mealtype'].first);
      String ordernumber=params['ordernumber'].first;
      int ordertype= int.parse(params['ordertype'].first);
      String totalnum=params['totalnum'].first;
      String totalprice=params['totalprice'].first;
      String orderdesc = params['orderdesc'].first;
      String caName = params['drinkCanteenName'].first;
      int canteenID_ID = int.parse(params['canteenID_ID'].first);
      return showcommentPage(mealtime, mealtype,ordernumber,ordertype,totalnum,totalprice,userID,orderdesc,caName,canteenID_ID);
    });

Handler putcommentpageHander=Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print(params);
      String mealtime = params['mealtime'].first;
      int mealtype = int.parse(params['mealtype'].first);
      String ordernumber=params['ordernumber'].first;
      int ordertype= int.parse(params['ordertype'].first);
      String totalnum=params['totalnum'].first;
      String totalprice=params['totalprice'].first;
      int c_id= int.parse(params['c_id'].first);
      return putCommentPage(mealtime, mealtype,ordernumber,ordertype,totalnum,totalprice,c_id);
    });
    
Handler mealStatisticalDetaileHander=Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print(params);
      String mealtime = params['mealtime'].first;
      int mealtype = int.parse(params['mealtype'].first);
      return MealStatisticalDetailedPage(mealtime, mealtype);
    });

Handler clientOrderDetailHander=Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return ClientOrderPage("");
    });

Handler myWebViewPageHander=Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
      Uri url = params['url'].first;
   String title = params['title'].first;
      return myWebViewPage(url,title);
    });

Handler managerLoveShopHander=Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {

      return managerLoveShopPage();
    });