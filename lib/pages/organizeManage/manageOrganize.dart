import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/model/organizemodel.dart';
import 'package:flutter_canteen/provide/organizeinfo.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provide/provide.dart';
import 'subLabelOptions.dart';

class manageOrganizePage extends StatefulWidget {
  @override
  _manageOrganizePageState createState() => _manageOrganizePageState();
}

class _manageOrganizePageState extends State<manageOrganizePage> {
  bool isdeleteOraddok=false;
  bool isaddOrganize=false;
  List<int> judge = new List<int>();
  var deleteid = 0;
  int maxLevel = 0;
  int maxLevels = 0;
  List<SlidableController> organizeslidableController = new List<SlidableController>();
  Map<int,Map<int,List<OrganizeData> > > orgmap=new Map();//最外层的key为level,里面的key为组织机构id, list为其子节点，结构只储存上下级对应关系，整个树列表进行遍历
  Map<int,int> currentIdindex=new Map(); //前一个int为level,后一个int为当前level的map选中的orgid
  TextEditingController organizeComtrollerList = new TextEditingController();//用于控制添加组织机构文本
  ListView _listView = new ListView();

  @override
  void initState() {
    super.initState();
    startIndexs = 0;
    endIndexs = 10;
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
    List<OrganizeData> orglisttemps = new List();
    orgmap.clear();
    for(int i=0;i<organizelist.length;i++) {
      organizeslidableController.add(new SlidableController());
      int level=organizelist[i].orglevel;
      if(level>1&&orgmap.containsKey(level)) {
        //把子节点放到父节点的下面
        if (orgmap[level].containsKey(organizelist[i].parentorganizeid)) {
          orgmap[level][organizelist[i].parentorganizeid].add(organizelist[i]);
        }
        if (!orgmap[level].containsKey(organizelist[i].parentorganizeid)) {
          List<OrganizeData> orglisttemp = new List();
          orglisttemp.add(organizelist[i]);
          orgmap[level].putIfAbsent(organizelist[i].parentorganizeid, () => orglisttemp);
        }
        currentIdindex.putIfAbsent(level, () =>  organizelist[i].organizeid);
      }
      if(level>1&&!orgmap.containsKey(level)) {
        //把子节点放到父节点的下面
        List<OrganizeData> orglisttemp = new List();
        orglisttemp.add(organizelist[i]);
        Map<int,List<OrganizeData> > maptemp=new Map();
        maptemp.putIfAbsent(
            organizelist[i].parentorganizeid, () => orglisttemp);
        orgmap.putIfAbsent(level, () => maptemp);
        currentIdindex.putIfAbsent(level, () =>  organizelist[i].organizeid);
      }
      if(level==1) {
          orglisttemps.add(organizelist[i]);
          Map<int,List<OrganizeData> > maptemp=new Map();
          maptemp.putIfAbsent(
              1, () => orglisttemps);
          orgmap.putIfAbsent(level, () => maptemp);
          currentIdindex.putIfAbsent(level, () =>  organizelist[i].organizeid);
      }
      if(maxLevel<organizelist[i].orglevel) {
        maxLevel=organizelist[i].orglevel;
        maxLevels = maxLevel;
      }
    }
  }

  //初始化organizeslidableController
  void _initOrganizeslidableController(){
    if(judge.isEmpty){
      for(int i=0;i<maxLevel;i++){
        judge.add(0);
      }
      currentIdindex[0] = 1;
    }
  }

