import 'package:flutter/material.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'dart:convert';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_canteen/model/category.dart';
import 'package:flutter_canteen/model/categoryFoodsList.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import 'package:flutter_canteen/provide/child_category.dart';
import 'package:flutter_canteen/provide/category_foods_list.dart';
import 'package:flutter_canteen/router/application.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/pages/detailPages/dishdetail.dart';
import 'package:flutter_canteen/pages/photo_view_page/photo_view_page.dart';



//左侧大类导航
class LeftCategoryNav extends StatefulWidget {
  @override
  LeftCategoryNavState createState() => LeftCategoryNavState();
}

class LeftCategoryNavState extends State<LeftCategoryNav> {
  var listIndex = 0; //索引
  bool firstload=true;
  static List<CategoryBigModelDataSecondaryCategoryList> childLists;
  static List<CategoryFoodsListModelDataFoodInfoList> foodsLists;

  @override
  void initState(){
    super.initState();
  }

  Widget build(BuildContext context) {

    return Provide<ChildCategory>(
      builder: (context,child,val){listIndex=val.categoryIndex;
        return Container(
          width: ScreenUtil().setSp(150),
          decoration: BoxDecoration(
              border: Border(right: BorderSide(width: 1, color: Colors.black12))),
          child: ListView.builder(
            itemCount: categoryList.length,
            itemBuilder: (context, index) {
              return _leftInkWel(index);
            },
          ),
        );
      },
    );
  }

  Widget _leftInkWel(int index) {
    bool isClick=false;
    isClick=(index==listIndex)?true:false;

    return InkWell(
      onTap: () {
        var childList = categoryList[index].secondaryCategoryList;
        if(childList.length>0) {
          var categoryId = categoryList[index].secondaryCategoryList[0].categoryId;
          Provide.value<ChildCategory>(context).changeCategory(
              categoryId, index);
          Provide.value<ChildCategory>(context).getChildCategory(
              childList, categoryId);
          getFoodList(context, categoryId);
        } else {
            childLists = Provide.value<ChildCategory>(context).childCategoryList;
            foodsLists = Provide.value<CategoryFoodsListProvide>(context).foodsList;
            //清空子类
            Provide.value<ChildCategory>(context).childCategoryList=[];
            //清空商品列表
            Provide.value<CategoryFoodsListProvide>(context).foodsList=[];

            Fluttertoast.showToast(
                msg: "该分类暂无菜品",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIos: floaststaytime,
                backgroundColor:Theme.of(context).primaryColor,
                textColor: Colors.white,
                fontSize: 16.0
            );
            setState(() {

            });
          }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: BoxDecoration(
            color: !isClick?  Color(0xFFF6F6F6):Colors.white,
        ),
        child: Text(
          categoryList[index].primaryCategoryName,
          style: TextStyle(fontSize: ScreenUtil().setSp(28),color: !isClick?Colors.black:Theme.of(context).primaryColor),
        ),
      ),
    );
  }

  //得到商品列表数据
  static void getFoodList(BuildContext context,String categoryId ) async{
    var data={
      'canteen_id':canteenID,
      'category':categoryId,
      'dish_id':null
    };
    /*if(Provide.value<ChildCategory>(context).subId.trim().length==0||Provide.value<ChildCategory>(context).subId==null)
      data={
        'canteen_id':canteenID,
        'category':null,
        'dish_id':null
      };*/

    await request('getFoodDish', '', formData: data).then((val) {
      if(val.toString()=="false") {
        return;
      }
      var data = val;
      if (data != null) {
        CategoryFoodsListModel foodsList = CategoryFoodsListModel.fromJson(data);
        Provide.value<CategoryFoodsListProvide>(context).getFoodsList(foodsList.data.foodInfoList);
      }
    });
  }
}


//右侧小类类别
class RightCategoryNav extends StatefulWidget {
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {

  int length;

  @override
  Widget build(BuildContext context) {
    return Container(
      // child: Text('${childCategory.childCategoryList.length}'),

        child: Provide<ChildCategory>(
          builder: (context, child, childCategory) {
            if(childCategory.childCategoryList!=null&&childCategory.childCategoryList.length>0){
              categoryBigModelDataSecondaryCategoryId = childCategory.childCategoryList[0].categoryId;
              length = childCategory.childCategoryList.length;
            }else{
              childCategory.childCategoryList = LeftCategoryNavState.childLists;
              Provide.value<CategoryFoodsListProvide>(context).foodsList = LeftCategoryNavState.foodsLists;
             }
            return Container(
                height: ScreenUtil().setSp(64),
                width: ScreenUtil().setSp(530),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,

                  itemCount: childCategory.childCategoryList==null?0:childCategory.childCategoryList.length,
                  itemBuilder: (context, index) {
                    return _rightInkWell(
                        index, childCategory.childCategoryList[index]);
                  },
                )
            );
          },
        )
    );
  }

