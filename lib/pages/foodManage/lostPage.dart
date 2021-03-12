import 'package:flutter/material.dart';

class LostPage extends StatelessWidget {
  final String functionID;
  LostPage(this.functionID);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('参数错误：${functionID}'),
      ),
    );
  }
}