  //初始化listview
  void _intitListView(){
    items.clear();
    //modify by wanchao 2020-11-23 roo级组织机构不能添加列表
    for(int i=0;i<=maxLevel;i++){
      if(i==maxLevel){
        items.add(organizeAddIconlevel());
      }else{
        items.add(Column(children: <Widget>[
          Text("添加"+(i+1).toString()+"级组织"),
          organizeAddIcon(i),
          _OrganizelistView(i+1),
        ]));
      }
    }
    _listView = ListView.builder(
      scrollDirection: Axis.horizontal,//设置列表为横向
      itemCount: items.length,
      itemBuilder: (context,index){
        return items[index];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _initOrganizeslidableController();
    _intitListView();
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
            '组织机构管理',
            style: TextStyle(color: Colors.black,
                fontSize: ScreenUtil().setSp(40),
                fontWeight:FontWeight.w500),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: orgmap.length==0?Container(
          child:Text("加载中"),
        ):SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil.getInstance().setSp(20.0),
                    ScreenUtil.getInstance().setSp(0.0),
                    ScreenUtil.getInstance().setSp(20.0),
                    0.0),
                child: Column(children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: ScreenUtil().setSp(40)),
                        child:Text("左滑删除组织"),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: ScreenUtil().setSp(40)),
                        child: Text("长按修改组织名称"),
                      ),
                      ],
                    )
                  ),
                  Container(
                    height: ScreenUtil().setSp(1100),
                    margin: EdgeInsets.only(top: 20),
                    child: _listView
                  ),
                ]))));
  }

  //组织栏
  Widget _OrganizelistView(int level) {
    if (orgmap[level][currentIdindex[level-1]]!=null&&(level==1||orgmap[level-1][currentIdindex[level-2]]!=null)) {
      return Container(
          height: ScreenUtil().setSp(800),
          width: ScreenUtil().setSp(500),
          margin: EdgeInsets.fromLTRB(
            ScreenUtil.getInstance().setSp(20.0),
            ScreenUtil.getInstance().setSp(0.0),
            ScreenUtil.getInstance().setSp(20.0),
            ScreenUtil.getInstance().setSp(0.0),
          ),
          padding: EdgeInsets.fromLTRB(
            ScreenUtil.getInstance().setSp(5.0),
            ScreenUtil.getInstance().setSp(0.0),
            ScreenUtil.getInstance().setSp(5.0),
            ScreenUtil.getInstance().setSp(0.0),
          ),
          decoration: new BoxDecoration(
            border: new Border.all(color: Colors.grey, width: 0.5),
            borderRadius: new BorderRadius.circular((10.0)), // 圆角度
            boxShadow: [BoxShadow(color: Colors.white)],
          ),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: orgmap[level][currentIdindex[level-1]].length,
              itemBuilder: (context, index) {
                var descIndex = orgmap[level][currentIdindex[level-1]].length - 1 - index;
                return Slidable(
                  key: Key(descIndex.toString()),
                  controller: organizeslidableController[index],
                  actionPane: SlidableScrollActionPane(),
                  // 侧滑菜单出现方式 SlidableScrollActionPane SlidableDrawerActionPane SlidableStrechActionPane
                  actionExtentRatio: 0.0,
                  // 侧滑按钮所占的宽度
                  enabled: true,
                  // 是否启用侧滑 默认启用
                  dismissal: SlidableDismissal(
                    child: SlidableDrawerDismissal(),
                    onWillDismiss: (actionType) {
                      deleteid = orgmap[level][currentIdindex[level-1]][index].organizeid;
                      return showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('删除'),
                            content: Text('删除该组织？'),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('取消'),
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                              ),
                              FlatButton(
                                  child: Text('确认'),
                                  onPressed: () async{
                                    if(haveChileOrgan(deleteid)) {
                                      Fluttertoast.showToast(
                                          msg: "需删除该父组织下所有子组织，才可进行操作",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIos: 2,
                                          backgroundColor: Theme.of(context).primaryColor,
                                          textColor: Colors.pink);
                                      Navigator.of(context).pop(false);
                                      return;
                                    }
                                    isdeleteOraddok=false;
                                    await _deleteOrganize(context,deleteid);
                                    if(isdeleteOraddok) {
                                      setState(() {
                                        orgmap[level][currentIdindex[level-1]].removeAt(index);
                                        if(orgmap[level][currentIdindex[level-1]].length==0){
                                          orgmap[level].remove(currentIdindex[level-1]);
                                        }
                                        if(orgmap[level].isEmpty){
                                          maxLevel--;
                                          judge.removeLast();
                                        }
                                     });
                                    Fluttertoast.showToast(
                                        msg: "删除成功",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIos: floaststaytime,
                                        backgroundColor: Theme.of(context).primaryColor,
                                        textColor: Colors.pink);
                                    Navigator.of(context).pop(true);
                                  }
                                    else {
                                      Fluttertoast.showToast(
                                          msg: "网络或服务器错误",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIos: floaststaytime,
                                          backgroundColor: Theme.of(context).primaryColor,
                                          textColor: Colors.pink);
                                      Navigator.of(context).pop(false);
                                    }
                                  }
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          currentIdindex[level] = orgmap[level][currentIdindex[level-1]][index].organizeid;
                          judge[level-1] = index;
                          if(level<maxLevel){
                            judge[level] = 0;
                            if(level<maxLevel-1){
                              for(int i=1;i<maxLevel-level;i++){
                                if(orgmap[level+i][currentIdindex[level+i-1]]!=null){
                                  judge[level+i-1] = 0;
                                  currentIdindex[level+i] = orgmap[level+i][currentIdindex[level+i-1]][0].organizeid;
                                }else{
                                  judge[level+i-1] = -1;
                                  currentIdindex[level+i] = 0;
                                }
                              }
                            }
                          }
                        });
                      },
                      onLongPress:(){
                        return updateOrganizeDialog(context,level,index);
                      },
                      onDoubleTap: (){
                        setState(() {
                          if (level == 1) {
                            Fluttertoast.showToast(
                                msg: "1级组织不可设置！",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIos: 2,
                                backgroundColor: Color.fromRGBO(236, 160, 139, 1.0),
                                textColor: Colors.pink);
                          } else {
                            currentIdindex[level] = orgmap[level]
                            [currentIdindex[level - 1]][index]
                                .organizeid;
                            judge[level - 1] = index;
                            if (level < maxLevel) {
                              judge[level] = 0;
                              if (level < maxLevel - 1) {
                                for (int i = 1; i < maxLevel - level; i++) {
                                  if (orgmap[level + i]
                                  [currentIdindex[level + i - 1]] !=
                                      null) {
                                    judge[level + i - 1] = 0;
                                    currentIdindex[level + i] = orgmap[level +
                                        i][currentIdindex[level + i - 1]][0]
                                        .organizeid;
                                  } else {
                                    judge[level + i - 1] = -1;
                                    currentIdindex[level + i] = 0;
                                  }
                                }
                              }
                            }
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return subLabelOpions(
                                      orgmap[level][currentIdindex[level - 1]]
                                      [index]
                                          .organizeiname,
                                      orgmap[level][currentIdindex[level - 1]]
                                      [index]
                                          .organizeid);
                                });
                          }
                        });
                      },
                      child: Column(children: <Widget>[
                        Container(
                          height: ScreenUtil().setSp(80.0),
                          padding: EdgeInsets.fromLTRB(5, 10, 10, 10),
                          decoration: BoxDecoration(
                              color: judge[level-1] == index
                                  ? Color.fromRGBO(236, 160, 139, 1.0)
                                  : Colors.white,
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Colors.black12))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: ScreenUtil().setSp(425),
                                child: Text(orgmap[level][currentIdindex[level-1]][index].organizeiname,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: ScreenUtil().setSp(28))
                                ),
                              ),
                              Container(
                                width: ScreenUtil().setSp(30),
                                child:level==maxLevel?Text(''):judge[level-1] == index?Icon(Icons.arrow_right):Text(""),
                              )
                            ],
                          )
                        ),
                        Divider(
                          height: 4.0,
                          indent: 0.0,
                          color: Colors.red,
                        ),
                      ])),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: '删除',
                      color: Colors.red,
                      icon: Icons.delete,
                      closeOnTap: false,
                      //onTap: () => _showSnackBar(level, organizelistlevel[level-1].length-1-index),
                    ),
                  ],
                );
              }));
    } else {
      return nullShuju();
    }
  }

  Widget nullShuju(){
    return Container(
        height: ScreenUtil().setSp(800),
        width: ScreenUtil().setSp(500),
        margin: EdgeInsets.fromLTRB(
          ScreenUtil.getInstance().setSp(20.0),
          ScreenUtil.getInstance().setSp(0.0),
          ScreenUtil.getInstance().setSp(20.0),
          ScreenUtil.getInstance().setSp(0.0),
        ),
        padding: EdgeInsets.fromLTRB(
          ScreenUtil.getInstance().setSp(5.0),
          ScreenUtil.getInstance().setSp(0.0),
          ScreenUtil.getInstance().setSp(5.0),
          ScreenUtil.getInstance().setSp(0.0),
        ),
        decoration: new BoxDecoration(
          border: new Border.all(color: Colors.grey, width: 0.5),
          borderRadius: new BorderRadius.circular((10.0)), // 圆角度
          boxShadow: [BoxShadow(color: Colors.white)],
        ),
        child: Text('暂时没有数据'));
  }

  //添加图标
  Widget organizeAddIcon(int index) {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 0, ScreenUtil().setSp(14), 0),
        child: new GestureDetector(
          child: Container(
            child: Image.asset(
              "assets/images/btn_add_selected.png",
              width: ScreenUtil().setSp(100),
            ),
          ),
          onTap: () async {
            if(index==0){
              Fluttertoast.showToast(
                  msg: "暂不可添加1级组织！",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIos: 2,
                  backgroundColor: Theme.of(context).primaryColor,
                  textColor: Colors.pink);
            }else if(index-1>=0&&judge[index-1]<0){
              Fluttertoast.showToast(
                  msg: "无父级组织,无法添加！",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIos: 2,
                  backgroundColor: Theme.of(context).primaryColor,
                  textColor: Colors.pink);
            }else{
              await addOrganizeDialog(context,index);
            }
          },
        ));
  }

  //添加新级别图标
  Widget organizeAddIconlevel() {
    return Container(
        child: new GestureDetector(
          child: Container(
            child: Image.asset(
              "assets/images/btn_add_selected.png",
              width: ScreenUtil().setSp(100),
            ),
          ),
          onTap: () async {
            bool result = await addOrganizelevelDialog(context);
          },
        ));
  }

  //添加组织
  Future addOrganizeDialog(BuildContext context, int index) async {
    organizeComtrollerList.text = "";
    String str = (index+1).toString();
    var result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('添加'+str+'级组织'),
            content: TextFormField(
              autofocus: false,
              maxLength: 15,
              controller: organizeComtrollerList,
              decoration: InputDecoration(
                  hintText: '请输入'+str+'级组织名称',
                  icon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(5.0)),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop('cancel');
                },
              ),
              FlatButton(
                child: Text('确认'),
                onPressed: () async{
                  if(organizeComtrollerList.text.trim().length == 0) {
                    Fluttertoast.showToast(
                        msg: "请输入组织名称",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIos: 2,
                        backgroundColor: Theme.of(context).primaryColor,
                        textColor: Colors.pink);
                    return;
                  }else{
                    isaddOrganize=false;
                    await _addOrganize(
                        context,
                        organizeComtrollerList.text,
                        index==0?0:currentIdindex[index],
                        organizeid,
                        index+1,
                        index);
                    if(isaddOrganize) {
                      if(judge[index]==-1){
                        judge[index] = 0;
                      }
                      organizeslidableController.add(new SlidableController());
                      print(2222222);
                      Fluttertoast.showToast(
                          msg: "添加成功",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIos: floaststaytime,
                          backgroundColor: Theme.of(context).primaryColor,
                          textColor: Colors.pink);
                      //_getOrganize(context);
                      Navigator.of(context).pop(true);
                    }
                    else {
                      Fluttertoast.showToast(
                          msg: "网络或服务器错误",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIos: floaststaytime,
                          backgroundColor: Theme.of(context).primaryColor,
                          textColor: Colors.pink);
                      Navigator.of(context).pop(false);
                    }
                  }
                },
              ),
            ],
          );
        });
    return result;
  }

  //添加组织
  Future addOrganizelevelDialog(BuildContext context) async{
    var result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('添加'),
            content: Text('添加新一级？'),
            actions: <Widget>[
              FlatButton(
                child: Text('取消'),
                onPressed: () =>
                  Navigator.of(context).pop(false),
              ),
              FlatButton(
                  child: Text('确认'),
                  onPressed: () {
                    int len = items.length;
                    if(orgmap[len-1].isEmpty){
                      Fluttertoast.showToast(
                          msg: "${len-1}级组织至少有一个组织信息才能继续添加！",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIos: floaststaytime,
                          backgroundColor: Theme.of(context).primaryColor,
                          textColor: Colors.pink);
                    }else{
                      setState(() {
                        Map<int,List<OrganizeData>> m = new Map<int,List<OrganizeData>>();
                        orgmap.putIfAbsent(len, () => m);
                        maxLevel++;
                        judge.add(-1);
                        if(orgmap[maxLevel-1][currentIdindex[maxLevel-2]]==null||orgmap[maxLevel-1][currentIdindex[maxLevel-2]].isEmpty){
                          judge[maxLevel-2]=-1;
                        }
                        Fluttertoast.showToast(
                            msg: "添加成功",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIos: floaststaytime,
                            backgroundColor: Theme.of(context).primaryColor,
                            textColor: Colors.pink);
                      });
                    }
                    Navigator.of(context).pop(false);
                  }
              ),
            ],
          );
        }
    );
  }

  //删除组织
  Future _deleteOrganize(BuildContext context,int Organize) async {
    var param={
      "organize_id":Organize
    };
    await requestDelete('getorganizeinfo','',formData:param).then((val) {
      if(val.toString()=="false")
      {
        isdeleteOraddok=false;
        return false;
      }
      if (val == null) {
        isdeleteOraddok=false;
        return false;
      }
      String code = val['code'].toString();
      if (code == "0") {
        isdeleteOraddok=true;
        return true;
      } else {
        isdeleteOraddok=false;
        return false;
      }
    });
  }


  //添加组织
  Future updateOrganizeDialog(BuildContext context,int level, int index) async {
    organizeComtrollerList.text = orgmap[level][currentIdindex[level-1]][index].organizeiname;
    var result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('修改组织名称'),
            content: TextFormField(
              autofocus: false,
              maxLength: 15,
              controller: organizeComtrollerList,
              decoration: InputDecoration(
                  icon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(5.0)),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop('cancel');
                },
              ),
              FlatButton(
                child: Text('确认'),
                onPressed: () async{
                  if(organizeComtrollerList.text.trim().length == 0) {
                    Fluttertoast.showToast(
                        msg: "请输入组织名称",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIos: 2,
                        backgroundColor: Theme.of(context).primaryColor,
                        textColor: Colors.pink);
                    return;
                  }else{
                    isaddOrganize=false;
                    await _updateOrganize(context, organizeComtrollerList.text, orgmap[level][currentIdindex[level-1]][index]);
                    if(isaddOrganize) {
                      setState(() {
                        orgmap[level][currentIdindex[level-1]][index].organizeiname = organizeComtrollerList.text;
                      });
                      Fluttertoast.showToast(
                          msg: "修改成功",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIos: floaststaytime,
                          backgroundColor: Theme.of(context).primaryColor,
                          textColor: Colors.pink);
                      //_getOrganize(context);
                      Navigator.of(context).pop(true);
                    }
                    else {
                      Fluttertoast.showToast(
                          msg: "网络或服务器错误",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIos: floaststaytime,
                          backgroundColor: Theme.of(context).primaryColor,
                          textColor: Colors.pink);
                      Navigator.of(context).pop(false);
                    }
                  }
                },
              ),
            ],
          );
        });
    return result;
  }

  //添加目录接口
  Future _addOrganize(BuildContext context,String organizeNamae,int parentOrganizeId
      ,int rootOrganizeId,int orgLevel,int index) async {
    var tempdata={
      "organize_name":organizeNamae,
      "organize_addr":"中国",
      "parent_organize_id":parentOrganizeId,
      "root_organize_id":rootOrganizeId,
      "state":1,
      "org_level":orgLevel
    };
    print(tempdata);
    await request('getorganizeinfo', '', formData:tempdata).then((val) {
      if(val.toString()=="false")
      {
        isaddOrganize=false;
        return false;
      }
      String code = val['code'].toString();
      if (code == "0") {
        isaddOrganize=true;
        setState(() {
          OrganizeData organizeData = new OrganizeData(
              val['data']['organize_id'],
              val['data']['organize_name'],
              val['data']['organize_addr'],
              val['data']['parent_organize_id'],
              val['data']['state'],
              val['data']['create_time'],
              val['data']['update_time'],
              val['data']['root_organize_id'],
              val['data']['org_level']
          );
          if(orgmap[index+1][currentIdindex[index]]==null){
            List<OrganizeData> orglist = new List<OrganizeData>();
            orglist.add(organizeData);
            orgmap[index+1].putIfAbsent(currentIdindex[index], () => orglist);
          }else{
            orgmap[index+1][currentIdindex[index]].add(organizeData);
          }
          if(index+1>maxLevels){
            currentIdindex[index+1] = val['data']['organize_id'];
          }
        });

        return true;
      } else {
        isaddOrganize=false;
        return false;
      }
    });
  }

  //修改组织接口
  Future _updateOrganize(BuildContext context,String organizeNamae,OrganizeData organizeData) async {
    var tempdata={
      "organize_id":organizeData.organizeid,
      "organize_name":organizeNamae,
      "organize_addr":organizeData.organizeiname,
      "parent_organize_id":organizeData.parentorganizeid,
      "root_organize_id":organizeData.rootorganizeid,
      "state":organizeData.state,
      "org_level":organizeData.orglevel
    };
    await requestPut('getorganizeinfo', '', formData:tempdata).then((val) {
      if(val.toString()=="false")
      {
        isaddOrganize=false;
        return false;
      }
      String code = val['code'].toString();
      if (code == "0") {
        isaddOrganize=true;
        return true;
      } else {
        isaddOrganize=false;
        return false;
      }
    });
  }

  //判断是否有子组织
  bool haveChileOrgan(int organ_id){
    for(int i=0;i<organizelist.length;i++){
      if(organizelist[i].parentorganizeid==organ_id){
        return true;
      }
    }
    return false;
  }
}
