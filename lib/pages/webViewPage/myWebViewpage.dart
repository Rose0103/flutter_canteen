import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
//import 'package:webview_flutter/webview_flutter.dart';

class myWebViewPage extends StatefulWidget {
  Uri url;
  String title;

  myWebViewPage(this.url, this.title);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return myWebViewState(url, title);
  }
}

class myWebViewState extends State<myWebViewPage> {
  Uri url;
  String title;

  //WebViewController _controller;

  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();

  double lineProgress = 0.0;

  myWebViewState(this.url, this.title);

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.onProgressChanged.listen((progress) {
      print(progress);
      setState(() {
        lineProgress = progress;
      });
    });
  }

    @override
    void dispose() {
      flutterWebviewPlugin.dispose();
      super.dispose();
    }

  _progressBar(double progress, BuildContext context) {
    return LinearProgressIndicator(
      backgroundColor: Colors.white70.withOpacity(0),
      value: progress == 1.0 ? 0 : progress,
      valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
    );
  }

    @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Image.asset(
                  "assets/images/btn_backs.png",
                  width: ScreenUtil().setWidth(84),
                  height: ScreenUtil().setWidth(84),
                  color: Colors.black,
                ),
                onPressed: () {
                  return Navigator.pop(context);
                }),
            centerTitle: true,
            title: Text(
              title,
              style: TextStyle(color: Colors.black,
                  fontSize: ScreenUtil().setSp(40),
                  fontWeight:FontWeight.w500),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            bottom: PreferredSize(
              child: _progressBar(lineProgress, context),
              preferredSize: Size.fromHeight(3.0),
            ),
          ),
        body:Container(
        padding:EdgeInsets.fromLTRB(ScreenUtil().setSp(10.0), ScreenUtil().setSp(0.0), ScreenUtil().setSp(0.0), ScreenUtil().setSp(0.0)),
        child:WebviewScaffold(
        url: url.toString(),
        useWideViewPort: true,
        displayZoomControls:true,
        withOverviewMode: true,
        clearCache:true,
        ignoreSSLErrors:true,
      )));
    }

}


