import 'package:flutter/material.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/model/canteenModel.dart';
import 'package:flutter_canteen/model/category.dart';
import 'package:flutter_canteen/model/organizemodel.dart';
import 'package:flutter_canteen/otherfunction/showDialog.dart';
import 'package:flutter_canteen/pages/associatedPage/chooseCanteen.dart';
import 'package:flutter_canteen/pages/associatedPage/select_organization_page.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AssociatedCanteenPage extends StatefulWidget {
  @override
  _associatedCanteenPageState createState() => _associatedCanteenPageState();
}

class _associatedCanteenPageState extends State<AssociatedCanteenPage> {
  List<CategoryBigModelData> list = [];
  int secondIndex = 0;
  bool isdeleteOraddok = false;
  SlidableController slidableController = new SlidableController();
  final SlidableController primaryslidableController = SlidableController();
  final SlidableController secondslidableController = SlidableController();
  final SlidableController foodlistController = SlidableController();
  TextEditingController organizeComtrollerList = new TextEditingController(); //
  organizeListModel organizeinfodata = null; //组织机构信息
  String OrgName = "1111";
//  List canteenlist;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _associatecanteen();
  }

  //查询单位可访问食堂权限
  Future _associatecanteen() async {
    await requestGet('getauthorization', '?type=canteen&auth=true').then((val) async {
      if (val.toString() == "false") {
        return;
      }
      if (val != null) {
        canteenModel canteenModelData = canteenModel.fromJson(val);
        canteenlist = canteenModelData.data;
        setState(() {});
      }
    });
  }

  //删除单位可访问食堂权限
  Future _associatecanteenDel(int descIndex) async {
    var formData = {
      "canteen_id": canteenlist[descIndex].canteenId
    };
    await requestDelete('getauthorization', '',formData: formData).then((val) async {
      if (val.toString() == "false") {
        return;
      }
      print(val);
      if(val['code']=="0"){
        showMessage(context, "解除成功");
        canteenlist.removeAt(descIndex);
        setState(() {});
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        // actions: <Widget>[Icon(Icons.more_vert)],
        centerTitle: true,
        title: Text(
          '关联食堂',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.orangeAccent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(
              ScreenUtil.getInstance().setSp(20.0),
              ScreenUtil.getInstance().setSp(50.0),
              ScreenUtil.getInstance().setSp(20.0),
              0.0),
          child: Column(
            children: <Widget>[
              Container(
                child: Container(
                  child: Text(
                    "左滑解除关联",
                    style: TextStyle(fontSize: ScreenUtil().setSp(34)),
                  ),
                ),
              ),
              //右边的子分类
              SizedBox(
                height: ScreenUtil().setSp(20),
              ),
              Text("关联食堂",style: TextStyle(fontWeight:FontWeight.w500,fontSize: ScreenUtil().setSp(34)),),
              SizedBox(
                height: ScreenUtil().setSp(20),
              ),
              secondAddIcon(),
              SizedBox(
                height: ScreenUtil().setSp(20),
              ),
              _secondCanteenView(),
            ]
          ),
        ),
      ),
    );
  }

  //选择食堂添加图标
  Widget secondAddIcon() {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 0, ScreenUtil().setSp(14), 0),
        child: new GestureDetector(
          child: IconButton(
            icon: Icon(Icons.add_circle),
            iconSize: 40,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChooseCanteenPage()));
            },
          ),
        ));
  }

  //组织机构
  Widget _primaryOrganizationView() {
    return Container(
      height: ScreenUtil().setSp(800),
      width: ScreenUtil().setSp(300),
      padding: EdgeInsets.fromLTRB(
          ScreenUtil.getInstance().setSp(20.0),
          ScreenUtil.getInstance().setSp(0.0),
          ScreenUtil.getInstance().setSp(20.0),
          0.0),
      decoration: new BoxDecoration(
        border: new Border.all(color: Colors.grey, width: 0.5),
        borderRadius: new BorderRadius.circular((10.0)), // 圆角度
        boxShadow: [BoxShadow(color: Colors.white)],
      ),
      child: Text(OrgName),
    );
  }

  //解除食堂关联
  Widget deleteOrganizeDialog(BuildContext context, int descIndex) {
    return AlertDialog(
      title: Text('确定解除与该食堂的关联？'),
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
            _associatecanteenDel(descIndex);
          },
        ),
      ],
    );
  }

  //选择食堂
  Widget _secondCanteenView() {
    return Container(
      height: ScreenUtil().setSp(700),
      width: ScreenUtil().setSp(450),
      padding: EdgeInsets.fromLTRB(
          ScreenUtil.getInstance().setSp(20.0),
          ScreenUtil.getInstance().setSp(0.0),
          ScreenUtil.getInstance().setSp(20.0),
          0.0),
      decoration: new BoxDecoration(
        border: new Border.all(color: Colors.grey, width: 0.5),
        borderRadius: new BorderRadius.circular((10.0)), // 圆角度
        boxShadow: [BoxShadow(color: Colors.white)],
      ),
//    child: Text("888888"),
      child: ListView.builder(
          itemCount: canteenlist.length,
          itemBuilder: (context, index) {
            return _item(index,canteenlist);
          }),
    );
  }

  Widget _item(int index,List org) {
    return Slidable(
      ///这个key是必要的
      key: Key(index.toString()),
      controller: slidableController,
      actionPane: SlidableScrollActionPane(),
      actionExtentRatio: 0.0,
      enabled: true,
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: '删除',
          color: Colors.red,
          icon: Icons.delete,
          closeOnTap: false,
          //onTap: () => _showSnackBar(level, organizelistlevel[level-1].length-1-index),
        ),
      ],
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        onWillDismiss: (actiontype){
          return showDialog<bool>(
            context: context,
            builder: (context) {
              return deleteOrganizeDialog(context, index);
            }
          );
        },
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FlatButton(
          child: Container(
            width: ScreenUtil().setSp(360),
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(20)),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: ScreenUtil().setSp(1),color: Colors.black12))
            ),
            child: Text(
              org[index].canteenName,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18)
            ),
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
