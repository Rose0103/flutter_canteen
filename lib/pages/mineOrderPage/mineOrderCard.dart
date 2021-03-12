import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/model/widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_canteen/router/application.dart';
import 'package:flutter_canteen/pages/commentPages/showcommentPage.dart';
import 'package:flutter_canteen/pages/commentPages/putcommentPage.dart';
import 'mineOrderItem.dart';

class MineOrderCard extends StatefulWidget {
  MineOrderItem category;

  MineOrderCard({@required this.category});

  @override
  State<StatefulWidget> createState() {
    return _MineOrderCard(category: category);
  }
}

class _MineOrderCard extends State<MineOrderCard> {
  // 一级菜单目录下的二级Cat集合
  MineOrderItem category;
  List<CommonItem> _firstChildList;

  _MineOrderCard({@required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF6F6F6),
      padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
      child: Container(
          constraints: BoxConstraints(maxHeight: double.infinity),
          padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/dingdanBG.png"),
                fit: BoxFit.fill,
              )),
          width: double.infinity,
          child: Column(
            verticalDirection: VerticalDirection.down,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                constraints: BoxConstraints(maxHeight: double.infinity),
                width: double.infinity,
                color: Colors.white,
                child: firstLine(),
              ),
              lineView(),
              ordertypeWidget(),
              twoLine(),
              evaluationOrDetails()
            ],
          )),
    );
  }

  Container twoLine() {
    return Container(
      constraints: BoxConstraints(maxHeight: double.infinity),
      width: double.infinity,
      child: Row(
        children: <Widget>[mealType(), diningType()],
      ),
    );
  }

  Row firstLine() {
    return Row(
      children: <Widget>[
        Text(
          category.time + ' ' + category.goMealType,
          maxLines: 2,
          style: TextStyle(
            color: Color(0xFF6D7278),
            fontSize: 12.0,
            height: 1.0,
            decoration: TextDecoration.none,
            decorationStyle: TextDecorationStyle.dashed,
          ),
        ),

        Container(
          padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
          child: Text(
            '订单编号：' + category.orderNumber,
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

        Container(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: Text(
            '食堂：' + category.caName,
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
    );
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

  //订单类型
  Container ordertypeWidget()
  {
    return(
        Container(
          padding: EdgeInsets.fromLTRB(16, 0, 0, 5),
          child: Row(
            children: <Widget>[
              Text(
                '订单类型： ',
                maxLines: 1,
                style: TextStyle(
                  color: Color(0xFF6D7278),
                  fontSize: 14.0,
                  height: 1.2,
                  decoration: TextDecoration.none,
                  decorationStyle: TextDecorationStyle.dashed,
                ),
              ),
              Container(
                child: category.state<4?Text(
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
                ):Text(
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
              Text(
                '     报餐数量：',
                maxLines: 1,
                style: TextStyle(
                  color: Color(0xFF6D7278),
                  fontSize: 14.0,
                  height: 1.2,
                  decoration: TextDecoration.none,
                  decorationStyle: TextDecorationStyle.dashed,
                ),
              ),
              Container(
                  child: Text(
                    category.mealsNum,
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
              ),
            ],
          ),
        )
    );
  }


  /**
   * 报餐状态
   */
  Expanded mealType() {
    Color colorbg=Colors.greenAccent;
    switch(category.state){
      case 0:
        colorbg=Colors.greenAccent;
        break;
      case 1:
        colorbg=Colors.cyanAccent;
        break;
      case 2:
        colorbg=Colors.grey;
        break;
      case 3:
        colorbg=Colors.greenAccent;
        break;
      case 4:
        colorbg=Colors.amberAccent;
        break;
      case 5:
        colorbg=Colors.lightBlueAccent;
        break;
      case 6:
        colorbg=Colors.greenAccent;
        break;
      case 7:
        colorbg=Colors.orangeAccent;
        break;
    }
    return Expanded(
        flex: 1,
        child: Container(
          padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    '报餐状态：  ',
                    maxLines: 1,
                    style: TextStyle(
                      color: Color(0xFF6D7278),
                      fontSize: 14.0,
                      height: 1.2,
                      decoration: TextDecoration.none,
                      decorationStyle: TextDecorationStyle.dashed,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
                    decoration: BoxDecoration(
                      color: colorbg,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      category.mealType,
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        decoration: TextDecoration.none,
                        decorationStyle: TextDecorationStyle.dashed,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
                child: Row(
                  children: <Widget>[
                    Text(
                      category.state<4?'用餐数量： ':"用餐人数：   ",
                      maxLines: 1,
                      style: TextStyle(
                        color: Color(0xFF6D7278),
                        fontSize: 14.0,
                        height: 1.2,
                        decoration: TextDecoration.none,
                        decorationStyle: TextDecorationStyle.dashed,
                      ),
                    ),
                    Text(
                      category.dingmealsNum ,
                      maxLines: 1,
                      style: TextStyle(
                        color: Color(0xFFEC3939),
                        fontSize: 14.0,
                        height: 1.2,
                        decoration: TextDecoration.none,
                        decorationStyle: TextDecorationStyle.dashed,
                      ),
                    ),
                  ],
                ),
              ),
              category.state<4?Container(
                padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
                alignment: Alignment.centerLeft,
                child: Text(
                  switchIftakeMoneyEaten?"扣款规则：就餐时扣款":"扣款规则：报餐时扣款",
                  style: TextStyle(
                      color: Color(0xff333333),
                      fontSize: 14),
                ),
              ):Container(
                  padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        "实际支付：",
                        style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 14),
                      ),
                      Text(
                        "${category.mealsPrice}元",
                        style: TextStyle(
                            color: Color(0xFFEC3939),
                            fontSize: 14),
                      ),
                    ],
                  )
              ),
            ],
          ),
        ));
  }

  Expanded diningType() {
    Color colorbg=Colors.greenAccent;
    if(category.diningType=="未就餐")
      colorbg=Colors.amberAccent;
    return Expanded(
        flex: 1,
        child: Container(
          constraints: BoxConstraints(maxHeight: double.infinity),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    '就餐状态： ',
                    maxLines: 1,
                    style: TextStyle(
                      color: Color(0xFF6D7278),
                      fontSize: 14.0,
                      height: 1.2,
                      decoration: TextDecoration.none,
                      decorationStyle: TextDecorationStyle.dashed,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
                    decoration: BoxDecoration(
                      color: colorbg,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      category.diningType,
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        decoration: TextDecoration.none,
                        decorationStyle: TextDecorationStyle.dashed,
                      ),
                    ),
                  ),
                ],
              ),
              category.state<4?Container(
                padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '实际支付：',
                      maxLines: 1,
                      style: TextStyle(
                        color: Color(0xFF6D7278),
                        fontSize: 14.0,
                        height: 1.2,
                        decoration: TextDecoration.none,
                        decorationStyle: TextDecorationStyle.dashed,
                      ),
                    ),
                    Text(
                      category.costType==0?"${category.mealsPrice}元":"${category.ticketNum}张",
                      maxLines: 1,
                      style: TextStyle(
                        color: Color(0xFFEC3939),
                        fontSize: 14.0,
                        height: 1.2,
                        decoration: TextDecoration.none,
                        decorationStyle: TextDecorationStyle.dashed,
                      ),
                    ),
                  ],
                ),
              ):Container(
                padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '支付方式：',
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14.0,
                        height: 1.2,
                        decoration: TextDecoration.none,
                        decorationStyle: TextDecorationStyle.dashed,
                      ),
                    ),
                    Text(
                      category.costType==0?"余额支付":"餐券支付",
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 14.0,
                        height: 1.2,
                        decoration: TextDecoration.none,
                        decorationStyle: TextDecorationStyle.dashed,
                      ),
                    ),
                  ],
                ),
              ),
              category.state<4?Container(
                padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '支付方式：',
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14.0,
                        height: 1.2,
                        decoration: TextDecoration.none,
                        decorationStyle: TextDecorationStyle.dashed,
                      ),
                    ),
                    Text(
                      category.costType==0?"余额支付":"餐券支付",
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 14.0,
                        height: 1.2,
                        decoration: TextDecoration.none,
                        decorationStyle: TextDecorationStyle.dashed,
                      ),
                    ),
                  ],
                ),
              ):Container(
                child: Text(
                  "",
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 14.0,
                    height: 1.2,
                    decoration: TextDecoration.none,
                    decorationStyle: TextDecorationStyle.dashed,
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Container evaluationOrDetails() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 16, 16, 0),
      constraints: BoxConstraints(maxHeight: double.infinity),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: (){
              if(category.state==null||category.state<4)
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => showcommentPage(category.time, category.int_mealtype,category.orderNumber,1,category.mealsNum,category.mealsPrice,userID,category.mealType,category.caName,category.canteenID)));
              //Appliaction.router.navigateTo(context,"/showcommentpage?mealtime=${category.time}&mealtype=${category.int_mealtype.toString()}&ordernumber=${category.orderNumber}&ordertype=${1}&totalnum=${category.mealsNum}&totalprice=${category.mealsPrice}");
              else
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => showcommentPage(category.time, category.int_mealtype,category.orderNumber,2,category.mealsNum,category.mealsPrice,userID,category.mealType,category.caName,category.canteenID)));
              //Appliaction.router.navigateTo(context,"/showcommentpage?mealtime=${category.time}&mealtype=${category.int_mealtype.toString()}&ordernumber=${category.orderNumber}&ordertype=${2}&totalnum=${category.mealsNum}&totalprice=${category.mealsPrice}");
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
              padding: EdgeInsets.fromLTRB(18, 3, 18, 3),
              decoration: BoxDecoration(
                border:
                Border.all(width: 1.0, color: Theme
                    .of(context)
                    .primaryColor),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              alignment: Alignment.center,
              child: Text(
                '详情',
                maxLines: 1,
                style: TextStyle(
                  color: Theme
                      .of(context)
                      .primaryColor,
                  fontSize: 12.0,
                  height: 1.2,
                  decoration: TextDecoration.none,
                  decorationStyle: TextDecorationStyle.dashed,
                ),
              ),
            ),
          ),
          category.diningType=="未就餐"?Container():InkWell(
              onTap: (){
                if(category.state==null||category.state<4){
                  print("1laile");
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => putCommentPage(category.time, category.int_mealtype,category.orderNumber,1,category.mealsNum,category.mealsPrice,category.canteenID)));
                }
                else{
                  print("2");
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => putCommentPage(category.time, category.int_mealtype,category.orderNumber,2,category.mealsNum,category.mealsPrice,category.canteenID)));
                  }
                },
              child:Container(
                padding: EdgeInsets.fromLTRB(18, 3, 18, 3),
                decoration: BoxDecoration(
                  border:
                  Border.all(width: 1.0, color: Theme
                      .of(context)
                      .primaryColor),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                alignment: Alignment.center,
                child: Text(
                  '评价',
                  maxLines: 1,
                  style: TextStyle(
                    color: Theme
                        .of(context)
                        .primaryColor,
                    fontSize: 12.0,
                    height: 1.2,
                    decoration: TextDecoration.none,
                    decorationStyle: TextDecorationStyle.dashed,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
