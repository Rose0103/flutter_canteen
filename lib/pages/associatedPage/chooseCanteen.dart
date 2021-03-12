import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_canteen/model/canteenModel.dart';
import 'package:flutter_canteen/otherfunction/showDialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'search.dart';
import 'package:flutter/services.dart';
import 'package:flutter_canteen/config/param.dart';


import 'package:flutter_canteen/service/service_method.dart';

class ChooseCanteenPage extends StatefulWidget {
  @override
  _ChooseCanteenPageState createState() => _ChooseCanteenPageState();
}

class _ChooseCanteenPageState extends State<ChooseCanteenPage> {
  FocusNode _focusNode;
  TextEditingController _controller;
  String _searchText;
  List<Data> canteenlists;
  List<Data>  searchCanteen;
  int judge = 0;//选中的item下标
  bool flag = true;

  @override
  void initState() {
    super.initState();
    _associatecanteen();
    _focusNode = FocusNode();
    _controller = TextEditingController();
  }

  //查询单位可访问食堂权限
  Future _associatecanteen() async {
    await requestGet('getauthorization', '?type=canteen&auth=false').then((val) async {
      if (val.toString() == "false") {
        return;
      }
      if (val != null) {
        canteenModel canteenModelDataFale = canteenModel.fromJson(val);
        searchCanteen = canteenModelDataFale.data;

        print("searchCanteen.length=${searchCanteen.length}");
        canteenlists = canteenModelDataFale.data;

        print("canteenlists.length=${canteenlists.length}");
        items.clear();
        for(int i =0 ;i<canteenlists.length; i ++){
          print("laile");
          items.add(_itemWidget(i));
        }
        setState(() {

        });
      }
    });
  }

  void updateItem(){
    print(items);
    items.clear();
    for(int i =0 ;i<canteenlists.length; i ++){
      items.add(_itemWidget(i));
    }
    setState(() {});
  }

  Widget _itemWidget(int i){
    return InkWell(
      onTap: (){
        judge = i;
        flag = true;
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(20)),
        decoration: BoxDecoration(
          color: i==judge?Colors.black12:Colors.transparent,
          border: Border(bottom: BorderSide(width: ScreenUtil().setSp(1),color: Colors.black12))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("     ",style: TextStyle(fontWeight:FontWeight.w500,fontSize: ScreenUtil().setSp(34))),
            Icon(Icons.bookmark_border,size: ScreenUtil().setSp(40),),
            Text("  ${canteenlists[i].canteenName}",style: TextStyle(fontWeight:FontWeight.w500,fontSize: ScreenUtil().setSp(34))),
          ],
        ),
      ),
    );
  }

  void changeChoose(value) {
    print("+++++++++++++++");
  }

  @override
  Widget build(BuildContext context) {
    if(flag&&canteenlists!=null){
      updateItem();
      flag = false;
    }
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
            Navigator.pop(context,true);
          },
        ),
        centerTitle: true,
        title: Text(
          '关联商户',
          style: TextStyle(
              color: Colors.black,
              fontSize: ScreenUtil().setSp(40),
              fontWeight: FontWeight.w500),
        ),
//        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());//触摸收起键盘
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(90)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
               searchNameWidget(),
            Container(
                height: ScreenUtil().setSp(100.0),
                width: ScreenUtil().setSp(350.0),
                child: DropdownButton(
//                  value: "离我最近",
                  items: [
                    DropdownMenuItem(child: Text('离我最近')),
                    DropdownMenuItem(child: Text('评价最高')),
                    DropdownMenuItem(child: Text('服务最好吃'))
                  ],
                  onChanged: changeChoose,
                )),
            Container(
              padding: EdgeInsets.all(ScreenUtil().setSp(12)),
              height: ScreenUtil().setSp(600),
//              width: ScreenUtil().setSp(500),
                  decoration: new BoxDecoration(
                    border: Border.all(width: ScreenUtil().setSp(2), color: Colors.black38)
                  ),
                  margin: EdgeInsets.only(top: ScreenUtil().setSp(20)),
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return items[index];
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        child: Text("添加",style: TextStyle(fontSize: ScreenUtil().setSp(32.0)),),
                        color: Colors.orangeAccent,
                        padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                        textColor: Colors.white,
                        onPressed: () {
                          print(judge);
                          int index = judge;
                          if(canteenlists.length>0){
                            //modify by lilixia   2020-11-23
                            showDialog<bool>(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('确定添加与该食堂的关联？'),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('取消'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      FlatButton(
                                        child: Text('确定'),
                                        onPressed: () {
                                          _addCanteen(index);
                                        },
                                      ),
                                    ],
                                  );
                                }
                            );
                          }else{
                            showMessage(context, "暂无可添加食堂");
                          }
                          judge = 0;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget searchNameWidget() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(top: ScreenUtil().setSp(5.0)),
        child: Container(
          height: 68.0,
          child: Row(
            children: <Widget>[
              new Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: new Card(
                      child: new Container(
                        width: ScreenUtil().setSp(520),
                        child: new Row(
                          children: <Widget>[
                            SizedBox(width: 10.0,),
                            Icon(Icons.search, color: Colors.grey,),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: TextField(
                                  controller: _controller,
                                  style: TextStyle(fontSize: ScreenUtil().setSp(30.0)),
                                  decoration: new InputDecoration(
                                      contentPadding: EdgeInsets.only(top: 0.0),
                                      hintText: '点我输入搜索', border: InputBorder.none),
                                  onChanged:(v) async{
                                    print(searchCanteen.length);
                                    canteenlists.clear();
                                    print(v);
                                    if(v.trim().length > 0){
                                      print("youle");
                                      print(searchCanteen.length);
                                      for(int i=0;i<searchCanteen.length;i++){
                                        print(searchCanteen.length);
                                        if(searchCanteen[i].canteenName.contains(v)){
                                          print(searchCanteen[i].canteenName);
                                        }
                                      }
                                    }
                                    setState(() {
                                    });
                                  },
                                ),
                              ),
                            ),
                            new IconButton(
                              icon: new Icon(Icons.cancel),
                              color: Colors.grey,
                              iconSize: 18.0,
                              onPressed: () {
                                _controller.clear();
                                setState(() {

                                });
                              },
                            ),
                          ],
                        ),
                      )
                  )
              ),
            ],
          ),
        ),
      ),

