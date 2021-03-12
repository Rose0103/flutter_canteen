import 'package:flutter/material.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/provide/organizeinfo.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

class SelectOrganization extends StatefulWidget {
  SelectOrganization({Key key}) : super(key: key);

  @override
  _SelectOrganizationState createState() => _SelectOrganizationState();
}

class _SelectOrganizationState extends State<SelectOrganization> {

  ListView _listView = new ListView();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await initOrgMap();
      setState(() {

      });
    });
  }

  //获取组织机构
  Future _getOrganize(BuildContext context) async {
    await Provide.value<GetOrganizeInfoDataProvide>(context).getOrganizeInfo();
    return '完成加载';
  }

  void initOrgMap() async{
    await _getOrganize(context);
    organizelist = Provide.value<GetOrganizeInfoDataProvide>(context).organizeinfodata.data;
    print(organizelist.length);
    items.clear();
    for(var i = 0; i < organizelist.length;i++){
//       organizelist[i].organizeiname;
      print("---"+organizelist[i].organizeiname);
      items.add(
        Column(
          children: <Widget>[
            Container(
                width: ScreenUtil().setWidth(800),
                height: ScreenUtil().setHeight(90),
                decoration: new BoxDecoration(
                    border:Border(bottom:BorderSide(width: 0.5,color: Colors.black ) )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(organizelist[i].organizeiname,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(36.0),
                    ),
                  ),
                )
            ),
          ],
        )
      );
    }

    _listView = ListView.builder(
      itemCount: items.length,
      itemBuilder: (context,index){
        return items[index];
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('选择组织机构'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(
              ScreenUtil.getInstance().setSp(20.0),
              ScreenUtil.getInstance().setSp(50.0),
              ScreenUtil.getInstance().setSp(20.0),
              0.0),
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: ScreenUtil().setSp(40)),
                      child:Text("只展示该管理员查到的1、2级",style: TextStyle(fontSize: ScreenUtil().setSp(34)),),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: ScreenUtil().setWidth(700),
                  height: ScreenUtil().setHeight(800),
                  padding: EdgeInsets.fromLTRB(
                      ScreenUtil.getInstance().setSp(0.0),
                      ScreenUtil.getInstance().setSp(0.0),
                      ScreenUtil.getInstance().setSp(0.0),
                      0.0
                  ),
                  decoration: new BoxDecoration(
                    border: new Border.all(color: Colors.black, width: 0.5),
                    boxShadow: [BoxShadow(color: Colors.white)],
                  ),
                  child: _listView,
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    OutlineButton(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                      highlightedBorderColor: Theme.of(context).primaryColor,
                      disabledBorderColor: Theme.of(context).primaryColor,
                      highlightColor: Colors.pink[100],
                      onPressed: () {
                        print("你点击了确定");
                      },
                      child: Text(
                        "确定",
                        style: TextStyle(color: Theme.of(context).primaryColor,fontSize: ScreenUtil().setSp(30.0)),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  }



