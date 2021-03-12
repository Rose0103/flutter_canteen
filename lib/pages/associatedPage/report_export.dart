import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_canteen/bean/organ.dart';
import 'package:flutter_canteen/common/shared_preference.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/otherfunction/showDialog.dart';
import 'package:flutter_canteen/pages/organizetree.dart';
import 'package:flutter_canteen/provide/organizeinfo.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

class ReportExportPage extends StatefulWidget {
  @override
  _ReportExportPageState createState() => _ReportExportPageState();
}

class _ReportExportPageState extends State<ReportExportPage> {

  TextEditingController _startController = TextEditingController();
  TextEditingController _endController = TextEditingController();
  TextEditingController _organizeController = TextEditingController();

  FocusNode _commentFocus = FocusNode(); //控制输入框焦点


  var _chooseDate = DateTime.now().toString().split(" ")[0];
  var _currentDate = DateTime.now();
  bool isfirstload = true;

  Future onGoBack(dynamic value) {
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    if (isfirstload) {
      setValues();
      isfirstload = false;
    }
    if (isupdateorganize) { //判断用户是否修改了组织
      _organizeController.text = searchkey;
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        // actions: <Widget>[Icon(Icons.more_vert)],
        centerTitle: true,
        title: Text(
          '报表导出',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.orangeAccent,
        elevation: 0.0,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 30.0),
        child: Column(
          children: <Widget>[
            startWidget(),
            endWidget(),
            organizeTypeWidget(),
            exportWidget(),
          ],
        ),
      ),
    );
  }

  Widget startWidget() {
    return Row(children: <Widget>[
      Container(
          padding: EdgeInsets.fromLTRB(
              ScreenUtil().setSp(100.0),
              ScreenUtil().setSp(0.0),
              ScreenUtil().setSp(32.0),
              ScreenUtil().setSp(0.0)),
          width: ScreenUtil().setSp(240),
          child: Text("从：",
              style: TextStyle(color: Colors.black, fontSize: 18))),
      Container(
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setSp(0.0),
            ScreenUtil().setSp(15.0),
            ScreenUtil().setSp(66.0),
            ScreenUtil().setSp(15.0)),
        width: ScreenUtil().setSp(510),
        child: TextFormField(
            focusNode: _commentFocus,
            readOnly: true,
            autofocus: false,
            controller: _startController,
            decoration: InputDecoration(
              fillColor: Theme
                  .of(context)
                  .primaryColor,
              hintStyle: TextStyle(
                  color: Colors.grey, fontSize: ScreenUtil().setSp(30.0)),
              errorStyle: TextStyle(color: Theme
                  .of(context)
                  .primaryColor, fontSize: ScreenUtil().setSp(25.0)),
              hintText: '请选择开始时间',
              border: OutlineInputBorder(),
            ),
            onTap: () {
              _commentFocus.unfocus(); // 失去焦点
              _showStartPicker();
            }),
      )
    ]);
  }

  Widget endWidget() {
    return Row(children: <Widget>[
      Container(
          padding: EdgeInsets.fromLTRB(
              ScreenUtil().setSp(100.0),
              ScreenUtil().setSp(0.0),
              ScreenUtil().setSp(32.0),
              ScreenUtil().setSp(0.0)),
          width: ScreenUtil().setSp(240),
          child: Text("至：",
              style: TextStyle(color: Colors.black, fontSize: 18))),
      Container(
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setSp(0.0),
            ScreenUtil().setSp(15.0),
            ScreenUtil().setSp(66.0),
            ScreenUtil().setSp(15.0)),
        width: ScreenUtil().setSp(510),
        child: TextFormField(
            focusNode: _commentFocus,
            readOnly: true,
            autofocus: false,
            controller: _endController,
            decoration: InputDecoration(
              fillColor: Theme
                  .of(context)
                  .primaryColor,
              hintStyle: TextStyle(
                  color: Colors.grey, fontSize: ScreenUtil().setSp(30.0)),
              errorStyle: TextStyle(color: Theme
                  .of(context)
                  .primaryColor, fontSize: ScreenUtil().setSp(25.0)),
              hintText: '请选择结束时间',
              border: OutlineInputBorder(),
            ),
            onTap: () {
              _commentFocus.unfocus(); // 失去焦点
              _showEndPicker();
            }),
      )
    ]);
  }

  _showStartPicker() async {
    var date;
    await DatePicker.showDatePicker(
      context,
      //最小值
      minDateTime: DateTime.now().add(Duration(days: -365 * 99)),
      //最大值
      maxDateTime: DateTime.now(),
      //默认日期
      initialDateTime: _startController.text
          .split("-")
          .length != 3 ? DateTime.now() :
      DateTime(int.parse(_startController.text.split("-")[0]),
          int.parse(_startController.text.split("-")[1]),
          int.parse(_startController.text.split("-")[2])),
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
          _startController.text = this._chooseDate;
          print("开始时间：" + _startController.text);
        });
      },
    );
  }

  _showEndPicker() async {
    var date;
    await DatePicker.showDatePicker(
      context,
      //最小值
      minDateTime: DateTime.now().add(Duration(days: -365 * 99)),
      //最大值
      maxDateTime: DateTime.now(),
      //默认日期
      initialDateTime: _endController.text
          .split("-")
          .length != 3 ? DateTime.now() :
      DateTime(int.parse(_endController.text.split("-")[0]),
          int.parse(_endController.text.split("-")[1]),
          int.parse(_endController.text.split("-")[2])),

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
          _endController.text = this._chooseDate;
          print("结束时间：" + _endController.text);
        });
      },
    );
  }

  Widget exportWidget() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(
              ScreenUtil().setSp(20.0),
              ScreenUtil().setSp(40.0),
              ScreenUtil().setSp(32.0),
              ScreenUtil().setSp(0.0)),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                      height: ScreenUtil().setSp(80.0),
                      width: ScreenUtil().setSp(330.0),
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      child: RaisedButton(
                        onPressed: () async {
                          if (_startController.text.isEmpty ||
                              _endController.text.isEmpty) {
                            showMessage(context, "请选择时间");
                            return;
                          }
                          if (_organizeController.text == "") {
                            showMessage(context, "请选择组织机构!");
                            return;
                          }
                          print("laile");
                          await exportExcel(1);
                        },
                        child: Text('导出点券报表'),
                        color: Colors.orange,
                        shape: StadiumBorder(),
                      )
                  ),
                  Container(
                      height: ScreenUtil().setSp(80.0),
                      width: ScreenUtil().setSp(330.0),
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      child: RaisedButton(
                        onPressed: () async {
                          if (_startController.text.isEmpty ||
                              _endController.text.isEmpty) {
                            showMessage(context, "请选择时间");
                            return;
                          }
                          if (_organizeController.text == "") {
                            showMessage(context, "请选择组织机构!");
                            return;
                          }
                          print("laile");
                          await exportExcel(0);
                        },
                        child: Text('导出消费金额报表'),
                        color: Colors.orange,
                        shape: StadiumBorder(),
                      )
                  ),
                ],
              ),
              SizedBox(height: 30.0,),
              Row(
                children: <Widget>[
                  Container(
                      height: ScreenUtil().setSp(80.0),
                      width: ScreenUtil().setSp(320.0),
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      child: RaisedButton(
                        onPressed: () async {
                          if (_startController.text.isEmpty ||
                              _endController.text.isEmpty) {
                            showMessage(context, "请选择时间");
                            return;
                          }
                          if (_organizeController.text == "") {
                            showMessage(context, "请选择组织机构!");
                            return;
                          }
                          print("laile");
                          await exportExcel(3);
                        },
                        child: Text('导出点券充值报表'),
                        color: Colors.orange,
                        shape: StadiumBorder(),
                      )
                  ),
                  Container(
                      height: ScreenUtil().setSp(80.0),
                      width: ScreenUtil().setSp(350.0),
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      child: RaisedButton(
                        onPressed: () async {
                          if (_startController.text.isEmpty ||
                              _endController.text.isEmpty) {
                            showMessage(context, "请选择时间");
                            return;
                          }
                          if (_organizeController.text == "") {
                            showMessage(context, "请选择组织机构!");
                            return;
                          }
                          print("laile");
                          await exportExcel(2);
                        },
                        child: Text('导出金额充值报表'),
                        color: Colors.orange,
                        shape: StadiumBorder(),
                      )
                  ),
                ],
              ),
              SizedBox(height: 30.0,),
              Row(
                children: <Widget>[
                  Container(
                      height: ScreenUtil().setSp(80.0),
                      width: ScreenUtil().setSp(350.0),
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      child: RaisedButton(
                        onPressed: () async {
                          if(_startController.text==""||_endController.text=="")
                          {
                            showMessage(context, "请选择时间段!");
                            return;
                          }
                          if(_organizeController.text=="")
                          {
                            showMessage(context, "请选择组织机构!");
                            return;
                          }
                          await exportExcel(4);
                        },
                        child: Text('导出金额明细报表'),
                        color: Colors.orange,
                        shape: StadiumBorder(),
                      )
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  //组织机构
  Widget organizeTypeWidget() {
    return Row(children: <Widget>[
      Container(
          padding: EdgeInsets.fromLTRB(
              ScreenUtil().setSp(80.0),
              ScreenUtil().setSp(15.0),
              ScreenUtil().setSp(0.0),
              ScreenUtil().setSp(0.0)),
          width: ScreenUtil().setSp(200),
          child: Text("组织机构：",
              style: TextStyle(color: Colors.black, fontSize: 18))),
      Container(
        width: ScreenUtil().setSp(550),
        height: ScreenUtil().setHeight(150),
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setSp(35.0),
            ScreenUtil().setSp(15.0),
            ScreenUtil().setSp(66.0),
            ScreenUtil().setSp(0.0)),
        child: TextFormField(
          onTap: () {
            _commentFocus.unfocus(); // 失去焦点
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => new Tree(_buildData(1)),
            )).then(onGoBack);
          },
          focusNode: _commentFocus,
          autofocus: false,
          readOnly: true,
          controller: _organizeController,
          decoration: InputDecoration(
            hintStyle: TextStyle(
                color: Colors.grey, fontSize: ScreenUtil().setSp(30.0)),
            errorStyle: TextStyle(color: Theme
                .of(context)
                .primaryColor, fontSize: ScreenUtil().setSp(25.0)),
            hintText: '单击选择您的组织机构',
            //icon: Icon(Icons.perm_identity),
            border: OutlineInputBorder(),
          ),
        ),
      )
    ]);
  }

  //构造组织机构树形数组
  List<Organ> _buildData(int orglevel) {
    List<Organ> organdata = new List<Organ>();
    Map map = new Map();
    for (int i = 0; i < organizelist.length; i++) {
      if (organizelist[i].orglevel == orglevel) {
        if (haveChileOrgan(organizelist[i].organizeid)) {
          map = getchildorganByid(organizelist[i].organizeid, orglevel + 1);
          organdata.add(new Organ(
              map["subOrgans"],
              map["members"],
              organizelist[i].organizeiname
          ));
        } else if (orglevel == 1) {
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
  Map getchildorganByid(int organ_id, int orglevel) {
    Map map = new Map();
    List<Member> members = new List<Member>();
    List<Organ> subOrgans = new List<Organ>();
    for (int i = 0; i < organizelist.length; i++) {
      if (organizelist[i].parentorganizeid == organ_id) {
        if (haveChileOrgan(organizelist[i].organizeid)) {
          subOrgans = _buildData(orglevel);
        } else {
          members.add(new Member(organizelist[i].organizeiname));
        }
      }
    }
    map["members"] = members;
    map["subOrgans"] = subOrgans;
    return map;
  }

  //判断是否有子组织
  bool haveChileOrgan(int organ_id) {
    for (int i = 0; i < organizelist.length; i++) {
      if (organizelist[i].parentorganizeid == organ_id) {
        return true;
      }
    }
    return false;
  }

  //获取组织机构
  Future _getOrganize(BuildContext context) async {
    await Provide.value<GetOrganizeInfoDataProvide>(context).getOrganizeInfo();
    return '完成加载';
  }

  void setValues() async {
    await _getOrganize(context);
    organizelist = Provide
        .value<GetOrganizeInfoDataProvide>(context)
        .organizeinfodata
        .data;
  }

  Future exportExcel(int type) async {
    int org_id = 0;
    int org_level = 1;
    for (int i = 0; i < organizelist.length; i++) {
      if (organizelist[i].organizeiname == _organizeController.text) {
        org_id = organizelist[i].organizeid;
        org_level = organizelist[i].orglevel;
      }
    }
    Dio dio = Dio();
//    //设置连接超时时间
    dio.options.connectTimeout = 10000;
//    //设置数据接收超时时间
    dio.options.receiveTimeout = 10000;
    String cookie = await KvStores.get(KeyConst.COOKIES);
    dio.options.headers = getHeaders(cookie);
    int isall;
    if (org_level == 1) {
      isall = 1;
    } else {
      isall = 0;
    }

    if (type == 0) {
      //导出金额报表
      Response response = await dio.download(
          "http://canteen.yangguangshitang.com/api/management/data/mealstat/report?start_date=${_startController.text}"
              "&end_date=${_endController.text}"
              "&canteen_id=${canteenID}"
              "&org_id=${org_id}"
              "&cost_type=${type}"
              "&isall=${isall}",
          "sdcard/Download/${canteenName}_${_startController.text}--${_endController.text}消费金额报表.xls");
      if (response.statusCode == 200) {
        print('下载请求成功');
        showMessage(context, "导出消费金额报表成功,请在sdcard/Download中查看!");
      }
    }

    else if (type == 1) {
      //导出点券报表
      Response response = await dio.download(
          "http://canteen.yangguangshitang.com/api/management/data/mealstat/report?start_date=${_startController.text}"
              "&end_date=${_endController.text}"
              "&canteen_id=${canteenID}"
              "&org_id=${org_id}"
              "&cost_type=${type}"
              "&isall=${isall}",
          "sdcard/Download/${canteenName}_${_startController.text}--${_endController.text}点券消费报表.xls");
      if (response.statusCode == 200) {
        print('下载请求成功');
        showMessage(context, "导出点券报表成功,请在sdcard/Download中查看!");
      }
    }
    else if (type == 2) {
      //导出金额充值报表
      Response response = await dio.download(
          "http://canteen.yangguangshitang.com/api/management/data/mealstat/rechargereport?start_date=${_startController.text}"
              "&end_date=${_endController.text}"
              "&canteen_id=${canteenID}"
              "&org_id=${org_id}"
              "&cost_type=${(type==2?0:1)}"
              "&isall=${isall}",
          "sdcard/Download/${canteenName}_${_startController.text}--${_endController.text}金额充值报表.xls");
      if (response.statusCode == 200) {
        print('下载请求成功');
        showMessage(context, "导出金额充值成功,请在sdcard/Download中查看!");
      }
    }
    else if (type == 3) {
      //导出点券充值报表
      Response response = await dio.download(
          "http://canteen.yangguangshitang.com/api/management/data/mealstat/rechargereport?start_date=${_startController.text}"
              "&end_date=${_endController.text}"
              "&canteen_id=${canteenID}"
              "&org_id=${org_id}"
              "&cost_type=${(type==2?0:1)}"
              "&isall=${isall}",
          "sdcard/Download/${canteenName}_${_startController.text}--${_endController.text}点券充值报表.xls");
      if (response.statusCode == 200) {
        print('下载请求成功');
        showMessage(context, "导出点券充值成功,请在sdcard/Download中查看!");
      }
    }
    else if (type == 4) {
      //导出点券充值报表
//      params = "http://canteen.yangguangshitang.com/api/management/data/mealstat/detailreport?start_date=${_startController.text}"+"&end_date=${_endController.text}"+"&canteen_id=${canteenID}"+"&cost_type=0"+"&org_id=${org_id}"+(org_level==1?"&isall=1":"&isall=0");
      Response response = await dio.download(
          "http://canteen.yangguangshitang.com/api/management/data/mealstat/detailreport?start_date=${_startController.text}"
              "&end_date=${_endController.text}"
              "&canteen_id=${canteenID}"
              "&org_id=${org_id}"
              "&cost_type=0"
              "&isall=${isall}",
          "sdcard/Download/${canteenName}_${_startController.text}--${_endController.text}金额明细报表.xls");
      if (response.statusCode == 200) {
        print('下载请求成功');
        showMessage(context, "导出金额明细成功,请在sdcard/Download中查看!");
      }
    }


  }
}