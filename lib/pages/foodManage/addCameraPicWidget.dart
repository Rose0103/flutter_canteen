import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_canteen/base64ToImage.dart';
import 'package:flutter_canteen/otherfunction/showDialog.dart';
import 'package:flutter_canteen/pages/LoginPage/CompletePersonInfoPage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_canteen/otherfunction/EncodeUtil.dart';
import 'package:flutter_canteen/config/param.dart';
import 'dart:convert';
import 'package:flutter_canteen/otherfunction/logutil.dart';
import 'package:flutter_canteen/router/application.dart';
import 'package:flutter_canteen/pages/facedetect/facedetectPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_canteen/pages/photo_view_page/photo_view_page.dart';


// base64库
import 'dart:convert' as convert;

// 文件相关
import 'dart:io';

class ImagePickerWidget extends StatefulWidget {
  final String widgetName;
  final int widgetType; //1:圆形展示  2：全图方形展示
  String imageBase64;

  ImagePickerWidget(this.widgetName, this.widgetType, this.imageBase64);

  @override
  State<StatefulWidget> createState() {
    return _ImagePickerState(widgetName, widgetType, imageBase64);
  }
}

class _ImagePickerState extends State<ImagePickerWidget> {
  final String widgetName;
  final int widgetType; //1:圆形展示  2：全图方形展示
  String imageBase64;
  String base64ed;

  _ImagePickerState(this.widgetName, this.widgetType, this.imageBase64);

  var _imgPath;

