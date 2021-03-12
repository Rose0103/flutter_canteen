import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_canteen/common/shared_preference.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/otherfunction/showDialog.dart';
import 'package:flutter_canteen/pages/associatedPage/beshared_moneys_detailed_page.dart';
import 'package:flutter_canteen/pages/personnelManagement/existingPersonnelListDetailed.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_canteen/model/userListModel.dart';

class TransferAccounts extends StatefulWidget {
  @override
  _TransferAccountsState createState() => _TransferAccountsState();
}

class _TransferAccountsState extends State<TransferAccounts> {

  String GiverMoneys = "0";//赠送人账户金额
  String beGiverMoneys = "0";//被赠送人账户金额
  TextEditingController _GivernameController = TextEditingController(); //转赠人姓名文本框
  TextEditingController _beGivernameController = TextEditingController();//被转赠人姓名文本框
  TextEditingController _GiverMoneyController = TextEditingController();//转赠金额文本框
  TextEditingController _PasswordController = TextEditingController();
  bool passwordRight=false;
  FocusNode _focusNode1 = new FocusNode();
  FocusNode _focusNode2 = new FocusNode();
  FocusNode _focusNode3 = new FocusNode();
  Widget sarchWidget = Text(""); //搜索提示框
  List <existingPersonnelListDetailed>sarchList = new List();
  List<existingPersonnelListDetailed> sarchsList = new List();



  int senderUserId  = -1;//赠送人的id
  int recevierUserId  = -1;//接收人的id