  Widget _rightInkWell(int index, CategoryBigModelDataSecondaryCategoryList item) {
    bool isCheck = false;
    isCheck = (index == Provide
        .value<ChildCategory>(context)
        .childIndex) ? true : false;

    return InkWell(
      onTap: () {
        categoryBigModelDataSecondaryCategoryId = item.categoryId;
        categoryIndex = length-index-1;
        Provide.value<ChildCategory>(context).changeChildIndex(
            index, item.categoryId);
        _getFoodList(context, item.categoryId);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
         alignment: Alignment.center,
        child: Text(
          item.categoryName,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(28),
              color: isCheck ? Theme.of(context).primaryColor : Colors.black),
        ),
      ),
    );
  }

  //得到商品列表数据
  void _getFoodList(context,String categorySubId) {

    var data={
      'canteen_id':canteenID,
      'category':categorySubId,
      'dish_id':null
    };
    /*if(categorySubId.trim().length==0||categorySubId==null)
      data={
        'canteen_id':canteenID,
        'category':null,
        'dish_id':null
      };*/

    request('getFoodDish', '',formData:data ).then((val){
      if(val.toString()=="false")
      {
        return;
      }
      var  data = val;
      CategoryFoodsListModel foodsList=  CategoryFoodsListModel.fromJson(data);
      Provide.value<CategoryFoodsListProvide>(context).getFoodsList(foodsList.data.foodInfoList);
    });
  }
}


class CategoryFoodsList extends StatefulWidget {
  @override
  _CategoryFoodsListState createState() => _CategoryFoodsListState();
}

class _CategoryFoodsListState extends State<CategoryFoodsList> {

  GlobalKey<EasyRefreshState> _easyRefreshKey =new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();
  var scrollController=new ScrollController();



  @override
  Widget build(BuildContext context) {
    return Provide<CategoryFoodsListProvide>(
      builder: (context,child,data){
        try{
          if(Provide.value<ChildCategory>(context).page==1){
            if (scrollController.hasClients) {
               scrollController.animateTo(
                0.0,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300),
              );
            }
          }
        }catch(e){
          print('进入页面第一次初始化：${e}');
        }

        if(data.foodsList != null){
          return Expanded(
            child:Container(
                width: ScreenUtil().setSp(570) ,
                child:EasyRefresh(
                  refreshFooter: ClassicsFooter(
                      key:_footerKey,
                      bgColor:Colors.white,
                      textColor:Colors.pink,
                      moreInfoColor: Colors.pink,
                      showMore:true,
                      noMoreText:Provide.value<ChildCategory>(context).noMoreText,
                      moreInfo:'加载中',
                      loadReadyText:'上拉加载'
                  ),
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: data.foodsList.length,
                    itemBuilder: (context,index){
                      return _ListWidget(data.foodsList,index);
                    },
                  ) ,
                  loadMore: ()async{
                    if(Provide.value<ChildCategory>(context).noMoreText=='没有更多了'){
                      Fluttertoast.showToast(
                          msg: "已经到底了",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIos: floaststaytime,
                          backgroundColor: Colors.pink,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }else{

                     // _getMoreList();
                    }

                  },
                )

            ) ,
          );
        }else{
          return  Text('暂时没有数据');
        }
      },

    );
  }


  Widget _ListWidget(List newList,int index){

    return InkWell(
        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailsPage(newList[index].dishId.toString())));
          //Appliaction.router.navigateTo(context,"/detail?id=${newList[index].dishId}");
        },
        child: Container(
          padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
          decoration: BoxDecoration(
              color: Colors.white,
          ),

          child: Row(
            children: <Widget>[
              newList[index].dishPhoto[0]!=staticimageurl?_foodsImage(newList,index):_nullImage(),
              Column(
                children: <Widget>[
                  _foodsName(newList,index),
                  _foodsPrice(newList,index)
                ],
              )
            ],
          ),
        )
    );

  }

  //没有图片
  Widget _nullImage(){
    return Container(
        width: ScreenUtil().setSp(200),
        child: Column(
          children: <Widget>[
            Icon(Icons.image,color: Colors.black26,size: ScreenUtil().setSp(80),),
            Container(
              child: Text("暂无图片",style: TextStyle(color:Colors.black26,fontWeight:FontWeight.w500,fontSize: ScreenUtil().setSp(28)),),
              height: ScreenUtil().setSp(40),
            )
          ],
        )
    );
  }

  //商品图片
  Widget _foodsImage(List newList,int index){

    return  InkWell(
        onTap: (){
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PhotoViewSimpleScreen(imageProvider: NetworkImage(newList[index].dishPhoto[0]),heroTag: "",)));
      //Appliaction.router.navigateTo(context,"/detail?id=${newList[index].dishId}");
    },
    child:Container(
      width: ScreenUtil().setSp(200),
      child:ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(newList[index].dishPhoto[0],
          height: ScreenUtil().setSp(140), //设置高度
          width: ScreenUtil().setSp(210), //设置宽度
          fit: BoxFit.fill, //填充
          gaplessPlayback: true, //防止重绘),
        ),
      ) ));

  }
  //商品名称方法
  Widget _foodsName(List newList,int index){
    return Container(
      padding: EdgeInsets.all(5.0),
      width: ScreenUtil().setSp(370),
      child: Text(
        newList[index].dishName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
      ),
    );
  }
  //商品价格方法
  Widget _foodsPrice(List newList,int index){
    return  Container(
        margin: EdgeInsets.only(top:20.0),
        width: ScreenUtil().setSp(370),
        child:Row(
            children: <Widget>[
              Text(
                '价格:￥${newList[index].dishPrice}元',
                style: TextStyle(color:Colors.pink,fontSize:ScreenUtil().setSp(30)),
              ),
            ]
        )
    );
  }


}