  Future onGoBack(dynamic value) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      //height: ScreenUtil().setHeight(210),
      //padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          border: Border.all(width: 2, color: Colors.black38),
        ),
        child: SingleChildScrollView(
          //padding: EdgeInsets.fromLTRB(30.0, 2.0, 10.0, 5.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _ImageView(_imgPath),
                  Column(children: <Widget>[
                    Container(
                      //color: Colors.black12,
                        child: IconButton(
                            icon: Icon(Icons.camera_alt),
                            iconSize: ScreenUtil().setSp(100.0),
                            onPressed: () {
                              _takePhoto();
                            })),
                    Container(
                      //color: Colors.black12,
                        child: IconButton(
                            icon: Icon(Icons.photo),
                            iconSize: ScreenUtil().setSp(100.0),
                            onPressed: () {
                              _openGallery();
                            })),
                  ])
                ])));
  }

  /*图片控件*/
  Widget _ImageView(imgPath) {
    if(widgetType == 1) {
      this.imageBase64 = featureBase64;
      base64ed = featureBase64;
    }
    if (imgPath == null) {
      if (widgetType == 1) {
        return Container(
            alignment: Alignment.center,
            height: ScreenUtil().setSp(400),
            width: ScreenUtil().setSp(500),
            padding:
            EdgeInsets.fromLTRB(ScreenUtil().setSp(32.0), 0.0, 0.0, 0.0),
            decoration: BoxDecoration(
              color: Colors.white,
              //设置四周圆角 角度
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              //设置四周边框
              border: Border.all(width: 1, color: Colors.black12),
            ),
            child: this.imageBase64 == null||this.imageBase64.trim().length==0
                ? IconButton(
                icon: Icon(Icons.person),
                iconSize: ScreenUtil().setSp(150.0),
                onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => FaceDetectPage()));
                  //Appliaction.router.navigateTo(context, "/facePage");
                })
                :  InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PhotoViewSimpleScreen(imageProvider: MemoryImage(base64.decode(this.imageBase64.split(',')[1])),heroTag: "",)));
                //Appliaction.router.navigateTo(context,"/detail?id=${newList[index].dishId}");
              },
              child: ClipOval(
                  child:Image.memory(
                    base64.decode(imageBase64.split(',')[1]),
                    height: 150, //设置高度
                    width: 150, //设置宽度
                    fit: BoxFit.fill, //填充
                    gaplessPlayback: true, //防止重绘
                  )
              ),
            ));
      } else {
        if (imageBase64!=null&&!imageBase64.contains("base64")&&!imageBase64.contains("http")) {
          imageBase64 = "http://$resourceUrl/" + imageBase64;
        } else if(imageBase64!=null&&imageBase64.contains("comdish")) {
          imageBase64 = imageBase64.toString().replaceAll("comdish", "com/dish");
        }
        dishPicpath = imageBase64;
//        paths = imageBase64;
        return Container(
            alignment: Alignment.center,
            height: ScreenUtil().setSp(250),
            width: ScreenUtil().setSp(500),
            padding: EdgeInsets.fromLTRB(ScreenUtil().setSp(32.0), 0.0, 0.0, 0.0),
            decoration: BoxDecoration(
              color: Colors.white,
              //设置四周圆角 角度
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              //设置四周边框
              border: Border.all(width: 1, color: Colors.black12),
            ),
            child: imageBase64 == null||imageBase64.trim().length==0
                ? IconButton(
                icon: Icon(Icons.fastfood),
                iconSize: ScreenUtil().setSp(150.0),
                onPressed: () {
                  _takePhoto();
                })
                : imageBase64.contains("base64")?InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PhotoViewSimpleScreen(imageProvider: MemoryImage(base64.decode(this.imageBase64.split(',')[1])),heroTag: "",)));
                //Appliaction.router.navigateTo(context,"/detail?id=${newList[index].dishId}");
              },
              child:Image.memory(
                base64.decode(imageBase64.split(',')[1]),
                fit: BoxFit.cover, //填充
                gaplessPlayback: true, //防止重绘
              ),
            ):InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PhotoViewSimpleScreen(imageProvider: NetworkImage(this.imageBase64),heroTag: "",)));
                //Appliaction.router.navigateTo(context,"/detail?id=${newList[index].dishId}");
              },
              child:Image.network(
                imageBase64,
                //height: 150, //设置高度
                //width: 150, //设置宽度
                fit: BoxFit.cover, //填充
                gaplessPlayback: true, //防止重绘
              ),
            ));
      }
    } else {
      if (widgetType == 2) {
        return Container(
            height: ScreenUtil().setSp(210),
            width: ScreenUtil().setSp(500),
            padding:
            EdgeInsets.fromLTRB(ScreenUtil().setSp(32.0), 0.0, 0.0, 0.0),
            child:InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PhotoViewSimpleScreen(imageProvider: MemoryImage(base64.decode(this.imageBase64.split(',')[1])),heroTag: "",)));
                  //Appliaction.router.navigateTo(context,"/detail?id=${newList[index].dishId}");
                },
                child:Image.memory(
                  base64.decode(imageBase64.split(',')[1]),
                  height: 150, //设置高度
                  width: 150, //设置宽度
                  fit: BoxFit.fill, //填充
                  gaplessPlayback: true, //防止重绘
                )));
      } else if (widgetType == 1) {
        return Container(
            alignment: Alignment.center,
            height: ScreenUtil().setSp(400),
            width: ScreenUtil().setSp(500),
            padding:
            EdgeInsets.fromLTRB(ScreenUtil().setSp(32.0), 0.0, 0.0, 0.0),
            decoration: BoxDecoration(
              color: Colors.white,
              //设置四周圆角 角度
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              //设置四周边框
              border: Border.all(width: 1, color: Colors.black12),
            ),
            child: InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PhotoViewSimpleScreen(imageProvider: MemoryImage(base64.decode(this.imageBase64.split(',')[1])),heroTag: "",)));
                  //Appliaction.router.navigateTo(context,"/detail?id=${newList[index].dishId}");
                },child:ClipOval(
              child: Image.memory(
                base64.decode(imageBase64.split(',')[1]),
                height: 150, //设置高度
                width: 150, //设置宽度
                fit: BoxFit.fill, //填充
                gaplessPlayback: true, //防止重绘
              ),
            )));
      }
    }
  }

  /*拍照*/
  _takePhoto() async {
    dishPicpath = null;
    paths = null;
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 100);
    if (image == null) return;
    String imagebase64;
    await EncodeUtil.image2Base64(image.toString()).then((data) {
      imagebase64 = data;
    });
    _imgPath = image;
    this.imageBase64 = imagebase64;
    String temppath=image.toString().replaceAll("File: '", "");
    temppath=temppath.replaceAll("'","");
    dishPicpath =temppath;
    print(3333333333334);
    print(dishPicpath);
    int count = 0;
    paths = await Base64ToImage.compressImage(File(dishPicpath),count);
    if (widgetType == 1){
      if(paths.contains("png")) {
        featureBase64 = 'data:image/png;base64,'+await Base64ToImage.image2Base64(paths);
      }else {
        featureBase64 = 'data:image/jpg;base64,'+await Base64ToImage.image2Base64(paths);
      }
    }
    String abc = featureBase64.split(',')[1];
    var formData = {
      "image":abc,
      "image_type":"BASE64",
      "face_field":"quality",
      "max_face_num":"1"
    };
    await CompletePersonInfoPageState.faceDetection("",formData:formData);
    print("isFaceDetection${isFaceDetection}");

    if(!isFaceDetection){
      showMessage(context, faceDetectionMsg);
      featureBase64 = base64ed;
      return;
    }
    print(paths);
    _imgPath = paths;
    setState(() {

    });
  }

  /*相册*/
  _openGallery() async {
    dishPicpath=null;
    paths = null;
    var image = await ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 100);
    if(image==null) return;
    String imagebase64;
    await EncodeUtil.image2Base64(image.toString()).then((data) {
      imagebase64 = data;
    });
    this.imageBase64 = imagebase64;
    String temppath = image.toString().replaceAll("File: '", "");
    temppath=temppath.replaceAll("'","");
    dishPicpath = temppath;
    print(3333333333334);
    print(dishPicpath);
    int count = 0;
    paths = await Base64ToImage.compressImage(File(dishPicpath),count);
    if (widgetType == 1){
      if(paths.contains("png")) {
        featureBase64 = 'data:image/png;base64,'+await Base64ToImage.image2Base64(paths);
      }else {
        featureBase64 = 'data:image/jpg;base64,'+await Base64ToImage.image2Base64(paths);
      }
    }
    String abc = featureBase64.split(',')[1];
    var formData = {
      "image":abc,
      "image_type":"BASE64",
      "face_field":"quality",
      "max_face_num":"1"
    };
    await CompletePersonInfoPageState.faceDetection("",formData:formData);
    if(!isFaceDetection){
      showMessage(context, faceDetectionMsg);
      featureBase64 = base64ed;
      return;
    }
    print(paths);
    _imgPath = paths;
    setState(() {

    });
  }
}
