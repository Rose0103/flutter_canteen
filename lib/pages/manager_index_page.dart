import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'HomePage/managerhomepage.dart';
import 'summaryPage/summaryPage.dart';
import 'userCenter/userCenterPage.dart';
import 'package:flutter_canteen/back_to_desktop.dart';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManagerIndexPage extends StatefulWidget {
  @override
  _ManagerIndexPageState createState() => _ManagerIndexPageState();
}

class _ManagerIndexPageState extends State<ManagerIndexPage> {
  //底部导航
  final List<BottomNavigationBarItem> bottomTabs =[
    BottomNavigationBarItem(
      icon:Image.asset("assets/images/nav_yanggst_unselected.png",width: ScreenUtil().setSp(88),
            height: ScreenUtil().setSp(80)),
        activeIcon:Image.asset("assets/images/nav_yanggst_selected.png",width: ScreenUtil().setSp(88),
            height: ScreenUtil().setSp(88)),
        title:Text('阳光食堂')
    ),
    BottomNavigationBarItem(
        icon:Image.asset("assets/images/nav_baocandc_unselected.png",width: ScreenUtil().setSp(88),
            height: ScreenUtil().setSp(80)),
        activeIcon: Image.asset("assets/images/nav_baocandc_selected.png",width: ScreenUtil().setSp(88),
            height: ScreenUtil().setSp(88)),
        title:Text('就餐统计')
    ),
    BottomNavigationBarItem(
        icon:Image.asset("assets/images/nav_usercenter_unselected.png",width: ScreenUtil().setSp(88),
            height: ScreenUtil().setSp(80)),
        activeIcon: Image.asset("assets/images/nav_usercenter_selected.png",width: ScreenUtil().setSp(88),
            height: ScreenUtil().setSp(88)) ,
        title:Text('个人中心')
    ),
  ];

  //页面放到队列里
  final List<Widget> tabBodies= [
    ManagerHomePage(),
    summaryPage(),
    userCenterPage()
  ];

  int currentIndex = 0;
  var currentPage;
  var _pageController = new PageController(initialPage: 0);
  @override

  void initState() {
    currentPage=tabBodies[currentIndex];
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(244,245,245,1.0),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: Theme.of(context).primaryColor,
        type:BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        items: bottomTabs,
        onTap: _onItemTapped,
      ),
      body:WillPopScope(
    onWillPop: () async {
    if(Platform.isAndroid) {
    AndroidBackTop.backDeskTop(); //设置为返回不退出app
    return false;
    }//一定要return false
    },
    child:PageView.builder(
      onPageChanged: _pageChange,
      controller: _pageController,
      itemCount: tabBodies.length,
      itemBuilder: (context, index) => tabBodies[index]),
    )
    );
  }

  void _pageChange(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void _onItemTapped(int index) {
    //bottomNavigationBar 和 PageView 关联
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }
}

