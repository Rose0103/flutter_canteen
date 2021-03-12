import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_canteen/model/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_canteen/pages/categoryPage/categorypage.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_canteen/model/categoryFoodsList.dart';
import 'package:provide/provide.dart';
import 'package:flutter_canteen/provide/child_category.dart';
import 'package:flutter_canteen/provide/category_foods_list.dart';
import 'package:flutter_canteen/provide/menu_data.dart';
import 'package:flutter_canteen/provide/foodMenuRelease.dart';
import 'package:flutter_canteen/router/application.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/model/menu_data.dart';
import 'package:flutter_canteen/pages/photo_view_page/photo_view_page.dart';
import 'package:flutter_canteen/otherfunction/showDialog.dart';

//发布菜单
class PublishCaiPinPage extends StatefulWidget {
  final String functionID;

  PublishCaiPinPage(this.functionID);

  @override
  _PublishCaiPinPageState createState() => _PublishCaiPinPageState();
}

class _PublishCaiPinPageState extends State<PublishCaiPinPage> {
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();
  var scrollController = new ScrollController();
  TextEditingController _foodnameController = TextEditingController();

  int groupValue = 1;
  @override
  var _chooseDate = DateTime.now().toString().split(" ")[0];

  var _currentDate = DateTime.now();

  MenuData caidanitems = null;
  DateTime lastPopTime=null;



