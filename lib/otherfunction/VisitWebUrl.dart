import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VisitWebUrl extends StatelessWidget {
  String URLImage;    //用户图片
  String URLAddress;    //用户电话

  VisitWebUrl({Key key,this.URLImage,this.URLAddress}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launchURL,
        child: Image.network(URLImage),
      ),
    );
  }

  void _launchURL() async{
    String url=URLAddress;
    if(await canLaunch(url)){
      await launch(url);
    }else{
      throw 'url不能进行访问，异常';
    }
  }
}