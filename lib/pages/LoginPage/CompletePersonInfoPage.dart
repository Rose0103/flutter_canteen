import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_canteen/bean/organ.dart';
import 'package:flutter_canteen/pages/manager_index_page.dart';
import 'package:flutter_canteen/provide/organizeinfo.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_canteen/pages/foodManage/addCameraPicWidget.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_canteen/provide/userInfo.dart';
import 'package:flutter_canteen/provide/serchcateenname.dart';
import '../../common/shared_preference.dart';
import 'package:provide/provide.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:flutter_canteen/model/serchCateenNameModel.dart';
import 'package:flutter_canteen/provide/habbit.dart';
import 'package:flutter_canteen/model/logindatamodel.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_canteen/pages/LoginPage/habitChosePage/habitChosePage.dart';
import 'package:flutter_canteen/otherfunction/showDialog.dart';

import 'dart:convert';

import '../client_index_page.dart';
import '../organizetree.dart';

/**
 * 个人信息模块
 */
class CompletePersonInfoPage extends StatefulWidget {
  @override
  CompletePersonInfoPageState createState() => CompletePersonInfoPageState();
}

class CompletePersonInfoPageState extends State<CompletePersonInfoPage> {
  /// 姓名文本字段的控制器。
  TextEditingController _realnameController = TextEditingController();
  TextEditingController _birthdayController = TextEditingController();
  TextEditingController _organizeController = TextEditingController();
  FocusNode _commentFocus = FocusNode();//控制输入框焦点

  /// 当前选择的性别值。
  int _genderSelect = 0;

  // 当前选择身份值
  int _typeSelect = 0;
  String imageBase64;

  //String currentCanteenName = " ";

  /// 当前昵称文本字段的状态。
  bool _userInput = false;

  //Canteens ex4 = Canteens();
  String _canteenName = "";
  int _canteenID = 0;
  bool iscommit = false;
  bool isfirstload = true;
  DateTime lastPopTime=null;

  @override
  void initState() {
    getToken();
    super.initState();
  }

  Future onGoBack(dynamic value) {
    setState(() {});
  }

  updateGenderValue(int v) {
    setState(() {
      _genderSelect = v;
    });
  }

  updatePersonTypeValue(int v) {
    setState(() {
      _typeSelect = v;
    });
  }



  void setValues() async {
    await _getPersonInfo(context);
    await _getOrganize(context);
    organizelist = Provide.value<GetOrganizeInfoDataProvide>(context).organizeinfodata.data;
    if (Provide.value<GetUserInfoDataProvide>(context).userinfodata == null)
      return;
    if (Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.feature != null) {
      imageBase64 = Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.feature;
    }
    if (Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.userName != null){
      _realnameController.text = Provide.value<GetUserInfoDataProvide>(context)
          .userinfodata
          .data
          .userName;
    }
    if (Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.organizeId != null){
      var organizeId = Provide.value<GetUserInfoDataProvide>(context)
          .userinfodata
          .data
          .organizeId;
      for(var i=0;i<organizelist.length;i++){
        if(organizeId==organizelist[i].organizeid){
          _organizeController.text = organizelist[i].organizeiname;
          break;
        }
      }
    }
    if (Provide.value<GetUserInfoDataProvide>(context)
            .userinfodata
            .data
            .canteenName !=
        null) {
      _canteenName = Provide.value<GetUserInfoDataProvide>(context)
          .userinfodata
          .data
          .canteenName;
      _canteenID = Provide.value<GetUserInfoDataProvide>(context)
          .userinfodata
          .data
          .canteenId;
    }
    if (Provide.value<GetUserInfoDataProvide>(context)
            .userinfodata
            .data
            .birthday !=
        null)
      _birthdayController.text = Provide.value<GetUserInfoDataProvide>(context)
          .userinfodata
          .data
          .birthday;
    if (Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.sex !=
        null) {
      _genderSelect =
          Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.sex -
              1;
    }
    if (Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.isEmployee != null) {
      if (Provide.value<GetUserInfoDataProvide>(context).userinfodata.data.isEmployee)
      _typeSelect = 0;
      else
      _typeSelect = 1;
    setState(() {});
  }}

