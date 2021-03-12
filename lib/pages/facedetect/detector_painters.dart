//// Copyright 2018 The Chromium Authors. All rights reserved.
//// Use of this source code is governed by a BSD-style license that can be
//// found in the LICENSE file.
//
//import 'dart:ui' as ui;
//
//import 'package:firebase_ml_vision/firebase_ml_vision.dart';
//import 'package:flutter/foundation.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_canteen/config/param.dart';
//
//enum Detector {face,landmark,Contours}
//
//
//class FaceDetectorPainter extends CustomPainter {
//  FaceDetectorPainter(this.imageSize, this.faces,this.direct,this.message);
//
//  final Size imageSize;
//  final List<Face> faces;
//  final String direct;
//  final String message;
//
//  @override
//  void paint(Canvas canvas, Size size) {
//    final Paint paint = Paint()
//      ..style = PaintingStyle.stroke
//      ..strokeWidth = 2.5
//      ..color = Colors.red;
//
//
//    final Paint paintcenter = Paint()
//      ..style = PaintingStyle.stroke
//      ..strokeWidth = 2.5
//      ..color = Colors.green;
//
//    Rect centerrect=new Rect.fromLTWH(painterWidgetWidth/4,painterWidgetHeiht/4,painterWidgetWidth/2,painterWidgetHeiht/2 );
//
//    canvas.drawRect(
//      centerrect,
//      paintcenter,
//    );
//
//    for (Face face in faces) {
//      Rect facerealRect= _scaleRect(
//        rect: face.boundingBox,
//        imageSize: imageSize,
//        widgetSize: size,
//        direct:direct
//      );
//
//
//
//      canvas.drawRect(
//        facerealRect,
//        paint,
//      );
//
//
//
//      final double scaleX = size.width / imageSize.width;
//      final double scaleY = size.height / imageSize.height;
//      List<Offset> pointstemp=new List();
//      for(Offset point in face.getContour(FaceContourType.allPoints).positionsList)
//        {
//          Offset ponittemp=new Offset(direct=="bak"||defaultTargetPlatform == TargetPlatform.iOS?(point.dx*scaleX):(imageSize.width-point.dx)*scaleX, point.dy*scaleY);
//          pointstemp.add(ponittemp);
//        }
//      //描轮廓点
//      canvas.drawPoints(
//        ///PointMode的枚举类型有三个，points（点），lines（线，隔点连接），polygon（线，相邻连接）
//          ui.PointMode.points,
//          pointstemp,
//          paint..color = Colors.lightBlueAccent);
//
//      String angley="左右偏转";
//      String anglez="上下偏转";
//      String otherinfo1=face.leftEyeOpenProbability>0.5?"左眼张开:是,分数${face.leftEyeOpenProbability.toStringAsFixed(2)}\n":"左眼张开:否,分数${face.leftEyeOpenProbability.toStringAsFixed(2)}\n";
//      otherinfo1 += face.rightEyeOpenProbability>0.5?"右眼张开:是,分数${face.rightEyeOpenProbability.toStringAsFixed(2)}\n":"右眼张开:否,分数${face.rightEyeOpenProbability.toStringAsFixed(2)}\n";
//      String otherinfo2=face.smilingProbability>0.5?"是否微笑:是,分数${face.smilingProbability.toStringAsFixed(2)}\n":"是否微笑:否,分数${face.smilingProbability.toStringAsFixed(2)}\n";
//      otherinfo2 +="跟踪ID:${face.trackingId}";
//
//      if(face.headEulerAngleY<0.0)
//      {
//        angley="左偏${face.headEulerAngleY.toStringAsFixed(2)}度";
//      }
//      else if(face.headEulerAngleY>0.0)
//      {
//        angley="右偏${face.headEulerAngleY.toStringAsFixed(2)}度";
//      }
//
//      if(face.headEulerAngleZ>0.0)
//      {
//        anglez="下偏${face.headEulerAngleZ.toStringAsFixed(2)}度";
//      }
//      else if(face.headEulerAngleZ<0.0)
//      {
//        anglez="上偏${face.headEulerAngleZ.toStringAsFixed(2)}度";
//      }
//
//      ui.ParagraphBuilder pb = ui.ParagraphBuilder(ui.ParagraphStyle(
//        textAlign: TextAlign.left,
//        fontWeight: FontWeight.w300,
//        fontStyle: FontStyle.italic,
//        fontSize: 10.0,
//      ));
//      pb.pushStyle(ui.TextStyle(color: Colors.blue));
//      pb.addText('${angley}\n ${anglez}\n$otherinfo1$otherinfo2');
//      // 设置文本的宽度约束
//      ui.ParagraphConstraints pc = ui.ParagraphConstraints(width: 300);
//      // 这里需要先layout,将宽度约束填入，否则无法绘制
//      ui.Paragraph paragraph = pb.build()..layout(pc);
//      // 文字左上角起始点
//      Offset offset = Offset(direct=="bak"||defaultTargetPlatform == TargetPlatform.iOS?facerealRect.bottomLeft.dx:facerealRect.bottomRight.dx, direct=="bak"?facerealRect.bottomLeft.dy:facerealRect.bottomRight.dy);
//      canvas.drawParagraph(paragraph, offset);
//
//    }
//
//    ui.ParagraphBuilder pd = ui.ParagraphBuilder(ui.ParagraphStyle(
//      textAlign: TextAlign.left,
//      fontWeight: FontWeight.w300,
//      fontStyle: FontStyle.italic,
//      fontSize: 30.0,
//    ));
//    pd.pushStyle(ui.TextStyle(color: Colors.pink));
//    pd.addText('$message');
//    ui.ParagraphConstraints pe = ui.ParagraphConstraints(width: 300);
//    ui.Paragraph paragrapf = pd.build()..layout(pe);
//    Offset offset2 = Offset(20,100);
//    canvas.drawParagraph(paragrapf, offset2);
//  }
//
//  @override
//  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
//    return oldDelegate.imageSize != imageSize || oldDelegate.faces != faces;
//  }
//}
//
//
//Rect _scaleRect({
//  @required Rect rect,
//  @required Size imageSize,
//  @required Size widgetSize,
//  @required String direct
//}) {
//  final double scaleX = widgetSize.width / imageSize.width;
//  final double scaleY = widgetSize.height / imageSize.height;
//  painterWidgetWidth=widgetSize.width;
//  painterWidgetHeiht=widgetSize.height;
//  return direct=="bak"||defaultTargetPlatform == TargetPlatform.iOS?Rect.fromLTRB(
//    rect.left<0?0:rect.left.toDouble() * scaleX,
//    rect.top<0?0:rect.top.toDouble() * scaleY,
//    rect.right<0?0:rect.right.toDouble() * scaleX,
//    rect.bottom<0?0:rect.bottom.toDouble() * scaleY,
//  ):Rect.fromLTRB(
//    (imageSize.width-rect.left.toDouble())<0?0:(imageSize.width-rect.left.toDouble()) * scaleX,
//    rect.top<0?0:rect.top.toDouble() * scaleY,
//    (imageSize.width-rect.right.toDouble())<0?0:(imageSize.width-rect.right.toDouble()) * scaleX,
//    rect.bottom<0?0:rect.bottom.toDouble() * scaleY,
//  );
//}
