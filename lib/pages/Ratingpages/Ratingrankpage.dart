import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_canteen/otherfunction/RatingBar.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_canteen/provide/rating_data.dart';
import 'package:flutter_canteen/model/ratingdata.dart';
import 'dart:convert';
import 'package:provide/provide.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_canteen/router/application.dart';
import 'package:flutter_canteen/pages/detailPages/dishdetail.dart';


//菜品总评价
class RatingrankPage extends StatefulWidget {
  final String functionID;

  RatingrankPage(this.functionID);

  @override
  _RatingrankPageState createState() => _RatingrankPageState();
}

class _RatingrankPageState extends State<RatingrankPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provide.value<RatingDataProvide>(context).getRatingDataInfo(canteenID);
    });
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
          '菜品评价排行榜',
          style: TextStyle(color: Colors.black,
              fontSize: ScreenUtil().setSp(40),
              fontWeight:FontWeight.w500),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 5.0),
            child: Column(
              children: <Widget>[
                FoodRatingList(),
              ],
            ),
          )),
    );
  }
}

class FoodRatingList extends StatefulWidget {
  @override
  _FoodRatingListState createState() => _FoodRatingListState();
}

class _FoodRatingListState extends State<FoodRatingList> {
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();
  var scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Provide<RatingDataProvide>(
      builder: (context, child, data) {
        try {
          if (Provide.value<RatingDataProvide>(context).page == 1) {
            if (scrollController.hasClients) {
              scrollController.animateTo(
                0.0,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300),
              );
            }
          }
        } catch (e) {
          print('进入页面第一次初始化：${e}');
        }

        if (data.rateFoodList.length != null&&data.rateFoodList.length != 0) {
          return Container(
              constraints: BoxConstraints.tightFor(
                  width: double.infinity,
                  height: double.maxFinite),
              child: EasyRefresh(
                refreshFooter: ClassicsFooter(
                    key: _footerKey,
                    bgColor: Colors.white,
                    textColor: Colors.pink,
                    moreInfoColor: Colors.pink,
                    showMore: true,
                    noMoreText:
                        Provide.value<RatingDataProvide>(context).noMoreText,
                    moreInfo: '加载中',
                    loadReadyText: '上拉加载'),
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: data.rateFoodList.length,
                  itemBuilder: (context, index) {
                    return _ListWidget(data.rateFoodList, index);
                  },
                ),
                loadMore: () async {
                  if (Provide.value<RatingDataProvide>(context).noMoreText ==
                      '没有更多了') {
                    Fluttertoast.showToast(
                        msg: "已经到底了",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIos: floaststaytime,
                        backgroundColor: Colors.pink,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    _getMoreList();
                  }
                },
              ));
        } else {
          return buildEmpty();
        }
      },
    );
  }

  Widget buildEmpty() {
    return Container(
      width: double.infinity, //宽度为无穷大
      height: ScreenUtil().setSp(700.0),
      color: Colors.white,
      
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "assets/images/empty1.png",
            fit: BoxFit.cover,
          ),
          Text(
            "暂时没有数据",
            maxLines: 1,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              height: 1.2,
              decoration: TextDecoration.none,
              decorationStyle: TextDecorationStyle.dashed,
            ),
          )
        ],
      ),
    );
  }

  //上拉加载更多的方法
  void _getMoreList() async {
    Provide.value<RatingDataProvide>(context).addPage();
    var data = {
      'cateenId': canteenID,
      'page': Provide.value<RatingDataProvide>(context).page
    };

    await request('foodScore', '', formData: data).then((val) {
      if(val.toString()=="false")
      {
        return;
      }
      var data = val;
      //var data=val;
      RatingData ratedata = null; //菜品排行信息
      List<Score> rateFoodList = [];
      ratedata = RatingData.fromJson(data);
      rateFoodList = ratedata.data.score;

      if (rateFoodList == null) {
        Provide.value<RatingDataProvide>(context).changeNoMore('没有更多了');
      } else {
        Provide.value<RatingDataProvide>(context).addRatingList(rateFoodList);
      }
    });
  }

  Widget _ListWidget(List<Score> newList, int index) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailsPage(newList[index].dishId.toString())));
          //Appliaction.router
          //    .navigateTo(context, "/detail?id=${newList[index].dishId}");
        },
        child: Container(
          padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.black12))),
          child: Row(
            children: <Widget>[
              //_foodsImage(newList,index),
              Column(
                children: <Widget>[
                  _foodsName(newList, index),
                  _foodsScore(newList, index),
                ],
              )
            ],
          ),
        ));
  }

  //商品图片
  Widget _foodsImage(List newList, int index) {
    return Container(
      width: ScreenUtil().setSp(150),
      child: Image.network(newList[index].image,
        height: ScreenUtil().setSp(140), //设置高度
        width: ScreenUtil().setSp(210), //设置宽度
        fit: BoxFit.fill, //填充
        gaplessPlayback: true, //防止重绘),
      ),
    );
  }

  //商品名称方法
  Widget _foodsName(List newList, int index) {
    return Container(
      padding: EdgeInsets.all(5.0),
      alignment: Alignment.centerLeft,
      width: ScreenUtil().setSp(500),
      child: Text(
        newList[index].dishName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
      ),
    );
  }

  //菜品分数
  Widget _foodsScore(List newList, int index) {
    return Container(
      width: ScreenUtil().setSp(500),
      padding: EdgeInsets.only(left: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            "排名：${(index + 1).toString()}",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style:
                TextStyle(fontSize: ScreenUtil().setSp(28), color: Colors.pink),
          ),
          RatingBar(
            clickable: false,
            size: 15,
            color: Colors.yellow,
            padding: 5,
            value: double.parse(newList[index].dishScore.toString()),
          ),
          Text(
            "评分：${newList[index].dishScore.toString()}",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: ScreenUtil().setSp(28)),
          ),
        ],
      ),
    );
  }

  //分割线
  Widget _splitLine() {
    return Divider(
      height: 4.0,
      indent: 0.0,
      color: Colors.red,
    );
  }
}
