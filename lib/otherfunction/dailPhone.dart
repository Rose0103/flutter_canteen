import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DailPhone extends StatelessWidget {
  String userImage;    //用户图片
  String userPhone;    //用户电话
  
  DailPhone({Key key,this.userImage,this.userPhone}):super(key:key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launchURL,
        child: Image.network(userImage),
      ),
    );
  }

  void _launchURL() async{
    String url='tel:'+userPhone;
    if(await canLaunch(url)){
      await launch(url);
    }else{
      throw 'url不能进行访问，异常';
    }
  }
}

