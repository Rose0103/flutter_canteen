import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_canteen/common/shared_preference.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/model/widget.dart';
import 'package:flutter_canteen/otherfunction/showDialog.dart';
import 'package:flutter_canteen/pages/commentPages/putcommentPage.dart';
import 'package:flutter_canteen/pages/commentPages/showcommentPage.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'orderConfirmItem.dart';

import 'package:url_launcher/url_launcher.dart';

class orderConfirmCard extends StatefulWidget {
  OrderConfirmItem category;

  orderConfirmCard({@required this.category});


  @override
  State<StatefulWidget> createState() {
    return _orderConfirmCard(category: category);
  }
}

class _orderConfirmCard extends State<orderConfirmCard> {
  // 一级菜单目录下的二级Cat集合
  OrderConfirmItem category;
  List<CommonItem> _firstChildList;


  _orderConfirmCard({@required this.category});

  var orderConfirm;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => showcommentPage(category.time, category.int_mealtype,category.orderNumber,2,category.mealsNum,category.mealsPrice,category.mUserId,category.mealType,category.caName,category.canteenID)));
      },
      child: Container(
        color: Color(0xFFF6F6F6),
        padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
        child: Container(
            constraints: BoxConstraints(maxHeight: double.infinity),
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
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
                //modify by lilixia   2020-11-23
                usertype=="3"?Text(''):category.mealType=='用户已取消'?Text(''):evaluationOrDetails()
//                category.mealType=='用户已取消'?Text(''):evaluationOrDetails()
              ],
            )),
      ),
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
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          child: Text(
              category.mealName
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
          child: IconButton(
            icon: Icon(Icons.call),
            onPressed: ()=>launch("tel:"+category.mealPhone),
          )
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
  Container ordertypeWidget() {
    return (Container(
      padding: EdgeInsets.fromLTRB(16, 0, 0, 5),
      child: Row(
        children: <Widget>[
          Text(
            '订单类型:  ',
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
            child: category.state < 4
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
          Container(
            padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
            child: Text(
              '食堂：' + category.caName,
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(0xFF6D7278),
                fontSize: 14.0,
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

  Expanded mealType() {
    Color colorbg=Colors.greenAccent;
    switch(category.state){
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
                    '报餐状态:  ',
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
                      category.state < 4 ? '报餐数量： ' : "用餐人数：   ",
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
                      category.mealsNum,
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
              )
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
                    '就餐状态:  ',
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
              Container(
                padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '价格:  ',
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
                      category.mealsPrice + "元",
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
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text(""),
          ),
          InkWell(
            onTap: () {

              if(category.mealType != "食堂已确认"){
                confirmOrCloseMeal(6);
              }else{
                showMessage(context, "订单已确认");
                return;
              }
            },
            child: category.mealType == "食堂已确认"
                ? Container(
              margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
              padding: EdgeInsets.fromLTRB(18, 3, 18, 3),
              decoration: BoxDecoration(
                border: Border.all(
                    width: 1.0, color: Colors.green),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              alignment: Alignment.center,
              child: Text(
                '已确定',
                maxLines: 1,
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 12.0,
                  height: 1.2,
                  decoration: TextDecoration.none,
                  decorationStyle: TextDecorationStyle.dashed,
                ),
              )
            ):
            (category.mealType == "食堂已拒绝"?Text(""):
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
              padding: EdgeInsets.fromLTRB(18, 3, 18, 3),
              decoration: BoxDecoration(
                border: Border.all(
                    width: 1.0, color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              alignment: Alignment.center,
              child: Text(
                '确认订单',
                maxLines: 1,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 12.0,
                  height: 1.2,
                  decoration: TextDecoration.none,
                  decorationStyle: TextDecorationStyle.dashed,
                ),
              ),
            )
            )
          ),
          InkWell(
              onTap: () {
                //未报餐
                if(category.mealType != "食堂已拒绝"){
                  confirmOrCloseMeal(7);
                }else{
                  showMessage(context, "订单已拒绝");
                  return;
                }
              },
              child:category.mealType == "食堂已确认" ? Container():
              (category.mealType == "食堂已拒绝" ? Container(
                padding: EdgeInsets.fromLTRB(18, 3, 18, 3),
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1.0, color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                alignment: Alignment.center,
                child: Text(
                  '已拒绝',
                  maxLines: 1,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12.0,
                    height: 1.2,
                    decoration: TextDecoration.none,
                    decorationStyle: TextDecorationStyle.dashed,
                  ),
                ),
              ):Container(
                padding: EdgeInsets.fromLTRB(18, 3, 18, 3),
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1.0, color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                alignment: Alignment.center,
                child: Text(
                  '拒绝订单',
                  maxLines: 1,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12.0,
                    height: 1.2,
                    decoration: TextDecoration.none,
                    decorationStyle: TextDecorationStyle.dashed,
                  ),
                ),
              ))
              ),
        ],
      ),
    );
  }

  /**
   * 确认或取消报餐
   */
  Future<void> confirmOrCloseMeal(int state) async {
    if(state == 7){
      category.mealsPrice = 0.toString();
    }
    var formData = {
      'mealstat_id': category.orderNumber,
      'state': state,
      'price': category.mealsPrice
    };
    print("##############:${formData.toString()}");
    await request('order', '', formData: formData).then((val) {
      orderConfirm = state;
      if (val != null) {
        var parse = val['code'];
        var parse2 = int.parse(parse);
        setState(() {
          if (parse2 == 0) {
            if (state == 5) {
              category.mealType = "用户取消订餐";
            } else if(state == 6){
              category.mealType = "食堂已确认";
            }else if(state == 7){
              category.mealType = "食堂已拒绝";
            }
          } else {
            showMessage(context, val['message']);
          }
        });
      }
    });
  }
}