  void initState() {
    super.initState();
    //modify by gaoyang 2020-11-24  菜品发布，开始进入无数据（是没调接口）
    _getCategory();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provide.value<MenuDataProvide>(context).getBaoCanMenuFoodsInfo(
          canteenID, _chooseDate.toString(), groupValue - 1, 1);
      if (_currentDate.hour > 20 && _currentDate.hour < 9)
        groupValue = 1;
      else if (_currentDate.hour > 9 && _currentDate.hour < 12)
        groupValue = 2;
      else if (_currentDate.hour > 12 && _currentDate.hour < 20) groupValue = 3;
      Future.delayed(Duration(seconds: 0), () {
        setState(() {
          caidanitems = Provide.value<MenuDataProvide>(context).menudata;
        });
      });
    });
  }

  //modify by gaoyang 2020-11-24   调用全部菜品的接口
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
      print(canteenlist.length);
      if(categoryList==null||categoryList.length==0){
        return;
      }

      if(categoryList[0].secondaryCategoryList.length>0){
      Provide.value<ChildCategory>(context).changeCategory(categoryList[0].secondaryCategoryList[0].categoryId, 0);
      LeftCategoryNavState.getFoodList(context,categoryList[0].secondaryCategoryList[0].categoryId);
      Provide.value<ChildCategory>(context).getChildCategory( categoryList[0].secondaryCategoryList,categoryList[0].secondaryCategoryList[0].categoryId);
      }else{
        //清空子类
        Provide.value<ChildCategory>(context).childCategoryList = [];
        //清空商品列表
        Provide.value<CategoryFoodsListProvide>(context).foodsList = [];
      }
      setState(() {});
    });
  }


  _showDatePicker() async {
    var date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().add(new Duration(days: -1)),
        lastDate: DateTime.now().add(new Duration(days: 14)),
        locale: Locale('zh'));
    if (date == null) {
      return;
    }
    if (!_currentDate.isAtSameMomentAs(date)) {
      _currentDate = date;
      updateGroupValue(_currentDate.toString().split(" ")[0], groupValue);
      setState(() {
        this._chooseDate = _currentDate.toString().split(" ")[0];
      });
    }
  }

  void _theDayBefor() {
    var _tempDate = _currentDate;
    _tempDate = _tempDate.add(new Duration(days: -1));
    if ((_tempDate.isAfter(DateTime.now().add(new Duration(days: -1))) ||
            _tempDate.isAtSameMomentAs(
                DateTime.now().add(new Duration(days: -1)))) &&
        (_tempDate.isBefore(DateTime.now().add(new Duration(days: 14))) ||
            _tempDate.isAtSameMomentAs(
                DateTime.now().add(new Duration(days: -1))))) {
      _currentDate = _tempDate;
      updateGroupValue(_currentDate.toString().split(" ")[0], groupValue);
      setState(() {
        this._chooseDate = _currentDate.toString().split(" ")[0];
      });
    }
  }

  void _theDayAfter() {
    var _tempDate = _currentDate;
    _tempDate = _tempDate.add(new Duration(days: 1));
    if ((_tempDate.isAfter(DateTime.now().add(new Duration(days: -1))) ||
            _tempDate.isAtSameMomentAs(
                DateTime.now().add(new Duration(days: -1)))) &&
        (_tempDate.isBefore(DateTime.now().add(new Duration(days: 14))) ||
            _tempDate.isAtSameMomentAs(
                DateTime.now().add(new Duration(days: -1))))) {
      _currentDate = _tempDate;
      updateGroupValue(_currentDate.toString().split(" ")[0], groupValue);
      setState(() {
        this._chooseDate = _currentDate.toString().split(" ")[0];
      });
    }
  }

  //前一天按钮
  Widget theDayBeforeButton() {
    return Container(
      width: ScreenUtil.getInstance().setSp(200),
      height: ScreenUtil.getInstance().setSp(68),
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
            image: AssetImage("assets/images/btn_qianyt_default.png"),
            fit: BoxFit.fill),
      ),
      alignment: Alignment.center,
      child: FlatButton(
        onPressed: _theDayBefor,
        child: Text("< 前一天"),
        color: Colors.transparent,
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0)), side: BorderSide(color: Colors.white, style: BorderStyle.solid, width: 21)),
      ),
    );
  }

  //后一天按钮
  Widget theDayAfterButton() {
    return Container(
      width: ScreenUtil.getInstance().setSp(200),
      height: ScreenUtil.getInstance().setSp(68),
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
            image: AssetImage("assets/images/btn_houyt_default.png"),
            fit: BoxFit.fill),
      ),
      alignment: Alignment.center,
      child: FlatButton(
        onPressed: _theDayAfter,
        child: Text("后一天 >"),
        color: Colors.transparent,
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0)), side: BorderSide(color: Colors.white, style: BorderStyle.solid, width: 21)),
      ),
    );
  }

  //时间选择按钮
  Widget timeChoseButton(BuildContext context) {
    return Container(
      width: ScreenUtil.getInstance().setSp(300),
      height: ScreenUtil.getInstance().setSp(60),
      decoration: BoxDecoration(
        border: Border.all(width: 2.0, color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      alignment: Alignment.center,
      child: FlatButton(
        child: Text(_chooseDate.toString()),
        color: Colors.transparent,
        onPressed: _showDatePicker,
      ),
    );
  }

  //时间控件
  Widget timeChoseWidget(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: ScreenUtil.getInstance().setSp(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            theDayBeforeButton(),
            timeChoseButton(context),
            theDayAfterButton(),
          ],
        ));
  }

  Widget _mealTimeChoseWidget() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: RadioListTile(
                  value: 1,
                  groupValue: groupValue,
                  activeColor: Theme.of(context).primaryColor,
                  title: Text('早餐'),
                  onChanged: (T) {
                    updateGroupValue(_currentDate.toString().split(" ")[0], T);
                  })),
          Expanded(
              child: RadioListTile(
                  value: 2,
                  groupValue: groupValue,
                  activeColor: Theme.of(context).primaryColor,
                  title: Text('中餐'),
                  onChanged: (T) {
                    updateGroupValue(_currentDate.toString().split(" ")[0], T);
                  })),
          Expanded(
              child: RadioListTile(
                  value: 3,
                  groupValue: groupValue,
                  activeColor: Theme.of(context).primaryColor,
                  title: Text('晚餐'),
                  onChanged: (T) {
                    updateGroupValue(_currentDate.toString().split(" ")[0], T);
                  })),
        ],
      ),
    );
  }

  updateGroupValue(String time, int v) async {
    if(lastPopTime == null || DateTime.now().difference(lastPopTime) > Duration(milliseconds: 300)) {
      lastPopTime = DateTime.now();
      await Provide.value<MenuDataProvide>(context)
          .getBaoCanMenuFoodsInfo(canteenID, time, v-1, 1);
      caidanitems = Provide.value<MenuDataProvide>(context).menudata;
      setState(() {
        groupValue = v;
      });
    }else{
      lastPopTime = DateTime.now();
      showMessage(context,"请勿重复点击！");
      return;
    }
  }

  Widget _caiDanlistView() {
    if (caidanitems != null &&
        caidanitems.data != null &&
        caidanitems.data.menuInfo != null) {
      return Container(
          height: ScreenUtil().setSp(800),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: caidanitems.data.menuInfo.length,
            itemBuilder: (context, index) {
              var descIndex = caidanitems.data.menuInfo.length - 1 - index;
              final item =
                  caidanitems.data.menuInfo[descIndex].dishName + '$descIndex';
              return Dismissible(
                  onDismissed: (_) {
                    //参数暂时没有用到，则用下划线表示
                    setState(() {
                      String caipin =
                          caidanitems.data.menuInfo[descIndex].dishName;
                      caidanitems.data.menuInfo.removeAt(descIndex);
                    });
                  }, // 监听
                  movementDuration: Duration(milliseconds: 100),
                  key: Key(item),
                  child: Column(children: <Widget>[
                    Container(
                      height: ScreenUtil().setSp(160.0),
                      //modify by gaoyang 2020-11-24   详情样式
                      padding: EdgeInsets.only(left: 20.0),
                      child: Row(
                        children: <Widget>[
//                          _foodsImage(caidanitems.data.menuInfo, descIndex),
                          //modify by gaoyang 2020-11-25 菜品图片移动了位置
                          caidanitems.data.menuInfo[descIndex].dishPhoto[0]!=null&&caidanitems.data.menuInfo[descIndex].dishPhoto[0]!=staticimageurl?_foodsImage(caidanitems.data.menuInfo,descIndex):_nullImage(),
                          //modify by gaoyang 2020-11-24  详情样式调节
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: _foodsName(
                                caidanitems.data.menuInfo, descIndex),
                          ),
                          //modify by gaoyang 2020-11-24  菜品详情价格
                          _foodsPrice(caidanitems.data.menuInfo,descIndex),
                        ],
                      ),
                    ),
                    Divider(
                      height: 4.0,
                      indent: 0.0,
                      color: Colors.red,
                    ),
                  ]));
            },
          ));
    } else {
      return Text('暂时没有数据');
    }
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


  //商品价格方法
  Widget _foodsPrice(List newList, int index) {
    return Container(
        margin: EdgeInsets.fromLTRB(ScreenUtil().setSp(20), 0, 0, 0),
        padding: EdgeInsets.all(ScreenUtil().setSp(1)),
        child:Text(
          '价格:￥${newList[index].dishPrice}元',
          textAlign: TextAlign.right,
          style:
              TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(30)),
        ),);
  }

  Widget _buttonsWidget(BuildContext context) {
      return Container(
          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Badge(
                    showBadge: caidanitems == null ||
                        caidanitems.data == null ||
                        caidanitems.data.menuInfo.length.toString() == "0"
                        ? false
                        : true,
                    position: BadgePosition.topRight(
                        top: -12, right: ScreenUtil().setSp(0)),
                    badgeColor: Colors.red,
                    badgeContent: Text(
                      caidanitems == null ||
                          caidanitems.data.menuInfo.length.toString() == "0"
                          ? ""
                          : caidanitems.data.menuInfo.length.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    animationType: BadgeAnimationType.slide,
                    child: Container(
                      height: ScreenUtil().setSp(80.0),
                      width: ScreenUtil().setSp(250.0),
                      child: RaisedButton(
                        onPressed: () {
                          _showModalBottomSheet(context);
                        },
                        //tooltip: '详情',
                        child: caidanitems == null
                            ? Text('详情')
                            : caidanitems.data == null
                            ? Text('详情')
                            : Text('详情'),

                        color: Colors.orange,
                        shape: StadiumBorder(),
                      ),
                    )),

                Container(
                    height: ScreenUtil().setSp(80.0),
                    width: ScreenUtil().setSp(250.0),
                    padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                    child: RaisedButton(
                      onPressed: () async {
                        if(usertype=="3"){
                          showMessage(context, "您没有权限");
                          return;
                        }
                        if(lastPopTime == null || DateTime.now().difference(lastPopTime) > Duration(seconds: 0)) {
                          lastPopTime = DateTime.now();
                          await _foodMenuRelease();
                        }else{
                          lastPopTime = DateTime.now();
                          showMessage(context,"请勿重复点击！");
                          return;
                        }
                      },
                      child: Text('确认发布'),
                      color: Colors.orange,
                      shape: StadiumBorder(),
                    )),
              ]));
  }

  _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
            child: Container(
                child: Column(
                  children: <Widget>[
                    gobackButton(context),
                    _caiDanlistView(),
                  ],
                )));
      },
    );
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
          '菜单发布',
          style: TextStyle(color: Colors.black,
              fontSize: ScreenUtil().setSp(40),
              fontWeight:FontWeight.w500),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 触摸收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
            child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 5.0),
          child: Column(
            children: <Widget>[
           timeChoseWidget(context),
          _mealTimeChoseWidget(),
              searchFoodNameWidget(),
              Container(
               // width: ScreenUtil().setSp(680),
                child: Row(
                  children: <Widget>[
                    LeftCategoryNav(),
                    Column(
                      children: <Widget>[
//                      gobackButton(context),
                        Container(
                          width: ScreenUtil().setSp(500),
                          child: RightCategoryNav(),
                        ),
                        dishsList(),
                      ],
                    )
                  ],
                ),
                height: MediaQuery.of(context).size.height*0.55,
              ),
              _buttonsWidget(context)
            ],
          ),
        )),
      ),
    );
  }

  Widget dishsList() {
    return Provide<CategoryFoodsListProvide>(
      builder: (context, child, data) {
        try {
          if (Provide.value<ChildCategory>(context).page == 1) {
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

        if (data.foodsList != null) {
          return Expanded(
            child: Container(
                width: ScreenUtil().setSp(500),
                child: EasyRefresh(
                  refreshFooter: ClassicsFooter(
                      key: _footerKey,
                      bgColor: Colors.white,
                      textColor: Colors.pink,
                      moreInfoColor: Colors.pink,
                      showMore: true,
                      noMoreText:
                          Provide.value<ChildCategory>(context).noMoreText,
                      moreInfo: '加载中',
                      loadReadyText: '上拉加载'),
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: data.foodsList.length,
                    itemBuilder: (context, index) {
                      return _ListWidget(data.foodsList, index);
                    },
                  ),
                  loadMore: () async {
                    if (Provide.value<ChildCategory>(context).noMoreText ==
                        '没有更多了') {
                      showMessage(context,"已经到底了");
                    } else {
                      // _getMoreList();
                    }
                  },
                )),
          );
        } else {
          return Text('暂时没有数据');
        }
      },
    );
  }



  Widget _ListWidget(List newList, int index) {
    return InkWell(
        onTap: () {
          String caipin = newList[index].dishName;
          bool iscontain = false;
          if(caidanitems!=null||caidanitems.data!=null) {
            for (int i = 0; i < caidanitems.data.menuInfo.length; i++) {
              if (caidanitems.data.menuInfo[i].dishName == caipin) {
                iscontain = true;
                break;
              }
            }
          }
          if (!iscontain) {
            MenuDataDataMenuInfo menuItem = new MenuDataDataMenuInfo(
                dishPhoto: newList[index].dishPhoto,
                dishPrice: newList[index].dishPrice,
                dishScore: newList[index].dishScore,
                dishName: newList[index].dishName,
                dishId: newList[index].dishId);
            setState(() {
              caidanitems.data.menuInfo.add(menuItem);
            });
          }
        },
        child: Container(
          padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            children: <Widget>[
              newList[index].dishPhoto[0]!=staticimageurl?_foodsImage(newList,index):_nullImage(),
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setSp(10)),
                width: ScreenUtil().setSp(270),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setSp(270),
                      child: _foodsName(newList,index),
                    ),
                    Container(
                      width: ScreenUtil().setSp(270),
                      child: _foodsPrice(newList,index),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  //商品图片
  Widget _foodsImage(List newList, int index) {
    if (!newList[index].dishPhoto[0].toString().contains("http")) {
      newList[index].dishPhoto[0] =
          "http://$resourceUrl/" + newList[index].dishPhoto[0];
    }
    return  InkWell(
        onTap: (){
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PhotoViewSimpleScreen(imageProvider: NetworkImage(newList[index].dishPhoto[0]),heroTag: "",)));
      //Appliaction.router.navigateTo(context,"/detail?id=${newList[index].dishId}");
    },child:Container(
        width: ScreenUtil().setSp(220),
        child: Image.network(newList[index].dishPhoto[0],
          height: ScreenUtil().setSp(140), //设置高度
          fit: BoxFit.fill, //填充
          gaplessPlayback: true, //防止重绘),
        )));
  }

  //商品名称方法
  Widget _foodsName(List newList, int index) {
    return Text(
        newList[index].dishName,
        textAlign: TextAlign.right,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
      );
  }

  Widget gobackButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,

        child: Text("<<返回",
            style: TextStyle(color: Theme.of(context).primaryColor)),
      ),
    );
  }

  //发布菜单
  Future _foodMenuRelease() async {
    List<int> dish_id = new List();
    if(caidanitems.data.menuInfo.length==0){
      showMessage(context,"请选择至少一种菜品");
    }else{
      for (int i = 0; i < caidanitems.data.menuInfo.length; i++) {
        dish_id.add(caidanitems.data.menuInfo[i].dishId);
      }
      await Provide.value<FoodMenuReleaseProvide>(context).postFoodMenuInfo(
          canteenID, _chooseDate.toString(), groupValue-1, dish_id);
      showMessage(context,"菜单发布成功");
      return '完成加载';
    }
  }

  Widget searchFoodNameWidget() {
    return Container(
       child: Padding(
         padding: EdgeInsets.only(top: ScreenUtil().setSp(5.0)),
         child: Container(
           height: 68.0,
           child: Row(
             children: <Widget>[
               new Padding(
                   padding: const EdgeInsets.all(6.0),
                   child: new Card(
                       child: new Container(
                         width: ScreenUtil().setSp(650),
                         child: new Row(
                           children: <Widget>[
                             SizedBox(width: 10.0,),
                             Icon(Icons.search, color: Colors.grey,),
                             Expanded(
                               child: Container(
                                 alignment: Alignment.center,
                                 child: TextField(
                                   maxLength:20,
                                   controller: _foodnameController,
                                   style: TextStyle(fontSize: ScreenUtil().setSp(30.0)),
                                   decoration: new InputDecoration(
                                       contentPadding: EdgeInsets.only(top: 0.0),
                                       hintText: '搜索菜品名', border: InputBorder.none),
                                   onChanged:(v) async{
                                     print(v);
                                     print(v.trim().length);
                                     if(v.trim().length > 0){
                                       bool isok =  await _getFoodListByName(
                                        context, _foodnameController.text.trim());
                                    print(isok);
                                    if(!isok){
                                      return showMessage(context,"没有找到该菜品，可以在菜品管理中添加" );
                                    }
                                    else{
                                        setState(() {
                                        });
                                    }
                                  }
                                else {
                                  var childList = categoryList[0].secondaryCategoryList;
                                  if (childList.length > 0) {
                                    var categoryId = categoryList[0].secondaryCategoryList[0]
                                        .categoryId;
                                    Provide.value<ChildCategory>(context).changeCategory(
                                        categoryId, 0);
                                    Provide.value<ChildCategory>(context).getChildCategory(
                                        childList, categoryId);
                                    getFoodList(context, categoryId);
                                  }
                                  setState(() {
                                  });
                                }
                                   }
                                 ),
                               ),
                             ),
                             new IconButton(
                               icon: new Icon(Icons.cancel),
                               color: Colors.grey,
                               iconSize: 18.0,
                               onPressed: () {
                                  _foodnameController.clear();
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  var childList = categoryList[0].secondaryCategoryList;
                                  if (childList.length > 0) {
                                    var categoryId = categoryList[0].secondaryCategoryList[0]
                                        .categoryId;
                                    Provide.value<ChildCategory>(context).changeCategory(
                                        categoryId, 0);
                                    Provide.value<ChildCategory>(context).getChildCategory(
                                        childList, categoryId);
                                    getFoodList(context, categoryId);
                                  }
                                  setState(() {
                                  });
                               },
                             ),
                           ],
                         ),
                       )
                   )
               ),
             ],
           ),
         ),
       ),
//        child: TextFormField(
//            autofocus: false,
//            maxLength: 20,
//            controller: _foodnameController,
//            decoration: InputDecoration(
//              enabledBorder: outlineborders(Colors.grey),
//              focusedBorder: outlineborders(Theme.of(context).primaryColor),
//              errorBorder: outlineborders(Theme.of(context).primaryColor),
//              focusedErrorBorder:outlineborders(Theme.of(context).primaryColor),
//              fillColor: Theme.of(context).primaryColor,
//              hintStyle: TextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(30.0)),
//              errorStyle:TextStyle(color: Theme.of(context).primaryColor, fontSize: ScreenUtil().setSp(20.0)),
//              //labelText: '手机号码登录',
//              hintText: '搜索菜品名',
//              icon: Icon(Icons.search,color: Theme.of(context).primaryColor),
//              border: OutlineInputBorder(),
//              suffixIcon: GestureDetector(
//                  onTap: () {
//                    _foodnameController.text="";
//                  },
//                  child: Icon(
//                    Icons.clear,
//                    color: Colors.black26,
//                  )
//              ),
//            ),
//            onChanged: (v) async{
//              print("来了");
//              print(v);
//              print(v.trim().length);
//              if (v.trim().length > 0) {
//                print("wwwww");
//                bool isok =  await _getFoodListByName(
////                    context, _foodnameController.text.trim());
////                print(isok);
////                if(!isok){
////                  return showMessage(context,"没有找到该菜品，可以在菜品管理中添加" );
////                }
////                else{
////                    setState(() {
////                    });
////                }
////              }
//              else {
//                var childList = categoryList[0].secondaryCategoryList;
//                if (childList.length > 0) {
//                  var categoryId = categoryList[0].secondaryCategoryList[0]
//                      .categoryId;
//                  Provide.value<ChildCategory>(context).changeCategory(
//                      categoryId, 0);
//                  Provide.value<ChildCategory>(context).getChildCategory(
//                      childList, categoryId);
//                  getFoodList(context, categoryId);
//                }
//                setState(() {
//                });
//              }
//            }
//        )
    );
  }


  Future<bool> _getFoodListByName(context,String foodNname) async{

    var data={
      'canteen_id':canteenID,
      'category':null,
      'dish_id':null,
      'dish_name':foodNname
    };
    bool b = false;
    await request('getFoodDish', '',formData:data ).then((val){
      if(val.toString()=="false")
      {
        return false;
      }
      var  data = val;
      CategoryFoodsListModel foodsList=  CategoryFoodsListModel.fromJson(data);
      if(foodsList!=null&&foodsList.data!=null&&foodsList.data.foodInfoList.length>0) {
        Provide.value<CategoryFoodsListProvide>(context).getFoodsList(
            foodsList.data.foodInfoList);
        b = true;
      }
    });
    return b;
  }

  //得到商品列表数据
  static void getFoodList(BuildContext context,String categoryId ) async{
    var data={
      'canteen_id':canteenID,
      'category':categoryId,
      'dish_id':null
    };

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
