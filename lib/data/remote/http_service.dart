


import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';
import 'package:http_parser/http_parser.dart';

import '../../core/constants/api_key.dart';
import '../models/cat_list_res.dart';
import 'http_helper.dart';


class HttpService{
  static bool isTester = true;
  static String SERVER_DEV = "api.thecatapi.com";
  static String SERVER_PROD = "api.thecatapi.com";

  static String getServer(){
    if(isTester)return SERVER_DEV;
    return SERVER_PROD;
  }
  static final _client = InterceptedClient.build(
    interceptors: [
      MyInterceptor(),
    ],
    retryPolicy: MyRetryPolicy(),
  );

  /* HTTP REQUESTS */
  static Future<String?> GET(String api,Map<String,String>params)async{
    try{
      var uri = Uri.https(getServer(),api,params);
      var response = await _client.get(uri);
      if(response.statusCode==200){
        return response.body;
      }else{
        _throwException(response);
      }
    }on SocketException catch(_){
      // If the network connection fails
      rethrow;
    }
    return null;
  }

  static Future<String?> MUL(String api,File file,Map<String,String>params)async{
    try{
      var uri = Uri.https(getServer(),api);
      var request = MultipartRequest("POST", uri);
      request.headers['x-api-key'] = API_KEY;
      request.headers['Content-Type'] = 'multipart/form-data';

      request.files.add(
        MultipartFile("file", file.readAsBytes().asStream(), file.lengthSync(),
            filename: file.path.split("/").last,
            contentType: MediaType("image","jpeg")
        ),
      );

      request.fields.addAll(params);
      StreamedResponse streamedResponse = await request.send();
      var response = await Response.fromStream(streamedResponse);
      if(response.statusCode==201){
        return response.body;
      }else{
        _throwException(response);
      }
    } on SocketException catch(_){
      // If the network connection fails
      rethrow;
    }
    return null;
  }

  /* Handling Exceptions */
  static _throwException(Response response){
    String reason = response.reasonPhrase!;
    switch(response.statusCode){
      case 400:
        throw BadRequestException(reason);
      case 401:
        throw InvalidInputException(reason);
      case 403:
        throw UnauthorisedException(reason);
      case 404:
        throw FetchDataException(reason);
      case 500:
      default:
        throw FetchDataException(reason);
    }
  }

  /* HTTP APIS */
  static String API_CAT_GET = "/v1/images";
  static String API_CAT_UPLOAD = "/v1/images/upload";

  /* HTTP PARAMS */
  static Map<String,String> paramsEmpty(){
    Map<String,String> params = {};
    return params;
  }

  // limit = 20 &page=0&order=DESC
  static Map<String,String> paramsCatList({required int currentPage}){
    Map<String,String> params = {};
    params.addAll({
      "limit":"20",
      "page":"$currentPage",
      "order":"DESC"
    });
    return params;
  }

  /* HTTP PARSING */
  static List<CatListRes> parseCatList(String response){
    dynamic json = jsonDecode(response);
    return List<CatListRes>.from(json.map((x)=>CatListRes.fromJson(x)));
  }

}