//        child: TextFormField(
//            autofocus: false,
//            maxLength: 20,
//            controller: _nameController,
//            decoration: InputDecoration(
//              enabledBorder: outlineborders(Colors.grey),
//              focusedBorder: outlineborders(Theme.of(context).primaryColor),
//              errorBorder: outlineborders(Theme.of(context).primaryColor),
//              focusedErrorBorder:outlineborders(Theme.of(context).primaryColor),
//              fillColor: Theme.of(context).primaryColor,
//              hintStyle: TextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(20.0)),
//              errorStyle:TextStyle(color: Theme.of(context).primaryColor, fontSize: ScreenUtil().setSp(20.0)),
//              //labelText: '手机号码登录',
//              hintText: '搜索人名',
////              icon: Icon(Icons.search,color: Theme.of(context).primaryColor),
//              icon: GestureDetector(
//                onTap: (){
//                  print("=====================${_nameController.text}");
//                  print(_nameController.text.length);
//                  if(_nameController.text.length>0){
//                    searchpersonList.clear();
//                    for(int i = 0 ; i<fristpersonListData.length;i++){
//                      if(fristpersonListData[i].usName.contains(_nameController.text.trim())){
//                        print("**********${fristpersonListData[i].usName}");
//                        searchpersonList.add(personnellDetailed(fristpersonListData[i].usName,fristpersonListData[i].sex,fristpersonListData[i].phoneName,fristpersonListData[i].isemployee,fristpersonListData[i].cID,fristpersonListData[i].userRootOrgId,fristpersonListData[i].isEnabled,fristpersonListData[i].userOrgId,selected:fristpersonListData[i].selected));
//                      }
//                    }
//                    print("###########${searchpersonList.length}");
//                    if(searchpersonList.length>0){
//                      personnelList.clear();
//                      for(int i = 0; i <searchpersonList.length;i++){
//                        personnelList.add(personnellDetailed(searchpersonList[i].usName,searchpersonList[i].sex,searchpersonList[i].phoneName,searchpersonList[i].isemployee,searchpersonList[i].cID,searchpersonList[i].userRootOrgId,searchpersonList[i].isEnabled,searchpersonList[i].userOrgId,selected:searchpersonList[i].selected));
//                      }
//                      setState(() {
//                      });
//                    }else{
//                      Fluttertoast.showToast(
//                          msg: "没有该用户",
//                          toastLength: Toast.LENGTH_SHORT,
//                          gravity: ToastGravity.CENTER,
//                          backgroundColor: Color.fromRGBO(236, 160, 139, 1.0),
//                          textColor: Colors.pink);
//                    }
//                  }else{
//                    personnelList.clear();
//                    for(int i = 0; i <fristpersonListData.length;i++){
//                      personnelList.add(personnellDetailed(fristpersonListData[i].usName,fristpersonListData[i].sex,fristpersonListData[i].phoneName,fristpersonListData[i].isemployee,fristpersonListData[i].cID,fristpersonListData[i].userRootOrgId,fristpersonListData[i].isEnabled,fristpersonListData[i].userOrgId,selected:fristpersonListData[i].selected));
//                    }
//                    setState(() {
//                    });
//                  }
//                },
//                child: Icon(Icons.search,color: Theme.of(context).primaryColor),
//              ),
//              border: OutlineInputBorder(),
//              suffixIcon: GestureDetector(
//                  onTap: () {
//                    _nameController.text="";
//                    personnelList.clear();
//                    for(int i = 0; i <fristpersonListData.length;i++){
//                      personnelList.add(personnellDetailed(fristpersonListData[i].usName,fristpersonListData[i].sex,fristpersonListData[i].phoneName,fristpersonListData[i].isemployee,fristpersonListData[i].cID,fristpersonListData[i].userRootOrgId,fristpersonListData[i].isEnabled,fristpersonListData[i].userOrgId,selected:fristpersonListData[i].selected));
//                    }
//                    setState(() {
//                    });
//                  },
//                  child: Icon(
//                    Icons.clear,
//                    color: Colors.black26,
//                  )
//              ),
//            ),
//            onChanged: (v) {
//
//            }
//        )
    );
  }


  Future _addCanteen(int index) async {
    var formData = {
      "canteen_id": canteenlists[index].canteenId
    };
    print("formData$formData");
    print(index);
    print(canteenlists.length);
    await request('getauthorization', '',formData: formData).then((val) async {
      if (val.toString() == "false") {
        return;
      }
      if (val != null) {
        if(val["code"]=="0"){
          showMessage(context, "添加成功");
          canteenlist.add(canteenlists[index]);
          canteenlists.removeAt(index);
          flag = true;
          setState(() {});
          //modify by lilixia   2020-11-23
          Navigator.pop(context);
        }
      }
    });
  }
}
