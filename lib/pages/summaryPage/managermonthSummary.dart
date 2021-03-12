import 'package:flutter/material.dart';
import 'package:flutter_canteen/router/application.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/config/show_month_picker.dart';
import 'package:flutter_canteen/provide/summaryData.dart';
import 'package:flutter_canteen/model/MonthSummaryDataModel.dart';
import 'package:provide/provide.dart';
import 'package:flutter_canteen/pages/mealStatisticalDetailedPage/mealStatisticalDetailedPage.dart';
import 'dart:convert';

//月统计表格
class monthAnalysis {
  String date; //时间：天
  String breakfastpost_eaten="0"; //早餐已报已就餐
  String breakfastpost_neaten="0"; //早餐已报未就餐
  String breakfastnpost_eaten="0"; //早餐未报已就餐
  String breakfastremain_eaten="0";
  String breakfastremain_neaten="0";

  String lunchpost_eaten="0"; //中餐已报已就餐
  String lunchpost_neaten="0"; //中餐已报未就餐
  String lunchnpost_eaten="0"; //中餐未报已就餐
  String lunchremain_eaten="0";
  String lunchremain_neaten="0";

  String supperpost_eaten="0"; //晚餐已报已就餐
  String supperpost_neaten="0"; //晚餐已报未就餐
  String suppernpost_eaten="0"; //晚餐未报已就餐
  String supperremain_eaten="0";
  String supperremain_neaten="0";

  monthAnalysis(
      this.date,
      this.breakfastpost_eaten,
      this.breakfastpost_neaten,
      this.breakfastnpost_eaten,
      this.breakfastremain_eaten,
      this.breakfastremain_neaten,
      this.lunchpost_eaten,
      this.lunchpost_neaten,
      this.lunchnpost_eaten,
      this.lunchremain_eaten,
      this.lunchremain_neaten,
      this.supperpost_eaten,
      this.supperpost_neaten,
      this.suppernpost_eaten,
      this.supperremain_eaten,
      this.supperremain_neaten);
}

class monthSummary extends StatefulWidget {
  @override
  monthSummaryState createState() => monthSummaryState();
}

class monthSummaryState extends State<monthSummary> {
  @override
  var _currentDate = DateTime.now();
  var _chooseDate = DateTime.now().toString().split(" ")[0];
  String starttime;
  String endtime;

  String breakfastpost_eatenTotal="0"; //早餐已报已就餐
  String breakfastpost_neatenTotal="0"; //早餐已报未就餐
  String breakfastnpost_eatenTotal="0"; //早餐未报已就餐
  String breakfastremain_eatenTotal="0"; //早餐已留餐已就餐
  String breakfastremain_neatenTotal="0"; //早餐已留餐未就餐

  String lunchpost_eatenTotal="0"; //中餐已报已就餐
  String lunchpost_neatenTotal="0"; //中餐已报未就餐
  String lunchnpost_eatenTotal="0"; //中餐未报已就餐
  String lunchremain_eatenTotal="0"; //中餐已留餐已就餐
  String lunchremain_neatenTotal="0"; //中餐已留餐未就餐

  String supperpost_eatenTotal="0"; //晚餐已报已就餐
  String supperpost_neatenTotal="0"; //晚餐已报未就餐
  String suppernpost_eatenTotal="0"; //晚餐未报已就餐
  String supperremain_eatenTotal="0"; //晚餐已留餐已就餐
  String supperremain_neatenTotal="0"; //晚餐已留餐未就餐

