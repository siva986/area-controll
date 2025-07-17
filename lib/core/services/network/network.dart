import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:area_control/core/services/network/api_headers.dart';
import 'package:area_control/core/utils/apis.dart';
import 'package:area_control/repos/user_repo.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
  final bool showToast;
  final ApiHeaders? header;
  final bool enableLog;
  final Map<String, dynamic>? parms;
  final Map<String, dynamic>? query;
  final Map<String, dynamic>? pathParameters;
  final String endpoint;

  ApiHelper(this.endpoint, {this.showToast = true, this.header, this.query, this.pathParameters, this.enableLog = true, this.parms});

  Future<Responce> get post {
    return request("POST");
  }

  Future<Responce> get get {
    return request("GET");
  }

  Future<Responce> get put {
    return request("PUT");
  }

  Future<Responce> get delete {
    return request("DELETE");
  }

  UserRepo userRepo = UserRepo();

  Future<Responce> request(String req) async {
    String url = NetworkEndPoints.baseUrl.path + endpoint;
    log('>>>>>> $req  ${(url)}');
    http.Request request = http.Request(req, Uri.parse(url));

    final token = await userRepo.getToken();

    ApiHeaders headers = ApiHeaders();
    headers = header ?? headers;

    headers.auth = token;

    log('>>>>>> Headers  ${headers.apiheaders}');
    request.headers.addAll(headers.apiheaders);
    request.body = jsonEncode(parms ?? {});

    log('>>>>>> Body  ${request.body}');
    return request.send().then((value) {
      return value.stream.bytesToString().then((byte) {
        log('>>>>>> Responce   $byte');

        switch (value.statusCode) {
          case 200 || 201:
            return Responce(status: value.statusCode).extract(byte);
          default:
            throw Responce(status: value.statusCode).extract(byte);
        }
      });
    }).onError<Responce>((error, stackTrace) {
      log("a123ewda  ${error.toJson()}");

      throw AppException.handleException(error, showToast: showToast);
    });
  }
}

class AppException {
  static handleException(Responce error, {bool showToast = true}) {
    if (error is SocketException) {
      // ToastMsg("Check Your Internet Connection").show;
    } else if (error is http.ClientException) {
      // ToastMsg("Check Your Internet Connection").show;
    } else {
      // if (showToast) ToastMsg(error.msg).show;
    }
    throw error;
  }
}

class Responce {
  final int status;
  final dynamic data;
  final Pagination? paginaton;
  final String msg;
  final String error;

  Responce({this.data = "", required this.status, this.msg = "", this.error = "", this.paginaton});

  Responce extract(String byte) {
    final dynamic vv = jsonDecode(byte);
    return Responce(
      data: vv['data'] ?? vv,
      status: status,
      msg: vv['msg'] ?? "Not Provided",
      error: vv['error'] ?? "Not Provided",
      paginaton: Pagination.fromJson(vv['pagination'] ?? {}),
    );
  }

  Map toJson() {
    return {"data": data, "paginaton": paginaton == null ? {} : paginaton!.toJson(), "error": error, "msg": msg, "status": status};
  }
}

class Pagination {
  final int pageNo;
  final int totalCount;

  Pagination({this.pageNo = 1, this.totalCount = 0});

  Pagination.fromJson(Map<String, dynamic> json)
      : pageNo = json['page'] ?? 1,
        totalCount = json['total'] ?? 0;

  Map toJson() {
    return {"page": pageNo, "total": totalCount};
  }
}
