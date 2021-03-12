import 'package:dio/dio.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/otherfunction/logutil.dart';
import 'dart:async';
import '../config/service_url.dart';
import '../common/shared_preference.dart';
import 'package:flutter_canteen/model/logindatamodel.dart';
import 'dart:convert';

getHeaders(String cookie) {
  return {
    'Accept':
        'application/json, text/plain,application/x-www-form-urlencoded,application/form-data, */*',
    'Content-Type': 'application/json,application/x-www-form-urlencoded',
    'Authorization': "**",
    'User-Aagent': "4.1.0;android;6.0.1;default;A001",
    "HZUID": "2",
    "cookie": cookie,
  };
}


//put接口
Future requestPut(url, String params, {formData}) async {
  Response response;
  Dio dio = new Dio();
  try {

    print('开始获取数据...............' + url);
    Response response;
    Dio dio = new Dio();
    dio.options.connectTimeout = 10000;
    //dio.options.contentType=ContentType.parse("application/x-www-form-urlencoded");
    String cookie = await KvStores.get(KeyConst.COOKIES);
    print(cookie);
    print(11111111);
    if (cookie == null) {}
    dio.options.headers = getHeaders(cookie);
    if (formData == null) {
      print(servicePath[url] + params);
      response = await dio.put(servicePath[url] + params,
          onSendProgress: (send, total) {
            print('已发送：$send  总大小：$total');
          });
    } else {
      print(servicePath[url] + params);
      response = await dio.put(servicePath[url] + params, data: formData,
          onSendProgress: (send, total) {
            print('已发送：$send  总大小：$total');
          });
    }
    print("response.statusCode${response.statusCode}");
    if (response.statusCode == 200) {
      if ((response.headers.value("set-cookie") != null)&&("loginByUsername".compareTo(url)==0)) {
        await KvStores.save(KeyConst.COOKIES, response.headers.value("set-cookie"));
        print("setcookie${response.headers.value('set-cookie')}");
      }
      print(response.data.toString());
      return response.data;
    }
    else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    if(e.toString().contains("401")) {
      print("401");
      if(!isYouKe){
        String userName=await KvStores.get(KeyConst.USER_NAME);
        String passwd=await KvStores.get(KeyConst.PASSWORD);
        await relogin(userName,passwd);
      }else{
        await relogin(yUserName,yPassword);
      }
      response = await dio.put(servicePath[url] + params, data: formData,
          onSendProgress: (send, total) {
            print('已发送：$send  总大小：$total');
          });

      if (response.statusCode == 200) {
        if ((response.headers.value("set-cookie") != null)&&("loginByUsername".compareTo(url)==0)) {
          await KvStores.save(KeyConst.COOKIES, response.headers.value("set-cookie"));
        }
        return response.data;
      }
      else {
        throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
      }
    }

    return print('ERROR:======>${e}');
  }
}

//post接口
Future request(url, String params, {formData}) async {
  Response response;
  Dio dio = new Dio();
  try {
    print('开始获取数据...............' + url);

    dio.options.connectTimeout = 10000;
    //dio.options.contentType=ContentType.parse("application/x-www-form-urlencoded");
    String cookie = await KvStores.get(KeyConst.COOKIES);
    print(cookie);
    print(11111111);
    if (cookie == null) {}
    dio.options.headers = getHeaders(cookie);
    if (formData == null) {
      print(servicePath[url] + params);
      response = await dio.post(servicePath[url] + params,
          onSendProgress: (send, total) {
        print('已发送：$send  总大小：$total');
      });
    } else {
      print(servicePath[url] + params);
      response = await dio.post(servicePath[url] + params, data: formData,
          onSendProgress: (send, total) {
        print('已发送：$send  总大小：$total');
      });
    }
    print("response.statusCode${response.statusCode}");
    if (response.statusCode == 200) {
      if ((response.headers.value("set-cookie") != null)&&("loginByUsername".compareTo(url)==0)) {
        await KvStores.save(KeyConst.COOKIES, response.headers.value("set-cookie"));
        print("setcookie${response.headers.value('set-cookie')}");
      }
      print(response.data.toString());
      return response.data;
    }
    else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    if(e.toString().contains("401")) {
      print("401");
      if(!isYouKe){
        String userName=await KvStores.get(KeyConst.USER_NAME);
        String passwd=await KvStores.get(KeyConst.PASSWORD);
        await relogin(userName,passwd);
      }else{
        await relogin(yUserName,yPassword);
      }
      response = await dio.post(servicePath[url] + params, data: formData,
          onSendProgress: (send, total) {
            print('已发送：$send  总大小：$total');
          });

      if (response.statusCode == 200) {
        if ((response.headers.value("set-cookie") != null)&&("loginByUsername".compareTo(url)==0)) {
          await KvStores.save(KeyConst.COOKIES, response.headers.value("set-cookie"));
        }
        return response.data;
      }
      else {
        throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
      }
    }
    return print('ERROR:======>${e}');
  }
}