  var _scrollController = new ScrollController();
  var _ITEM_HEIGHT=ScreenUtil().setSp(350);

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await _getSummaryData(canteenID, _currentDate);
      for (int i = 0; i < listItems.length; i++) {
        print(listItems.elementAt(i).date);
        print(_currentDate.toString().split(" ")[0].toString());
        if (listItems.elementAt(i).date==_currentDate.toString().split(" ")[0].toString()) {
          print(i * _ITEM_HEIGHT);
          _scrollController.jumpTo(i * _ITEM_HEIGHT);
          break;
        }
      }
    });
  }

  void getStartAndEndTime(DateTime datetime) {
    DateTime lastdate = datetime;
    int currentyear = datetime.year;
    int currentmonth = datetime.month;
    for (int i = 0; i < 35; i++) {
      DateTime lastdatetemp;
      lastdatetemp = lastdate.add(Duration(days: 1));
      if (lastdatetemp.month != currentmonth)
        break;
      else
        lastdate = lastdatetemp;
    }

    starttime = "$currentyear-$currentmonth-01";
    endtime = lastdate.toString().split(" ")[0];
  }

  _showDatePicker() async {
    var date = await showMonthPicker(
        context: context,
        firstDate: DateTime(2019, 5),
        lastDate: DateTime(DateTime.now().year, DateTime.now().month),
        initialDate: DateTime.now());

    if (date == null) {
      return;
    }

    _getSummaryData(canteenID, date);
    setState(() {
      _currentDate = date as DateTime;
    });
  }

  List<monthAnalysis> listItems = [];

  Future _getSummaryData(String cateenID, DateTime date) async {
    getStartAndEndTime(date);
    print(starttime);
    print(endtime);
    await Provide.value<MonthSummaryDataProvide>(context)
        .getMonthSummaryData(starttime, endtime);
    if (Provide.value<MonthSummaryDataProvide>(context).monthSummaryData.data !=
        null) {
      setState(() {
        breakfastpost_eatenTotal =
            Provide.value<MonthSummaryDataProvide>(context)
                .monthSummaryData
                .data
                .count
                .breakfast
                .postEaten
                .toString();
        breakfastpost_neatenTotal =
            Provide.value<MonthSummaryDataProvide>(context)
                .monthSummaryData
                .data
                .count
                .breakfast
                .postNeaten
                .toString();
//        breakfastnpost_eatenTotal =
//            Provide.value<MonthSummaryDataProvide>(context)
//                .monthSummaryData
//                .data
//                .count
//                .breakfast
//                .npostEaten
//                .toString();
        breakfastnpost_eatenTotal =
            (Provide.value<MonthSummaryDataProvide>(context)
                .monthSummaryData
                .data
                .count
                .breakfast
                .npostEaten+Provide.value<MonthSummaryDataProvide>(context)
                .monthSummaryData
                .data
                .count
                .breakfast
                .upostEaten)
                .toString();

        breakfastremain_eatenTotal =
            Provide.value<MonthSummaryDataProvide>(context)
                .monthSummaryData
                .data
                .count
                .breakfast
                .remainEaten
                .toString();
        breakfastremain_neatenTotal =
            Provide.value<MonthSummaryDataProvide>(context)
                .monthSummaryData
                .data
                .count
                .breakfast
                .remainNeaten
                .toString();


        lunchpost_eatenTotal = Provide.value<MonthSummaryDataProvide>(context)
            .monthSummaryData
            .data
            .count
            .lunch
            .postEaten
            .toString();
        lunchpost_neatenTotal = Provide.value<MonthSummaryDataProvide>(context)
            .monthSummaryData
            .data
            .count
            .lunch
            .postNeaten
            .toString();
//        lunchnpost_eatenTotal = Provide.value<MonthSummaryDataProvide>(context)
//            .monthSummaryData
//            .data
//            .count
//            .lunch
//            .npostEaten
//            .toString();
        lunchnpost_eatenTotal = (Provide.value<MonthSummaryDataProvide>(context)
            .monthSummaryData
            .data
            .count
            .lunch
            .npostEaten+Provide.value<MonthSummaryDataProvide>(context)
            .monthSummaryData
            .data
            .count
            .lunch
            .upostEaten)
            .toString();
        lunchremain_eatenTotal = Provide.value<MonthSummaryDataProvide>(context)
            .monthSummaryData
            .data
            .count
            .lunch
            .remainEaten
            .toString();
        lunchremain_neatenTotal = Provide.value<MonthSummaryDataProvide>(context)
            .monthSummaryData
            .data
            .count
            .lunch
            .remainNeaten
            .toString();

        supperpost_eatenTotal = Provide.value<MonthSummaryDataProvide>(context)
            .monthSummaryData
            .data
            .count
            .dinner
            .postEaten
            .toString();
        supperpost_neatenTotal = Provide.value<MonthSummaryDataProvide>(context)
            .monthSummaryData
            .data
            .count
            .dinner
            .postNeaten
            .toString();
        suppernpost_eatenTotal = (Provide.value<MonthSummaryDataProvide>(context)
            .monthSummaryData
            .data
            .count
            .dinner
            .npostEaten+Provide.value<MonthSummaryDataProvide>(context)
            .monthSummaryData
            .data
            .count
            .dinner
            .upostEaten)
            .toString();
        supperremain_eatenTotal = Provide.value<MonthSummaryDataProvide>(context)
            .monthSummaryData
            .data
            .count
            .dinner
            .remainEaten
            .toString();
        supperremain_neatenTotal = Provide.value<MonthSummaryDataProvide>(context)
            .monthSummaryData
            .data
            .count
            .dinner
            .remainNeaten
            .toString();

        listItems.clear();
        Provide.value<MonthSummaryDataProvide>(context)
            .monthSummaryData
            .data
            .detaildata
            .forEach((v) {
          monthAnalysis datedatatemp = new monthAnalysis(
              v.date,
              v.summaryData.breakfast.postEaten.toString(),
              v.summaryData.breakfast.postNeaten.toString(),
//              v.summaryData.breakfast.npostEaten.toString(),
              (v.summaryData.breakfast.npostEaten+v.summaryData.breakfast.upostEaten).toString(),
              v.summaryData.breakfast.remainEaten.toString(),
              v.summaryData.breakfast.remainNeaten.toString(),
              v.summaryData.lunch.postEaten.toString(),
              v.summaryData.lunch.postNeaten.toString(),
//              v.summaryData.lunch.npostEaten.toString(),
              (v.summaryData.lunch.npostEaten+v.summaryData.lunch.upostEaten).toString(),
              v.summaryData.lunch.remainEaten.toString(),
              v.summaryData.lunch.remainNeaten.toString(),
              v.summaryData.dinner.postEaten.toString(),
              v.summaryData.dinner.postNeaten.toString(),
//              v.summaryData.dinner.npostEaten.toString(),
              (v.summaryData.dinner.npostEaten+v.summaryData.dinner.upostEaten).toString(),
              v.summaryData.dinner.remainEaten.toString(),
              v.summaryData.dinner.remainNeaten.toString());
          listItems.add(datedatatemp);
        });
      });
    }
  }

  Widget _summaryDataBar() {
    return new Stack(
      children: <Widget>[
        new AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            '就餐统计',
            style: TextStyle(color: Colors.black,
                fontSize: ScreenUtil().setSp(40),
                fontWeight:FontWeight.w500),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: <Widget>[
            new FlatButton(
              onPressed: _showDatePicker,
              child: new Text(_currentDate.toString().split(" ")[0].substring(0, 7).toString(),
                style: new TextStyle(color: Colors.black),
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
        child: new Text(
      text == null ? "" : text,
      textAlign: TextAlign.left,
      style: TextStyle(fontSize: 13),
    ));
  }

  //containerBox封装
  Widget _containerBox(String text, Color color) {
    return Container(
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
        decoration: BoxDecoration(color: Color(0xf6f6f80)),
        child: Text(
          text == null ? " " : text,
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 16, color: color),
        ));
  }

  //containerBox2封装
  Widget _containerBoxTotal(String text, Color color) {
    return Container(
        alignment: Alignment.center,
        //padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        decoration: BoxDecoration(color: Color(0xf6f6f80)),
        child: Text(
          text == null ? " " : text,
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 18, color: color),
        ));
  }

  //imageContainer封装
  Widget _imagecontainer(String imagepath, time, type) {
    return GestureDetector(
      child: Container(
        width: ScreenUtil.getInstance().setSp(100),
        height: ScreenUtil.getInstance().setSp(100),
        decoration: BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
            image: AssetImage(imagepath),
            fit: BoxFit.fill,
          ),
        ), //monthAnalysis.date
      ),
      onTap: () {
        if (time != null && time != "") {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MealStatisticalDetailedPage(time,type)));
          //Appliaction.router.navigateTo(context,
          //    "/mealStatisticalDetail?mealtime=${time}&mealtype=${type.toString()}");
        }
      },
    );
  }

  /**
   * 每餐的列格式 iconpath 图片url  orderAndeatNum 已报用餐 orderNotEatNum 已报未用餐  notOrderButEatNum  未报用餐
   *   time 时间  type 0 1 2 早中晚
   */
  Widget _columnBox(String iconpath, String orderAndeatNum,
      String orderNotEatNum, String notOrderButEatNum, String time, type) {
    return Column(children: <Widget>[
      _sizedBox(" "),
      _imagecontainer(iconpath, time, type),
      _sizedBox(" "),
      _sizedBox("已报用餐:      $orderAndeatNum"),
      _sizedBox("已报未用餐:  $orderNotEatNum"),
      _sizedBox("未报用餐:      $notOrderButEatNum"),
    ]);
  }

  //月统计区域的每一行封装
  Widget _containerShow(monthAnalysis monthAnalysis) {
    return new
    Container(
        color: Color(0xFFF6F6F6),
    child: Container(
      //padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      height: _ITEM_HEIGHT,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/dingdanBG.png"),
            fit: BoxFit.fill,
          )),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _containerBox(monthAnalysis.date, Colors.black),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _columnBox(
                      "assets/images/icon_zaocan.png",
                      (int.parse(monthAnalysis.breakfastpost_eaten)+int.parse(monthAnalysis.breakfastremain_eaten)).toString(),
                      (int.parse(monthAnalysis.breakfastpost_neaten)+int.parse(monthAnalysis.breakfastremain_neaten)).toString(),
                      monthAnalysis.breakfastnpost_eaten,
                      monthAnalysis.date,
                      0),
                  _columnBox(
                      "assets/images/icon_wucan.png",
                      (int.parse(monthAnalysis.lunchpost_eaten)+int.parse(monthAnalysis.lunchremain_eaten)).toString(),
                      (int.parse(monthAnalysis.lunchpost_neaten)+int.parse(monthAnalysis.lunchremain_neaten)).toString(),
                      monthAnalysis.lunchnpost_eaten,
                      monthAnalysis.date,
                      1),
                  _columnBox(
                      "assets/images/icon_wancan.png",
                      (int.parse(monthAnalysis.supperpost_eaten)+int.parse(monthAnalysis.supperremain_eaten)).toString(),
                      (int.parse(monthAnalysis.supperpost_neaten)+int.parse(monthAnalysis.supperremain_neaten)).toString(),
                      monthAnalysis.suppernpost_eaten,
                      monthAnalysis.date,
                      2),
                ]),
          ]),
    ));
  }

  //月统计总计封装
  Widget _containerTotalShow() {
    return new Container(
      //padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
      decoration: new BoxDecoration(
          color: Colors.white,
          border: Border(bottom: new BorderSide(color: Colors.white))),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _containerBoxTotal("总计", Colors.black),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _columnBox(
                      "assets/images/icon_zaocan.png",
                      (int.parse(breakfastpost_eatenTotal)+int.parse(breakfastremain_eatenTotal)).toString(),
                      (int.parse(breakfastpost_neatenTotal)+int.parse(breakfastremain_neatenTotal)).toString(),
                      breakfastnpost_eatenTotal,
                      "",
                      0),
                  _columnBox(
                      "assets/images/icon_wucan.png",
                      (int.parse(lunchpost_eatenTotal)+int.parse(lunchremain_eatenTotal)).toString(),
                      (int.parse(lunchpost_neatenTotal)+int.parse(lunchremain_neatenTotal)).toString(),
                      lunchnpost_eatenTotal,
                      "",
                      1),
                  _columnBox(
                      "assets/images/icon_wancan.png",
                      (int.parse(supperpost_eatenTotal)+int.parse(supperremain_eatenTotal)).toString(),
                      (int.parse(supperpost_neatenTotal)+int.parse(supperremain_neatenTotal)).toString(),
                      suppernpost_eatenTotal,
                      "",
                      2),
                ]),
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
              //margin: const EdgeInsets.all(8.0),
              child: new Column(
                children: <Widget>[
                  new Flexible(
                    child: new ListView(
                      controller: _scrollController,
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
