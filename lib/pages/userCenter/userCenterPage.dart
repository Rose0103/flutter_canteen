import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_canteen/otherfunction/EncodeUtil.dart';
import 'package:flutter_canteen/otherfunction/showDialog.dart';
import 'package:flutter_canteen/pages/associatedPage/associated_canteen_page.dart';
import 'package:flutter_canteen/pages/associatedPage/report_export.dart';
import 'package:flutter_canteen/pages/associatedPage/transfer_accounts.dart';
import 'package:flutter_canteen/pages/orderConfirmPage/orderConfirmPage.dart';
import 'package:flutter_canteen/pages/organizeManage/manageOrganize.dart';
import 'package:flutter_canteen/pages/topUpPage/topUpPage.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_canteen/widget/CommonBottomSheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/router/application.dart';
import 'package:flutter_canteen/pages/LoginPage/CompletePersonInfoPage.dart';
import 'package:flutter_canteen/pages/systemSettingPage/systemSettingPage.dart';
import 'package:flutter_canteen/pages/systemSettingPage/otherSettings.dart';
import 'package:flutter_canteen/pages/mineOrderPage/mineOrderPage.dart';
import 'package:flutter_canteen/provide/userInfo.dart';
import 'package:provide/provide.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_canteen/pages/moneyPages/totalmoney.dart';
import 'package:flutter_canteen/pages/deadlineAndPricePage/postDeadLinePage.dart';
import 'package:flutter_canteen/pages/deadlineAndPricePage/setPricePage.dart';



//个人中心页面
class userCenterPage extends StatefulWidget {
  String userName = '文林夕';
  String photoImagePath = 'http://$resourceUrl/images/YHZXYHTX.png';
  String money = totalMoney;
  File headInfo;

  @override
  State<StatefulWidget> createState() {
    return userCenterState();
  }
}

