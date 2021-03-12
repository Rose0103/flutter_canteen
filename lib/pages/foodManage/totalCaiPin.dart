import 'package:flutter/material.dart';
import 'package:flutter_canteen/model/category.dart';
import 'package:flutter_canteen/provide/child_category.dart';
import 'package:flutter_canteen/provide/category_foods_list.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'dart:core';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_canteen/pages/categoryPage/categorypage.dart';
import 'package:provide/provide.dart';
import 'package:flutter_canteen/config/param.dart';


class TotalCaiPinPage extends StatefulWidget {
  final String functionID;
  TotalCaiPinPage(this.functionID);

  @override
  _TotalCaiPinPageState createState() => _TotalCaiPinPageState();
}

class _TotalCaiPinPageState extends State<TotalCaiPinPage>  {

  @override
  void initState() {
    categoryBigModelDataSecondaryCategoryId = "";
    categoryIndex = 0;
    _getCategory();
    super.initState();
  }

  void _getCategory() async{
    categoryList.clear();
    await requestGet('Category', '?canteen_id='+canteenID).then((val) async{
      if(val.toString()=="false") {
        return;
      }
      //var  data = json.decode(val.toString());
      //print(data);
      CategoryBigModel category=CategoryBigModel.fromJson(val);
      categoryList = category.data;
      if(categoryList==null||categoryList.length==0){
        return;
      }
     if(categoryList[0].secondaryCategoryList.length>0)
      {
        Provide.value<ChildCategory>(context).changeCategory(categoryList[0].secondaryCategoryList[0].categoryId, 0);
        LeftCategoryNavState.getFoodList(context,categoryList[0].secondaryCategoryList[0].categoryId);
        Provide.value<ChildCategory>(context).getChildCategory( categoryList[0].secondaryCategoryList,categoryList[0].secondaryCategoryList[0].categoryId);
      }
      else
      {
        //清空子类
        Provide.value<ChildCategory>(context).childCategoryList=[];
        //清空商品列表
        Provide.value<CategoryFoodsListProvide>(context).foodsList=[];
      }

    });
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    print("categorylist:${categoryList.length}");
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
          '全部菜品',
          style: TextStyle(color: Colors.black,
    fontSize: ScreenUtil().setSp(40),
    fontWeight:FontWeight.w500),
    ),
    backgroundColor: Colors.transparent,
    elevation: 0.0,
      ),
      body: Container(
        child: categoryList.length>0?Row(
          children: <Widget>[
            LeftCategoryNav(),
            Column(
              children: <Widget>[
                RightCategoryNav(),
                CategoryFoodsList()
              ],
            )
          ],
        ):buildEmpty(),
      ),
    );
  }

  Widget buildEmpty() {
    return Container(
      width: double.infinity, //宽度为无穷大
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
}