  var _chooseDate = DateTime.now().toString().split(" ")[0];
  var _currentDate = DateTime.now();

  _showDatePicker() async {
    var date;
    await DatePicker.showDatePicker(
      context,
      minDateTime: DateTime.now().add(Duration(days: -365 * 99)),
      //最小值
      maxDateTime: DateTime.now(),
      //最大值
      initialDateTime:_birthdayController.text.split("-").length!=3?DateTime(1970,01,01):DateTime(int.parse(_birthdayController.text.split("-")[0]),int.parse(_birthdayController.text.split("-")[1]),int.parse(_birthdayController.text.split("-")[2])),
      //默认日期
      dateFormat: 'yyyy-MM-dd',
      locale: DateTimePickerLocale.zh_cn,
      pickerMode: DateTimePickerMode.date,
      //选择器种类
      onCancel: () {},
      onClose: () {},
      onChange: (date, i) {
        print(date);
      },
      onConfirm: (date, i) {
        setState(() {
          _currentDate = date;
          this._chooseDate = date.toString().split(" ")[0];
          _birthdayController.text = this._chooseDate;
        });
      },
    );
  }

  //返回箭头按钮
  Widget backButtonWidget() {
    return Container(
        alignment: Alignment.bottomLeft,
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setSp(0.0),
            ScreenUtil().setSp(50.0),
            ScreenUtil().setSp(0.0),
            ScreenUtil().setSp(0.0)),
        child: IconButton(
            icon: ImageIcon(AssetImage("assets/images/btn_back.png")),
            iconSize: ScreenUtil().setSp(80.0),
            onPressed: () {
              Navigator.of(context).pop();
            }
        )
    );
  }

  //标题
  Widget titleWidget(String title) {
    return Container(
      //width: ScreenUtil().setWidth(200),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setSp(32.0),
          ScreenUtil().setSp(0.0),
          ScreenUtil().setSp(0.0),
          ScreenUtil().setSp(10.0)
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: ScreenUtil().setSp(40),
        ),
      ),
    );
  }

  //就餐食堂
  /* Widget cattenAdressWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setSp(120.0),
          ScreenUtil().setSp(56.0),
          ScreenUtil().setSp(32.0),
          ScreenUtil().setSp(0.0)),
      width: ScreenUtil().setSp(686),
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        child: Text(ex4.canteenName == null ? "请选择餐厅" : ex4.canteenName),
        onPressed: () {
          SelectDialog.showModal<Canteens>(
            context,
            label: "餐厅名称",
            selectedValue: ex4,
            itemBuilder:
                (BuildContext context, Canteens item, bool isSelected) {
              return Container(
                decoration: !isSelected
                    ? null
                    : BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                child: ListTile(
                  selected: isSelected,
                  title: Text(item.canteenName),
                  subtitle: Text("餐厅ID:" + item.canteenId.toString()),
                ),
              );
            },
            //onFind: (String filter) => _searchCanteenName(filter),
            onFind: (String filter) =>
                _searchCanteenName(filter) ,
                //filter.length > 0 ? _searchCanteenName(filter) : null,
            onChange: (Canteens selected) {
              setState(() {
                ex4 = selected;
              });
            },
          );
        },
      ),
    );
  }*/

  Widget cattenAdressWidget() {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setSp(0.0),
            ScreenUtil().setSp(0.0),
            ScreenUtil().setSp(0.0),
            ScreenUtil().setSp(0.0)),
        width: ScreenUtil().setSp(686),
        child: Text(
          _canteenName,
          style: TextStyle(
            color: Colors.black87,
            fontSize: ScreenUtil().setSp(40),
          ),
        ));
  }

  //姓名
  Widget realNameWidget() {
    return Row(children: <Widget>[
      Container(
          padding: EdgeInsets.fromLTRB(
              ScreenUtil().setSp(50.0),
              ScreenUtil().setSp(15.0),
              ScreenUtil().setSp(0.0),
              ScreenUtil().setSp(0.0)),
          width: ScreenUtil().setSp(240),
          child: Text("姓名",
              style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18))),
      Container(
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setSp(0.0),
            ScreenUtil().setSp(15.0),
            ScreenUtil().setSp(66.0),
            ScreenUtil().setSp(0.0)),
        width: ScreenUtil().setSp(510),
        child: TextFormField(
          autofocus: false,
          controller: _realnameController,
          decoration: InputDecoration(
            enabledBorder: outlineborders(Colors.grey),
            focusedBorder: outlineborders(Theme.of(context).primaryColor),
            errorBorder: outlineborders(Theme.of(context).primaryColor),
            focusedErrorBorder:outlineborders(Theme.of(context).primaryColor),
            fillColor: Theme.of(context).primaryColor,
            hintStyle: TextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(30.0)),
            errorStyle:TextStyle(color: Theme.of(context).primaryColor, fontSize: ScreenUtil().setSp(25.0)),
            //labelText: '姓名',
            hintText: '请输入您的姓名',
            //icon: Icon(Icons.perm_identity),
            border: OutlineInputBorder(),
          ),
//          onTap: (){
//            _commentFocus.unfocus();    // 失去焦点
//          },

        ),
      )
    ]);
  }

  //生日
  Widget birthdayWidget() {
    return Row(children: <Widget>[
      Container(
          padding: EdgeInsets.fromLTRB(
              ScreenUtil().setSp(50.0),
              ScreenUtil().setSp(0.0),
              ScreenUtil().setSp(32.0),
              ScreenUtil().setSp(0.0)),
          width: ScreenUtil().setSp(240),
          child: Text("出生日期",
              style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18))),
      Container(
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setSp(0.0),
            ScreenUtil().setSp(15.0),
            ScreenUtil().setSp(66.0),
            ScreenUtil().setSp(15.0)),
        width: ScreenUtil().setSp(510),
        child: TextFormField(
            focusNode: _commentFocus,
            readOnly:true,
            autofocus: false,
            controller: _birthdayController,
            decoration: InputDecoration(
                enabledBorder: outlineborders(Colors.grey),
                focusedBorder: outlineborders(Theme.of(context).primaryColor),
                errorBorder: outlineborders(Theme.of(context).primaryColor),
                focusedErrorBorder:outlineborders(Theme.of(context).primaryColor),
                fillColor: Theme.of(context).primaryColor,
                hintStyle: TextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(30.0)),
                errorStyle:TextStyle(color: Theme.of(context).primaryColor, fontSize: ScreenUtil().setSp(25.0)),
                //labelText: '出生日期',
                hintText: '请选择您的出生日期',
                //icon: Icon(Icons.today),
                border: OutlineInputBorder(),
            ),
            onTap: () {
              _commentFocus.unfocus();    // 失去焦点
              _showDatePicker();
            }),
      )
    ]);
  }

  //选择控件
  Widget radioWidget(String radioName, int value, int ratioType) {
    return Expanded(
        child: RadioListTile(
            value: value,
            groupValue: ratioType == 1 ? _genderSelect : _typeSelect,
            activeColor: Theme.of(context).primaryColor,
            title: Text(radioName,
                style: TextStyle(color: Colors.black54, fontSize: 20)),
            onChanged: (T) {
              if (ratioType == 1)
                updateGenderValue(T);
              else if (ratioType == 2) updatePersonTypeValue(T);
            }));
  }

  //性别
  Widget genderWidget() {
    return Row(children: <Widget>[
      Container(
          padding: EdgeInsets.fromLTRB(
              ScreenUtil().setSp(50.0),
              ScreenUtil().setSp(0.0),
              ScreenUtil().setSp(0.0),
              ScreenUtil().setSp(0.0)),
          width: ScreenUtil().setSp(240),
          child: Text("性别",
              style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18))),
      Container(
//          margin: EdgeInsets.only(left: ScreenUtil().setSp(-1)),
          padding: EdgeInsets.fromLTRB(
              ScreenUtil().setSp(0.0),
              ScreenUtil().setSp(0.0),
              ScreenUtil().setSp(86.0),
              ScreenUtil().setSp(0.0)),
          width: ScreenUtil().setSp(450),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            border: Border.all(width: 2, color: Colors.black38),
          ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                radioWidget('男', 0, 1),
                radioWidget('女', 1, 1),
              ])
      )
    ]);
  }

  Widget splitspace() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setSp(0.0),
          ScreenUtil().setSp(15.0),
          ScreenUtil().setSp(0.0),
          ScreenUtil().setSp(0.0)),
    );
  }

  //身份类别
  Widget personTypeWidget() {
    return Row(children: <Widget>[
      Container(
          padding: EdgeInsets.fromLTRB(
              ScreenUtil().setSp(50.0),
              ScreenUtil().setSp(0.0),
              ScreenUtil().setSp(0.0),
              ScreenUtil().setSp(0.0)),
          width: ScreenUtil().setSp(240),
          child: Text("身份类别",
              style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18))),
      Container(
          padding: EdgeInsets.fromLTRB(
              ScreenUtil().setSp(0.0),
              ScreenUtil().setSp(0.0),
              ScreenUtil().setSp(0.0),
              ScreenUtil().setSp(0.0)),
          width: ScreenUtil().setSp(450),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            border: Border.all(width: 2, color: Colors.black38),
          ),
          child: usertype == "1"
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                      radioWidget('管理员', 0, 2),
                    ])
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                      radioWidget('本单位职工', 0, 2),
                    ]))
    ]);
  }

  //组织机构
  Widget organizeTypeWidget() {
    return Row(children: <Widget>[
      Container(
          padding: EdgeInsets.fromLTRB(
              ScreenUtil().setSp(50.0),
              ScreenUtil().setSp(15.0),
              ScreenUtil().setSp(0.0),
              ScreenUtil().setSp(0.0)),
          width: ScreenUtil().setSp(240),
          child: Text("组织机构",
              style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18))),
      Container(
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setSp(0.0),
            ScreenUtil().setSp(15.0),
            ScreenUtil().setSp(66.0),
            ScreenUtil().setSp(0.0)),
        width: ScreenUtil().setSp(510),
        child: TextFormField(
          onTap: (){
            _commentFocus.unfocus();    // 失去焦点
//            Navigator.push(context, MaterialPageRoute(
//              builder: (context)=>new Tree(_buildData(1)),
//            )).then(onGoBack);
          },
          focusNode: _commentFocus,
          autofocus: false,
          readOnly: true,
          controller: _organizeController,
          decoration: InputDecoration(
            enabledBorder: outlineborders(Colors.grey),
            focusedBorder: outlineborders(Theme.of(context).primaryColor),
            errorBorder: outlineborders(Theme.of(context).primaryColor),
            focusedErrorBorder:outlineborders(Theme.of(context).primaryColor),
            fillColor: Theme.of(context).primaryColor,
            hintStyle: TextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(30.0)),
            errorStyle:TextStyle(color: Theme.of(context).primaryColor, fontSize: ScreenUtil().setSp(25.0)),
            hintText: '暂无组织机构',
            //icon: Icon(Icons.perm_identity),
            border: OutlineInputBorder(),
          ),
        ),
      )
    ]);
  }

  //构造组织机构树形数组
  List<Organ> _buildData(int orglevel){
    List<Organ> organdata = new List<Organ>();
    Map map = new Map();
    for(int i=0;i<organizelist.length;i++){
      if(organizelist[i].orglevel==orglevel){
        if(haveChileOrgan(organizelist[i].organizeid)){
          map = getchildorganByid(organizelist[i].organizeid,orglevel+1);
          organdata.add(new Organ(
              map["subOrgans"],
              map["members"],
              organizelist[i].organizeiname
          ));
        }else if(orglevel==1){
          organdata.add(new Organ(
              new List<Organ>(),
              new List<Member>(),
              organizelist[i].organizeiname
          ));
        }
      }
    }
    return organdata;
  }
  //根据id查字组织
  Map getchildorganByid(int organ_id,int orglevel){
    Map map = new Map();
    List<Member> members = new List<Member>();
    List<Organ> subOrgans = new List<Organ>();
    for(int i=0;i<organizelist.length;i++){
      if(organizelist[i].parentorganizeid==organ_id){
        if(haveChileOrgan(organizelist[i].organizeid)){
          subOrgans = _buildData(orglevel);
        }else{
          members.add(new Member(organizelist[i].organizeiname));
        }
      }
    }
    map["members"] = members;
    map["subOrgans"] = subOrgans;
    return map;
  }
  //判断是否有子组织
  bool haveChileOrgan(int organ_id){
    for(int i=0;i<organizelist.length;i++){
      if(organizelist[i].parentorganizeid==organ_id){
        return true;
      }
    }
    return false;
  }

