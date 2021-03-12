import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_canteen/otherfunction/RatingBar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'comments_item.dart';

class CommentsSectionCard extends StatefulWidget {
  CommentsItem commentsItem;

  CommentsSectionCard(@required this.commentsItem);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CommentsSectionCardState(commentsItem);
  }
}

class CommentsSectionCardState extends State<CommentsSectionCard> {
  CommentsItem commentsItem;

  CommentsSectionCardState(@required this.commentsItem);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
        onTap: () {
          // Appliaction.router.navigateTo(context,"/detail?id=${newList[index].foodsId}");
        },
        child: Container(
          width: ScreenUtil().setSp(730),
          padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.black12))),
          child: Column(
            children: <Widget>[_foodsComment(), _userName(), _splitLine()],
          ),
        ));
    ;
  }

  //菜品评论
  Widget _foodsComment() {
    return Container(
      width: ScreenUtil().setSp(730),
      //padding: EdgeInsets.only(left: 15.0),
      //margin: EdgeInsets.only(top: 8.0),
      child: Text(
        '${commentsItem.board_content}',
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  //分割线
  Widget _splitLine() {
    return Divider(
      height: 4.0,
      indent: 0.0,
      color: Colors.red,
    );
  }

  //评论用户
  Widget _userName() {
    String time=commentsItem.create_time;
    String strtime=time.replaceAll("T", " ").split(".")[0];
    return Container(
      width: ScreenUtil().setSp(730),
      //padding: EdgeInsets.only(left: 15.0),
      //margin: EdgeInsets.only(top: 8.0),
      child: Row(
        children: <Widget>[
          Text(
            '用户：${commentsItem.user_id__user_name}',
            style: TextStyle(
              color: Colors.pinkAccent,
              fontSize: ScreenUtil().setSp(25),
            ),
          ),
          Expanded(
              child: Container(
            height: 80.0,
            alignment: Alignment.centerRight,
            child: Text('$strtime',
                style: TextStyle(
                    color: Colors.black54, fontSize: ScreenUtil().setSp(25))),
          )),
        ],
      ),
    );
  }
}