  @override
  void initState() {
    _geuserInfo();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Image.asset(
              "assets/images/btn_backs.png",
              width: ScreenUtil().setSp(84),
              height: ScreenUtil().setSp(84),
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        centerTitle: true,
        title: Text(
          '转赠金额',
          style: TextStyle(
              color: Colors.black,
              fontSize: ScreenUtil().setSp(40),
              fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());//触摸收起键盘
        },
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
              appBar: TabBar(
                labelColor: Colors.black, //字体颜色
                tabs: <Widget>[
                  //选项卡内容
                  Tab(
                    text: "转赠账户余额",
                  ),
                  Tab(
                    text: "转赠金额明细",
                  ),
                ],
              ),
              body: TabBarView(
                //选项卡 切换的内容信息展示和调用
                children: <Widget>[
                  shareMoneys(),
                  shareMoneysDetails(),
                ],
              )),
        ),
      ),
    );
  }

  //转赠账户余额
  Widget shareMoneys(){
    return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: ScreenUtil().setSp(90.0)),
            child: Stack(
                children: <Widget>[
                  Positioned(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                        ScreenUtil.getInstance().setSp(0.0),
                        ScreenUtil.getInstance().setSp(50.0),
                        ScreenUtil.getInstance().setSp(0.0),
                        ScreenUtil.getInstance().setSp(0.0)),
                      child: Column(
                        children: <Widget>[
                          Container(
                          child: Row(
                            children: <Widget>[
                              Text(
                                '赠送人账户余额：',
                              ),
                              Text(
                                '${GiverMoneys}元',
                              ),
                            ],
                          ),
                        ),
                          Container(
                            margin: EdgeInsets.only(top:ScreenUtil().setSp(20.0)),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  '转赠人：',
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: ScreenUtil().setSp(100.0)),
                                  width: ScreenUtil.getInstance().setSp(430),
                                  height: ScreenUtil.getInstance().setSp(90),
                                  child: TextFormField(
                                    autofocus: false,
                                    focusNode: _focusNode1,
                                    controller: _GivernameController,
                                    onChanged: (v){
                                      sarchList.clear();
                                      print(v);
                                      if(v.length==0){
                                        sarchWidget = Container();
                                        setState(() {});
                                        return;
                                      }
                                      for(int i = 0 ;i<sarchsList.length;i++){
                                        print(sarchsList.length);
                                        if(sarchsList[i].usName.contains(_GivernameController.text)){
                                          sarchList.add(sarchsList[i]);
                                        }
                                      }
                                      // print(sarchList.length);
                                      if(sarchList.length>0){
                                        sarchWidget = getSarchWidget(1);
                                      }
                                      if(sarchList.length==0){
                                        sarchWidget = Container();
                                      }
                                      setState(() {});
                                    },

                                    decoration: InputDecoration(
                                      errorBorder: outlineborders(Theme.of(context).primaryColor),
                                      focusedErrorBorder: outlineborders(Theme.of(context).primaryColor),
                                      fillColor: Theme.of(context).primaryColor,
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: ScreenUtil().setSp(30.0)),
                                      errorStyle: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: ScreenUtil().setSp(25.0)),
                                      hintText: '请输入转赠人姓名',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top:ScreenUtil().setSp(20.0)),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  '被赠送人账户余额：',
                                ),
                                Text(
                                  '${beGiverMoneys}元',
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top:ScreenUtil().setSp(20.0)),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  '被转赠人：',
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: ScreenUtil().setSp(75.0)),
                                  width: ScreenUtil.getInstance().setSp(430),
                                  height: ScreenUtil.getInstance().setSp(90),
                                  child: TextFormField(
                                    autofocus: false,
                                    focusNode: _focusNode2,
                                    controller: _beGivernameController,
                                    onChanged: (v){
                                      sarchList.clear();
                                      print(v);
                                      if(v.length==0){
                                        sarchWidget = Container();
                                        setState(() {});
                                        return;
                                      }
                                      for(int i = 0 ;i<sarchsList.length;i++){
                                        if(sarchsList[i].usName.contains(_beGivernameController.text)){
                                          sarchList.add(sarchsList[i]);
                                        }
                                      }
                                      // print(sarchList.length);
                                      if(sarchList.length>0){
                                        sarchWidget = getSarchWidget(2);
                                      }
                                      if(sarchList.length==0){
                                        sarchWidget = Container();
                                      }
                                      setState(() {});
                                    },

                                    decoration: InputDecoration(
                                      errorBorder: outlineborders(Theme.of(context).primaryColor),
                                      focusedErrorBorder: outlineborders(Theme.of(context).primaryColor),
                                      fillColor: Theme.of(context).primaryColor,
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: ScreenUtil().setSp(30.0)),
                                      errorStyle: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: ScreenUtil().setSp(25.0)),
                                      hintText: '请输入被转赠人姓名',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top:ScreenUtil().setSp(20.0)),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  '转赠金额(元)：',
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: ScreenUtil().setSp(30.0)),
                                  width: ScreenUtil.getInstance().setSp(430),
                                  height: ScreenUtil.getInstance().setSp(90),
                                  child: TextFormField(
                                    autofocus: false,
                                    focusNode: _focusNode3,
                                    controller: _GiverMoneyController,
                                    decoration: InputDecoration(
                                      errorBorder: outlineborders(Theme.of(context).primaryColor),
                                      focusedErrorBorder: outlineborders(Theme.of(context).primaryColor),
                                      fillColor: Theme.of(context).primaryColor,
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: ScreenUtil().setSp(30.0)),
                                      errorStyle: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: ScreenUtil().setSp(25.0)),
                                      hintText: '请输入转赠金额',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(ScreenUtil().setSp(160.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FlatButton(
                                  onPressed: () async {
                                    if(_GivernameController.text.length==0){
                                      showMessage(context, '转赠人姓名不能为空!');
                                      return;
                                    }
                                    if(_beGivernameController.text.length==0){
                                      showMessage(context, '被转赠人姓名不能为空!');
                                      return;
                                    }
                                    if(_GiverMoneyController.text.length==0){
                                      showMessage(context, '请输入转赠金额!');
                                      return;
                                    }

                                    bool nameFlag = false;
                                    sarchList.clear();
                                    for (int i = 0; i < sarchsList.length; i++) {
                                      if (sarchsList[i].usName == _GivernameController.text) {
                                        nameFlag = true;
                                        break;
                                      }
                                    }
                                    if (!nameFlag) {
                                      showMessage(context, "赠送人不存在");
                                      return;
                                    }

                                    nameFlag = false;
                                    sarchList.clear();
                                    for (int i = 0; i < sarchsList.length; i++) {
                                      if (sarchsList[i].usName == _beGivernameController.text) {
                                        nameFlag = true;
                                        break;
                                      }
                                    }
                                    if (!nameFlag) {
                                      showMessage(context, "被赠送人不存在");
                                      return;
                                    }

                                    if(GiverMoneys=='0'){
                                      showMessage(context, '赠送人账户余额不足!');
                                      return;
                                    }
                                    if(beGiverMoneys=='0'){
                                      showMessage(context, '被转赠人账户金额不足!');
                                      return;
                                    }
                                    await adminPassword();
                                    print(passwordRight);
                                    if(!passwordRight) return;
                                    await _sharemoney(senderUserId,recevierUserId,int.parse(_GiverMoneyController.text));
                                  },
                                  child: Text(
                                    '确认转赠',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: ScreenUtil().setSp(32)
                                    ),
                                  ),
                                  color: Colors.black,
                                  shape: StadiumBorder(),
                                  padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
            Positioned(
              top: ScreenUtil().setSp(200),
              left: ScreenUtil().setSp(210),
              child: sarchWidget,
            ),
            ]),
          ),
    );
}