class userCenterState extends State<userCenterPage> {
  String userName = realName;
  String photoImagePath = 'http://$resourceUrl/images/YHZXYHTX.png';
  String money = totalMoney;
  File headInfo; //原始图片路径
@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: ListView(
          children: <Widget>[
           _topHeader(context),
            _actionList(context),
          ],
        ));
    ;
  }

  Widget _topHeader(BuildContext context) {
    return Container(
        //width: ScreenUtil().setSp(750),
        height: ScreenUtil().setSp(500),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/usercenterBG.png"),
              fit: BoxFit.fill,
            )),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: ScreenUtil().setSp(192),
                height: ScreenUtil().setSp(192),
                child: InkWell(
                  child: ClipOval(
                    child: headInfo != null ?Image.file(headInfo,
                      fit: BoxFit.fill, //填充
                      gaplessPlayback: true, //防止重绘
                    ): useInfoBase64!=null&&useInfoBase64!="" ? headImage():
                    Container(
                      color: Colors.black12,
                    ),
                  ),
                  onTap: () {
                    if(isYouKe == true){
//                      showMessage(context, "当前身份是游客，请先登录");
                      return;
                    }else {
                      selectHeadDialog(context);
                    }
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  realName,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(50), color: Colors.black87),
                ),
              ),
            ]));
  }

  /**
   * 选择头像显示的dialog
   */
  void selectHeadDialog(BuildContext context) {
    var list = List();
    list.add('相册');
    list.add('相机');
    showDialog(
        barrierDismissible: true, //是否点击空白区域关闭对话框,默认为true，可以关闭
        context: context,
        builder: (BuildContext mContext) {
          return CommonBottomSheet(
            mContext: mContext,
            list: list,
            onItemClickListener: (index) async {
              if (index == 0) {
                chooseImage();
              } else {
                getImage();
              }
              Navigator.pop(mContext);
            },
          );
        });
  }

  ///拍摄照片
  Future getImage() async {
    await ImagePicker.pickImage(source: ImageSource.camera,imageQuality: 30,maxWidth: 240,maxHeight: 160)
        .then((image) => EncodeUtil.image2Base64(image.toString()).then((data) {
      setState(() {
        useInfoBase64 = data;
        headInfo = image;
        // 这是是返回图片文件headInfo ，还有返回的base64 useInfoBase64
        upData();
      });
    }));
  }

  ///从相册选取
  Future chooseImage() async {
    await ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 30,maxWidth: 240,maxHeight: 160)
        .then((image) =>EncodeUtil.image2Base64(image.toString()).then((data){
      setState(() {
        useInfoBase64 = data;
        headInfo = image;
        // 这是是返回图片文件headInfo ，还有返回的base64 useInfoBase64
        upData();
      });
    }));
  }

  Image headImage() {
    return Image.memory(
      base64.decode(useInfoBase64.split(',')[1]),
      fit: BoxFit.fill, //填充
      gaplessPlayback: true, //防止重绘
    );
  }

  Widget getUserCenterListWidget(String id) {
    if (id == "3")
      return CompletePersonInfoPage();
    else if(id=="1")
      return totalMoeyAndBill();
    else if (id == "4")
      return postDeadLinePage();
    else if (id == "6")
      return setPricePage();
    else if (id == "5") return systemSettingPage();
    else if (id == "7") return topUpPage();
    else if (id == "8") return otherSettingPage();
    else if (id == "9") return manageOrganizePage();
    else if (id == "10") return AssociatedCanteenPage();
    else if (id == "12") return ReportExportPage();
    else if (id == "13") return TransferAccounts();
  }

  //通用ListTile
  Widget _myListTile(BuildContext context, String title, String name, int ID) {
    IconData iconimage;
    bool hasarrow = false;
    switch (ID) {
      case 1:
        iconimage = Icons.account_balance;
        hasarrow = true;
        break;
      case 2:
        iconimage = Icons.account_box;
        break;
      case 3:
        iconimage = Icons.perm_identity;
        hasarrow = true;
        break;
      case 4:
        iconimage = Icons.access_time;
        hasarrow = true;
        break;
      case 5:
        iconimage = Icons.settings;
        hasarrow = true;
        break;
      case 6:
        iconimage = Icons.settings;
        hasarrow = true;
        break;
      case 7:
        iconimage = Icons.attach_money;
        hasarrow = true;
        break;
      case 8:
        iconimage = Icons.settings;
        hasarrow = true;
        break;
      case 9:
        iconimage = Icons.account_balance;
        hasarrow = true;
        break;
      case 10:
        iconimage = Icons.account_balance;
        hasarrow = true;
        break;
      case 12:
        iconimage = Icons.account_balance;
        hasarrow = true;
        break;
      case 13:
        iconimage = Icons.monetization_on;
        hasarrow = true;
        break;
    }
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
      child: ListTile(
        leading: Icon(iconimage, size: ScreenUtil().setSp(60),color: Theme.of(context).primaryColor,),
        title: Text(title + '   ' + name),
        trailing: hasarrow ? Icon(Icons.arrow_right) : null,
        onTap: () {
          hasarrow
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          getUserCenterListWidget(ID.toString())))
              : null;
          // hasarrow?Appliaction.router.navigateTo(context,"/userCenterdetail?id=$ID"):null;
        },
      ),
    );
  }

  Widget _actionList(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          // _myListTile(context,'就餐单位',canteenName==null?' ':canteenName,1),
          _myListTile(context, '身份类型', usertype=="1"?'餐厅管理员':usertype=='2'?'普通用户':"超级管理员", 2),
          usertype == "2" ? (!isYouKe?_myListTile(context, '支付', ' ', 1) : Container()):Container(),
          usertype == "3" ? _myListTile(context, '充值', ' ', 7) : Container(),
          isYouKe || usertype != "2"?Container():_myListTile(context, '个人信息修改', ' ', 3),
//          isYouKe?Container():_myListTile(context, '个人信息修改', ' ', 3),
          //_myListTile(context,'个人就餐统计',' ',4),
          usertype=="3"?_myListTile(context,'组织机构管理',' ',9):Container(),
          usertype=="3"?_myListTile(context,'关联食堂',' ',10):Container(),
          usertype=="3"?_myListTile(context,'报表导出',' ',12):Container(),
          usertype=="3"?_myListTile(context,'转账管理',' ',13):Container(),
          usertype=="1"?_myListTile(context,'设置截止时间',' ',4):Container(),
          usertype=="1"?_myListTile(context,'设置报餐价格',' ',6):Container(),
          usertype=="1"?_myListTile(context,'更多报餐设置',' ',8):Container(),
          _myListTile(context, '系统设置', ' ', 5),

        ],
      ),
    );
  }

  Future image2Base64(File image) async {
    List<int> imageBytes = await image.readAsBytes();
    return base64Encode(imageBytes);
  }

  /**
   * 在这里上传图片(String userName,int sex,String organizeId ,String birthday ,
      String canteenId,String  canteenName,String usertype,int is_employee,String userImage,String featurelast) async{

   */
  Future upData() async{
    await Provide.value<PostUserInfoDataProvide>(context).postUserInfo(
        realName,
        gender,
        organizeid,
        birthday,
        canteenID.toString(),
        canteenName,
        usertype,
        is_employee,
        useInfoBase64,
        featureBase64);
    if (Provide.value<PostUserInfoDataProvide>(context).code == "0") {
      return '提交成功';
    } else {
      return '提交失败';
    }
  }
}
