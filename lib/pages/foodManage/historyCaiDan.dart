import 'package:flutter/material.dart';
import 'package:flutter_canteen/provide/menu_data.dart';
import 'package:provide/provide.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/pages/foodManage/menuDataList.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_canteen/otherfunction/showDialog.dart';


//菜单
class HistoryCaiDanPage extends StatefulWidget {
  final String functionID;

  HistoryCaiDanPage(this.functionID);

  @override
  _HistoryCaiDanPageState createState() => _HistoryCaiDanPageState();
}

class _HistoryCaiDanPageState extends State<HistoryCaiDanPage> {
  int groupValue = 1;
  @override
  var _chooseDate = DateTime.now().toString().split(" ")[0];

  var _currentDate = DateTime.now();
  DateTime lastPopTime=null;

  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provide.value<MenuDataProvide>(context).getBaoCanMenuFoodsInfo(
          canteenID, _currentDate.toString().split(" ")[0], groupValue-1, 1);
      if (_currentDate.hour > 20 && _currentDate.hour < 9) {
        groupValue = 3;
      }
      else if (_currentDate.hour > 9 && _currentDate.hour < 12)
        groupValue = 1;
      else if (_currentDate.hour > 12 && _currentDate.hour < 20) groupValue = 2;
      setState(() {
      });
    });
  }


  _showDatePicker() async {
    var date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2019),
        lastDate: DateTime.now(),
        locale: Locale('zh'));
    if (date == null) {
      return;
    }
    if (!_currentDate.isAtSameMomentAs(date)) {
      _currentDate = date;
      updateGroupValue(_currentDate.toString().split(" ")[0], groupValue);
      setState(() {
        this._chooseDate = _currentDate.toString().split(" ")[0];
      });
    }
  }

  void _theDayBefor() {
    var _tempDate = _currentDate;
    _tempDate = _tempDate.add(new Duration(days: -1));
//    if ((_tempDate.isAfter(DateTime(2019)) ||
//            _tempDate.isAtSameMomentAs(DateTime(2019))) &&
//        (_tempDate.isBefore(DateTime.now()) ||
//            _tempDate.isAtSameMomentAs(DateTime.now()))) {
//
//    }

    _currentDate = _tempDate;
    updateGroupValue(_currentDate.toString().split(" ")[0], groupValue);
    setState(() {
      this._chooseDate = _currentDate.toString().split(" ")[0];
    });
  }

  void _theDayAfter() {
    var _tempDate = _currentDate;
    _tempDate = _tempDate.add(new Duration(days: 1));
//    if ((_tempDate.isAfter(DateTime(2019)) ||
//            _tempDate.isAtSameMomentAs(DateTime(2019))) &&
//        (_tempDate.isBefore(DateTime.now()) ||
//            _tempDate.isAtSameMomentAs(DateTime.now()))) {
//
//    }
    _currentDate = _tempDate;
    updateGroupValue(_currentDate.toString().split(" ")[0], groupValue);
    setState(() {
      this._chooseDate = _currentDate.toString().split(" ")[0];
    });
  }

  //前一天按钮
  Widget theDayBeforeButton() {
    return Container(
      width: ScreenUtil.getInstance().setSp(200),
      height: ScreenUtil.getInstance().setSp(68),
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
            image: AssetImage("assets/images/btn_qianyt_default.png"),
            fit: BoxFit.fill),
      ),
      alignment: Alignment.center,
      child: FlatButton(
        onPressed: _theDayBefor,
        child: Text("< 前一天"),
        color: Colors.transparent,
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0)), side: BorderSide(color: Colors.white, style: BorderStyle.solid, width: 21)),
      ),
    );
  }

  //后一天按钮
  Widget theDayAfterButton() {
    return Container(
      width: ScreenUtil.getInstance().setSp(200),
      height: ScreenUtil.getInstance().setSp(68),
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
            image: AssetImage("assets/images/btn_houyt_default.png"),
            fit: BoxFit.fill),
      ),
      alignment: Alignment.center,
      child: FlatButton(
        onPressed: _theDayAfter,
        child: Text("后一天 >"),
        color: Colors.transparent,
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0)), side: BorderSide(color: Colors.white, style: BorderStyle.solid, width: 21)),
      ),
    );
  }

  //时间选择按钮
  Widget timeChoseButton(BuildContext context) {
    return Container(
      width: ScreenUtil.getInstance().setSp(300),
      height: ScreenUtil.getInstance().setSp(60),
      decoration: BoxDecoration(
        border: Border.all(width: 2.0, color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      alignment: Alignment.center,
      child: FlatButton(
        child: Text(_chooseDate.toString()),
        color: Colors.transparent,
        onPressed: _showDatePicker,
      ),
    );
  }

  //时间控件
  Widget timeChoseWidget(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: ScreenUtil.getInstance().setSp(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            theDayBeforeButton(),
            timeChoseButton(context),
            theDayAfterButton(),
          ],
        ));
  }

  Widget _mealTimeChoseWidget() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: RadioListTile(
                  value: 1,
                  activeColor: Theme.of(context).primaryColor,
                  groupValue: groupValue,
                  title: Text('早餐'),
                  onChanged: (T) {
                    updateGroupValue(_currentDate.toString().split(" ")[0], T);
                  })),
          Expanded(
              child: RadioListTile(
                  value: 2,
                  activeColor: Theme.of(context).primaryColor,
                  groupValue: groupValue,
                  title: Text('中餐'),
                  onChanged: (T) {
                    updateGroupValue(_currentDate.toString().split(" ")[0], T);
                  })),
          Expanded(
              child: RadioListTile(
                  value: 3,
                  activeColor: Theme.of(context).primaryColor,
                  groupValue: groupValue,
                  title: Text('晚餐'),
                  onChanged: (T) {
                    updateGroupValue(_currentDate.toString().split(" ")[0], T);
                  })),
        ],
      ),
    );
  }

  updateGroupValue(String time, int v) async {
    if(lastPopTime == null || DateTime.now().difference(lastPopTime) > Duration(seconds: 0)) {
      lastPopTime = DateTime.now();
      Provide.value<MenuDataProvide>(context).getBaoCanMenuFoodsInfo(canteenID, time, v-1, 1);
      setState(() {
        groupValue = v;
      });
    }else{
      lastPopTime = DateTime.now();
      showMessage(context,"请勿重复点击！");
      return;
    }
  }

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
          '历史菜单',
          style: TextStyle(color: Colors.black,
              fontSize: ScreenUtil().setSp(40),
              fontWeight:FontWeight.w500),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
          child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 5.0),
        child: Column(
          children: <Widget>[
            timeChoseWidget(context),
            _mealTimeChoseWidget(),
            MenuDataList("1"),
          ],
        ),
      )),
    );
  }
}
