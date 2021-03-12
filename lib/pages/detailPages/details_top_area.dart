import 'package:flutter/material.dart';
import 'package:flutter_canteen/provide/detail_info.dart';
import 'package:provide/provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/pages/photo_view_page/photo_view_page.dart';
//商品详情页的首屏区域，包括图片、商品名称，商品价格，商品编号的UI展示
class DetailsTopArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<DetailsInfoProvide>(

        builder:(context,child,val){
          var foodsInfo=Provide.value<DetailsInfoProvide>(context).foodsInfo.data.foodInfo;

          if(foodsInfo != null){
            return Container(
              color: Colors.white,
              padding: EdgeInsets.all(2.0),
              child: Column(
                children: <Widget>[
//                  _foodsImage( foodsInfo.dishPhoto[0],context),
                  foodsInfo.dishPhoto[0]+"/"!=staticimageurl?_foodsImage(foodsInfo.dishPhoto[0],context):_nullImage(),
                  _foodsName( foodsInfo.dishName ),
                  _foodsNum(foodsInfo.dishId),
                  _foodsPrice(foodsInfo.dishPrice)
                ],
              ),
            );

          }else{
            return Text('正在加载中......');
          }
        }
    );

  }

  //没有图片
  Widget _nullImage(){
    return Container(
        width: ScreenUtil().setSp(700),
        color: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(150)),
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Icon(Icons.image,color: Colors.black26,size: ScreenUtil().setSp(150),),
              Container(
                child: Text("暂无图片",style: TextStyle(fontWeight:FontWeight.w500,fontSize: ScreenUtil().setSp(36)),),
                height: ScreenUtil().setSp(70),
              )
            ],
          ),
        )
    );
  }

  //商品图片
  Widget _foodsImage(url,BuildContext context){
    if(!url.contains("http"))
    {
      url="http://$resourceUrl/"+url;
    }
    else if(url.contains("comdish"))
      url=url.toString().replaceAll("comdish", "com/dish");
    return  InkWell(
        onTap: (){
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PhotoViewSimpleScreen(imageProvider: NetworkImage(url),heroTag: "",)));
      //Appliaction.router.navigateTo(context,"/detail?id=${newList[index].dishId}");
    },
    child:Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      height:ScreenUtil().setSp(500) ,
      width:ScreenUtil().setSp(740),
      child: Image.network(
          url,
          fit: BoxFit.fill, //填充
          gaplessPlayback: true, //防止重绘),
      ),
    ));
  }

  //商品名称
  Widget _foodsName(name){

    return Container(
      width: ScreenUtil().setSp(730),
      padding: EdgeInsets.only(left:15.0),
      child: Text(
        name,
        maxLines: 1,
        style: TextStyle(
            fontSize: ScreenUtil().setSp(30)
        ),
      ),
    );
  }

  //商品编号

  Widget _foodsNum(num){
    return  Container(
      width: ScreenUtil().setSp(730),
      padding: EdgeInsets.only(left:15.0),
      margin: EdgeInsets.only(top:8.0),
      child: Text(
        '编号:${num}',
        style: TextStyle(
            color: Colors.black26
        ),
      ),

    );
  }

  //商品价格方法

  Widget _foodsPrice(presentPrice){

    return  Container(
      width: ScreenUtil().setSp(730),
      padding: EdgeInsets.only(left:15.0),
      margin: EdgeInsets.only(top:8.0),
      child: Row(
        children: <Widget>[
          Text(
            '价格${presentPrice}元',
            style: TextStyle(
              color:Colors.pinkAccent,
              fontSize: ScreenUtil().setSp(40),

            ),

          ),
          //Text(
          //  '市场价:￥${oriPrice}',
          //  style: TextStyle(
          //      color: Colors.black26,
          //      decoration: TextDecoration.lineThrough
          //  ),
         // )
        ],
      ),
    );

  }


}