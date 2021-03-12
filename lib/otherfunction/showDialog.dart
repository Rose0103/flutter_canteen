import 'package:flutter/material.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class bntn extends StatefulWidget {
  @override
  _bntnState createState() => _bntnState();
}

class _bntnState extends State<bntn> {
  @override
  void initState() {
    // TODO: implement initState
    dingpersonnum=0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.fromLTRB(
          ScreenUtil().setSp(6), 0.0, ScreenUtil().setSp(6), 0.0),
      padding: EdgeInsets.fromLTRB(
          0, ScreenUtil().setSp(14), 0, ScreenUtil().setSp(14)),
      width: double.infinity,
      height: ScreenUtil().setSp(200),
      alignment: Alignment.bottomRight,
      decoration: new BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Color(0x33333333)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(ScreenUtil().setSp(15)),
            child: Align(
              child: Text(
                '用餐人数',
                style: TextStyle(
                    color: Color(0xff333333), fontSize: ScreenUtil().setSp(30)),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              new GestureDetector(
                child: Container(
                  child: Image.asset(
                    "assets/images/btn_qiyongcp_selected.png",
                    width: ScreenUtil().setSp(80),
                  ),
                ),
                //不写的话点击起来不流畅
                onTap: () {
                  setState(() {
                    if (dingpersonnum <0) {
                      return;
                    }
                    dingpersonnum--;
                  });
                },
              ),
              Padding(
                padding: EdgeInsets.all(ScreenUtil().setSp(15)),
                child: Align(
                  child: Text(
                    '$dingpersonnum',
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: ScreenUtil().setSp(30)),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, ScreenUtil().setSp(14), 0),
                child: new GestureDetector(
                  child: Container(
                    child: Image.asset(
                      "assets/images/btn_add_selected.png",
                      width: ScreenUtil().setSp(80),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      if (dingpersonnum >= 9999) {
                        return;
                      }
                      dingpersonnum++;
                      print("dingpersonnum$dingpersonnum");
                    });

                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}


Future chooseDialog(BuildContext context,String tips) async{
  var result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('提示'),
          content: Text(tips),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop('cancel');
              },
            ),
            FlatButton(
              child: Text('确认'),
              onPressed: () {
                Navigator.of(context).pop('ok');
              },
            ),
          ],
        );
      });
  return result;
}

Future closeDialog(BuildContext context) async{
  var result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('取消订单'),
          content: Text('是否确认取消订单'),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop('cancel');
              },
            ),
            FlatButton(
              child: Text('确认'),
              onPressed: () {
                  Navigator.of(context).pop('ok');
              },
            ),
          ],
        );
      });
  return result;
}


Future choosePersonNumDialog(BuildContext context) async{
  var result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('请选择就餐人数'),
          content: bntn(),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop('cancel');
              },
            ),
            FlatButton(
              child: Text('确认'),
              onPressed: () {
                if(dingpersonnum==0)
                  {
                    Fluttertoast.showToast(
                        msg: "请选择就餐人数",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIos: 2,
                        backgroundColor: Theme.of(context).primaryColor,
                        textColor: Colors.pink);
                    return;
                  }
                else
                Navigator.of(context).pop('ok');
              },
            ),
          ],
        );
      });
  return result;
}

void showMessage(BuildContext context,String text) async{
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: floaststaytime,
      backgroundColor: Theme.of(context).primaryColor,
      textColor: Colors.pink);
  return;
}


Widget topBGIMG()
{
  return Container(
    height: ScreenUtil().setSp(250),
    decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/usercenterBG.png"),
          fit: BoxFit.fill,
        )),
  );
}

//标题
Widget titleWidget2(String title,BuildContext context) {
  return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            child: IconButton(
                icon: ImageIcon(AssetImage("assets/images/btn_back.png")),
                iconSize: ScreenUtil().setSp(100.0),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.of(context).pop();
                })),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.fromLTRB(
              ScreenUtil().setSp(50.0),
              ScreenUtil().setSp(0.0),
              ScreenUtil().setSp(0.0),
              ScreenUtil().setSp(0.0)),
          child: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: ScreenUtil().setSp(40),
              fontWeight:FontWeight.bold,

            ),
          ),
        )]);
}

OutlineInputBorder outlineborders(Color color)
{
  return OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(30), //边角为30
    ),
    borderSide: BorderSide(
      color: color, //边线颜色为黄色
      width: 2, //边线宽度为2
    ),
  );
}