import 'package:city_pickers/city_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/**
 * 爱心商店
 */
class supportingPoorShopPage extends StatefulWidget {
  final String functionID;

  supportingPoorShopPage(this.functionID);

  @override
  _supportingPoorShopPageState createState() => _supportingPoorShopPageState();
}

class _supportingPoorShopPageState extends State<supportingPoorShopPage> {
  Result resultArr = new Result();

  void _clickEventFunc() async {
    Result tempResult = await CityPickers.showCitiesSelector(
      context: context,
      theme: Theme.of(context).copyWith(primaryColor: Color(0xfffe1314)),
      // 设置主题
      locationCode: resultArr != null
          ? resultArr.areaId ?? resultArr.cityId ?? resultArr.provinceId
          : null, // 初始化地址信息
    );
    if (tempResult != null) {
      setState(() {
        resultArr = tempResult;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            '爱心商店',
            style: TextStyle(color: Colors.black,
                fontSize: ScreenUtil().setSp(40),
                fontWeight:FontWeight.w500),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Container(
          child: RaisedButton(
            onPressed: _clickEventFunc,
            child: Text("选择城市"),
            color: Theme.of(context).primaryColor,
            colorBrightness: Brightness.light,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ));
  }
}
