import 'package:flutter/material.dart';
import 'package:flutter_canteen/pages/HomePage/loginOrRegister.dart';
import 'package:flutter_canteen/pages/foodManage/menuDataList.dart';
import 'package:flutter_canteen/provide/menu_data.dart';
import 'package:flutter_canteen/provide/detail_info.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/common/shared_preference.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_canteen/otherfunction/showDialog.dart';

class showcommentPage extends StatefulWidget {
  String mealtime;
  int mealtype;
  String ordernumber;
  int ordertype; //订单类型： 1 报餐订单  2. 订餐订单
  String totalnum;
  String totalprice;
  String mUserId = null;
  String orderdesc;
  String drinkCanteenName;
  int canteenID_ID;

  // showcommentPage(this.mealtime, this.mealtype, this.ordernumber,this.ordertype,this.totalnum,this.totalprice);
  showcommentPage(this.mealtime, this.mealtype, this.ordernumber,
      this.ordertype, this.totalnum, this.totalprice, this.mUserId,this.orderdesc, this.drinkCanteenName,this.canteenID_ID);

  @override
  _showcommentPageState createState() => _showcommentPageState(
      this.mealtime,
      this.mealtype,
      this.ordernumber,
      this.ordertype,
      this.totalnum,
      this.totalprice,
      this.mUserId,
      this.orderdesc,
      this.drinkCanteenName,
      this.canteenID_ID
  );
}

class _showcommentPageState extends State<showcommentPage> {
  String mealtime;
  int mealtype;
  String ordernumber;
  int ordertype; //订单类型： 1 报餐订单  2. 订餐订单
  String totalnum;
  String totalprice;
  String mUserId = null;
  String orderdesc;
  String drinkCanteenName;
  int canteenID_ID;

  _showcommentPageState(this.mealtime, this.mealtype, this.ordernumber,
      this.ordertype, this.totalnum, this.totalprice, this.mUserId,this.orderdesc, this.drinkCanteenName,this.canteenID_ID);


