import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_canteen/pages/webViewPage/myWebViewpage.dart';
import 'package:flutter_canteen/router/application.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'loveShopPageItem.dart';

class loveShopCard extends StatefulWidget {
  loveShopPageItem mLoveShopPageItem;

  loveShopCard(this.mLoveShopPageItem);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoveShopCard(mLoveShopPageItem);
  }
}

class _LoveShopCard extends State<loveShopCard> {
  loveShopPageItem mLoveShopPageItem;

  _LoveShopCard(this.mLoveShopPageItem);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.white,
      height: ScreenUtil().setWidth(80),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(40), 0, 0, 0),
            child: Text(
              mLoveShopPageItem.loveShop,
              style: TextStyle(
                color: Color(0xFF535353),
                fontSize: ScreenUtil().setSp(24),
                height: 1.0,
                decoration: TextDecoration.none,
                decorationStyle: TextDecorationStyle.dashed,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(10), 0, 0, 0),
            child: Text(
              "主营：",
              style: TextStyle(
                color: Color(0xFF535353),
                fontSize: ScreenUtil().setSp(20),
                height: 1.0,
                decoration: TextDecoration.none,
                decorationStyle: TextDecorationStyle.dashed,
              ),
            ),
          ),
          Container(
            child: Text(
              mLoveShopPageItem.business,
              style: TextStyle(
                color: Color(0xFF535353),
                fontSize: ScreenUtil().setSp(20),
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
          InkWell(
            onTap: () {
              //&title=${mLoveShopPageItem.loveShop}
              var parse = Uri.parse(mLoveShopPageItem.url);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          myWebViewPage(parse, mLoveShopPageItem.loveShop)));
            },
            child: Container(
              color: Theme.of(context).primaryColor,
              width: ScreenUtil().setSp(180),
              height: ScreenUtil().setSp(60),
              margin: EdgeInsets.fromLTRB(0, 0, ScreenUtil().setWidth(20), 0),
              child: Center(
                child: Text("进入店铺"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
