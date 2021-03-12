
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/pages/detailPages/detail_web.dart';
import 'package:flutter_canteen/pages/mineOrderPage/mineOrderItem.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_canteen/otherfunction/EncodeUtil.dart';
import 'package:flutter_canteen/pages/commentsSectionPage/commentsSectionPage.dart';
import 'comments_detail_web.dart';
import 'comments_item.dart';
import 'comments_section_card.dart';

class AddCommentsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddCommentsPageState();
  }
}

class AddCommentsPageState extends State<AddCommentsPage> {
  TextEditingController _textEditingController = new TextEditingController();
  int board_type = 1;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
          '评论',
          style: TextStyle(color: Colors.black,
              fontSize: ScreenUtil().setSp(40),
              fontWeight:FontWeight.w500),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.dark,
      ),
      resizeToAvoidBottomPadding: false,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());//触摸收起键盘
        },
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              selectAnonymity(),
              inputWidget(),
              submitButton(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget selectAnonymity() {
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setSp(60)),
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setHeight(100), 0, ScreenUtil().setHeight(20), 0),
      child: Row(
        children: <Widget>[
//          Text("匿名："),
//          Radio(
//            value: 0,
//            groupValue: this.board_type,
//            onChanged: (value) {
//              setState(() {
//                this.board_type = value;
//              });
//            },
//          ),
//          SizedBox(width: 20),
          Text("非匿名："),
          Radio(
            value: 1,
            groupValue: this.board_type,
            onChanged: (value) {
              setState(() {
                this.board_type = value;
              });
            },
          )
        ],
      ),
    );
  }

  Widget submitButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      width: ScreenUtil().setSp(500),
      child: RaisedButton(
          child: Text("提交评论"),
          color: Theme.of(context).primaryColor,
          highlightColor: Theme.of(context).primaryColor,
          colorBrightness: Brightness.dark,
          splashColor: Colors.grey,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          onPressed: () async {
            await putSubmit();
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CommentsSectionPage()));
          }),
    );
  }

  Widget inputWidget() {
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setSp(80)),
      width: ScreenUtil().setSp(600),
      height: ScreenUtil().setSp(360),
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setSp(20), 0, ScreenUtil().setSp(20), 0),
      child: TextField(
        maxLines: 6,
        maxLength: 50,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '请输入评论内容',
//          设置输入框前面有一个电话的按钮 suffixIcon
          labelStyle: TextStyle(
              fontSize: 14,
              color: Colors.grey
          ),
        ),
        controller: _textEditingController,
      ),
      decoration: BoxDecoration(
        border: Border.all(color:Colors.grey,width: 1)
      ),
    );
  }

  Future putSubmit() async {
    if (_textEditingController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "请输入评论内容");
      return;
    }
    var formData = {
      'board_content': EncodeUtil.encodeBase64(_textEditingController.text.trim()),
      'board_type': this.board_type,
      'canteen_id': canteenID,
    };
    await requestPut('boardContent', '', formData: formData).then((val) {
      Fluttertoast.showToast(msg: "提交成功");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
}