  bool isfirstload = true;
  DateTime lastPopTime=null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("###########订单:${canteenID_ID},${drinkCanteenName}");
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
            '订单详情',
            style: TextStyle(color: Colors.black,
                fontSize: ScreenUtil().setSp(40),
                fontWeight:FontWeight.w500),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: FutureBuilder(
          future: ordertype == 1 ? getBaocanFoodsMenu() : getDingCanFoodsMenu(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 5.0),
                    child: Column(
                      children: <Widget>[
                        dateAndOrderIDWidget(),
                        ordertypeWidget(),
                        lineView(),
                        ordertype == 1
                            ? new MenuDataList("2")
                            : new MenuDataList("3"),
                        totalNumAndPrice(),
                        mUserId != userID && ordertype == 2 && usertype == "1"
                            ?(orderdesc=="食堂已确认" ?_buttonsGrey(context) :(
                            orderdesc=="食堂已拒绝"?_buttonsrefuse(context):_buttonsWidget(context)
                        ))
                            : Text("")
                      ],
                    ),
                  ));
            } else {
              return Center(
                  child: Text('加载中……',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil.getInstance().setSp(24))));
            }
          },
        ));
  }

  Widget dateAndOrderIDWidget() {
    return Row(
      children: <Widget>[
        Text(
          mealtime +
              "  " +
              (mealtype == 1 ? "早餐" : mealtype == 2 ? "中餐" : "晚餐"),
          maxLines: 1,
          style: TextStyle(
            color: Color(0xFF6D7278),
            fontSize: 12.0,
            height: 1.0,
            decoration: TextDecoration.none,
            decorationStyle: TextDecorationStyle.dashed,
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(""),
        ),
        Container(
          child: Text(
            '订单编号：' + ordernumber,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Color(0xFF6D7278),
              fontSize: 12.0,
              height: 1.0,
              decoration: TextDecoration.none,
              decorationStyle: TextDecorationStyle.dashed,
            ),
          ),
        ),
      ],
    );
  }

  //订单类型
  Container ordertypeWidget() {
    return (Container(
      child: Row(
        children: <Widget>[
          Text(
            '订单类型:  ',
            maxLines: 1,
            style: TextStyle(
              color: Color(0xFF6D7278),
              fontSize: 12.0,
              height: 1.2,
              decoration: TextDecoration.none,
              decorationStyle: TextDecorationStyle.dashed,
            ),
          ),
          Container(
            child: ordertype == 1
                ? Text(
              "报餐订单",
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.orange,
                fontSize: 12.0,
                height: 1.0,
                decoration: TextDecoration.none,
                decorationStyle: TextDecorationStyle.dashed,
              ),
            )
                : Text(
              "订餐订单",
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.blue,
                fontSize: 12.0,
                height: 1.0,
                decoration: TextDecoration.none,
                decorationStyle: TextDecorationStyle.dashed,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(""),
          ),
          Container(
            child: Text(
              '食堂：' + drinkCanteenName,
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(0xFF6D7278),
                fontSize: 12.0,
                height: 1.0,
                decoration: TextDecoration.none,
                decorationStyle: TextDecorationStyle.dashed,
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget totalNumAndPrice() {
    return Column(children: <Widget>[
      Container(
        padding: EdgeInsets.fromLTRB(0, 7, ScreenUtil().setSp(75), 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              ordertype == 1 ? '菜品数量： ' : '用餐人数： ',
              maxLines: 1,
              style: TextStyle(
                color: Color(0xFF6D7278),
                fontSize: ScreenUtil().setSp(25),
                height: 1.2,
                decoration: TextDecoration.none,
                decorationStyle: TextDecorationStyle.dashed,
              ),
            ),
            Text(
              totalnum,
              maxLines: 1,
              style: TextStyle(
                color: Color(0xFFEC3939),
                fontSize: ScreenUtil().setSp(25),
                height: 1.2,
                decoration: TextDecoration.none,
                decorationStyle: TextDecorationStyle.dashed,
              ),
            ),
          ],
        ),
      ),
      Container(
        padding: EdgeInsets.fromLTRB(0, 7, ScreenUtil().setSp(75), 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              '价格总计:  ',
              maxLines: 1,
              style: TextStyle(
                color: Color(0xFF6D7278),
                fontSize: ScreenUtil().setSp(25),
                height: 1.2,
                decoration: TextDecoration.none,
                decorationStyle: TextDecorationStyle.dashed,
              ),
            ),
            Text(
              totalprice + "元",
              maxLines: 1,
              style: TextStyle(
                color: Color(0xFFEC3939),
                fontSize: ScreenUtil().setSp(25),
                height: 1.2,
                decoration: TextDecoration.none,
                decorationStyle: TextDecorationStyle.dashed,
              ),
            ),
          ],
        ),
      )
    ]);
  }

  /**
   * 分割线
   */
  Container lineView() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Divider(
        height: 1.0,
        indent: 0.0,
        color: Colors.grey,
      ),
    );
  }

  //String userID =await KvStores.get(KeyConst.USERID);
  Future getBaocanFoodsMenu() async {
    if (!isfirstload) return "second";
    isfirstload = false;
    await Provide.value<MenuDataProvide>(context)
        .getBaoCanMenuFoodsInfo(canteenID_ID.toString(), mealtime, mealtype - 1, 2);
    int size = Provide.value<MenuDataProvide>(context)
        .personalmenudata
        .data
        .menuInfo
        .length;

    return "success";
  }

  Future getDingCanFoodsMenu() async {
    if (!isfirstload) return "second";
    isfirstload = false;
    await Provide.value<MenuDataProvide>(context)
        .getDingCanMenuFoodsInfo(mUserId, mealtime, mealtype - 1,canteenID_ID);
    int size = Provide.value<MenuDataProvide>(context)
        .dingdanmenudata
        .data
        .foodInfoList
        .length;
    return "success";
  }

  Widget _buttonsGrey(BuildContext context){
    return Container(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  height: ScreenUtil().setSp(80.0),
                  width: ScreenUtil().setSp(250.0),
                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                  child: RaisedButton(
                    onPressed: () {

                    },
                    child: Text('已确认'),
                    color: Colors.grey,
                    shape: StadiumBorder(),
                  )),

            ]));
  }
  Widget _buttonsrefuse(BuildContext context){
    return Container(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  height: ScreenUtil().setSp(80.0),
                  width: ScreenUtil().setSp(250.0),
                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                  child: RaisedButton(
                    onPressed: () {

                    },
                    child: Text('已拒绝'),
                    color: Colors.grey,
                    shape: StadiumBorder(),
                  )),

            ]));
  }

  Widget _buttonsWidget(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  height: ScreenUtil().setSp(80.0),
                  width: ScreenUtil().setSp(250.0),
                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                  child: RaisedButton(
                    onPressed: () async {
                      if(lastPopTime == null || DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
                        lastPopTime = DateTime.now();
                        setState(() async{
                          await confirmOrCloseMeal(7);
                        });
                      }else{
                        lastPopTime = DateTime.now();
                        showMessage(context,"请勿重复点击！");
                        return;
                      }
                    },
                    child: Text('拒绝订单'),
                    color: Colors.orange,
                    shape: StadiumBorder(),
                  )),
              Container(
                  height: ScreenUtil().setSp(80.0),
                  width: ScreenUtil().setSp(250.0),
                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                  child: RaisedButton(
                    onPressed: () async {
                      if(isYouKe){
                        showDialog(
                            context: context,
                            builder: (context){
                              return LoginOrRegister();
                            }
                        );
                      }else{
                        if(lastPopTime == null || DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
                          lastPopTime = DateTime.now();
                          setState(() async{
                            await confirmOrCloseMeal(6);
                          });
                        }else{
                          lastPopTime = DateTime.now();
                          showMessage(context,"请勿重复点击！");
                          return;
                        }
                      }
                    },
                    child: Text('确认订单'),
                    color: Colors.orange,
                    shape: StadiumBorder(),
                  )),
            ]));
  }

  /**
   * 确认或取消报餐
   */
  Future<void> confirmOrCloseMeal(int state) async {
    var fromData = {
      'mealstat_id': ordernumber,
      'state': state,
      'price': totalprice
    };
    await request('order', '', formData: fromData).then((val) {
      if (val != null) {
        var parse = val['code'];
        var parse2 = int.parse(parse);
        setState(() {
          if (parse2 == 0) {
            if (state == 5) {
              showMessage(context,"取消订单成功");
            } else {
              showMessage(context,"确认订单成功");
            }
          } else {
            showMessage(context,val['message']);
          }
        });
      }
    });
  }
}
