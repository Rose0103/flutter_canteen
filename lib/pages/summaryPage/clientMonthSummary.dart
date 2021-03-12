import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/config/show_month_picker.dart';
import 'package:flutter_canteen/provide/summaryData.dart';
import 'package:flutter_canteen/model/MonthSummaryDataModel.dart';
import 'package:provide/provide.dart';

//月统计表格
class personalMonthAnalysis {
  String date; //时间：天
  String breakfastOrderNum; //早餐报餐
  String breakfastEatNum; //早餐就餐
  String lunchOrderNum; //中餐报餐
  String lunchEatNum; //中餐就餐
  String supperOrderNum; //晚餐报餐
  String supperEatNum; //晚餐就餐

  personalMonthAnalysis(
      this.date,
      this.breakfastOrderNum,
      this.breakfastEatNum,
      this.lunchOrderNum,
      this.lunchEatNum,
      this.supperOrderNum,
      this.supperEatNum);

  personalMonthAnalysis.fromMap(Map<String, dynamic> map) {
    date = map['date'].toString();
    breakfastOrderNum = map['breakfastOrderNum'].toString();
    breakfastEatNum = map['breakfastEatNum'].toString();
    lunchOrderNum = map['lunchOrderNum'].toString();
    lunchEatNum = map['lunchEatNum'].toString();
    supperOrderNum = map['supperOrderNum'].toString();
    supperEatNum = map['supperEatNum'].toString();
  }
}

class personalMonthSummary extends StatefulWidget {
  final String functionID;

  personalMonthSummary(this.functionID);

  @override
  _personalMonthSummaryState createState() => _personalMonthSummaryState();
}

class _personalMonthSummaryState extends State<personalMonthSummary> {
  @override
  var _currentDate = DateTime.now();
  var _chooseDate = DateTime.now().toString().split(" ")[0];

  void initState() {
    super.initState();
    _getpersonalMonthSummaryData(_currentDate.toString().split(" ")[0].substring(0, 7).toString());
  }

  _showDatePicker() async {
    var date = await showMonthPicker(
        context: context,
        firstDate: DateTime(2019, 5),
        lastDate: DateTime(DateTime.now().year + 1, 9),
        initialDate: DateTime.now());

    if (date == null) {
      return;
    }

    _getpersonalMonthSummaryData(date.toString().split(" ")[0].substring(0, 7).toString());
    setState(() {
      _currentDate = date as DateTime;
    });
  }

  String breakfastOrderTotal;
  String breakfastEatTotal;
  String lunchOrderTotal;
  String lunchEatTotal;
  String supperOrderTotal;
  String supperEatTotal;

  List summaryDataList;
  List<personalMonthAnalysis> listItems = [];

  void _getpersonalMonthSummaryData(String date) async {
    var data = {'organize_id': organizeid, 'time': date, 'cookie': cookie};
    await request('getMonthSummaryData', '', formData: data).then((val) {
      if(val.toString()=="false")
      {
        return;
      }
      var data = val;
      print("mamama" + data['data'].toString());
      setState(() {
        listItems.clear();
        summaryDataList = data['data']['monthSummaryData'];
        breakfastOrderTotal = data['data']['breakfastOrderTotal'];
        breakfastEatTotal = data['data']['breakfastEatTotal'];
        lunchOrderTotal = data['data']['lunchOrderTotal'];
        lunchEatTotal = data['data']['lunchEatTotal'];
        supperOrderTotal = data['data']['supperOrderTotal'];
        supperEatTotal = data['data']['supperEatTotal'];
        summaryDataList.forEach((element) {
          listItems.add(personalMonthAnalysis.fromMap(element));
        });
      });
    });
  }

  Widget _summaryDataBar() {
    return new Stack(
      children: <Widget>[
        new AppBar(
          title: Text('就餐统计'),
          backgroundColor: Colors.orange,
          elevation: 0.0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: <Widget>[
            new FlatButton(
              onPressed: _showDatePicker,
              child: new Text(
                _currentDate
                    .toString()
                    .split(" ")[0]
                    .substring(0, 7)
                    .toString(),
                style: new TextStyle(color: Colors.white),
              ),
            )
          ],
        )
      ],
    );
  }

  //sizedbox封装
  Widget _sizedBox(String text) {
    return new SizedBox(
        //width: 45.0,
        child: new Text(
      text == null ? " " : text,
      textAlign: TextAlign.left,
    ));
  }

