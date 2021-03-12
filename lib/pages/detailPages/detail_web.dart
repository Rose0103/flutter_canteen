import 'package:flutter/material.dart';
import 'package:flutter_canteen/provide/detail_info.dart';
import 'package:provide/provide.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_canteen/otherfunction/RatingBar.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_canteen/model/details.dart';
import 'package:flutter_canteen/config/param.dart';
import 'dart:convert';

class DetailsWeb extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var foodsDetail = Provide
        .value<DetailsInfoProvide>(context)
        .foodsInfo
        .data
        .foodInfo.dishDesc;


    return Provide<DetailsInfoProvide>(

      builder: (context, child, val) {
        var isLeft = Provide
            .value<DetailsInfoProvide>(context)
            .isLeft;
        if (isLeft) {
          return Container(
            child: Html(
                data: foodsDetail
            ),
          );
        } else {
          return Container(
              width: ScreenUtil().setSp(750),
              padding: EdgeInsets.all(20),
              alignment: Alignment.center,
              child:CommentList()
              );
        }
      },
    );
  }

}

class CommentList extends StatefulWidget {
  @override
  _CommentListState createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {

  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();
  var scrollController=new ScrollController();


  @override
  Widget build(BuildContext context) {
    return Provide<DetailsInfoProvide>(
      builder: (context,child,data){
        try{
          if(Provide.value<DetailsInfoProvide>(context).page==1){
            if (scrollController.hasClients) {
              scrollController.animateTo(
                0.0,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300),
              );
            }
          }
        }catch(e){
          print('进入页面第一次初始化：${e}');
        }

        if(data.commentlist!= null){
          return Container(
               constraints: BoxConstraints.tightFor(width:ScreenUtil().setSp(730),height:ScreenUtil().setSp(500)),
                width: ScreenUtil().setSp(570) ,
                child:EasyRefresh(
                  refreshFooter: ClassicsFooter(
                      key:_footerKey,
                      bgColor:Colors.white,
                      textColor:Colors.pink,
                      moreInfoColor: Colors.pink,
                      showMore:true,
                      noMoreText:Provide.value<DetailsInfoProvide>(context).noMoreText,
                      moreInfo:'加载中',
                      loadReadyText:'上拉加载'
                  ),
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: data.commentlist.length,
                    itemBuilder: (context,index){
                      return _ListWidget(data.commentlist,index);
                    },
                  ) ,
                  loadMore: ()async{
                    if(Provide.value<DetailsInfoProvide>(context).noMoreText=='没有更多了'){
                      Fluttertoast.showToast(
                          msg: "已经到底了",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIos: floaststaytime,
                          backgroundColor: Colors.pink,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }else{

                      _getMoreList();
                    }

                  },
                )

            ) ;

        }else{
          return  Text('暂时没有数据');
        }
      },

    );
  }

  //上拉加载更多的方法
  void _getMoreList(){

    Provide.value<DetailsInfoProvide>(context).addPage();
    var data={
      'dish_id':Provide.value<DetailsInfoProvide>(context).foodsInfo.data.foodInfo.dishId,
      'start_position':(Provide.value<DetailsInfoProvide>(context).page-1)*10,
      'end_position':(Provide.value<DetailsInfoProvide>(context).page-1)*10+9
    };

    request('foodEvaluation', '',formData:data ).then((val){
      if(val.toString()=="false")
      {
        return;
      }
      var  data = val;
      foodDetails foodsInfo=  foodDetails.fromJson(data);

      if(foodsInfo.data.foodComments==null){
        Provide.value<DetailsInfoProvide>(context).changeNoMore('没有更多了');
      }else{
        Provide.value<DetailsInfoProvide>(context).addCommentsList(foodsInfo);
      }
    });


  }



  Widget _ListWidget(List<foodDetailsDataFoodComments> newList,int index){

    return InkWell(
        onTap: (){
         // Appliaction.router.navigateTo(context,"/detail?id=${newList[index].foodsId}");
        },
        child: Container(
          width: ScreenUtil().setSp(730),
          padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(width: 1.0,color: Colors.black12)
              )
          ),

          child:
              Column(
                children: <Widget>[
                  _foodsScore(newList[index].dish_score),
                  _foodsComment(newList[index].comment_details),
                  //modify by lilixia   2020-11-23
                  _userName(newList[index].user_name, newList[index].create_time),


                  _splitLine()
                ],

          ),
        )
    );

  }

  //评论用户
  Widget _userName(userName,time) {
    return Container(
      width: ScreenUtil().setSp(730),
      //padding: EdgeInsets.only(left: 15.0),
      //margin: EdgeInsets.only(top: 8.0),
      child: Row(
        children: <Widget>[
          Text(
            '用户：${userName}',
            style: TextStyle(
              color: Colors.pinkAccent,
              fontSize: ScreenUtil().setSp(25),
            ),
          ),
          Expanded(
              child: Container(
                height: 80.0,
                alignment: Alignment.centerRight,
                child:  Text('${time.toString()}',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: ScreenUtil().setSp(25))),
              )),
        ],
      ),
    );
  }

  //菜品分数
  Widget _foodsScore(score) {
    return Container(
      width: ScreenUtil().setSp(730),
      //padding: EdgeInsets.only(left: 5.0),
      child: Row(
        children: <Widget>[
          RatingBar(
                clickable: false,
                size: 15,
                color: Colors.yellow,
                padding: 5,
                value: double.parse(score.toString()),
              ),
        ],
      ),
    );
  }

  //菜品评论
  Widget _foodsComment(comment) {
    return Container(
      width: ScreenUtil().setSp(730),
      //padding: EdgeInsets.only(left: 15.0),
      //margin: EdgeInsets.only(top: 8.0),
      child: Text(
        '${comment}',
        style: TextStyle(
            color: Colors.black
        ),
      ),
    );
  }

  //分割线
  Widget _splitLine()
  {
    return Divider(
      height: 4.0,
      indent: 0.0,
      color: Colors.red,
    );
  }


}
