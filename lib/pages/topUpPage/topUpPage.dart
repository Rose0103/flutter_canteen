import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/model/userListModel.dart';
import 'package:flutter_canteen/otherfunction/showDialog.dart';
import 'package:flutter_canteen/pages/topUpPage/topUpDetailedModel.dart';
import 'package:flutter_canteen/provide/organizeinfo.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';

import 'PrecisionLimitFormatter.dart';

class topUpPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return topUpPageState();
  }
}

class topUpPageState extends State<topUpPage> {
  var _chooseDate = DateTime.now().toString().split(" ")[0];
  userListModel dataUserListModel;
  Map<int, topUpDetailedModel> map = new Map();
  Map<int, topUpDetailedModel> mapList = new Map();
  bool check = false;
  TextEditingController _moneyController = TextEditingController();
  TextEditingController _CountingController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  List<DropdownMenuItem> _item = new List();
  String hintStr = "全部机构";
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getSumUser();
      await _initItem();
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
                  Navigator.pop(context);
                }),
            centerTitle: true,
            title: Text(
              '充值',
              style: TextStyle(color: Colors.black,
                  fontSize: ScreenUtil().setSp(40),
                  fontWeight:FontWeight.w500),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            /*   elevation: 0.0,*/
          ),
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              // 触摸收起键盘
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      searchFoodNameWidget(),
                      Expanded(
                        child: Scrollbar(
                          child: ListView(
                            children: <Widget>[
                               SingleChildScrollView(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(15)),

                                    child: Table(
                                      columnWidths:  {
                                        0: FixedColumnWidth(ScreenUtil().setSp(60.0)),
                                        1: FixedColumnWidth(ScreenUtil().setSp(110.0)),
                                        2: FixedColumnWidth(ScreenUtil().setSp(180.0)),
                                        3: FixedColumnWidth(ScreenUtil().setSp(140.0)),
                                        4: FixedColumnWidth(ScreenUtil().setSp(130.0)),
                                        5: FixedColumnWidth(ScreenUtil().setSp(100.0)),
                                      },
                                      border: TableBorder.all(
                                          color: Colors.black,
                                          width: 1.0,
                                          style: BorderStyle.solid),
                                      children: _tableRowList(),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 40.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                                height: ScreenUtil().setSp(80.0),
                                width: ScreenUtil().setSp(250.0),
                                padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                child: RaisedButton(
                                  onPressed: () async {
                                    setState(() {
                                      if (map.keys.toList().length != 0) {
                                        var count = map.keys.toList().length;
                                        for (int i = 0; i < count; i++) {
                                          topUpDetailedModel data =
                                              map[map.keys.toList()[i]];
                                          data.select = true;
                                        }
                                      }
                                    });
                                  },
                                  child: Text('全选'),
                                  color: Colors.orange,
                                  shape: StadiumBorder(),
                                )),
                            Container(
                                height: ScreenUtil().setSp(80.0),
                                width: ScreenUtil().setSp(250.0),
                                padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                child: RaisedButton(
                                  onPressed: () async {
                                    setState(() {
                                      if (map.keys.toList().length != 0) {
                                        var count = map.keys.toList().length;
                                        for (int i = 0; i < count; i++) {
                                          topUpDetailedModel data =
                                              map[map.keys.toList()[i]];
                                          data.select = false;
                                        }
                                      }
                                    });
                                  },
                                  child: Text('非全选'),
                                  color: Colors.orange,
                                  shape: StadiumBorder(),
                                )),
                            Container(
                                height: ScreenUtil().setSp(80.0),
                                width: ScreenUtil().setSp(250.0),
                                padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                child: RaisedButton(
                                  onPressed: () async {
                                    _moneyController.clear();
                                    _CountingController.clear();
                                    int counts = 0;
                                    if(map.keys.toList().length != 0){
                                      for (int i = 0; i < map.keys.toList().length; i++) {
                                        topUpDetailedModel data = map[map.keys.toList()[i]];
                                        if (data.select) {
                                          counts++;
                                        }
                                      }
                                    }
                                    if(counts==0){
                                      showMessage(context,"请至少选择一个需要充值的用户");
                                      return;
                                    }
                                    setState(() {
                                      showDialog<Null>(
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
                                                '充值',
                                                style: TextStyle(
                                                  fontSize: ScreenUtil().setSp(34),
                                                  fontWeight: FontWeight.w600
                                                ),
                                              ),
                                              content: SingleChildScrollView(
                                                child: Column(
                                                  children: <Widget>[
                                                    _textWidget(_moneyController,"金额："),
                                                    _textWidget(_CountingController,"餐券："),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                new FlatButton(
                                                  child: new Text('取消'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                new FlatButton(
                                                  child: new Text('确定'),
                                                  onPressed: () async{
                                                    if(_moneyController.text.trim().isEmpty&&_CountingController.text.trim().isEmpty){
                                                      Fluttertoast.showToast(msg: "请输入要充值的余额或餐券数量");
                                                      return;
                                                    }
                                                    if (_moneyController.text.trim().isNotEmpty) {
                                                      await putSubmit();

                                                    }
                                                    if (_CountingController.text.trim().isNotEmpty) {
                                                      await putSubmits();
                                                    }
                                                    Navigator.of(context).pop();
                                                    setState(() {
                                                      _getSumUser();
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ).then((val) {
                                        print(val);
                                      });
                                    });
                                  },
                                  child: Text('充值'),
                                  color: Colors.orange,
                                  shape: StadiumBorder(),
                                )),
                          ],
                        ),
                      ),
                    ],
                  )),
          ),
          ),
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
              inputFormatters: title=="餐券"?[
                LengthLimitingTextInputFormatter(6), WhitelistingTextInputFormatter.digitsOnly
              ]:[PrecisionLimitFormatter(2)],
              // cursorWidth: 5,
              decoration: InputDecoration(
                hintText: '   请输入',
                hintStyle: TextStyle(
                  fontSize: ScreenUtil().setSp(24),
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }

  void _initItem() async{
    _item.clear();
    _item.add(
      new DropdownMenuItem(
          value: -1,
          child: Text(
              '全部机构',
              style: TextStyle(fontWeight:FontWeight.w500, fontSize: ScreenUtil().setSp(36))
          )
      ),
    );
    await Provide.value<GetOrganizeInfoDataProvide>(context).getOrganizeInfo();
    organizelist = Provide.value<GetOrganizeInfoDataProvide>(context).organizeinfodata.data;
    for(int i=0;i<organizelist.length;i++){
      if(organizelist[i].orglevel>1){
        _item.add(
          new DropdownMenuItem(
              value: organizelist[i].organizeiname+"_"+organizelist[i].organizeid.toString(),
              child: Text(
                  organizelist[i].organizeiname,
                  style: TextStyle(fontWeight:FontWeight.w500, fontSize: ScreenUtil().setSp(36))
              )
          ),
        );
      }
    }
  }

   //搜索
  Widget searchFoodNameWidget() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(top: ScreenUtil().setSp(5.0)),
        child: Container(
          height: 68.0,
          child: Row(
            children: <Widget>[
              new Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: new Card(
                      child: new Container(
                        width: ScreenUtil().setSp(380),
                        child: new Row(
                          children: <Widget>[
                            SizedBox(width: 10.0,),
                            Icon(Icons.search, color: Colors.grey,),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: TextField(
                                  maxLength:11,
                                  controller: _nameController,
                                  style: TextStyle(fontSize: ScreenUtil().setSp(30.0)),
                                  decoration: new InputDecoration(
                                      contentPadding: EdgeInsets.only(top: 0.0),
                                      hintText: '点我输入搜索', border: InputBorder.none),
                                  onChanged:(v) async{
                                    print(v);
                                    print(v.trim().length);
                                    if(v.trim().length > 0){
                                      map.clear();
                                      for(var i =0;i<mapList.keys.toList().length;i++){
                                        topUpDetailedModel data = mapList[mapList.keys.toList()[i]];
                                        if(data.userName.contains(v) || data.phoneNum.contains(v)){
                                          map[data.userId] = data;
                                        }
                                      }
                                      if(map.length==0){
                                        showMessage(context, "未找到该用户");
                                      }
                                    }else{
                                      map.addAll(mapList);
                                    }
                                    setState(() {

                                    });
                                  },
                                ),
                              ),
                            ),
                            new IconButton(
                              icon: new Icon(Icons.cancel),
                              color: Colors.grey,
                              iconSize: 18.0,
                              onPressed: () {
                                _nameController.clear();
                                FocusScope.of(context).requestFocus(FocusNode());
                                setState(() {
                                  map.addAll(mapList);
                                });
                              },
                            ),
                          ],
                        ),
                      )
                  )
              ),
              new Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: new Card(
                      child: new Container(
                        width: ScreenUtil().setSp(310),
                        child: new Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                  margin: EdgeInsets.only(left: ScreenUtil().setSp(40)),
                                  height: ScreenUtil().setSp(90.0),
                                  // width: ScreenUtil().setSp(200.0),
                                  decoration: BoxDecoration(
                                    // border: Border.all(width: ScreenUtil().setSp(1),color: Colors.black26)
                                  ),
                                  child: DropdownButton(
                                    items: _item,
                                    hint: Text(
                                        hintStr,
                                        style: TextStyle(fontWeight:FontWeight.w500, fontSize: ScreenUtil().setSp(36))
                                    ),
                                    onChanged: (value){
                                      print(value);
                                      map.clear();
                                      if(value==-1){
                                        hintStr = "全部机构";
                                        setState(() {
                                          map.addAll(mapList);
                                        });
                                      }else{
                                        hintStr = value.toString().split("_")[0];
                                        for(var i =0;i<mapList.keys.toList().length;i++){
                                          topUpDetailedModel data = mapList[mapList.keys.toList()[i]];
                                          var id = data.organize_id;
                                          var isId = value.toString().split("_")[1];
                                          if(id.toString() == isId){
                                            map[data.userId] = data;
                                          }
                                        }
                                      }
                                      setState(() {

                                      });
                                    },
                                  )
                              ),
                            ),
                          ],
                        ),
                      )
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }




  _tableRowList() {
    dynamic content;
    List<TableRow> Tlist = <TableRow>[
      TableRow(children: [
        centerText("序号"),
        centerText("姓名"),
        centerText("联系电话"),
        centerText("余额"),
        centerText("餐券"),
        centerText("充值"),
      ]),
    ];

    if (map.keys.toList().length != 0) {
      var count = map.keys.toList().length;
      for (int i = 0; i < count; i++) {
        topUpDetailedModel data = map[map.keys.toList()[i]];
        content = TableRow(children: [
          centerText((i + 1).toString()),
          centerText(data.userName),
          centerText(data.phoneNum),
          centerText(data.money),
          centerText(data.moneys.toString()),
          new Checkbox(
            value: data.select,
            activeColor: Colors.blue,
            onChanged: (bool val) {
              // val 是布尔值
              this.setState(() {
                data.select = !data.select;
              });
            },
          ),
        ]);
        Tlist.add(content);
      }
    }
    return Tlist;
  }

  Container centerText(String text) {
    return Container(
      alignment: Alignment.center,
      height: ScreenUtil().setSp(76),
        child: Text(
          text,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(24)),
        ),
    );
  }

  Future _getSumUser() async {
    await requestGet('managementUserInfo', '').then((val) {
      if (val.toString() == "false") {
        return;
      }
      setState(() {
        map.clear();
        mapList.clear();
        userListModel dataUserListModel = userListModel.fromJson(val);
        for (int i = 0; i < dataUserListModel.data.length; i++) {
          topUpDetailedModel mTopUpDetailedModel = new topUpDetailedModel();
          map[dataUserListModel.data[i].userId] = mTopUpDetailedModel;
          map[dataUserListModel.data[i].userId].userName =
              dataUserListModel.data[i].userName == null
                  ? ""
                  : dataUserListModel.data[i].userName;
          map[dataUserListModel.data[i].userId].phoneNum =
              dataUserListModel.data[i].phoneNum;
          map[dataUserListModel.data[i].userId].money =
              dataUserListModel.data[i].money;
          map[dataUserListModel.data[i].userId].moneys =
              dataUserListModel.data[i].ticket_num;
          map[dataUserListModel.data[i].userId].userId =
              dataUserListModel.data[i].userId;
          map[dataUserListModel.data[i].userId].organize_id =
              dataUserListModel.data[i].organizeId;

          mapList[dataUserListModel.data[i].userId] = mTopUpDetailedModel;
          mapList[dataUserListModel.data[i].userId].userName =
          dataUserListModel.data[i].userName == null
              ? ""
              : dataUserListModel.data[i].userName;
          mapList[dataUserListModel.data[i].userId].phoneNum =
              dataUserListModel.data[i].phoneNum;
          mapList[dataUserListModel.data[i].userId].money =
              dataUserListModel.data[i].money;
          mapList[dataUserListModel.data[i].userId].moneys =
              dataUserListModel.data[i].ticket_num;
          mapList[dataUserListModel.data[i].userId].userId =
              dataUserListModel.data[i].userId;
          mapList[dataUserListModel.data[i].userId].organize_id =
              dataUserListModel.data[i].organizeId;
        }

      });

    });
  }

  //用户id的list
  List<int> getUserList(){
    List<int> consumerList = [];
    if (map.keys.toList().length != 0) {
      var count = map.keys.toList().length;
      for (int i = 0; i < count; i++) {
        topUpDetailedModel data = map[map.keys.toList()[i]];
        if (data.select) {
          consumerList.add(map.keys.toList()[i]);
        }
      }
    }
    return consumerList;
  }

  //充值余额
  Future putSubmit() async {
    //充值金额大小限制
    var formData = {
      'consumer_id_list': getUserList(),
      'money': double.parse(_moneyController.text.trim()),
    };
    print(formData.toString());
    await requestPut('recharge', '', formData: formData).then((val) {
      print(val.toString());
      Fluttertoast.showToast(msg: "提交成功");
    });
  }

  //充值餐券
  Future putSubmits() async {
    var formData = {
      'consumer_id_list': getUserList(),
      'ticket_num': int.parse(_CountingController.text.trim()),
    };
    print(formData.toString());
    await requestPut('recharges', '', formData: formData).then((val) {
      print(val.toString());
      Fluttertoast.showToast(msg: "提交成功");
    });
  }
}
