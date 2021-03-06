import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_canteen/base64ToImage.dart';
import 'package:flutter_canteen/pages/foodManage/addCameraPicWidget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/model/category.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_canteen/provide/detail_info.dart';
import 'package:provide/provide.dart';
import 'package:flutter_canteen/otherfunction/moneytext.dart';
import 'package:flutter_canteen/pages/managerCategoryPages/manage_primary_category.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:flutter_canteen/otherfunction/showDialog.dart';
import 'package:path_provider/path_provider.dart';

class AddCaiPinPage extends StatefulWidget {
  String functionID;

  AddCaiPinPage(this.functionID);

  @override
  _AddCaiPinPageState createState() => _AddCaiPinPageState(this.functionID);
}

class _AddCaiPinPageState extends State<AddCaiPinPage> {
  String functionID;
  final TextEditingController _namecontroller = new TextEditingController();
  final TextEditingController _pricecontroller = new TextEditingController();
  final TextEditingController _detailtroller = new TextEditingController();
  String imageBase64;
  List<CategoryBigModelData> list = [];
  bool iscommit=false;
  DateTime lastPopTime=null;
  String compressPath;
  List<DropdownMenuItem<String>> _dropDownCategoryItems;
  List<DropdownMenuItem<String>> _dropDownSecondCategoryItems;
  String _selectedCategory;
  String _selectedSecondCategory;
  bool ismodify=false;

  List<DropdownMenuItem<String>> buildAndGetDropDownCategoryItems(
      List<CategoryBigModelData> categorys) {
    List<DropdownMenuItem<String>> items = List();
    for (CategoryBigModelData category in categorys) {
      items.add(DropdownMenuItem(
          value: category.primaryCategoryId,
          child: Text(category.primaryCategoryName)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownsecondCategoryItems(
      List<CategoryBigModelDataSecondaryCategoryList> secondCategory) {
    List<DropdownMenuItem<String>> items = List();
    for (CategoryBigModelDataSecondaryCategoryList category in secondCategory) {
      items.add(DropdownMenuItem(
          value: category.categoryId, child: Text(category.categoryName)));
    }
    return items;
  }

  void changedDropDownCategoryItem(String selectedCategory) {
    for(int i=0;i<list.length;i++) {
      if(list[i].primaryCategoryId==selectedCategory) {
        _dropDownSecondCategoryItems = buildAndGetDropDownsecondCategoryItems(
            list[i].secondaryCategoryList);
        break;
      }
    }
    _selectedCategory = selectedCategory;
    //modify by gaoyang 2020-11-24  ???????????? ???????????????????????????????????????????????????????????????????????????????????????????????????????????????
    setState(() {
      if(_dropDownSecondCategoryItems!=null && _dropDownSecondCategoryItems.length > 0){
        _selectedSecondCategory = _dropDownSecondCategoryItems[0].value;
      }else{
        showMessage(context, "????????????????????????");
      }
    });
  }

  void changedDropDownsecondCategoryItem(String selectedSecondCategory) {
    setState(() {
      _selectedSecondCategory = selectedSecondCategory;
    });
  }

  _AddCaiPinPageState(this.functionID);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCategory();
      Future.delayed(Duration(seconds: 1), () {
        if(list != null && list.length>0){
          _dropDownCategoryItems = buildAndGetDropDownCategoryItems(list);
          _dropDownSecondCategoryItems = buildAndGetDropDownsecondCategoryItems(
              list[0].secondaryCategoryList);
        }


        //???????????????????????????
        if (Provide.value<DetailsInfoProvide>(context).foodsInfo != null) {
          ismodify = true;

          _namecontroller.text = Provide.value<DetailsInfoProvide>(context)
              .foodsInfo
              .data
              .foodInfo
              .dishName;
          _pricecontroller.text = Provide.value<DetailsInfoProvide>(context)
              .foodsInfo
              .data
              .foodInfo
              .dishPrice
              .toString();
          _detailtroller.text = Provide.value<DetailsInfoProvide>(context)
              .foodsInfo
              .data
              .foodInfo
              .dishDesc;
          int currentCategory = Provide.value<DetailsInfoProvide>(context)
              .foodsInfo
              .data
              .foodInfo
              .category;
          imageBase64 = Provide.value<DetailsInfoProvide>(context)
              .foodsInfo
              .data
              .foodInfo
              .dishPhoto[0];
          print("!!!!!!!!!!!!!!:${imageBase64}");
          bool ischoose = false;
          for (int i = 0; i < list.length; i++) {
            for (int j = 0; j < list[i].secondaryCategoryList.length; j++) {
              if (list[i].secondaryCategoryList[j].categoryId ==
                  currentCategory.toString()) {
                changedDropDownCategoryItem(list[i].primaryCategoryId);
                changedDropDownsecondCategoryItem(
                    list[i].secondaryCategoryList[j].categoryId);
                ischoose = true;
                break;
              }
            }
            if (ischoose) break;
          }
        }
        setState(() {});
      });
    });
  }

//??????????????????
  Widget backButtonWidget(BuildContext context) {
    return Container(
        alignment: Alignment.bottomLeft,
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setSp(0.0),
            ScreenUtil().setSp(120.0),
            ScreenUtil().setSp(0.0),
            ScreenUtil().setSp(0.0)),
        child: IconButton(
            icon: ImageIcon(AssetImage("assets/images/btn_back.png")),
            iconSize: ScreenUtil().setSp(100.0),
            onPressed: () {
              Navigator.of(context).pop();
            }));
  }