//头像信息
  Widget personPhoto() {
    return Container(
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setSp(10.0),
                ScreenUtil().setSp(15.0),
                ScreenUtil().setSp(0.0),
                ScreenUtil().setSp(0.0)),
            width: ScreenUtil().setSp(700),
            child:ImagePickerWidget("请拍摄头像", 1, imageBase64),
    );
  }

  //提交按钮
  Widget commitButton() {
    return Container(
      width: ScreenUtil().setSp(686),
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setSp(86.0),
          ScreenUtil().setSp(30.0),
          ScreenUtil().setSp(86.0),
          ScreenUtil().setSp(0.0)),
      child: RaisedButton(
          onPressed: () async {
            if(lastPopTime == null || DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
              lastPopTime = DateTime.now();
              if (_realnameController.text == null ||
                  _realnameController.text.trim().length == 0) {
                showMessage(context,"请输入用户姓名");
                return;
              }
//              if (_organizeController.text == null ||
//                  _organizeController.text.trim().length == 0) {
//                showMessage(context,"请选择您的组织机构");
//                return;
//              }
              if (_birthdayController.text == null ||
                  _birthdayController.text.trim().length == 0) {
                showMessage(context,"请输入出生日期");
                return;
              }

              if(useInfoBase64.length<10&&featureBase64.length>500)
                useInfoBase64=featureBase64;

              if (useInfoBase64.length < 100) {
                showMessage(context,"请上传用户头像");
                return;
              }
              await _postPersonInfo(context);
              if (iscommit) {
                await relogin();
                //Appliaction.router.navigateTo(context, "/habitchosePage");
              } else {
                showMessage(context,Provide.value<PostUserInfoDataProvide>(context).message);
                return;
              }
            }else{
              lastPopTime = DateTime.now();
              showMessage(context,"请勿重复点击！");
              return;
            }
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(44.0)),
          padding: EdgeInsets.all(15.0),
          child: Text("下一步"),
          //hoverColor: Theme.of(context).primaryColor,
          //splashColor: Colors.black12,
          color: Theme.of(context).primaryColor,
          textColor: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isfirstload) {
      setValues();
      isfirstload = false;
    }
    else imageBase64=featureBase64;
    if(isupdateorganize){//判断用户是否修改了组织
      _organizeController.text = searchkey;
    }
    return Scaffold(
        body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
      // 触摸收起键盘
      FocusScope.of(context).requestFocus(FocusNode());
    },
    child:Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                topBGIMG(),
                titleWidget2("个人信息完善",context),
                realNameWidget(),
                birthdayWidget(),
                genderWidget(),
                splitspace(),
                personTypeWidget(),
                organizeTypeWidget(),
                personPhoto(),
                commitButton()
              ],
            ),
          ),
        )));
  }

  //模糊查询食堂信息
  Future<List<Canteens>> _searchCanteenName(filter) async {
    await Provide.value<searchcanteennameProvide>(context)
        .searchcanteennameInfo(filter);
    return Provide.value<searchcanteennameProvide>(context).canteensdata;
  }

  //加载个人信息
  Future _getPersonInfo(BuildContext context) async {
    String userName = await KvStores.get(KeyConst.USER_NAME);
    await Provide.value<GetUserInfoDataProvide>(context).getUserInfo(userName);
    return '完成加载';
  }

  //获取组织机构
  Future _getOrganize(BuildContext context) async {
    await Provide.value<GetOrganizeInfoDataProvide>(context).getOrganizeInfo();
    return '完成加载';
  }

  //提交个人信息
  Future _postPersonInfo(BuildContext context) async {
    iscommit = false;
    await Provide.value<PostUserInfoDataProvide>(context).postUserInfo(
        _realnameController.text,
        _genderSelect + 1,
        getOrganidByOrganname(_organizeController.text),
        _birthdayController.text,
        canteenID.toString(),
        canteenName,
        usertype,
        _typeSelect + 1,
        useInfoBase64.length<10?featureBase64:useInfoBase64,
        featureBase64);
    if (Provide.value<PostUserInfoDataProvide>(context).code == "0") {
      iscommit = true;
      realName = _realnameController.text;
      //useInfoBase64 = imageBase64;
      return '提交成功';
    } else {
      return '提交失败';
    }
  }

  //根据组织名获取组织id
  int getOrganidByOrganname(String organname){
    for(int i=0;i<organizelist.length;i++){
      if(organizelist[i].organizeiname==organname){
        return organizelist[i].organizeid;
      }
    }
  }

  void relogin() async {
    if(usertype=='2'){
      await  _getHabbitInfo(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => MyChoicePage()));
    }
    if(usertype=='1'||usertype=='3'){
      showMessage(context, '修改成功');
      Navigator.of(context).pop();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ManagerIndexPage()));
    }
  }

  //加载个人兴趣
  Future _getHabbitInfo(BuildContext context) async {
    await Provide.value<GetHabbitDataProvide>(context).gethabbitInfo(userID);
    return '完成加载';
  }


  //比对人脸
  static Future faceDetection(String params, {formData})async{
    print("000000000000000000000");
    print(formData.toString());
    Response response;
    Dio dio = new Dio(options);
    try {
      dio.options.connectTimeout = 10000;
      response = await dio.post("https://aip.baidubce.com/rest/2.0/face/v3/detect?access_token=${baiduToken}" , data: formData,);
      print("response.statusCode${response.toString()}");
      var data = json.decode(response.toString());
      if(data['error_code']==0){
        print("33333333333333");
        var face_list = data['result']['face_list'];//人脸信息列表
        double Pitch=face_list[0]['angle']['pitch'];//三维旋转之俯仰角度
        double  Roll=face_list[0]['angle']['yaw'];//平面内旋转角
        double  Yaw=face_list[0]['angle']['roll'];//三维旋转之左右旋转角
        if(Pitch.abs()>20||Roll.abs()>20||Yaw>20){
          faceDetectionMsg = "请选择直视屏幕的照片";
          isFaceDetection = false;
          return;
        }
        var quality = face_list[0]['quality'];//人脸质量信息
        var illumination = quality['illumination'];
        if(illumination<=40){
          faceDetectionMsg = "照片光线太暗，请重新选择照片";
          isFaceDetection = false;
          return;
        }
        int completeness = quality['completeness'];
        if(completeness==0){
          isFaceDetection = false;
          return;
        }
        print("222222");
        var blur = quality['blur'];
        print("completeness:${blur}");
        if(blur>=0.7){
          isFaceDetection = false;
          faceDetectionMsg = "照片不清晰，请重新选择照片";
          return;
        }
        isFaceDetection = true;
        print("quality:${quality.toString()}}");
      }else{
        faceDetectionMsg = "没有检测到人脸";
        isFaceDetection = false;
      }
    }catch(e){
    }
  }

}
