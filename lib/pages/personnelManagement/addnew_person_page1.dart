
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_canteen/base64ToImage.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/otherfunction/EncodeUtil.dart';
import 'package:flutter_canteen/otherfunction/showDialog.dart';
import 'package:flutter_canteen/pages/orderConfirmPage/orderConfirmPage.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_canteen/widget/CommonBottomSheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_canteen/model/userListModel.dart';
import 'package:image_picker/image_picker.dart';

import 'AddPerson.dart';

// ignore: must_be_immutable
class AddNewPersonPage extends StatefulWidget {
  bool ishead = false;
  int orgId;
  int cID;
  AddNewPersonPage(this.orgId,{this.ishead,this.cID});

  @override
  _AddNewPersonPageState createState() => _AddNewPersonPageState();
}

class _AddNewPersonPageState extends State<AddNewPersonPage>{

  List<TextEditingController> _peersController = new List<TextEditingController>();
  List<TextEditingController> _idCardController = new List<TextEditingController>();

  int count;
  List<AddPerson> addPersonlist = new List();

  /// 当前选择的性别值。
  List<int> list = new List();

  List<bool> ischeck = new List();
  List<String> useInfoBase64list = new List();

  List<File> headInfo = new List(); //原始图片路径
  List<String> helptext = new List();//手机号提示
  List<bool> phoneMath = new List();
  String phoned;

