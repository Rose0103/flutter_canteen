import 'package:flutter/material.dart';
import 'package:flutter_canteen/common/database_helper.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/model/canteenModel.dart';
import 'package:flutter_canteen/model/userandCanteen.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'muliti_normal_select_choice.dart';
import 'muliti_select_choice.dart';
import 'base_select_entity.dart';
import 'package:flutter_canteen/router/application.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_canteen/provide/habbit.dart';
import '../../../common/shared_preference.dart';
import 'package:provide/provide.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_canteen/pages/manager_index_page.dart';
import 'package:flutter_canteen/pages/client_index_page.dart';
import 'package:flutter_canteen/otherfunction/showDialog.dart';

class MyChoicePage extends StatefulWidget {
  MyChoicePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyChoicePageState createState() => _MyChoicePageState();
}

class _MyChoicePageState extends State<MyChoicePage> {
  List<TestSelectEntity> selectList = new List();

  List<TestSelectEntity> allList = new List();
  String habbits;
  bool iscommit=false;
  bool isfirstload=true;
  DateTime lastPopTime=null;
  DatabaseHelper db;

  void initState() {
    db = new DatabaseHelper();
    super.initState();
  }

  void initData() {
    habbits = Provide.value<GetHabbitDataProvide>(context).habbitdata.data.userHobby;
    List<TestSelectEntity> tempselectList=new List();
    TestSelectEntity selcttitle1=TestSelectEntity(title: "吃辣    ",id:"1");
    TestSelectEntity selcttitle2=TestSelectEntity(title: "不吃辣",id:"2");
    TestSelectEntity selcttitle3=TestSelectEntity(title: "爱素食",id:"3");
    TestSelectEntity selcttitle4=TestSelectEntity(title: "爱荤菜",id:"4");
    TestSelectEntity selcttitle5=TestSelectEntity(title: "偏咸    ",id:"5");
    TestSelectEntity selcttitle6=TestSelectEntity(title: "偏淡    ",id:"6");
    if(habbits!=null)
    {
      selectList.clear();
      List<String> listhabbit=habbits.split(",");

      for(int i=0;i<listhabbit.length;i++)
      {
        if(listhabbit[i]=="1")
          tempselectList.add(selcttitle1);
        else if(listhabbit[i]=="2")
          tempselectList.add(selcttitle2);
        else if(listhabbit[i]=="3")
          tempselectList.add(selcttitle3);
        else if(listhabbit[i]=="4")
          tempselectList.add(selcttitle4);
        else if(listhabbit[i]=="5")
          tempselectList.add(selcttitle5);
        else if(listhabbit[i]=="6")
          tempselectList.add(selcttitle6);

      }
    }
    allList.clear();
    allList.add(selcttitle1);
    allList.add(selcttitle2);
    allList.add(selcttitle3);
    allList.add(selcttitle4);
    allList.add(selcttitle5);
    allList.add(selcttitle6);

    for(int i=0;i<tempselectList.length;i++)
    {
      selectList.add(tempselectList[i]);
    }
  }

//返回箭头按钮
  Widget backButtonWidget() {
    return Container(
        alignment: Alignment.bottomLeft,
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setSp(0.0),
            ScreenUtil().setSp(50.0),
            ScreenUtil().setSp(0.0),
            ScreenUtil().setSp(0.0)),
        child: IconButton(
            icon: ImageIcon(AssetImage("assets/images/btn_back.png")),
            iconSize: ScreenUtil().setSp(80.0),
            onPressed: () {
              Navigator.of(context).pop();
            }));
  }

  //标题
  Widget titleWidget(String title) {
    return Container(
      //width: ScreenUtil().setSp(200),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setSp(32.0),
          ScreenUtil().setSp(0.0),
          ScreenUtil().setSp(0.0),
          ScreenUtil().setSp(80.0)),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: ScreenUtil().setSp(50),
        ),
      ),
    );
  }



  //兴趣项标签加载
  Widget habitLabelsWidget() {
    return Container(
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setSp(86.0),
            ScreenUtil().setSp(10.0),
            ScreenUtil().setSp(86.0),
            ScreenUtil().setSp(0.0)),
        //width: ScreenUtil().setSp(500),
        child:MultiSelectChip(
          allList,
          selectList: selectList,
          onSelectionChanged: (selectedList) {
            allList = selectedList;
          },
        ));
  }

  //提交按钮
  Widget commitButton(){
    return Container(
      width: ScreenUtil().setSp(686),
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setSp(86.0),
          ScreenUtil().setSp(100.0),
          ScreenUtil().setSp(86.0),
          ScreenUtil().setSp(0.0)),
      child: RaisedButton(
          onPressed: () async{
            if(lastPopTime == null || DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
              lastPopTime = DateTime.now();
              if(selectList.length==0)
              {
                showMessage(context,"请至少选择一项口味兴趣");
                return;
              }
              await _postPersonInfo(context);
            }else{
              lastPopTime = DateTime.now();
              showMessage(context,"请勿重复点击！");
              return;
            }
            if(iscommit) {
              UserAndCanteen userAndCanteen = await db.getCanteenByUserId(int.parse(userID));
              if(userAndCanteen==null){
                await _associatecanteen();
              }else{
                canteenID = userAndCanteen.canteen_id.toString();
                canteenName = userAndCanteen.canteen_name;
              }
              showMessage(context, '修改成功');
              //Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ClientIndexPage()));
              //usertype=="2"?Appliaction.router.navigateTo(context, "/userIndexPage"):Appliaction.router.navigateTo(context, "/managerIndexPage");
            }
            else
            {
              showMessage(context,Provide.value<PostHabbitDataProvide>(context).message);
              return;
            }
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(44.0)),
          padding: EdgeInsets.all(15.0),
          child: Text("确认提交"),
          splashColor: Colors.black12,
          color: Theme.of(context).primaryColor,
          textColor: Colors.white),
    );
  }

  Future _associatecanteen() async {
    await requestGet('getauthorization', '?type=canteen' ).then((val)async{
      if(val.toString() == "false"){
        return;
      }
      if(val != null){
        canteenModel canteenModelData = canteenModel.fromJson(val);
        canteenID = canteenModelData.data[0].canteenId.toString();
        canteenlist = canteenModelData.data;
        canteenName = canteenModelData.data[0].canteenName.toString();
        UserAndCanteen userAndCanteen = new UserAndCanteen(
            user_id: int.parse(userID),
            canteen_id: int.parse(canteenID),
            canteen_name: canteenName
        );
        db.saveRecord(userAndCanteen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(isfirstload)
      {
        initData();
        isfirstload=false;
      }
    return Scaffold(
      body: Container(
        child:SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //backButtonWidget(),
            //titleWidget("用户口味选择"),
            topBGIMG(),
            titleWidget2("用户口味选择",context),
            habitLabelsWidget(),
            commitButton()
          ],
        ),
      ),
    ));
  }

  //加载个人兴趣
  Future _getHabbitInfo(BuildContext context )async{

    String userID= await KvStores.get(KeyConst.USERID);
    await  Provide.value<GetHabbitDataProvide>(context).gethabbitInfo(userID);
    habbits=Provide.value<GetHabbitDataProvide>(context).habbitdata.data.userHobby;
    return '完成加载';
  }

  //提交个人信息
  Future _postPersonInfo(BuildContext context ) async{

    String userID=await KvStores.get(KeyConst.USERID);

    String habbitstr;
    for(int i=0;i<selectList.length;i++)
      {
        String id=selectList[i].getId();
        if(habbitstr==null)
          habbitstr=id;
        else
        habbitstr=habbitstr+","+id;
      }

    iscommit=false;
    await  Provide.value<PostHabbitDataProvide>(context).savehabbitInfo(userID,habbitstr);
    if(Provide.value<PostHabbitDataProvide>(context).code=="0")
      iscommit=true;
    return '完成加载';
  }

}




class TestSelectEntity implements BaseSelectEntity {
  final String title;
  final String id;

  TestSelectEntity({this.title,this.id});

  @override
  String getTag() {
    return title;
  }

  String getId(){
    return id;
  }
}