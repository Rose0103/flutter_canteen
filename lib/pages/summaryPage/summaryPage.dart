import 'package:flutter/material.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'managermonthSummary.dart';

//就餐统计页面

class summaryPage extends StatefulWidget {
  @override
  _summaryPageState createState() => _summaryPageState();
}

class _summaryPageState extends State<summaryPage> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  List<Map> navigatorList;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: monthSummary());
  }
}