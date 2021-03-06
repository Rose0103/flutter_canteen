import 'package:flutter/material.dart';
import 'package:flutter_canteen/provide/detail_comment.dart';
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

class DetailsCommentsWeb extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var foodsDetail = Provide
        .value<DetailsCommentProvide>(context)
        .foodsInfo
        .data
        .foodInfo.dishDesc;


    return Provide<DetailsCommentProvide>(

      builder: (context, child, val) {
        var isLeft = Provide
            .value<DetailsCommentProvide>(context)
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
    return Provide<DetailsCommentProvide>(
      builder: (context,child,data){
        try{
          if(Provide.value<DetailsCommentProvide>(context).page==1){
            if (scrollController.hasClients) {
              scrollController.animateTo(
                0.0,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300),
              );
            }
          }
        }catch(e){
          print('?????????????????????????????????${e}');
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
                      noMoreText:Provide.value<DetailsCommentProvide>(context).noMoreText,
                      moreInfo:'?????????',
                      loadReadyText:'????????????'
                  ),
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: data.commentlist.length,
                    itemBuilder: (context,index){
                      return _ListWidget(data.commentlist,index);
                    },
                  ) ,
                  loadMore: ()async{
                    if(Provide.value<DetailsCommentProvide>(context).noMoreText=='???????????????'){
                      Fluttertoast.showToast(
                          msg: "???????????????",
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
          return  Text('??????????????????');
        }
      },

    );
  }

  //???????????????????????????
  void _getMoreList(){
    Provide.value<DetailsCommentProvide>(context).addPage();
    var data={
      'start':(Provide.value<DetailsCommentProvide>(context).page-1)*10,
      'end':(Provide.value<DetailsCommentProvide>(context).page-1)*10+9
    };

    request('foodEvaluation', '',formData:data ).then((val){
      if(val.toString()=="false")
      {
        return;
      }
      var  data = val;
      foodDetails foodsInfo=  foodDetails.fromJson(data);

      if(foodsInfo.data.foodComments==null){
        Provide.value<DetailsCommentProvide>(context).changeNoMore('???????????????');
      }else{
        Provide.value<DetailsCommentProvide>(context).addCommentsList(foodsInfo);
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
                  _userName(newList[index].user_id, newList[index].create_time),


                  _splitLine()
                ],

          ),
        )
    );

  }

  //????????????
  Widget _userName(userName,time) {
    String strtime=time.replaceAll("T", " ").split(".")[0];
    return Container(
      width: ScreenUtil().setSp(730),
      //padding: EdgeInsets.only(left: 15.0),
      //margin: EdgeInsets.only(top: 8.0),
      child: Row(
        children: <Widget>[
          Text(
            '?????????${userName}',
            style: TextStyle(
              color: Colors.pinkAccent,
              fontSize: ScreenUtil().setSp(25),
            ),
          ),
          Expanded(
              child: Container(
                height: 80.0,
                alignment: Alignment.centerRight,
                child:  Text('$strtime',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: ScreenUtil().setSp(25))),
              )),
        ],
      ),
    );
  }

  //????????????
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

  //????????????
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

  //?????????
  Widget _splitLine()
  {
    return Divider(
      height: 4.0,
      indent: 0.0,
      color: Colors.red,
    );
  }


}