//get接口
Future requestGet(url, String params) async {
  Response response;
  Dio dio = new Dio();
  try {
    print('开始获取数据...............' + url);

    dio.options.connectTimeout = 10000;
    //dio.options.contentType=ContentType.parse("application/x-www-form-urlencoded");
    //loginByUsername
    String cookie = await KvStores.get(KeyConst.COOKIES);
    print("cookie:$cookie");
    print(11111111);
    dio.options.headers = getHeaders(cookie);
    print(params);
    if (params.length==0) {
      print(servicePath[url]);
      print("bbbbbbbbbbb");
      response = await dio.get(
        servicePath[url],
      );
      print("aaaaaaaaaa");
    } else {
      print(2222222);
      print(servicePath[url]+params);
      response = await dio.get(servicePath[url] + params);
    }

    print("response.statusCode${response.statusCode}");
    if (response.statusCode == 200) {
      if (response.headers.value("cookie") != null) {
        print(response.headers.value("cookie"));
        await KvStores.save(KeyConst.COOKIES, response.headers.value("cookie"));
      }
      LogUtil.v("get_fanhui----${response.data.toString()}");
      return response.data;
    }
    else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    if(e.toString().contains("401")) {
        print("401");
        if(!isYouKe){
          String userName=await KvStores.get(KeyConst.USER_NAME);
          String passwd=await KvStores.get(KeyConst.PASSWORD);
          await relogin(userName,passwd);
        }else{
          await relogin(yUserName,yPassword);
        }
        response = await dio.get(servicePath[url] + params);
        if (response.statusCode == 200) {
          if (response.headers.value("cookie") != null) {
            await KvStores.save(KeyConst.COOKIES, response.headers.value("cookie"));
          }
          return response.data;
        }else {
          throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
        }
      }
    return print('ERROR:======>${e}');
  }
}

//delete接口
Future requestDelete(url, String params, {formData}) async {
  Response response;
  Dio dio = new Dio();
  try {
    print('开始获取数据...............' + url);
    dio.options.connectTimeout = 10000;
    //dio.options.contentType=ContentType.parse("application/x-www-form-urlencoded");
    String cookie = await KvStores.get(KeyConst.COOKIES);
    print(cookie);
    if (cookie == null) {}
    dio.options.headers = getHeaders(cookie);
    if (formData == null) {
      print(servicePath[url] + params);
      response = await dio.delete(servicePath[url] + params);
    } else {
      print(servicePath[url] + params);
      response = await dio.delete(servicePath[url] + params, data: formData);
    }
    print("response.statusCode${response.statusCode}");
    if (response.statusCode == 200) {
      if ((response.headers.value("set-cookie") != null)&&("loginByUsername".compareTo(url)==0)) {
        await KvStores.save(KeyConst.COOKIES, response.headers.value("set-cookie"));
        print("setcookie${response.headers.value('set-cookie')}");
      }
      LogUtil.v(response.data.toString());
      return response.data;
    }
    else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    if(e.toString().contains("401")) {
      print("401");
      if(!isYouKe){
        String userName=await KvStores.get(KeyConst.USER_NAME);
        String passwd=await KvStores.get(KeyConst.PASSWORD);
        await relogin(userName,passwd);
      }else{
        await relogin(yUserName,yPassword);
      }
      if (formData == null) {
        print(servicePath[url] + params);
        response = await dio.delete(servicePath[url] + params);
      } else {
        print(servicePath[url] + params);
        response = await dio.delete(servicePath[url] + params, data: formData);
      }
      if (response.statusCode == 200) {
        if (response.headers.value("cookie") != null) {
          await KvStores.save(KeyConst.COOKIES, response.headers.value("cookie"));
        }
        return response.data;
      }else {
        throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
      }
    }
    return print('ERROR:======>${e}');
  }
}

