//import 'package:camera/camera.dart';
//import 'package:firebase_ml_vision/firebase_ml_vision.dart';
//import 'package:flutter/foundation.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'detector_painters.dart';
//import 'utils.dart';
//import 'package:flutter/services.dart';
//import 'dart:typed_data';
//import 'package:flutter_canteen/router/application.dart';
//import 'package:permission_handler/permission_handler.dart';
//import 'package:fluttertoast/fluttertoast.dart';
//
//import 'dart:ui';
//import 'package:flutter_canteen/config/param.dart';
//import 'package:flutter_canteen/otherfunction/EncodeUtil.dart';
//
//class FaceDetectPage extends StatefulWidget {
//  @override
//  _FaceDetectPageState createState() => _FaceDetectPageState();
//}
//
//class _FaceDetectPageState extends State<FaceDetectPage> {
//  dynamic _scanResults;
//  CameraController _camera;
//  Detector _currentDetector = Detector.face;
//  bool _isDetecting = false;
//  bool _isenableLandmarks = false;
//  bool _isenableContours = false;
//  String _messaga = "开始采集";
//  bool isdetect = true;
//
//  CameraLensDirection _direction = CameraLensDirection.front;
//
//  @override
//  void initState() {
//    super.initState();
//    _initializeCamera();
//  }
//
//  void setMessage(String message) {
//    setState(() {
//      _messaga = message;
//    });
//  }
//
//  void _initializeCamera() async {
//    CameraDescription description = await getCamera(_direction);
//    ImageRotation rotation = rotationIntToImageRotation(
//      description.sensorOrientation,
//    );
//    _camera = CameraController(
//      description,
//      defaultTargetPlatform == TargetPlatform.iOS
//          ? ResolutionPreset.medium
//          : ResolutionPreset.high,
//    );
//    String loadmodelresult = await LoadModel();
//
//    await _camera.initialize();
//    bool isfirsttime = true;
//    _camera.startImageStream((CameraImage image) async {
//      if (isfirsttime)
//        await Future.delayed(Duration(seconds: 1), () async {
//          isfirsttime = false;
//        });
//      if (!_isDetecting) {
//        _isDetecting = true;
//
//        fullPicPath = "";
//        facePicPath = "";
//        detectFace = null;
//        List<Face> faces = new List();
//
//        detect(image, _getDetectionMethod(), rotation).then(
//          (dynamic result) async {
//            setState(() {
//              _scanResults = result;
//            });
//            faces = _scanResults;
//            int len = faces.length;
//
//            if (isdetect) {
//              if (len == 0) {
//                setMessage("未检测到人脸");
//                _isDetecting = false;
//                return 0;
//              }
//            }
//
//            int maxFaceNum = 0;
//            double size = 0.0;
//            for (int i = 0; i < faces.length; i++) {
//              Face facetemp = faces[i];
//              if (size <
//                  facetemp.boundingBox.width * facetemp.boundingBox.height) {
//                size = facetemp.boundingBox.width * facetemp.boundingBox.height;
//                maxFaceNum = i;
//              }
//            }
//
//            if (isdetect) {
//              if (faces[maxFaceNum].boundingBox.width *
//                      faces[maxFaceNum].boundingBox.height <
//                  120 * 120) {
//                setMessage("请靠近屏幕一点");
//                _isDetecting = false;
//                return 0;
//              }
//
//              final Size imagsize = Size(
//                _camera.value.previewSize.height,
//                _camera.value.previewSize.width,
//              );
//              final Size widgetsize = Size(
//                painterWidgetWidth,
//                painterWidgetHeiht,
//              );
//              String direction = "bak";
//              if (_direction == CameraLensDirection.front) direction = "front";
//
//              Rect rectface = _scaleRect(
//                  rect: faces[maxFaceNum].boundingBox,
//                  imageSize: imagsize,
//                  widgetSize: widgetsize,
//                  direct: direction);
//
//              int count = 0;
//              if (rectface.left < 2.0) count++;
//              if ((painterWidgetWidth - rectface.right) < 2.0) count++;
//              if (rectface.top < 2.0) count++;
//              if ((painterWidgetHeiht - rectface.bottom) < 2.0) count++;
//              if (count >= 2) {
//                setMessage("请离屏幕远一点");
//                _isDetecting = false;
//                return 0;
//              }
//
//              if (count == 1) {
//                setMessage("请将人脸放入屏幕中心位置");
//                _isDetecting = false;
//                return 0;
//              }
//
//              if (faces[maxFaceNum].headEulerAngleY.toDouble().abs() > 6.0) {
//                setMessage("左右测脸角度过大，请调整到正脸");
//                _isDetecting = false;
//                return 0;
//              }
//
//              if (faces[maxFaceNum].headEulerAngleZ.toDouble().abs() > 5.0) {
//                setMessage("抬头或低头角度过大，请调整到正脸");
//                _isDetecting = false;
//                return 0;
//              }
//
//              /*if (faces[maxFaceNum]
//                .getContour(FaceContourType.allPoints)
//                .positionsList
//                .length < 40) {
//              setMessage("人脸特征不全，请将正脸放到屏幕中心位置");
//              _isDetecting = false;
//              return 0;
//            }*/
//            }
//
//            int xmin=faces[maxFaceNum].boundingBox.centerLeft.dx.toInt();
//            int xmax=faces[maxFaceNum].boundingBox.centerLeft.dx.toInt()+faces[maxFaceNum].boundingBox.width.toInt();
//            int ymin=faces[maxFaceNum].boundingBox.topCenter.dy.toInt();
//            int ymax=faces[maxFaceNum].boundingBox.topCenter.dy.toInt()+faces[maxFaceNum].boundingBox.height.toInt();
//	    /*
//            for(Offset point in faces[maxFaceNum].getContour(FaceContourType.face).positionsList)
//            {
//              if(xmin>point.dx||xmin==0)
//                 xmin=point.dx.toInt();
//              if(xmax<point.dx||xmax==0)
//                xmax=point.dx.toInt();
//              if(ymax<point.dy||ymax==0)
//                ymax=point.dy.toInt();
//              if(ymin>point.dy||ymin==0)
//                ymin=point.dy.toInt();
//            }
//
//            ymin=ymin-((ymax-ymin)/6).toInt();
//            //统一截到眉毛上面
//           for(Offset point in faces[maxFaceNum].getContour(FaceContourType.rightEyebrowTop).positionsList)
//            {
//              if(ymin>point.dy||ymin==0)
//                ymin=point.dy.toInt();
//            }
//
//            for(Offset point in faces[maxFaceNum].getContour(FaceContourType.leftEyebrowTop).positionsList)
//            {
//              if(ymin>point.dy||ymin==0)
//                ymin=point.dy.toInt();
//            }*/
//
//            String imagelight = await GetImageLight(
//            bytesList: image.planes.map((plane) {
//              return plane.bytes;
//            }).toList(),
//            imageHeight: image.height,
//            imageWidth: image.width,
//            rotation: rotationImageRotationToInt(rotation),
//            faceX: xmin.toInt()< 0 ? 0 :xmin.toInt() ,
//            faceY: ymin.toInt()< 0 ? 0 : ymin.toInt() ,
//            faceWidth: xmax-xmin.toInt(),
//            faceHeight: ymax-ymin.toInt()); //检测人脸中心区域，不要内背景干扰
//
//            if (imagelight == null || imagelight.trim().length < 2) {
//              setMessage("检测光照环境失败");
//              _isDetecting = false;
//              return 0;
//            }
//
//            if (isdetect) {
//              List<String> lightList = imagelight.split(",");
//              fullLight = lightList[0].toString();
//              leftfaceLight = lightList[2].toString();
//              rightfaceLight = lightList[1].toString();
//              if (int.parse(lightList[0].toString()) < 60) {
//                setMessage("环境光线过暗，请调整环境或补光$imagelight");
//                _isDetecting = false;
//                return 0;
//              }
//
//              if (int.parse(lightList[0].toString()) > 200) {
//                setMessage("环境光线过亮，请调整环境$imagelight");
//                _isDetecting = false;
//                return 0;
//              }
//
//              if (int.parse(lightList[1].toString()) > 200 ||
//                  int.parse(lightList[2].toString()) > 200) {
//                setMessage("左脸或右脸光线过亮，请调整环境$imagelight");
//                _isDetecting = false;
//                return 0;
//              }
//
//              if (int.parse(lightList[1].toString()) < 60 ||
//                  int.parse(lightList[2].toString()) < 60) {
//                setMessage("左脸或右脸光线过暗，请调整环境或补光$imagelight");
//                _isDetecting = false;
//                return 0;
//              }
//
//              int diff = (int.parse(lightList[1].toString()) -
//                      int.parse(lightList[2].toString()))
//                  .abs();
//              if (diff > 50) {
//                setMessage("左右脸光线差别大，阴阳脸，请调整环境$imagelight");
//                _isDetecting = false;
//                return 0;
//              }
//
//              if (faces[maxFaceNum].rightEyeOpenProbability < 0.9 ||
//                  faces[maxFaceNum].leftEyeOpenProbability < 0.9) {
//                setMessage("请不要闭眼");
//                _isDetecting = false;
//                return 0;
//              }
//            }
//
//
//            PermissionStatus permission = await PermissionHandler()
//                .checkPermissionStatus(PermissionGroup.storage);
//
//            if (permission != PermissionStatus.granted) {
//              Map<PermissionGroup, PermissionStatus> permissions =
//                  await PermissionHandler()
//                      .requestPermissions([PermissionGroup.storage]);
//
//              // 申请结果
//
//              PermissionStatus permission = await PermissionHandler()
//                  .checkPermissionStatus(PermissionGroup.storage);
//
//              if (permission == PermissionStatus.granted) {
//                //Fluttertoast.showToast(msg: "权限申请通过");
//
//              } else {
//                Fluttertoast.showToast(msg: "权限申请被拒绝");
//                _isDetecting = false;
//                return 0;
//              }
//            }
//
//            String picpath = await SaveImages(
//                bytesList: image.planes.map((plane) {
//                  return plane.bytes;
//                }).toList(),
//                imageHeight: image.height,
//                imageWidth: image.width,
//                rotation: rotationImageRotationToInt(rotation),
//                faceX: xmin.toInt(),
//                faceY: ymin.toInt() ,
//                faceWidth: (xmax-xmin).toInt(),
//                faceHeight: (ymax-ymin).toInt());
//            /*print("getfeature1111111");
//            String feature = await GetFeature(
//                bytesList: image.planes.map((plane) {
//                  return plane.bytes;
//                }).toList(),
//                imageHeight: image.height,
//                imageWidth: image.width,
//                rotation: rotationImageRotationToInt(rotation),
//                faceX: xmin.toInt() < 0 ? 0 : xmin.toInt(),
//                faceY: ymin.toInt() < 0 ? 0 : ymin.toInt(),
//                faceWidth: (xmax-xmin).toInt(),
//                faceHeight: (ymax-ymin).toInt());
//            print("getfeature2222222");
//            print("facefeature:$feature，featurelength${feature.length}");
//            print("featurelength${feature.length}");
//            if (featurelast != null && featurelast.length > 100) {
//              print("getfeature44444333");
//              String score = await EvaluateScore(
//                feature1: featurelast,
//                feature2: feature,
//              );
//              print("getfeature55555555");
//              print("score:$score");
//            }*/
//
//            //featurelast = feature;
//
//            if (picpath == null || picpath.trim().length < 2) {
//              setMessage("保存图片失败");
//              _isDetecting = false;
//              return 0;
//            } else {
//              setMessage("人脸正常,检测到人脸数：$len，正在保存");
//              List<String> pathList = picpath.split(",");
//              _messaga == "人脸保存成功,即将跳转";
//              fullPicPath = pathList[0].toString();
//              facePicPath = pathList[1].toString();
//              detectFace = faces[maxFaceNum];
//              featureBase64 = await EncodeUtil.image2Base64(facePicPath);
//              if (_camera != null &&
//                  _camera.value.isInitialized &&
//                  _camera.value.isStreamingImages) {
//                await _camera.stopImageStream();
//                await _camera.dispose();
//                setState(() {
//                  _camera = null;
//                });
//              }
//              Navigator.pop(context);
//              return 0;
//            }
//          },
//        ).catchError(
//          (_) {
//            setMessage("请将人脸放入屏幕中心位置");
//            _isDetecting = false;
//          },
//        );
//      }
//    });
//  }
//
//  HandleDetection _getDetectionMethod() {
//    final faceDetector = FirebaseVision.instance.faceDetector(
//        FaceDetectorOptions(
//            enableClassification: true,
//            enableLandmarks: _isenableLandmarks,
//            enableContours: _isenableContours,
//            enableTracking: true));
//    return faceDetector.processImage;
//  }
//
//  Widget textWidget() {
//    return Container(
//      constraints: new BoxConstraints.expand(
//        height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 50.0,
//      ),
//      padding: const EdgeInsets.all(8.0),
//      alignment: Alignment.centerLeft,
//      child: new Text(_messaga,
//          style: Theme.of(context)
//              .textTheme
//              .display1
//              .copyWith(color: Colors.black)),
//    );
//  }
//
//  Widget _buildResults() {
//    const Text noResultsText = const Text('No results!');
//
//    if (_scanResults == null ||
//        _camera == null ||
//        !_camera.value.isInitialized) {
//      return noResultsText;
//    }
//
//    CustomPainter painter;
//
//    final Size imageSize = Size(
//      _camera.value.previewSize.height,
//      _camera.value.previewSize.width,
//    );
//
//    if (_scanResults is! List<Face>) {
//      return noResultsText;
//    }
//    String direction = "bak";
//    if (_direction == CameraLensDirection.front) direction = "front";
//    painter = FaceDetectorPainter(imageSize, _scanResults, direction, _messaga);
//    return CustomPaint(
//      painter: painter,
//    );
//  }
//
//  Widget _buildImage() {
//    return Container(
//      constraints: const BoxConstraints.expand(),
//      child: _camera == null
//          ? const Center(
//              child: Text(
//                '正在开启摄像头',
//                style: TextStyle(
//                  color: Colors.green,
//                  fontSize: 30.0,
//                ),
//              ),
//            )
//          : Stack(
//              fit: StackFit.expand,
//              children: <Widget>[
//                CameraPreview(_camera),
//                _buildResults(),
//              ],
//            ),
//    );
//  }
//
//  void _toggleCameraDirection() async {
//    if (_direction == CameraLensDirection.back) {
//      _direction = CameraLensDirection.front;
//    } else {
//      _direction = CameraLensDirection.back;
//    }
//
//    await _camera.stopImageStream();
//    await _camera.dispose();
//
//    setState(() {
//      _camera = null;
//    });
//
//    _initializeCamera();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        centerTitle: true,
//        automaticallyImplyLeading: false,
//        title:  Text(
//          '人脸识别',
//          style: TextStyle(color: Colors.black,
//              fontSize: ScreenUtil().setSp(40),
//              fontWeight:FontWeight.w500),
//        ),
//        backgroundColor: Colors.transparent,
//        elevation: 0.0,
//        leading: IconButton(
//            icon: Image.asset( "assets/images/btn_backs.png",
//              width: ScreenUtil().setSp(84),
//              height: ScreenUtil().setSp(84),
//              color: Colors.black,
//            ),
//            onPressed: () async {
//              if (_camera != null &&
//                  _camera.value.isInitialized &&
//                  _camera.value.isStreamingImages) {
//                await _camera.stopImageStream();
//                await _camera.dispose();
//
//                setState(() {
//                  _camera = null;
//                });
//              }
//
//              Navigator.pop(context);
//            }),
//        actions: <Widget>[
//          PopupMenuButton<Detector>(
//            onSelected: (Detector result) {
//              if (Detector.landmark == result)
//                _isenableLandmarks
//                    ? _isenableLandmarks = false
//                    : _isenableLandmarks = true;
//              else if (Detector.Contours == result)
//                _isenableContours
//                    ? _isenableContours = false
//                    : _isenableContours = true;
//              else if (Detector.face == result) _currentDetector = result;
//            },
//            itemBuilder: (BuildContext context) => <PopupMenuEntry<Detector>>[
//              const PopupMenuItem<Detector>(
//                child: Text('人脸识别'),
//                value: Detector.face,
//              ),
//              //const PopupMenuItem<Detector>(
//              //  child: Text('开启/关闭人脸特征点'),
//              //  value: Detector.landmark,
//              //),
//              //const PopupMenuItem<Detector>(
//              //  child: Text('开启/关闭人脸轮廓'),
//              //  value: Detector.Contours,
//              //),
//            ],
//          ),
//        ],
//      ),
//      body: _buildImage(),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _toggleCameraDirection,
//        child: _direction == CameraLensDirection.back
//            ? const Icon(Icons.camera_front)
//            : const Icon(Icons.camera_rear),
//      ),
//    );
//  }
//
//  static const MethodChannel _channel = const MethodChannel('Flutterimage');
//
//  static Future<String> SaveImages(
//      {@required List<Uint8List> bytesList,
//      int imageHeight = 1280,
//      int imageWidth = 720,
//      int rotation: 90, // Android only
//      int faceX,
//      int faceY,
//      int faceWidth,
//      int faceHeight}) async {
//    return await _channel.invokeMethod(
//      'SaveImages',
//      {
//        "bytesList": bytesList,
//        "imageHeight": imageHeight,
//        "imageWidth": imageWidth,
//        "rotation": rotation,
//        "faceX": faceX,
//        "faceY": faceY,
//        "faceWidth": faceWidth,
//        "faceHeight": faceHeight
//      },
//    );
//  }
//
//  static Future<String> LoadModel() async {
//    return await _channel.invokeMethod('LoadModel');
//  }
//
//  static Future<String> GetImageLight(
//      {@required List<Uint8List> bytesList,
//      int imageHeight = 1280,
//      int imageWidth = 720,
//      int rotation: 90, // Android only
//      int faceX,
//      int faceY,
//      int faceWidth,
//      int faceHeight}) async {
//    return await _channel.invokeMethod(
//      'GetImageLight',
//      {
//        "bytesList": bytesList,
//        "imageHeight": imageHeight,
//        "imageWidth": imageWidth,
//        "rotation": rotation,
//        "faceX": faceX,
//        "faceY": faceY,
//        "faceWidth": faceWidth,
//        "faceHeight": faceHeight
//      },
//    );
//  }
//
//  static Future<String> GetFeature(
//      {@required List<Uint8List> bytesList,
//      int imageHeight = 1280,
//      int imageWidth = 720,
//      int rotation: 90, // Android only
//      int faceX,
//      int faceY,
//      int faceWidth,
//      int faceHeight}) async {
//    return await _channel.invokeMethod(
//      'GetFeature',
//      {
//        "bytesList": bytesList,
//        "imageHeight": imageHeight,
//        "imageWidth": imageWidth,
//        "rotation": rotation,
//        "faceX": faceX,
//        "faceY": faceY,
//        "faceWidth": faceWidth,
//        "faceHeight": faceHeight
//      },
//    );
//  }
//
//  static Future<String> DeSpoofing(
//      {@required List<Uint8List> bytesList,
//      int imageHeight = 1280,
//      int imageWidth = 720,
//      int rotation: 90, // Android only
//      int faceX,
//      int faceY,
//      int faceWidth,
//      int faceHeight}) async {
//    return await _channel.invokeMethod(
//      'DeSpoofing',
//      {
//        "bytesList": bytesList,
//        "imageHeight": imageHeight,
//        "imageWidth": imageWidth,
//        "rotation": rotation,
//        "faceX": faceX,
//        "faceY": faceY,
//        "faceWidth": faceWidth,
//        "faceHeight": faceHeight
//      },
//    );
//  }
//
//  static Future<String> EvaluateScore({
//    String feature1,
//    String feature2,
//  }) async {
//    return await _channel.invokeMethod(
//      'EvaluateScore',
//      {
//        "feature1": feature1,
//        "feature2": feature2,
//      },
//    );
//  }
//
//  Future<void> _getBatteryLevel() async {
//    String batteryLevel;
//    try {
//      final int result = await _channel.invokeMethod('getBatteryLevel');
//      batteryLevel = 'Battery level at $result % .';
//    } on PlatformException catch (e) {
//      batteryLevel = "Failed to get battery level: '${e.message}'.";
//    }
//  }
//}
//
//int rotationImageRotationToInt(ImageRotation rotation) {
//  switch (rotation) {
//    case ImageRotation.rotation0:
//      return 0;
//    case ImageRotation.rotation90:
//      return 90;
//    case ImageRotation.rotation180:
//      return 180;
//    default:
//      return 270;
//  }
//}
//
//Rect _scaleRect(
//    {@required Rect rect,
//    @required Size imageSize,
//    @required Size widgetSize,
//    @required String direct}) {
//  final double scaleX = widgetSize.width / imageSize.width;
//  final double scaleY = widgetSize.height / imageSize.height;
//  painterWidgetWidth = widgetSize.width;
//  painterWidgetHeiht = widgetSize.height;
//
//  return Rect.fromLTRB(
//    rect.left < 0 ? 0 : rect.left.toDouble() * scaleX,
//    rect.top < 0 ? 0 : rect.top.toDouble() * scaleY,
//    rect.right < 0 ? 0 : rect.right.toDouble() * scaleX,
//    rect.bottom < 0 ? 0 : rect.bottom.toDouble() * scaleY,
//  );
//}
//
////调用方法
///*String imagepath=await ConvertImage(
//                  bytesList: img.planes.map((plane) {
//                    return plane.bytes;
//                  }).toList(),
//                  imageHeight: img.height,
//                  imageWidth: img.width,
//                  rotation: rotationImageRotationToInt(rotation)
//              );
//              print('imagepath:$imagepath');
//              if(imagepath==null)
//                {
//                  isDetecting = false;
//                  return;
//                }*/