  //??????
  Widget titleWidget(String title) {
    return Container(
      //width: ScreenUtil().setSp(200),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setSp(32.0),
          ScreenUtil().setSp(0.0),
          ScreenUtil().setSp(0.0),
          ScreenUtil().setSp(0.0)),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: ScreenUtil().setSp(50),
        ),
      ),
    );
  }

  //????????????
  Widget inputCaiPinNameWidget() {
    return Container(
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setSp(32.0),
            ScreenUtil().setSp(10.0),
            ScreenUtil().setSp(32.0),
            ScreenUtil().setSp(0.0)),
        width: ScreenUtil().setSp(686),
        child: TextFormField(
          autofocus: false,
          controller: _namecontroller,
          decoration: InputDecoration(
              //labelText: '????????????',
              hintText: '?????????????????????',
              icon: Icon(Icons.format_color_text),
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(15.0)),
          validator: (v) {
            return v.trim().length > 0 ? null : '??????????????????';
          },
        ));
  }

  //????????????
  Widget categoryCombbox() {
    return Container(
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setSp(32.0),
            ScreenUtil().setSp(10.0),
            ScreenUtil().setSp(32.0),
            ScreenUtil().setSp(0.0)),
        width: ScreenUtil().setSp(800),
        child: Row(
          //crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("?????????????????????"),
            Container(
                height:ScreenUtil().setSp(100.0) ,
                width:ScreenUtil().setSp(350.0) ,
                padding: EdgeInsets.only(left: ScreenUtil.getInstance().setSp(50)),
                child:DropdownButton(
              value: _selectedCategory,
              items: _dropDownCategoryItems,
              onChanged: changedDropDownCategoryItem,
            ))
          ],
        ));
  }

  //??????
  Widget secondCategoryCombbox() {
    return Container(
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setSp(32.0),
            ScreenUtil().setSp(10.0),
            ScreenUtil().setSp(32.0),
            ScreenUtil().setSp(0.0)),
        width: ScreenUtil().setSp(686),
        child: Row(
          //crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("??????????????????"),
        Container(
          height:ScreenUtil().setSp(100.0) ,
          width:ScreenUtil().setSp(380.0) ,
          padding: EdgeInsets.only(left: ScreenUtil.getInstance().setSp(75)),
          child:DropdownButton(
              value: _selectedSecondCategory,
              items: _dropDownSecondCategoryItems,
              onChanged: changedDropDownsecondCategoryItem,
            ))
        ],
        ));
  }

  Widget managerButton()
  {
    return Container(
      child: RaisedButton(
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => manageCategoryPage()));
        },
        child: Text("????????????"),
        color: Theme.of(context).primaryColor,
        colorBrightness: Brightness.light,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  //????????????
  Widget inputPriceWidget() {
    return Container(
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setSp(32.0),
            ScreenUtil().setSp(10.0),
            ScreenUtil().setSp(32.0),
            ScreenUtil().setSp(0.0)),
        width: ScreenUtil().setSp(686),
        child: TextFormField(
          autofocus: false,
          inputFormatters: [
            WhitelistingTextInputFormatter(RegExp("[0-9.]")),
            LengthLimitingTextInputFormatter(9),
            MoneyTextInputFormatter()],
          keyboardType: TextInputType.number,
          controller: _pricecontroller,
          decoration: InputDecoration(
              //labelText: '????????????',
              hintText: '?????????????????????(????????????)',
              icon: Icon(Icons.monetization_on),
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(15.0)),
          validator: (v) {
            return v.trim().length > 0 ? null : '?????????????????????(????????????)';
          },
        ));
  }

  //????????????
  Widget inputDetailWidget() {
    return Container(
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setSp(32.0),
            ScreenUtil().setSp(10.0),
            ScreenUtil().setSp(32.0),
            ScreenUtil().setSp(0.0)),
        width: ScreenUtil().setSp(686),
        height: ScreenUtil().setSp(180),
        child: TextFormField(
          autofocus: false,
          maxLines: 2,
          controller: _detailtroller,
          decoration: InputDecoration(
              //labelText: '????????????',
              hintText: '?????????????????????',
              icon: Icon(Icons.book),
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(15.0)),
          validator: (v) {
            return v.trim().length > 0 ? null : '?????????????????????';
          },
        ));
  }

  //????????????
  Widget useflagWidget() {
    return Container(
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setSp(32.0),
            ScreenUtil().setSp(10.0),
            ScreenUtil().setSp(32.0),
            ScreenUtil().setSp(0.0)),
        width: ScreenUtil().setSp(686),
        child: CheckboxListTile(
          title: const Text('????????????'),
          value: true,
        ));
  }

  //????????????
  Widget confirButtonWidget(BuildContext context) {
    return Container(
        width: ScreenUtil().setSp(686),
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setSp(32.0),
            ScreenUtil().setSp(10.0),
            ScreenUtil().setSp(32.0),
            ScreenUtil().setSp(0.0)),
        child: RaisedButton(
            padding: EdgeInsets.all(15.0),
            child: Text("????????????"),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: () async {
              if(_selectedCategory==null||_selectedCategory.trim().length==0)
              {
                showMessage(context,"?????????????????????");
                return;
              }

              if(_namecontroller.text==null||_namecontroller.text.trim().length==0)
              {
                showMessage(context,"?????????????????????");
                return;
              }
              if(_pricecontroller.text==null||_pricecontroller.text.trim().length==0)
              {
                showMessage(context,"?????????????????????");
                return;
              }
              if(_detailtroller.text==null||_detailtroller.text.trim().length==0)
              {
                showMessage(context,"?????????????????????");
                return;
              }
              if(dishPicpath==null)
              {
                showMessage(context,"?????????????????????");
                return;
              }
              //????????????????????????
              if(_selectedSecondCategory==null)
              {
                showMessage(context,"????????????????????????,??????????????????");
                return;
              }
              if(lastPopTime == null || DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
                lastPopTime = DateTime.now();
                setState((){
                   _postcaipin();
                });
              }else{
                lastPopTime = DateTime.now();
                showMessage(context,"?????????????????????");
                return;
              }
              if(iscommit) {
                Navigator.of(context).pop();
              }

            },));
  }

  void _getCategory() async {
    var data = {'canteen_id': canteenID};

    await requestGet('Category', '?canteen_id=$canteenID').then((val) {
      if(val.toString()=="false")
      {
        return;
      }
      CategoryBigModel category = CategoryBigModel.fromJson(val);
      list = category.data;
      if(list!=null && list.length >0){
        _dropDownCategoryItems = buildAndGetDropDownCategoryItems(list);
        _dropDownSecondCategoryItems = buildAndGetDropDownsecondCategoryItems(list[0].secondaryCategoryList);
      }

      //???????????????????????????
      if(Provide.value<DetailsInfoProvide>(context).foodsInfo!=null) {
        ismodify=true;
        _namecontroller.text=Provide.value<DetailsInfoProvide>(context).foodsInfo.data.foodInfo.dishName;
        _pricecontroller.text=Provide.value<DetailsInfoProvide>(context).foodsInfo.data.foodInfo.dishPrice.toString();
        _detailtroller.text=Provide.value<DetailsInfoProvide>(context).foodsInfo.data.foodInfo.dishDesc;
        int currentCategory=Provide.value<DetailsInfoProvide>(context).foodsInfo.data.foodInfo.category;
        imageBase64=Provide.value<DetailsInfoProvide>(context).foodsInfo.data.foodInfo.dishPhoto[0];
        bool ischoose = false;
        for(int i=0;i<list.length;i++) {
          for(int j=0;j<list[i].secondaryCategoryList.length;j++)
          {
            if(list[i].secondaryCategoryList[j].categoryId==currentCategory.toString())
            {
              changedDropDownCategoryItem(list[i].primaryCategoryId);
              changedDropDownsecondCategoryItem(list[i].secondaryCategoryList[j].categoryId);
              ischoose=true;
              break;
            }
          }
          if(ischoose) break;
        }
      }
      setState(() {
      });
    });
  }

  void _postcaipin() async {
    iscommit=false;
    var datatext={
      "canteen_id": 1,
      "dish_name": _namecontroller.text,
      "dish_desc": _detailtroller.text,
      "dish_flavor": " ",
      "dish_price": _pricecontroller.text,  //???????????????10000.00
      "type": "add",
      "category":int.parse(_selectedSecondCategory)
    };
    if(ismodify) {
      datatext = {
        "canteen_id": 1,
        "dish_name": _namecontroller.text,
        "dish_desc": _detailtroller.text,
        "dish_flavor": " ",
        "dish_price": _pricecontroller.text, //???????????????10000.00
        "type": "modify",
        "dish_id":Provide.value<DetailsInfoProvide>(context).foodsInfo.data.foodInfo.dishId,
        "category": int.parse(_selectedSecondCategory)
      };
    }
    print(paths);
    FormData data;
    if (paths == null||paths=="") {
      data = FormData.fromMap({
        "dish_content": jsonEncode(datatext)
      });
    }else{
      data = FormData.fromMap({
        "image": await MultipartFile.fromFile(paths, filename: 'text.jpg'),
        "dish_content": jsonEncode(datatext)
      });
    }

    await request('foodEntry', '', formData: data).then((val) {
      if(val.toString()=="false")
      {
        return;
      }
      var data = val;
      if(data==null)
        {
          showMessage(context,"???????????????????????????????????????");
          return;
        }
      String code=data['code'].toString();
      String message=data['message'].toString();
      if(code=="0") {
        iscommit = true;
        showMessage(context,"????????????");
        //modify by gaoyang 2020-11-24  ??????????????????????????????????????????
        if(!ismodify){
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddCaiPinPage("00002")));
        }

//        setState(() {
//          imageBase64 = "";
//          dishPicpath = "";
//          _namecontroller.text = "";
//          _pricecontroller.text = "";
//          _detailtroller.text = "";
//        });
      }
      else if(code=="1") {
        showMessage(context, "??????????????????");
      }else{
        showMessage(context, message);
      }
    });
    paths = "";
//    File(paths).delete();
  }

  @override
  Widget build(BuildContext context) {
    if(Provide.value<DetailsInfoProvide>(context).foodsInfo!=null)
    {
      imageBase64=Provide.value<DetailsInfoProvide>(context).foodsInfo.data.foodInfo.dishPhoto[0];
    }
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
              "????????????",
              style: TextStyle(color: Colors.black,
                  fontSize: ScreenUtil().setSp(40),
                  fontWeight:FontWeight.w500),
            ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              actions:  <Widget>[
                FlatButton(
                  onPressed: () async{
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => manageCategoryPage()));
                  },
                  child: new Text(
                    '??????????????????',
                    style: new TextStyle(color: Colors.black),
                  ),
                )]),
        body: SingleChildScrollView(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              // ??????????????????
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                child: Form(
                    child: Column(
                  children: <Widget>[
                    //backButtonWidget(context),
                    //titleWidget("????????????"),
                    ImagePickerWidget("?????????", 2, imageBase64),
                    categoryCombbox(),
                    secondCategoryCombbox(),
                    inputCaiPinNameWidget(),
                    inputPriceWidget(),
                    inputDetailWidget(),
                    //useflagWidget(),
                    confirButtonWidget(context)
                  ],
                ) )))));
  }
}