//获取首页轮播/导航/食堂信息
Future getHomePageContent(String url) async {
  Response response;
  Dio dio = new Dio();
  try {
    print('开始获取首页数据...............');
    // dio.options.contentType =
    //    ContentType.parse("application/x-www-form-urlencoded");
    String cookie = await KvStores.get(KeyConst.COOKIES);
    dio.options.headers = getHeaders(cookie);
    String username = await KvStores.get(KeyConst.USER_NAME);

    var formData = {'user': username};
    print(servicePath[url]);
    response = await dio.get(servicePath[url]);
    print("response.statusCode${response.statusCode}");
    if (response.statusCode == 200) {
      return response.data;
    }
    else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    if(e.toString().contains("401"))
    {
      print("401");
      String userName=await KvStores.get(KeyConst.USER_NAME);
      String passwd=await KvStores.get(KeyConst.PASSWORD);
      await relogin(userName,passwd);
      response = await dio.get(servicePath[url]);
      if (response.statusCode == 200) {
        if (response.headers.value("cookie") != null) {
          await KvStores.save(KeyConst.COOKIES, response.headers.value("cookie"));
        }
        return response.data;
      }else {
        throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
      }
    }
    return print('ERROR:======>${e}');
  }
}
//get接口
Future requestMapGet(url, Map<String,dynamic> params) async {
  Response response;
  Dio dio = new Dio();
  try {
    print('开始获取数据...............' + url);

    dio.options.connectTimeout = 10000;
    //dio.options.contentType=ContentType.parse("application/x-www-form-urlencoded");
    //loginByUsername
    String cookie = await KvStores.get(KeyConst.COOKIES);
    print(cookie);
    dio.options.headers = getHeaders(cookie);
    print(params);
    if (params.length==0&&params.isEmpty) {
      print(servicePath[url]);
      response = await dio.get(
        servicePath[url],
      );
    } else {
      print(servicePath[url]);
      response = await dio.get(url,queryParameters: params);
    }

    print("response.statusCode${response.statusCode}");
    if (response.statusCode == 200) {
      if (response.headers.value("cookie") != null) {
        print(response.headers.value("cookie"));
        await KvStores.save(KeyConst.COOKIES, response.headers.value("cookie"));
      }
      print("get_fanhui----${response.data.toString()}");
      return response.data;
    }
    else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch (e) {
    if(e.toString().contains("401"))
    {
      print("401");
      String userName=await KvStores.get(KeyConst.USER_NAME);
      String passwd=await KvStores.get(KeyConst.PASSWORD);
      await relogin(userName,passwd);
      if (params.length==0&&params.isEmpty) {
        print(servicePath[url]);
        response = await dio.get(
          servicePath[url],
        );
      } else {
        print(servicePath[url]);
        response = await dio.get(url,queryParameters: params);
      }
      if (response.statusCode == 200) {
        if (response.headers.value("cookie") != null) {
          await KvStores.save(KeyConst.COOKIES, response.headers.value("cookie"));
        }
        return response.data;
      }else {
        throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
      }
    }
    return print('ERROR:======>${e}');
  }
}

void relogin(String username, String password) async {
  var data = {
    'phone_num': username,
    'password': password,
  };
  await request('loginByUsername', '',formData: data).then((val) {
    if (val != null) {

      var data = val;
      print(data);
      loginDataModel loginModel = loginDataModel.fromJson(data);
      print(loginModel.code);
    }
  });
}

BaseOptions options = new BaseOptions(
//    baseUrl: "http://www.baidu.com",
//    connectTimeout: 10000,
//    receiveTimeout: 5000,
  headers: {
    'Accept': 'application/json, text/plain,application/x-www-form-urlencoded,application/form-data, */*',
    'Content-Type': 'application/json',
    'Access-Control-Allow-Credentials': 'true',
//      'Access-Control-Allow-Orign':"http://canteen.yangguangshitang.com/",
    'Access-Control-Allow-Orign':"*",
//      'Accept-Encoding':'gzip, deflate',
    'Accept-Language':'zh-CN,zh;q=0.9',
    'Cache-Control':'max-age=0',
//      'Connection':'keep-alive',
//      'Host':'aip.baidubce.com',
    'Upgrade-Insecure-Requests':'1',
//      'User-Agent':'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1'
  },
);


//获取百度得token
Future getToken() async {
  print("333333333333");
  Response response;
  Dio dio = new Dio(options);
  try {
    dio.options.connectTimeout = 10000;
    response = await dio.get("https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=Eyf7HFz3VVC7u2QkKic7vqik&client_secret=rkREPE8YXpeVub7YLnMpqGIKg1stfQpy");
    var data = json.decode(response.toString());
    baiduToken = data["access_token"];
    print(baiduToken);
    print("response.statusCode${response.toString()}");
  } catch (e) {
    if(e.toString().contains("401")) {
      if(!isYouKe){
      }else{
        await relogin(yUserName,yPassword);
      }
      if (response.statusCode == 200) {

      }else {
        throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
      }
    }
  }
}