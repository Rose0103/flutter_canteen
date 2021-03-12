import 'dart:math';

class CompareStr{
  // final String str1,str2;
  // CompareStr({this.str1,this.str2});

  int compare(String str1, String str2){
    final minCount = min(str1.length, str2.length);
    for (var i = 0; i < minCount; i++) {
      final l1 = str1.codeUnitAt(i);
      final l2 = str2.codeUnitAt(i);
      if(l1>l2){
        return 1;
      }else if(l1<l2){
        return -1;
      }else{
        continue;
      }
    }
    if(str1.length>str2.length){
      return 1;
    }else if(str1.length<str2.length){
      return -1;
    }else{
      return 0;
    }
  }
}