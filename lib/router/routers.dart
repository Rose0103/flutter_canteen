import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'router_handler.dart';

class Routes {
  static String root ='/';
  static String managerhomepagenavigator='/managerhomepagenavigator';
  static String clienthomepagenavigator='/clienthomepagenavigator';
  static String detailsPage = '/detail';
  static String loginPage='/loginPage';
  static String registerPage='/register';
  static String resetPage='/resetPage';
  static String managerIndexHandler='/managerIndexPage';
  static String clientIndexHandler='/userIndexPage';
  static String completeInfoPage='/completeInfoPage';
  static String habitchosePage='/habitchosePage';
  static String userCenterDetailPage='/userCenterdetail';
  static String addCaiPinPage='/addcaipin';
  static String facepage='/facePage';
  static String showcommentpage='/showcommentpage';
  static String putcommentpage='/putcommentpage';
  static String systemSetting='/systemSetting';
  static String mealStatisticalDetail='/mealStatisticalDetail';
  static String clientOrderDetail='/clientOrderDetail';
  static String myWebViewPage='/myWebViewPage';
  static String managerLoveShopPage='/managerLoveShopPage';

  static void configureRoutes(Router router) {
    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          print('ERROR====>ROUTE WAS NOT FOUND');
        }
    );
    router.define(loginPage, handler: LoginHandler);
    router.define(completeInfoPage,handler:completeInfoPageHandler);
    router.define(habitchosePage,handler:habitchosePageHandler);
    router.define(managerIndexHandler,handler:ManagerIndexHandler);
    router.define(clientIndexHandler,handler:ClientIndexHandler);
    router.define(registerPage, handler: RegisterHandler);
    router.define(resetPage, handler: ResetHandler);
    router.define(managerhomepagenavigator, handler:managerHomePageNavigatorHandler);
    router.define(clienthomepagenavigator, handler:clientHomePageNavigatorHandler);
    router.define(detailsPage,handler:detailsHander);
    router.define(userCenterDetailPage,handler:userCenterDetaieHander);
    router.define(systemSetting,handler:systemHandler);
    router.define(addCaiPinPage,handler:addCaiPinPageHander);
    router.define(facepage,handler:facepageHander);
    router.define(showcommentpage,handler:showcommentpageHander);
    router.define(putcommentpage,handler:putcommentpageHander);
    router.define(mealStatisticalDetail,handler:mealStatisticalDetaileHander);
    router.define(clientOrderDetail,handler:clientOrderDetailHander);
    router.define(myWebViewPage,handler:myWebViewPageHander);
    router.define(managerLoveShopPage,handler:managerLoveShopHander);
  }
}