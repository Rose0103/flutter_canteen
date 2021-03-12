import 'package:flutter/material.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_canteen/model/category.dart';
import 'package:dio/dio.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_canteen/model/categoryFoodsList.dart';
import 'dart:convert';

class manageCategoryPage extends StatefulWidget {
  @override
  _manageCategoryPageState createState() => _manageCategoryPageState();
}

class _manageCategoryPageState extends State<manageCategoryPage> {
  List<CategoryBigModelData> list = [];
  CategoryFoodsListModel foodsList=null;
  int secondIndex = 0;
  var lastIndex = 0; //索引
  var foodlistIndex=0;
  bool isdeleteOraddok=false;

  final SlidableController primaryslidableController = SlidableController();
  final SlidableController secondslidableController = SlidableController();
  final SlidableController foodlistController = SlidableController();
  TextEditingController _primarayTextController = TextEditingController();
  TextEditingController _secondTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCategory();
    });
  }

  @override
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
                Navigator.pop(context);
              }),
          centerTitle: true,
          title: Text(
            '菜品分类管理',
            style: TextStyle(color: Colors.black,
                fontSize: ScreenUtil().setSp(40),
                fontWeight:FontWeight.w500),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil.getInstance().setSp(20.0),
                    ScreenUtil.getInstance().setSp(0.0),
                    ScreenUtil.getInstance().setSp(20.0),
                    0.0),
                child: Column(children: <Widget>[
                  Container(
                    child: Text("左滑删除类别"),
                  ),
                  SizedBox(height: 30.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //左边的主分类
                      Column(children: <Widget>[
                        Text("添加主分类"),
                        primaryAddIcon(),
                        _primaryCateGorylistView(),

                      ]),

                      Icon(Icons.arrow_forward_ios),
                      //右边的子分类
                      Column(children: <Widget>[
                        Text("添加子分类"),
                        secondAddIcon(),
                        _secondCateGorylistView(),
                      ])
                    ],
                  ),
                ]))));
  }

  void _getCategory() async {
    var data = {'canteen_id': canteenID};

    await requestGet('Category', '?canteen_id=$canteenID').then((val) {
      if (val.toString() == "false") {
        return;
      }
      CategoryBigModel category = CategoryBigModel.fromJson(val);
      if(category.code=="0"){
        setState(() {
          list = category.data;
        });
      }
    });
  }

  _primaryshowSnackBar(String val, int idx) {
    setState(() {
      list.removeAt(idx);
    });
  }

  _secondshowSnackBar(String val, int idx) {
    setState(() {
      list[secondIndex]
          .secondaryCategoryList.removeAt(idx);
    });
  }

  _showSnack(BuildContext context, type) {
  }

  //主菜品栏
  Widget _primaryCateGorylistView() {
    if (list.length > 0) {
      return Container(
          height: ScreenUtil().setSp(800),
          width: ScreenUtil().setSp(300),
          padding: EdgeInsets.fromLTRB(
              ScreenUtil.getInstance().setSp(20.0),
              ScreenUtil.getInstance().setSp(0.0),
              ScreenUtil.getInstance().setSp(20.0),
              0.0),
          decoration: new BoxDecoration(
            border: new Border.all(color: Colors.grey, width: 0.5),
            borderRadius: new BorderRadius.circular((10.0)), // 圆角度
            boxShadow: [BoxShadow(color: Colors.white)],
          ),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, index) {
                var descIndex = list.length - 1 - index;
                final item = list[descIndex].primaryCategoryName + '$descIndex';
                bool isClick = false;
                isClick = (secondIndex == descIndex) ? true : false;
                return Slidable(
                  key: Key(descIndex.toString()),
                  controller: primaryslidableController,
                  actionPane: SlidableScrollActionPane(),
                  // 侧滑菜单出现方式 SlidableScrollActionPane SlidableDrawerActionPane SlidableStrechActionPane
                  actionExtentRatio: 0.0,
                  // 侧滑按钮所占的宽度
                  enabled: true,
                  // 是否启用侧滑 默认启用
                  dismissal: SlidableDismissal(
                    child: SlidableDrawerDismissal(),
                    onDismissed: (actionType) {
                      _showSnack(
                          context,
                          actionType == SlideActionType.primary
                              ? 'Dismiss Archive'
                              : 'Dimiss Delete');
                      setState(() {
                        descIndex-1>0?secondIndex = descIndex-1:secondIndex=0;
                        list.removeAt(descIndex);
                      });
                    },
                    onWillDismiss: (actionType) {
                      return showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('删除'),
                            content: Text('删除这条类别？'),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('取消'),
                                onPressed: () => Navigator.of(context).pop(false),
                              ),
                              FlatButton(
                                child: Text('确认'),
                                onPressed: () async{
                                  if(list[descIndex].secondaryCategoryList.length>0){
                                    Fluttertoast.showToast(
                                      msg: "需删除该大类下所有子分类，才可进行操作",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIos: 2,
                                      backgroundColor: Theme.of(context).primaryColor,
                                      textColor: Colors.pink
                                    );
                                    Navigator.of(context).pop(false);
                                    return;
                                  }
                                  isdeleteOraddok=false;
                                  await _deleteCategory(context,list[descIndex].primaryCategoryId,"");
                                  if(isdeleteOraddok) {
                                    Fluttertoast.showToast(
                                      msg: "删除成功",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIos: floaststaytime,
                                      backgroundColor: Theme.of(context).primaryColor,
                                      textColor: Colors.pink
                                    );
                                    Navigator.of(context).pop(true);
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: "网络或服务器错误",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIos: floaststaytime,
                                      backgroundColor: Theme.of(context).primaryColor,
                                      textColor: Colors.pink
                                    );
                                    Navigator.of(context).pop(false);
                                  }
                                }
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          secondIndex = descIndex;
                        });
                      },
                      child: Column(children: <Widget>[
                        Container(
                          height: ScreenUtil().setSp(80.0),
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          decoration: BoxDecoration(
                              color: isClick
                                  ? Color.fromRGBO(236, 160, 139, 1.0)
                                  : Colors.white,
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Colors.black12))),
                          child: isClick
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(list[descIndex].primaryCategoryName,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: ScreenUtil().setSp(28))),
                                    Icon(Icons.arrow_right)
                                  ],
                                )
                              : Text(list[descIndex].primaryCategoryName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                        ),
                        Divider(
                          height: 4.0,
                          indent: 0.0,
                          color: Colors.red,
                        ),
                      ]
                    )
                  ),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: '删除',
                      color: Colors.red,
                      icon: Icons.delete,
                      closeOnTap: false,
                      onTap: () => _primaryshowSnackBar('删除', index),
                    ),
                  ],
                );
              }
            )
      );
    } else {
      return Container(
        height: ScreenUtil().setSp(800),
        width: ScreenUtil().setSp(300),
        decoration: new BoxDecoration(
          border: new Border.all(color: Colors.grey, width: 0.5),
          borderRadius: new BorderRadius.circular((10.0)), // 圆角度
          boxShadow: [BoxShadow(color: Colors.white)],
        ),
        child: Text('暂时没有数据')
      );
    }
  }

  //主菜品添加图标
  Widget primaryAddIcon() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, ScreenUtil().setSp(14), 0),
      child: new GestureDetector(
        child: Container(
          child: Image.asset(
            "assets/images/btn_add_selected.png",
            width: ScreenUtil().setSp(100),
          ),
        ),
        onTap: () async {
          bool result = await addPrimaryCategoryDialog(context);
        },
      )
    );
  }

  //子菜品添加图标
  Widget secondAddIcon() {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 0, ScreenUtil().setSp(14), 0),
        child: new GestureDetector(
          child: Container(
            child: Image.asset(
              "assets/images/btn_add_selected.png",
              width: ScreenUtil().setSp(100),
            ),
          ),
          onTap: () async {
            bool result = await addSecondCategoryDialog(context);
          },
        ));
  }

  //子菜品栏
  Widget _secondCateGorylistView() {
    if (list!=null&&list.length > 0 && list[secondIndex].secondaryCategoryList.length > 0) {
      return Container(
          decoration: new BoxDecoration(
            border: new Border.all(color: Colors.grey, width: 0.5),
            borderRadius: new BorderRadius.circular((10.0)), // 圆角度
            boxShadow: [BoxShadow(color: Colors.white)],
          ),
          padding: EdgeInsets.fromLTRB(
              ScreenUtil.getInstance().setSp(20.0),
              ScreenUtil.getInstance().setSp(0.0),
              ScreenUtil.getInstance().setSp(20.0),
              0.0),
          height: ScreenUtil().setSp(800),
          width: ScreenUtil().setSp(300),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: list[secondIndex].secondaryCategoryList.length,
            itemBuilder: (context, index) {
              var descIndex = list[secondIndex].secondaryCategoryList.length - 1 - index;
//              final item = list[secondIndex]
//                      .secondaryCategoryList[descIndex]
//                      .categoryName + '$descIndex';
              bool isClick = false;
              isClick = (lastIndex == descIndex) ? true : false;
              return Slidable(
                key: Key(descIndex.toString()),
                controller: secondslidableController,
                actionPane: SlidableScrollActionPane(),
                // 侧滑菜单出现方式 SlidableScrollActionPane SlidableDrawerActionPane SlidableStrechActionPane
                actionExtentRatio: 0.0,
                // 侧滑按钮所占的宽度
                enabled: true,
                // 是否启用侧滑 默认启用
                dismissal: SlidableDismissal(
                  child: SlidableDrawerDismissal(),
                  onDismissed: (actionType) {
                    _showSnack(context,
                      actionType == SlideActionType.primary?'Dismiss Archive':'Dimiss Delete');
                    setState(() {
                      descIndex-1>0?lastIndex = descIndex-1:lastIndex=0;
                      list[secondIndex].secondaryCategoryList.removeAt(descIndex);
                    });
                  },
                  onWillDismiss: (actionType) {
                    return showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('删除'),
                          content: Text('删除这条类别？'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('取消'),
                              onPressed: () => Navigator.of(context).pop(false),
                            ),
                            FlatButton(
                              child: Text('确认'),
                              onPressed: () async{
                                await _getFoodList(context,list[secondIndex]
                                     .secondaryCategoryList[descIndex].categoryId);
                                if(foodsList!=null&&foodsList.data.foodInfoList.length>0)
                                  {
                                    Fluttertoast.showToast(
                                        msg: "需删除子分类下所有菜品，才可进行删除该分类",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIos: 2,
                                        backgroundColor: Theme.of(context).primaryColor,
                                        textColor: Colors.pink);
                                    await choosePersonNumDialog(context);
                                    return;
                                  }
                                isdeleteOraddok=false;
                                await _deleteCategory(context,"",list[secondIndex]
                                    .secondaryCategoryList[descIndex].categoryId);
                                if(isdeleteOraddok) {
                                  Fluttertoast.showToast(
                                      msg: "删除成功",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIos: floaststaytime,
                                      backgroundColor: Theme.of(context).primaryColor,
                                      textColor: Colors.pink);
                                  Navigator.of(context).pop(true);
                                }
                                else {
                                  Fluttertoast.showToast(
                                      msg: "网络或服务器错误",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIos: floaststaytime,
                                      backgroundColor: Theme.of(context).primaryColor,
                                      textColor: Colors.pink);
                                  Navigator.of(context).pop(false);
                                }
                              }
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                child: InkWell(
                    onTap: () async {
                      setState(() {
                        lastIndex = descIndex;
                      });
                    },
                    child: Column(children: <Widget>[
                      Container(
                        height: ScreenUtil().setSp(80.0),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        decoration: BoxDecoration(
                            color: isClick
                                ? Color.fromRGBO(236, 160, 139, 1.0)
                                : Colors.white,
                            border: Border(
                                bottom: BorderSide(
                                    width: 1, color: Colors.black12))),
                        child: isClick
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                    Text(list[secondIndex]
                                        .secondaryCategoryList[descIndex]
                                        .categoryName,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: ScreenUtil().setSp(30)),),

                                  ])
                            : Text(list[secondIndex]
                                .secondaryCategoryList[descIndex]
                                .categoryName,
                             maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: ScreenUtil().setSp(28)),),
                      ),
                      Divider(
                        height: 4.0,
                        indent: 0.0,
                        color: Colors.red,
                      ),
                    ])),

                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: '删除',
                    color: Colors.red,
                    icon: Icons.delete,
                    closeOnTap: false,
                    onTap: () => _secondshowSnackBar('删除', descIndex),
                  ),
                ],
              );
            },
          ));
    } else {
      return Container(
          height: ScreenUtil().setSp(800),
          width: ScreenUtil().setSp(300),
          decoration: new BoxDecoration(
            border: new Border.all(color: Colors.grey, width: 0.5),
            borderRadius: new BorderRadius.circular((10.0)), // 圆角度
            boxShadow: [BoxShadow(color: Colors.white)],
          ),
          child: Text('暂时没有数据'));
    }
  }

  //子菜品栏
  Widget _CaiPinlistView() {
    if (foodsList!=null&&foodsList.data.foodInfoList.length>0) {
      return Container(
          decoration: new BoxDecoration(
            border: new Border.all(color: Colors.grey, width: 0.5),
            borderRadius: new BorderRadius.circular((10.0)), // 圆角度
            boxShadow: [BoxShadow(color: Colors.white)],
          ),
          padding: EdgeInsets.fromLTRB(
              ScreenUtil.getInstance().setSp(20.0),
              ScreenUtil.getInstance().setSp(0.0),
              ScreenUtil.getInstance().setSp(20.0),
              0.0),
          height: ScreenUtil().setSp(800),
          width: ScreenUtil().setSp(300),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: foodsList.data.foodInfoList.length,
            itemBuilder: (context, index) {
              var descIndex =
                  foodsList.data.foodInfoList.length - 1 - index;
              final item = foodsList.data.foodInfoList[descIndex].dishName+
                  '$descIndex';
              return Slidable(
                key: Key(descIndex.toString()),
                controller: foodlistController,
                actionPane: SlidableScrollActionPane(),
                // 侧滑菜单出现方式 SlidableScrollActionPane SlidableDrawerActionPane SlidableStrechActionPane
                actionExtentRatio: 0.0,
                // 侧滑按钮所占的宽度
                enabled: true,
                // 是否启用侧滑 默认启用
                dismissal: SlidableDismissal(
                  child: SlidableDrawerDismissal(),
                  onDismissed: (actionType) {
                    _showSnack(
                        context,
                        actionType == SlideActionType.primary
                            ? 'Dismiss Archive'
                            : 'Dimiss Delete');
                    setState(() {
                      descIndex-1>0?foodlistIndex = descIndex-1:foodlistIndex=0;
                      foodsList.data.foodInfoList.removeAt(descIndex);
                    });
                  },
                  onWillDismiss: (actionType) {
                    return showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('删除'),
                          content: Text('删除这条菜品？'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('取消'),
                              onPressed: () => Navigator.of(context).pop(false),
                            ),
                            FlatButton(
                                child: Text('确认'),
                                onPressed: () async{
                                  isdeleteOraddok=false;
                                  await _deletecaipin(context,foodsList.data.foodInfoList[descIndex].dishId);
                                  if(isdeleteOraddok) {
                                    Fluttertoast.showToast(
                                        msg: "删除成功",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIos: floaststaytime,
                                        backgroundColor: Theme.of(context).primaryColor,
                                        textColor: Colors.pink);
                                    Navigator.of(context).pop(true);
                                  }
                                  else {
                                    Fluttertoast.showToast(
                                        msg: "网络或服务器错误",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIos: floaststaytime,
                                        backgroundColor: Theme.of(context).primaryColor,
                                        textColor: Colors.pink);
                                    Navigator.of(context).pop(false);
                                  }
                                }
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                child: InkWell(
                    onTap: () async {
                      setState(() {
                        foodlistIndex = descIndex;
                      });
                    },
                    child: Column(children: <Widget>[
                      Container(
                        height: ScreenUtil().setSp(80.0),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        decoration: BoxDecoration(
                            color:  Colors.white,
                            border: Border(
                                bottom: BorderSide(
                                    width: 1, color: Colors.black12))),
                        child: Text(foodsList.data.foodInfoList[descIndex].dishName),
                      ),
                      Divider(
                        height: 4.0,
                        indent: 0.0,
                        color: Colors.red,
                      ),
                    ])),

                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: '删除',
                    color: Colors.red,
                    icon: Icons.delete,
                    closeOnTap: false,
                    onTap: () => _secondshowSnackBar('删除', descIndex),
                  ),
                ],
              );
            },
          ));
    } else {
      return Container(
          height: ScreenUtil().setSp(800),
          width: ScreenUtil().setSp(300),
          decoration: new BoxDecoration(
            border: new Border.all(color: Colors.grey, width: 0.5),
            borderRadius: new BorderRadius.circular((10.0)), // 圆角度
            boxShadow: [BoxShadow(color: Colors.white)],
          ),
          child: Text('暂时没有数据'));
    }
  }

  Future choosePersonNumDialog(BuildContext context) async{
    var result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('删除子分类下所有菜品\n才能进行删除该分类\n请左滑删除需要删除的菜品'),
            content:  _CaiPinlistView(),
            actions: <Widget>[
              FlatButton(
                child: Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop('cancel');
                },
              ),
              FlatButton(
                child: Text('确认'),
                onPressed: () {
                    Navigator.of(context).pop('ok');
                },
              ),
            ],
          );
        });
    return result;
  }


  Future addPrimaryCategoryDialog(BuildContext context) async {
    _primarayTextController.text = "";
    var result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('添加主类别名'),
            content: TextFormField(
              autofocus: false,
              controller: _primarayTextController,
              decoration: InputDecoration(
                  hintText: "请输入主类别名称",
                  icon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(5.0)),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop('cancel');
                },
              ),
              FlatButton(
                child: Text('确认'),
                onPressed: () async{
                  if (_primarayTextController.text.trim().length == 0) {
                    Fluttertoast.showToast(
                        msg: "请输入类别名字",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIos: 2,
                        backgroundColor: Theme.of(context).primaryColor,
                        textColor: Colors.pink);
                    return;
                  } else {
                    List<String> templist=[];
                    isdeleteOraddok=false;
                    if(iscunZai(_primarayTextController.text,index: -1)){
                      await _addCategory(context, _primarayTextController.text,templist);
                      if(isdeleteOraddok) {
                        Fluttertoast.showToast(
                            msg: "添加成功",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIos: floaststaytime,
                            backgroundColor: Theme.of(context).primaryColor,
                            textColor: Colors.pink);
                        _getCategory();
                        setState(() {

                        });
                        Navigator.of(context).pop(true);
                      }
                      else {
                        Fluttertoast.showToast(
                            msg: "网络或服务器错误",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIos: floaststaytime,
                            backgroundColor: Theme.of(context).primaryColor,
                            textColor: Colors.pink);
                        Navigator.of(context).pop(false);
                      }
                    }else{
                      Fluttertoast.showToast(
                          msg: "存在已有类型",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIos: floaststaytime,
                          backgroundColor: Theme.of(context).primaryColor,
                          textColor: Colors.pink);
                      Navigator.of(context).pop(false);
                    }
                  }
                },
              ),
            ],
          );
        });
    return result;
  }

  Future addSecondCategoryDialog(BuildContext context) async {
    _secondTextController.text = "";
    var result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('添加子类别名'),
            content: TextFormField(
              autofocus: false,
              controller: _secondTextController,
              decoration: InputDecoration(
                  hintText: "请输入子类别名称",
                  icon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(5.0)),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop('cancel');
                },
              ),
              FlatButton(
                child: Text('确认'),
                onPressed: () async{
                  if (_secondTextController.text.trim().length == 0) {
                    Fluttertoast.showToast(
                        msg: "请输入类别名字",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIos: 2,
                        backgroundColor: Theme.of(context).primaryColor,
                        textColor: Colors.pink);
                    return;
                  } else {
                    List<String> templist=[];
                    templist.add(_secondTextController.text);
                    isdeleteOraddok=false;
                    if(iscunZai(list[secondIndex].primaryCategoryName,index: secondIndex)){
                      await _addCategory(context, list[secondIndex].primaryCategoryName,templist);
                      if(isdeleteOraddok) {
                        Fluttertoast.showToast(
                          msg: "添加成功",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIos: floaststaytime,
                          backgroundColor: Theme.of(context).primaryColor,
                          textColor: Colors.pink
                        );
                        _getCategory();
                        setState(() {
                        });
                        Navigator.of(context).pop(true);
                      }
                      else {
                        Fluttertoast.showToast(
                          msg: "网络或服务器错误",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIos: floaststaytime,
                          backgroundColor: Theme.of(context).primaryColor,
                          textColor: Colors.pink
                        );
                        Navigator.of(context).pop(false);
                      }
                    }else{
                      Fluttertoast.showToast(
                          msg: "存在已有类型",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIos: floaststaytime,
                          backgroundColor: Theme.of(context).primaryColor,
                          textColor: Colors.pink);
                      Navigator.of(context).pop(false);
                    }
                  }
                },
              ),
            ],
          );
        });
    return result;
  }


  //得到菜品列表数据
  void _getFoodList(context,String categorySubId) async{
    foodsList=null;
    var data={
      'canteen_id':canteenID,
      'category':categorySubId,
      'dish_id':null
    };


    await request('getFoodDish', '',formData:data ).then((val){
      if(val.toString()=="false")
      {
        return;
      }
      var  data = val;
      foodsList=  CategoryFoodsListModel.fromJson(data);
    });
  }

  //删除菜品接口
  Future _deletecaipin(BuildContext context,int dishID) async {
    List<int> dish_id = new List();
    dish_id.add(dishID);
    var datatext = {"canteen_id": 1, "type": "delete", "dish_id": dish_id};
    FormData data = FormData.fromMap({"dish_content": jsonEncode(datatext)});
    await request('foodEntry', '', formData: data).then((val) {
      if(val.toString()=="false")
      {
        isdeleteOraddok=false;
        return false;
      }
      var data = val;
      if (data == null) {
        isdeleteOraddok=false;
        return false;
      }
      String code = data['code'].toString();
      String message = data['message'].toString();
      if (code == "0") {
        isdeleteOraddok=true;
        return true;
      } else {
        isdeleteOraddok=false;
        return false;
      }
    });
  }

  //删除目录接口
  Future _deleteCategory(BuildContext context,String primaryID,String secondId) async {
   // var formdata = {
   //   'primary': primaryID,
   //   'secondary': secondId,
  //  };
    var param="?primary=$primaryID&secondary=$secondId";
    await requestDelete('Category', param, ).then((val) {
      if(val.toString()=="false")
      {
        isdeleteOraddok=false;
        return false;
      }

      if (val == null) {
        isdeleteOraddok=false;
        return false;
      }
      String code = val['code'].toString();
      String message = val['message'].toString();
      if (code == "0") {
        isdeleteOraddok=true;
        return true;
      } else {
        isdeleteOraddok=false;
        return false;
      }
    });
  }

  //添加目录接口
  Future _addCategory(BuildContext context,String primaryName,List<String> secondName) async {
    List data=[];
    var tempdata={"primary_category_name":primaryName,
        "secondary_category_name":secondName
    };
    data.add(tempdata);
    var formdata = {
      'data': data,
    };
    await request('CreateCategory', '', formData:formdata).then((val) {
      if(val.toString()=="false") {
        isdeleteOraddok=false;
        return false;
      }
      var data = val;
      if (data == null) {
        isdeleteOraddok=false;
        return false;
      }
      String code = data['code'].toString();
      String message = data['message'].toString();
      if (code == "0") {
        isdeleteOraddok=true;
        return true;
      } else {
        isdeleteOraddok=false;
        return false;
      }
    });
  }

  bool iscunZai(String name,{int index}){
    if(index==-1){
      for(int i=0;i<list.length;i++){
        if(name==list[i].primaryCategoryName){
          return false;
        }
      }
      return true;
    }else{
      for(int i=0;i<list[index].secondaryCategoryList.length;i++){
        if(name==list[index].secondaryCategoryList[i].categoryName){
          return false;
        }
      }
      return true;
    }
  }
}