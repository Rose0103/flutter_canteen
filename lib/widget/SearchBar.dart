import 'package:flutter/material.dart';
import 'package:flutter_canteen/bean/node.dart';
import 'package:flutter_canteen/bean/organ.dart';
import 'package:flutter_canteen/config/param.dart';

///支持搜索功能
class SearchBar extends StatefulWidget {
  final List<Node> list;
  final Function onResult;

  SearchBar(this.list, this.onResult);

  @override
  State<StatefulWidget> createState() {
    return SearchBarState();
  }
}

class SearchBarState extends State<SearchBar> {
  static bool _delOff = true; //是否展示删除按钮


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: double.infinity,
        height: 50,
        color: Colors.grey,
        padding: EdgeInsets.all(5),
        child: TextField(
          decoration: InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              fillColor: Colors.white,
              filled: true,
              contentPadding: EdgeInsets.all(8),
              suffixIcon: GestureDetector(
                child: Offstage(
                  offstage: _delOff,
                  child: Icon(
                    Icons.highlight_off,
                    color: Colors.grey,
                  ),
                ),
                onTap: () {
                  setState(() {
                    searchkey = "";
                    search(searchkey);
                  });
                },
              )),
          controller: TextEditingController.fromValue(
            TextEditingValue(
              text: searchkey,
              selection: TextSelection.fromPosition(
                TextPosition(
                  offset: searchkey == null ? 0 : searchkey.length, //保证光标在最后
                ),
              ),
            ),
          ),
          onChanged: search,
        ),
      ),
    );
  }

  ///关键字查找
  void search(String value) {
    searchkey = value;
    List<Node> tmp = List();
    if (value.isEmpty) { //如果关键字为空，代表全匹配
      _delOff = true;
      widget.onResult(null);
    } else { //如果有关键字，那么就去查找关键字
      _delOff = false;
      for (Node n in widget.list) {
        if (n.type == Node.typeMember) {
          Member m = n.object as Member;
          if (m.name.toLowerCase().contains(value.toLowerCase())) { //匹配大小写
            tmp.add(n);
          }
        }
      }
      widget.onResult(tmp);
    }
  }
}