//搜索功能
  Widget getSarchWidget(int type) {
    double h = sarchList.length * 50.0 + 10;
    if (h > 165.0) {
      h = 165.0;
    }
    print("================h:${h}");
    print(sarchList.length);
    return Container(
        decoration: new BoxDecoration(
            color: Colors.white,
            border:
            Border.all(width: ScreenUtil().setSp(3), color: Colors.orange)),
        child: SizedBox(
            height: ScreenUtil().setSp(h),
            width: ScreenUtil().setSp(354),
            child: ListView.builder(
                itemExtent: ScreenUtil().setSp(50),
                itemCount: sarchList.length,
                itemBuilder: (BuildContext context, int index) {
                  return FlatButton(
                      onPressed: () {
                        if (type == 1) {
                          senderUserId = sarchList[index].cID;
                          _GivernameController.text = sarchList[index].usName;
                          GiverMoneys = sarchList[index].money;
                        } else if (type == 2) {
                          recevierUserId = sarchList[index].cID;
                          _beGivernameController.text = sarchList[index].usName;
                          beGiverMoneys = sarchList[index].money;
                        }
                        FocusScope.of(context).requestFocus(FocusNode());
                        sarchWidget = Text("");
                        setState(() {});
                      },
                      child: Container(
                        width: ScreenUtil().setSp(225),
                        height: ScreenUtil().setSp(45),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          sarchList[index].usName,
                          style: TextStyle(fontSize: ScreenUtil().setSp(34)),
                        ),
                      ));
                })));
  }

  //转赠金额明细
  Widget shareMoneysDetails(){
    return Container(
            padding: EdgeInsets.fromLTRB(
                ScreenUtil.getInstance().setSp(0.0),
                ScreenUtil.getInstance().setSp(0.0),
                ScreenUtil.getInstance().setSp(0.0),
                0.0),
            child: BeSharedMoneysDetailedPage(_focusNode1,_focusNode2,_focusNode3)

    );

  }

  //分享余额 senderuserId赠送人id   recevieruserId被赠送人id
  Future _sharemoney(int senderuserId,int recevieruserId,int money) async {
    var data = {
      'giver_id':senderuserId,
      'receiver_id': recevieruserId,
      'money': money
    };
    print(data.toString());
    await request('moneyGive', '', formData: data).then((val) {
      print(val);
      if (val.toString() == "false") {
        return;
      }
      if( val['code'] =="0"){
        _geuserInfo();
        showMessage(context,"分享成功");
        _GivernameController.text = "";
        _beGivernameController.text="";
        _GiverMoneyController.text="";
        GiverMoneys="0";
        beGiverMoneys="0";
        setState(() {

        });
      }

    });
  }

  //查询用户列表
  Future _geuserInfo() async {
    print("organizeid:${rootOrgid}");
    await requestGet('managementUserInfo', '?root_organize_id=${rootOrgid}')
        .then((val) {
      print("bbbbbbb");
      print(val);
      if (val.toString() == "false") {
        return;
      }
      if (val != null) {
        setState(() {
          sarchsList.clear();
          var userData = userListModel.fromJson(val);
          if (userData.data != null && userData.data.length > 0) {
            userData.data.forEach((f) {
                String sexName;
                if (f.sex) {
                  sexName = "男";
                } else {
                  sexName = "女";
                }
                sarchsList.add(existingPersonnelListDetailed(
                    f.userName.toString(),
                    sexName,
                    f.phoneNum.toString(),
                    f.organizeName.toString(),
                    f.userId,
                    f.money,
                    ));
            });
            setState(() {

            });
          }
        });
      }
    });
  }


  void adminPassword() async{
    _PasswordController.clear();
    await showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());//触摸收起键盘
          },
          child: new AlertDialog(
            title: new Text(
              '请输入管理员密码',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(34),
                  fontWeight: FontWeight.w600
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _textWidget(_PasswordController,"密码:"),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _PasswordController.clear();
                  return;
                },
              ),
              new FlatButton(
                child: new Text('确定'),
                onPressed: () async{
                  if(_PasswordController.text.trim().isEmpty){
                    Fluttertoast.showToast(msg: "请输入管理员密码");
                    return;
                  }
                  if (_PasswordController.text.trim().isNotEmpty) {
                    String passwd = await KvStores.get(KeyConst.PASSWORD);
                    if(_PasswordController.text.trim()==passwd) {
                      passwordRight=true;
                      Navigator.of(context).pop();
                    }
                    else{
                      Fluttertoast.showToast(msg: "密码错误");
                      return;
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _textWidget(TextEditingController controller,String title){
    return Container(
      margin: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(15)),
      child: Row(
        children: <Widget>[
          Container(
            child: Text(
              title,
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(28),
                  fontWeight: FontWeight.w600
              ),
            ),
          ),
          Container(
            width: ScreenUtil().setSp(370),
            child: TextField(
              controller: controller,
              // maxLength: 6,
              maxLines: 1,
              // cursorWidth: 5,
              decoration: InputDecoration(
                hintText: '   请输入',
                hintStyle: TextStyle(
                  fontSize: ScreenUtil().setSp(24),
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              keyboardType: title=="密码:"?TextInputType.text:TextInputType.number,
              obscureText:title=="密码:"?true:false,
            ),
          ),
        ],
      ),
    );
  }

}