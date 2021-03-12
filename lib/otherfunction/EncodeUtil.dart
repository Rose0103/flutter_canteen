import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:io';
import 'logutil.dart';
class EncodeUtil {
  /*
  * Md5加密
  * */
  static String generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return digest.toString();
  }

  /*
  * Base64加密
  */
  static String encodeBase64(String data) {
    var content = utf8.encode(data);
    var digest = base64Encode(content);
    return digest;
  }

  /*
  * Base64解密
  */
  //static String decodeBase64(String data) {
  //  return String.fromCharCodes(base64Decode(data));
  //}

  /*
  * Base64解密
  */
  static String decodeBase64(String data){
    List<int> bytes = base64Decode(data);
    // 网上找的很多都是String.fromCharCodes，这个中文会乱码
    //String txt1 = String.fromCharCodes(bytes);
    String result = utf8.decode(bytes);
    return result;
  }

  /*
  * 通过图片路径将图片转换成Base64字符串
  */
  static Future image2Base64(String path) async {
    String temppath=path.replaceAll("File: '", "");
    temppath=temppath.replaceAll("'","");
    File file = new File(temppath);
    bool isok=await file.exists();
    if(!isok)
      {
        LogUtil.d("2222222222222");
      }
    List<int> imageBytes =  file.readAsBytesSync();

    String base64Image;
    if(path.contains("png"))
      base64Image = await 'data:image/png;base64,' + base64Encode(imageBytes);
    else
      base64Image = await 'data:image/jpg;base64,' + base64Encode(imageBytes);
    return base64Image;
  }
}
