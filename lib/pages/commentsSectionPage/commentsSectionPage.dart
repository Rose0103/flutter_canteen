import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/model/commentsSectionModel.dart';
import 'package:flutter_canteen/pages/HomePage/loginOrRegister.dart';
import 'package:flutter_canteen/pages/detailPages/detail_web.dart';
import 'package:flutter_canteen/pages/mineOrderPage/mineOrderItem.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_canteen/otherfunction/EncodeUtil.dart';
import 'addCommentsPage.dart';
import 'comments_detail_web.dart';
import 'comments_item.dart';
import 'comments_section_card.dart';

class CommentsSectionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CommentsSectionPageState();
  }
}

class CommentsSectionPageState extends State<CommentsSectionPage> {
  List<CommentsItem> children = [];
  var _futureBuilderFuture;
  Future listData;
  bool isfirstload = true;
  var lastday = DateTime.now(); //最前日期
  int i = 0;
  int start = 0;
  int end = 10;
  bool isfirst=true;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Widget buildEmpty() {
    return Container(
      width: double.infinity, //宽度为无穷大
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "assets/images/empty1.png",
            fit: BoxFit.cover,
          ),
          Text(
            "没数据,请下拉刷新",
            maxLines: 1,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              height: 1.2,
              decoration: TextDecoration.none,
              decorationStyle: TextDecorationStyle.dashed,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        color: Colors.white,
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: Image.asset(
                    "assets/images/btn_backs.png",
                    width: ScreenUtil().setSp(84),
                    height: ScreenUtil().setSp(84),
                    color: Colors.black,
                  ),
                  onPressed: () {
                    children.clear();
                    Navigator.pop(context);
                  }),
              centerTitle: true,
              title: Text(
                '评论区',
                style: TextStyle(color: Colors.black,
                    fontSize: ScreenUtil().setSp(40),
                    fontWeight:FontWeight.w500),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              brightness: Brightness.dark,
              /*   elevation: 0.0,*/
              actions: <Widget>[
                IconButton(
                  //btn_add_selected
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if(isYouKe){
                      showDialog(
                          context: context,
                          builder: (context){
                            return LoginOrRegister();
                          }
                      );
                      return;
                    }
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddCommentsPage()));
                  },
                ),
                /* InkWell(
                  child: Text(
                    "评论",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {},
                )*/
              ],
            ),
            body:FutureBuilder(
              future:_futureBuilderFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData ) {
                  CommentsSectionModel commentsSectionModel = CommentsSectionModel.fromJson(snapshot.data);
                  if (commentsSectionModel.data.length != 0&&isfirst) {
                    for (int i = 0; i < commentsSectionModel.data.length; i++) {
                      CommentsItem commentsItem = new CommentsItem();
                      commentsItem.user_id__user_name = commentsSectionModel.data[i].userName;
                      commentsItem.user_id = commentsSectionModel.data[i].userId;
                      // print(commentsSectionModel.data[i].boardContent);
                      try{
                        commentsItem.board_content = EncodeUtil.decodeBase64(commentsSectionModel.data[i].boardContent);
                      }catch(e){
                        commentsItem.board_content = commentsSectionModel.data[i].boardContent;
                      }
                      commentsItem.create_time = commentsSectionModel.data[i].createTime;
                      commentsItem.board_type = commentsSectionModel.data[i].boardType;
                      if (commentsItem.board_type == 0) {
                        commentsItem.user_id__user_name = "匿名";
                      }
                      children.add(commentsItem);
                    }
                    start = end;
                    end = start + 10;
                    isfirst=false;
                  }
                  return SmartRefresher(
                    controller: _refreshController,
                    enablePullUp: true,
                    enablePullDown: true,
                    footer: CustomFooter(
                      builder: (BuildContext context, LoadStatus mode) {
                        Widget body;
                        if (mode == LoadStatus.idle) {
                          body = Text("上拉加载");
                        } else if (mode == LoadStatus.loading) {
                          body = CupertinoActivityIndicator();
                        } else if (mode == LoadStatus.failed) {
                          body = Text("加载失败！点击重试！");
                        } else if (mode == LoadStatus.canLoading) {
                          body = Text("松手,加载更多!");
                        } else {
                          body = Text("没有更多数据了!");
                        }
                        return Container(
                          height: 55.0,
                          child: Center(child: body),
                        );
                      },
                    ),
                    onLoading: () async {
                      await _onLoading();
                    },
                    onRefresh: () async {
                      await _onRefresh();
                    },
                    child: children.length == 0
                        ? buildEmpty()
                        : ListView.builder(
                      itemBuilder: (c, i) => new CommentsSectionCard(
                          children.elementAt(i)),
                      itemCount: children.length,
                    ),
                  );
                } else {
                return Center(
                child: Text('加载中……',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil.getInstance().setSp(24))));
                }
              },
            )));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _futureBuilderFuture= _getBuildFuture() ;
  }

  Future _getBuildFuture() {
    return requestGet('boardContent', "?start=$start&end=$end&canteen_id=$canteenID");
  }

  void _onLoading() async {
    // monitor network fetch

    // if failed,use loadFailed(),if no data return,use LoadNodata()
    /*if (mounted) setState(() {});
    _refreshController.loadNoData();*/

    // _refreshController.loadComplete();
    getList();
    setState(() {

    });

  }

  void _onRefresh() async {
    // monitor network fetch
    start = 0;
    end = 10;

    getList();
    // _refreshController.loadComplete();
  }

  Future getList() async {
    var params = "?start=$start&end=$end&canteen_id=$canteenID";
    await requestGet('boardContent', params).then((val) {
      CommentsSectionModel commentsSectionModel =
          CommentsSectionModel.fromJson(val);
      setState(() {
        if (start == 0) {
          _refreshController.refreshCompleted();
          _refreshController.loadComplete();
          children.clear();
        }
        if (commentsSectionModel.data.length != 0) {
          for (int i = 0; i < commentsSectionModel.data.length; i++) {
            CommentsItem commentsItem = new CommentsItem();
            commentsItem.user_id__user_name =
                commentsSectionModel.data[i].userName;
            commentsItem.user_id = commentsSectionModel.data[i].userId;
            try{
              commentsItem.board_content = EncodeUtil.decodeBase64(commentsSectionModel.data[i].boardContent);
            }catch(e){
              commentsItem.board_content = commentsSectionModel.data[i].boardContent;
            }
            commentsItem.create_time = commentsSectionModel.data[i].createTime;
            commentsItem.board_type = commentsSectionModel.data[i].boardType;
            if (commentsItem.board_type == 0) {
              commentsItem.user_id__user_name = "匿名";
            }
            children.add(commentsItem);
          }
          if (start != 0) {
            _refreshController.loadComplete();
          }
        } else {
          _refreshController.loadNoData();
        }
        start = end;
        end = start + 10;
      });
    });
  }
}