  //containerBox封装
  Widget _containerBox(String text, Color color) {
    return Container(
        alignment: Alignment.centerLeft,
        child: new GestureDetector(
          child: Text(
            text == null ? " " : text,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 15, color: color),
          ),
          onTap: () {
            setState(() {

            });
          },
        ));
  }

  //每餐的行格式
  Widget _lineBox(
      String orderAndeatNum, String orderNotEatNum, String notOrderButEatNum) {
    return Row(children: <Widget>[
      _sizedBox("报餐状态: "),
      _sizedBox(orderAndeatNum == "1" ? "已报餐" : "未报餐"),
      _sizedBox("  | 用餐状态: "),
      _sizedBox(orderNotEatNum == "1" ? "已用餐" : "未用餐"),
      Container(
          width: 80,
          child: RaisedButton(
            onPressed: () {},
            color: Colors.orange,
            child: Text("评价"),
          )),
    ]);
  }

  //总计餐的行格式
  Widget _lineBox2(
      String orderAndeatNum, String orderNotEatNum, String notOrderButEatNum) {
    return Row(children: <Widget>[
      _sizedBox("已报用餐: "),
      _sizedBox(orderAndeatNum),
      _sizedBox("  | 已报未用餐: "),
      _sizedBox(orderNotEatNum),
      _sizedBox("  | 未报用餐: "),
      _sizedBox(notOrderButEatNum),
    ]);
  }

  //月统计区域的每一行封装
  Widget _containerShow(personalMonthAnalysis personalMonthAnalysis) {
    return new Container(
      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
      decoration: new BoxDecoration(
          border: Border(bottom: new BorderSide(color: Colors.grey[200]))),
      child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _containerBox(personalMonthAnalysis.date, Colors.pink),
            _containerBox("早餐", Colors.greenAccent),
            _lineBox(
                personalMonthAnalysis.breakfastEatNum,
                personalMonthAnalysis.breakfastOrderNum,
                personalMonthAnalysis.breakfastEatNum),
            _containerBox("中餐", Colors.deepOrange),
            _lineBox(
                personalMonthAnalysis.lunchEatNum,
                personalMonthAnalysis.lunchOrderNum,
                personalMonthAnalysis.lunchEatNum),
            _containerBox("晚餐", Colors.blueAccent),
            _lineBox(
                personalMonthAnalysis.supperEatNum,
                personalMonthAnalysis.supperOrderNum,
                personalMonthAnalysis.supperEatNum),
            //RaisedButton(
            //  child: Text("待评价"),
            //  onPressed: (){},
            //)
          ]),
    );
  }

  //月统计总计封装
  Widget _containerTotalShow() {
    return new Container(
      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
      decoration: new BoxDecoration(
          color: Colors.orange,
          boxShadow: [
            BoxShadow(
                color: Colors.orange,
                offset: Offset(5.0, 5.0),
                blurRadius: 10.0,
                spreadRadius: 2.0),
            BoxShadow(color: Colors.orange, offset: Offset(1.0, 1.0)),
            BoxShadow(color: Colors.orange)
          ],
          border: Border(bottom: new BorderSide(color: Colors.grey[200]))),
      child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _sizedBox("总计"),
            _containerBox("早餐", Colors.greenAccent),
            _lineBox2(
                breakfastEatTotal, breakfastOrderTotal, breakfastEatTotal),
            _containerBox("中餐", Colors.deepOrange),
            _lineBox2(lunchEatTotal, lunchOrderTotal, lunchEatTotal),
            _containerBox("晚餐", Colors.blueAccent),
            _lineBox2(supperEatTotal, supperOrderTotal, supperEatTotal),
          ]),
    );
  }

  Widget build(BuildContext context) {
    //自定义appbar
    return Container(
        child: Scaffold(
      body: new Stack(
        children: <Widget>[
          _summaryDataBar(),
          new Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: new Card(
              margin: const EdgeInsets.all(8.0),
              child: new Column(
                children: <Widget>[
                  new Flexible(
                    child: new ListView(
                      padding: EdgeInsets.zero, //这一行一定要添加，不然会与标题栏有一段空白。
                      children: listItems.map((listItem) {
                        return _containerShow(listItem);
                      }).toList(),
                    ),
                  ),
                  _containerTotalShow(),
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