  @override
  void initState() {
    super.initState();
    none?count=2:count = 1;
    list.clear();
    for(int i=0;i<count;i++){
      list.add(0);
      ischeck.add(false);
      headInfo.add(null);
      useInfoBase64list.add("");
      helptext.add("");
      phoneMath.add(false);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if(none == false){
        await _getSumUser();
        for(int i=0;i<listss.length;i++) {
          if (listss[i]['user_id'] == widget.cID) {
            setState(() {
              useInfoBase64list[0] = listss[i]['feature'];
              print(useInfoBase64list[0]);
              setState(() {

              });
            });
          }
        }
        if(useInfoBase64list[0]==null||useInfoBase64list[0]==""){
          await _getUserFeature();
        }
      }
    });
  }

  updateGenderValue(int v,int index) {
    setState(() {
      list[index] = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Image.asset(
                "assets/images/btn_backs.png",
                width: ScreenUtil().setSp(84),
                height: ScreenUtil().setSp(84),
                color: Colors.black,
              ),
              onPressed: () {
                personnelRefresh = true;
                Navigator.pop(context);
              }),
          centerTitle: true,
          title: Text(
            none == true ? '添加新人员':'编辑人员',
            style: TextStyle(color: Colors.black,
                fontSize: ScreenUtil().setSp(40),
                fontWeight:FontWeight.w500),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Container(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              // 触摸收起键盘
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    peersInfoWidget(),
                    none== true ?secondAddIcon():Container(),
                    commitButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget peersInfoWidget() {
    return SingleChildScrollView(
        child:Container(
          height: ScreenUtil().setHeight(900),
          child: ListView.builder(
            padding: EdgeInsets.all(5.0),
            itemExtent: 400.0,
            itemCount: count ,
            itemBuilder: (BuildContext context,int index){
              _peersController.add(new TextEditingController());
              _idCardController.add(new TextEditingController());
              return Container(
                height: ScreenUtil().setSp(750),
                margin: EdgeInsets.fromLTRB(
                    ScreenUtil().setSp(10.0),
                    ScreenUtil().setSp(15.0),
                    ScreenUtil().setSp(10.0),
                    ScreenUtil().setSp(0.0)),
                padding: EdgeInsets.only(top: 10.0),
                decoration: new BoxDecoration(
                  border: new Border.all(color: Colors.black, width: 0.5),
                  boxShadow: [BoxShadow(color: Colors.white)],
                ),
                child: none == true?Column(
                  children: <Widget>[
                    Container(
                      height: ScreenUtil().setSp(40),
                      margin: EdgeInsets.only(left:ScreenUtil().setSp(30)),
                      alignment: Alignment.centerLeft,
                      child: Text(
                          "${index+101} :",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                              fontSize: ScreenUtil.getInstance().setSp(40.0)
                          )
                      ),
                    ),
                    inputWidget("姓名：", "请输入姓名", false, _peersController[index], TextInputType.text,60.0,410.0,index: index),
                    inputWidget("手机号码：", "请输入手机号码", false, _idCardController[index], TextInputType.number,110.0,410.0,index: index),
                    sexWidget("性别：", "", false, 110.0,410.0,index: index),
                    headportraitWidget( "", false, 110.0,900.0,index: index),
                  ],
                ):Column(
                  children: <Widget>[
                    Container(
                      height: ScreenUtil().setSp(40),
                      margin: EdgeInsets.only(left:ScreenUtil().setSp(30)),
                      alignment: Alignment.centerLeft,
                      child: Text(
                          "${index+101} :",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                              fontSize: ScreenUtil.getInstance().setSp(40.0)
                          )
                      ),
                    ),
                    inputWidget("姓名：", "请输入姓名", false, _peersController[0], TextInputType.text,60.0,410.0,index: index),
                    inputWidget("手机号码：", "请输入手机号码", false, _idCardController[0], TextInputType.number,110.0,410.0,index: index,length: 11),
                    sexWidget("性别：", "", false,110.0,410.0,index: index),
                    headportraitWidget( "", false,110.0,900.0,index: index),
                  ],
                ),
              );
            },
          ),
        )
    );
  }

  //姓名和手机号
  Widget inputWidget(String title, String tips, bool necessary, TextEditingController textcontroller,
      TextInputType type,double wid,double inputwidth,{int index,int length}) {
    return Container(
        child: Row(
            children: <Widget>[
              Container(
                width: ScreenUtil().setSp(40.0),
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setSp(30.0),
                    ScreenUtil().setSp(5.0),
                    ScreenUtil().setSp(0.0),
                    ScreenUtil().setSp(5.0)
                ),
                child: Text(necessary ? "*" : "  ",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: ScreenUtil.getInstance().setSp(20)
                    )
                ),
              ),
              Container(
                width: ScreenUtil().setSp(200),
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setSp(0.0),
                    ScreenUtil().setSp(10.0),
                    ScreenUtil().setSp(0.0),
                    ScreenUtil().setSp(10.0)
                ),
                child: Text(title,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: ScreenUtil.getInstance().setSp(30.0)
                    )
                ),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(
                      ScreenUtil().setSp(15.0),
                      ScreenUtil().setSp(5.0),
                      ScreenUtil().setSp(0.0),
                      ScreenUtil().setSp(5.0)
                  ),
                  width: ScreenUtil().setWidth(inputwidth),
                  child: TextFormField(
                    inputFormatters: title=="手机号码："?[
                      LengthLimitingTextInputFormatter(11), WhitelistingTextInputFormatter.digitsOnly
                    ]:null,
                    autofocus: false,
                    controller: textcontroller,
                    keyboardType: type,
                    style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                    decoration: InputDecoration(
                      hintText: tips,
                      helperText: title=="手机号码："?helptext[index]:null,
                      helperStyle: TextStyle(
                          color: Colors.redAccent, fontSize: ScreenUtil().setSp(24.0)),
                      filled: true,
                      fillColor: Color(0xfff9f9f9),
                      hintStyle: TextStyle(
                          color: Colors.grey, fontSize: ScreenUtil().setSp(30.0)),
                      errorStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: ScreenUtil().setSp(20.0)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffebedf5),
                          )),
                      contentPadding: EdgeInsets.all(5.0),
                    ),
                    onChanged: (text) async{
                      if(title=="手机号码："){
                        if (text.length == 11) {
                          await _checkPhoneNum(text,index);
                        }else if(text.length==0){
                          helptext[index] = "";
                          phoneMath[index] = false;
                        } else {
                          helptext[index] = '请输入正确手机号码';
                          phoneMath[index] = false;
                        }
                        if(!none&&text==phoned){
                          phoneMath[index] = true;
                          helptext[index] = '';
                        }
                      }
                      setState(() {

                      });
                    },
                  )
              ),
            ]
        )
    );
  }

  Future _checkPhoneNum(String text,int index) async {
    String params = '/' + text;
    int retCheckcode = -99;
    await requestGet('phomeNumCheck', params).then((val) {
      if (val.toString() == "false") {
        return;
      }
      var data = val;
      setState(() {
        if (int.parse(data['code'].toString()) != null)
          retCheckcode = int.parse(data['code'].toString());
        if (retCheckcode == -99) {
          helptext[index] = "网络连接异常，不能连接到服务器";
        }
        if (retCheckcode == 0) {
          phoneMath[index] = true;
          helptext[index] = "";
          return;
        } else if (retCheckcode == 1) {
          helptext[index] = data['message'].toString();
        } else {
          helptext[index] =  "";
        }
        phoneMath[index] = false;
      });
    });
  }

  //性别
  Widget sexWidget(String title, String tips, bool necessary,
      double wid,double inputwidth,{int index}) {
    return Container(
        child: Row(
            children: <Widget>[
              Container(
                width: ScreenUtil().setSp(40.0),
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setSp(30.0),
                    ScreenUtil().setSp(5.0),
                    ScreenUtil().setSp(0.0),
                    ScreenUtil().setSp(5.0)
                ),
                child: Text(necessary ? "*" : "  ",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: ScreenUtil.getInstance().setSp(20)
                    )
                ),
              ),
              Container(
                width: ScreenUtil().setSp(200),
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setSp(0.0),
                    ScreenUtil().setSp(10.0),
                    ScreenUtil().setSp(0.0),
                    ScreenUtil().setSp(10.0)
                ),
                child: Text(title,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: ScreenUtil.getInstance().setSp(30.0)
                    )
                ),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(
                      ScreenUtil().setSp(15.0),
                      ScreenUtil().setSp(5.0),
                      ScreenUtil().setSp(0.0),
                      ScreenUtil().setSp(5.0)
                  ),
                  width: ScreenUtil().setWidth(inputwidth),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        radioWidget('男', 0,index: index),
                        radioWidget('女', 1,index: index),
                      ])
              ),
            ]
        )
    );
  }

  //单位人员
  Widget headportraitWidget( String tips, bool necessary, double wid,double inputwidth,{int index}) {
    return Container(
        child: Row(
            children: <Widget>[
              Container(
                width: ScreenUtil().setSp(10.0),
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setSp(30.0),
                    ScreenUtil().setSp(5.0),
                    ScreenUtil().setSp(0.0),
                    ScreenUtil().setSp(5.0)
                ),
                child: Text(necessary ? "*" : "  ",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: ScreenUtil.getInstance().setSp(20)
                    )
                ),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(
                      ScreenUtil().setSp(15.0),
                      ScreenUtil().setSp(5.0),
                      ScreenUtil().setSp(0.0),
                      ScreenUtil().setSp(5.0)
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  new Checkbox(
                                    value: ischeck[index],
                                    activeColor: Colors.white,
                                    checkColor: Colors.green,
                                    onChanged: (bool val) {
                                      // val 是布尔值
                                      this.setState(() {
                                        ischeck[index] = !ischeck[index];
                                      });
                                    },
                                  ),
                                  Text("单位员工",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18))
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: ScreenUtil().setSp(30.0)),
                              child: Row(
                                children: <Widget>[
                                  Text("头像：",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18)),
                                  Container(
                                    margin: EdgeInsets.only(left:ScreenUtil().setSp(30.0)),
                                    decoration: new BoxDecoration(
                                      border: new Border.all(color: Colors.black, width: 1),
                                      color: Color(0xFF9E9E9E),
                                    ),
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: ScreenUtil().setSp(242),
                                      height: ScreenUtil().setSp(282),
                                      child: InkWell(
                                        child: widget.ishead == true?
                                        ClipRect(
                                            child: useInfoBase64list[0]==null||useInfoBase64list[0]==""?
                                            (headInfo[0]!=null?initImage(0):initContainer()):
                                            headImage(useInfoBase64list[0])
                                        ):
                                        ClipRect(
                                            child: headInfo[index] != null ?initImage(index):initContainer()
                                        ),
                                        onTap: () {
                                          selectHeadDialog(context,index);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
              ),
            ]
        )
    );
  }

  Image initImage(int i){
    return Image.file( headInfo[i],
      fit: BoxFit.fill, //填充
      gaplessPlayback: true, //防止重绘
    );
  }

  Container initContainer(){
    return Container(
      child: Image.asset("assets/images/head.png",
        width: 120.0,
        height:130.0,
        fit: BoxFit.fill,
      ),
    );
  }

  /*
   * 选择头像显示的dialog
   */
  void selectHeadDialog(BuildContext context,int index) {
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
            onItemClickListener: (indexs) async {
              if (indexs == 0) {
                await chooseImage(index);
              } else {
                await getImage(index);
              }
              Navigator.pop(mContext);
              setState(() {

              });
            },
          );
        });
  }

  ///拍摄照片
  Future getImage(int index) async {
    await ImagePicker.pickImage(source: ImageSource.camera).then((image){
      Base64ToImage.compressImage(image, 0).then((path){
        EncodeUtil.image2Base64(path).then((data){
          useInfoBase64list[index] = data;
          headInfo[index] = image;
          // 这是是返回图片文件headInfo ，还有返回的base64 useInfoBase64
//        upData();
        });
      });
    });
  }

  ///从相册选取
  Future chooseImage(int index) async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      Base64ToImage.compressImage(image, 0).then((path){
        EncodeUtil.image2Base64(path).then((data){
          useInfoBase64list[index] = data;
          headInfo[index] = image;
          // 这是是返回图片文件headInfo ，还有返回的base64 useInfoBase64
//        upData();
        });
      });
    });
  }

  Image headImage(String userBase64) {
    return Image.memory(
      base64.decode(userBase64.split(',')[1]),
      fit: BoxFit.fill, //填充
      gaplessPlayback: true, //防止重绘
    );
  }


  //选择控件
  Widget radioWidget(String radioName, int value,{index}) {
    return Expanded(
        child: RadioListTile(
            value: value,
            groupValue: list[index],
            activeColor: Theme.of(context).primaryColor,
            title: Text(radioName,
                style: TextStyle(color: Colors.black54, fontSize: 20)),
            onChanged: (T) {
              updateGenderValue(T,index);
            }));
  }

  //添加人员图标
  Widget secondAddIcon() {
    return Container(
        child: new GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.add_circle),
                iconSize: 40,
                onPressed: () {
                  setState(() {
                    count++;
                    list.add(0);
                    ischeck.add(false);
                    headInfo.add(null);
                    useInfoBase64list.add("");
                    helptext.add("");
                    phoneMath.add(false);
                  });
                },
              ),
              Text("添加人员",style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18))
            ],
          ),
        )
    );
  }

  //确认添加按钮
  Widget commitButton(){
    return Container(
      width: ScreenUtil().setSp(686),
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setSp(86.0),
          ScreenUtil().setSp(30.0),
          ScreenUtil().setSp(86.0),
          ScreenUtil().setSp(0.0)),
      child: none == true ? RaisedButton(
        onPressed: () async{
          addPersonlist.clear();
          for(int i=0;i<count;i++){
            if(_peersController[i].text.isEmpty&&_idCardController[i].text.isEmpty){
              break;
            }
            if(!phoneMath[i]){
              showMessage(context, "手机号格式不正确或已注册  （${i+101}）");
              return;
            }
            if(_peersController[i].text.isEmpty){
              showMessage(context, "姓名不能为空  （${i+101}）");
              return;
            }
            if(useInfoBase64list[i]==""){
              showMessage(context, "请上传人脸照片  （${i+101}）");
              return;
            }
            addPersonlist.add(new AddPerson(
                _peersController[i].text,
                _idCardController[i].text,
                list[i]==0?"1":"0",
                ischeck[i]?"1":"0",
                useInfoBase64list[i]
            ));
          }
          if(addPersonlist.length>0){
            await addPersonList();
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(44.0)),
        padding: EdgeInsets.all(15.0),
        child: Text("确认",style: TextStyle(fontSize: ScreenUtil().setSp(34.0)),),
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
      ):RaisedButton(
        onPressed: () async{
          addPersonlist.clear();
          for(int i=0;i<count;i++){
            if(_peersController[i].text.isEmpty&&_idCardController[i].text.isEmpty){
              break;
            }
            if(!phoneMath[i]){
              showMessage(context, "手机号格式不正确或已注册  （${i+101}）");
              return;
            }
            if(_peersController[i].text.isEmpty){
              showMessage(context, "姓名不能为空  （${i+101}）");
              return;
            }
            if(useInfoBase64list[i]==""){
              showMessage(context, "请上传人脸照片  （${i+101}）");
              return;
            }
            addPersonlist.add(new AddPerson(
                _peersController[i].text,
                _idCardController[i].text,
                list[i]==0?"1":"0",
                ischeck[i]?"1":"0",
                useInfoBase64list[i]
            ));
          }
          if(addPersonlist.length>0) {
            await editPersonList();
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(44.0)),
        padding: EdgeInsets.all(15.0),
        child: Text("确认",style: TextStyle(fontSize: ScreenUtil().setSp(34.0)),),
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
      ),
    );
  }

  //编辑人员
  Future editPersonList() async{
    print(addPersonlist[0].sex);
    var data = {
      'user_name' : _peersController[0].text,
      'phone_num' : _idCardController[0].text,
      'user_id'   : widget.cID,
      'organize_id' :widget.orgId,
      'sex' :addPersonlist[0].sex,
      'is_employee' :addPersonlist[0].check,
      'feature' :addPersonlist[0].head

    };
    await request('managementUserInfo','',formData: data).then((val){
      if(val != null){
        setState(() {
          if(val['code'] == "0"){
            showMessage(context,"编辑成功");
            personnelRefresh = true;
            Navigator.pop(context);
          }else {
            showMessage(context,"编辑失败");
          }

        });
      }

    });
  }

  //增加人员
  Future addPersonList() async{
    print(addPersonlist[0].sex);
    List lists = new List();
    for(int i=0;i<addPersonlist.length;i++){
      Map _map = new Map();
      _map["user_name"] = addPersonlist[i].name;
      _map["phone_num"] = addPersonlist[i].phone;
      _map["password"] = "pbkdf2_sha256\$150000\$e10adc3949ba59abbe56e057f20f883e\$ueG5D9NJJP3FwoQwgD32RSllACQiKbmiar/wQvFixBI=".toString();
      _map["salt"] = "e10adc3949ba59abbe56e057f20f883e".toString();
      _map["sex"] = addPersonlist[i].sex;
      _map["organize_id"] = widget.orgId;
      _map["root_organize_id"] = rootOrgid;
      _map["is_employee"] = addPersonlist[i].check;
      _map["feature"] = addPersonlist[i].head;
      lists.add(_map);
    }
    var data = {
      "data": lists
    };
    print(data.toString());
    await requestPut('managementUserInfo', '',formData: data).then((val){
      print(val);
      if(val!=null&&val["code"]=="0"){
        showMessage(context, "添加成功!");
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder:(context) => AddNewPersonPage(widget.orgId)));
      }
    });
  }


  Future _getSumUser() async{
    String params = "?organize_id=${widget.orgId}"+"&user_id=${widget.cID}"+"&root_organize_id=${rootOrgid}";
    await requestGet('managementUserInfo',params).then((val){
      if (val.toString() == "false") {
        return;
      }
      if(val != null){
        setState(() {
          List _list = val['data'];
          _peersController[0].text = _list[0]["user_name"];
          _idCardController[0].text = _list[0]["phone_num"];
          phoned = _list[0]["phone_num"];
          phoneMath[0] = true;
          list[0] = _list[0]["sex"]?0:1;
          useInfoBase64list[0] = _list[0]["feature"];
          ischeck[0] = _list[0]["is_employee"];
        });
      }
    });
  }

  Future _getUserFeature() async{
    print(33333333);
    bool f = false;
    String parms = "/$startIndexs/$endIndexs/none";
    await requestGet('getFeature',parms).then((val){
      if (val.toString() == "false") {
        return;
      }
      if(val != null){
        List _lists = val['data'];
        if(_lists==null||_lists.length<=0){
          showMessage(context, "该用户暂无人脸");
        }else{
          listss.addAll(_lists);
          f = true;
        }
      }
    });
    if(f){
      for(int i=0;i<listss.length;i++) {
        if (listss[i]['user_id'] == widget.cID) {
          setState(() {
            useInfoBase64list[0] = listss[i]['feature'];
            print(useInfoBase64list[0]);
            setState(() {

            });
          });
        }
      }
      if(useInfoBase64list[0]==null||useInfoBase64list[0]=="") {
        startIndexs = startIndexs+10;
        endIndexs = endIndexs+10;
        await _getUserFeature();
      }
    }
  }
}

