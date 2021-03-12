import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_canteen/model/manager_homepage_data.dart';

// 首页轮播组件编写
class SwiperDiy extends StatelessWidget {
  final List<Slides> swiperDataList;

  SwiperDiy({Key key, this.swiperDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: ScreenUtil().setSp(268),
      padding: EdgeInsets.fromLTRB(ScreenUtil().setSp(15), 0, ScreenUtil().setSp(15), 0),
      //width: ScreenUtil().setSp(750),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Container(
              decoration: BoxDecoration(
              border: new Border.all(color: Colors.white, width: 0.5),
              borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
          image: NetworkImage("${swiperDataList[index].image}"),
          fit: BoxFit.fill)
          ));
        },
        itemCount: swiperDataList.length,
        pagination: new SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}
