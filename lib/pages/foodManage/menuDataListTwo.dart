import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_canteen/otherfunction/RatingBar.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_canteen/router/application.dart';
import 'package:flutter/material.dart';
import 'package:flutter_canteen/provide/menu_data.dart';
import 'package:provide/provide.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/common/shared_preference.dart';
import 'package:flutter_canteen/pages/foodManage/addCaiPin.dart';
import 'package:flutter_canteen/pages/detailPages/dishdetail.dart';
import 'package:flutter_canteen/pages/photo_view_page/photo_view_page.dart';

class MenuDataListTwo extends StatefulWidget {
  String widgettype; //historymenu:1   usermenu:2  历史菜单不查询具体评论
  MenuDataListTwo(this.widgettype);

  @override
  _MenuDataListState createState() => _MenuDataListState(this.widgettype);
}

class _MenuDataListState extends State<MenuDataListTwo> {
  String widgettype; //
  _MenuDataListState(this.widgettype);

  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();
  var scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Provide<MenuDataProvide>(
      builder: (context, child, data) {
        if (widgettype == "1"
            ? data.menudata != null
            : data.personalmenudata != null) {
          return Column(children: <Widget>[
            Text(
              "菜品详情",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: ScreenUtil().setSp(28)),
            ),
            Container(
              width: ScreenUtil().setSp(730),
              height: ScreenUtil().setSp(900),
              child: ListView.builder(
                shrinkWrap: true,
                physics: new NeverScrollableScrollPhysics(),
                controller: scrollController,
                itemCount: widgettype == "1"
                    ? data.menudata.data.menuInfo.length
                    : data.personalmenudata.data.menuInfo.length,
                itemBuilder: (context, index) {
                  return _ListWidget(
                      widgettype == "1"
                          ? data.menudata.data.menuInfo
                          : data.personalmenudata.data.menuInfo,
                      index);
                },
              ),
            )
          ]);
        } else {
          return Text('暂时没有数据');
        }
      },
    );
  }

  Widget _ListWidget(List newList, int index) {
    return Container(
      height: ScreenUtil().setSp(180),
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 1.0, color: Colors.black12))),
      child: Row(
        children: <Widget>[
          _foodsImage(newList, index),
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DetailsPage(newList[index].dishId.toString())));
                //Appliaction.router.navigateTo(context,"/detail?id=${newList[index].dishId}");
              },
              child: Column(
                children: <Widget>[
                  _foodsName(newList, index),
                  _foodsScore(newList, index),
                ],
              ))
        ],
      ),
    );
  }

  //商品图片
  Widget _foodsImage(List newList, int index) {
    if (!newList[index].dishPhoto[0].toString().contains("http")) {
      newList[index].dishPhoto[0] =
          "http://$resourceUrl/" + newList[index].dishPhoto[0];
    }
    return Container(
        width: ScreenUtil().setSp(180),
        height: ScreenUtil().setSp(140),
        child: newList[index].dishPhoto[0] == null
            ? Icon(Icons.image)
            : InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PhotoViewSimpleScreen(
                                imageProvider:
                                    NetworkImage(newList[index].dishPhoto[0]),
                                heroTag: "",
                              )));
                },
                child: Image.network(
                  newList[index].dishPhoto[0],
                  height: ScreenUtil().setSp(140), //设置高度
                  width: ScreenUtil().setSp(210), //设置宽度
                  fit: BoxFit.fill, //填充
                  gaplessPlayback: true, //防止重绘),
                ),
                //child:Icon(Icons.image),
              ));
  }

  //商品名称和评论方法
  Widget _foodsName(List newList, int index) {
    return Container(
      padding: EdgeInsets.all(5.0),
      alignment: Alignment.centerLeft,
      width: ScreenUtil().setSp(500),
      child: widgettype == "2" && newList[index].dishFlavor.length > 0
          ? Column(children: <Widget>[
              Text(
                newList[index].dishName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: ScreenUtil().setSp(30)),
              ),
              Text(
                newList[index].dishFlavor,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: ScreenUtil().setSp(25)),
              )
            ])
          : Text(
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "评分：",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: ScreenUtil().setSp(28)),
          ),
          RatingBar(
            clickable: false,
            size: 15,
            color: Colors.yellow,
            padding: 5,
            value: double.parse(newList[index].dishPrice.toString()),
          ),
        ],
      ),
    );
  }
}
