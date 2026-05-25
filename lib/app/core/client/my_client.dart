import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cncours_quiz/app/data/models/token.dart';


import '../helpers/dialog_helper.dart';

import '../helpers/env_helper.dart';
import 'package:get/get.dart';

import 'app_exception.dart';

class MyClient extends GetConnect {
  static const int timeOutDuration = 200;
// method to get data from the database
  Future<dynamic> clientGet(
      {bool auth = true, required String apiRoute}) async {
    try {
      var response =
          await get((EnvHelper.apiUrl + apiRoute), headers: headers(auth: auth))
              .timeout(const Duration(seconds: timeOutDuration));
      return processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', '');
    } on TimeoutException {
      throw ApiNotRespondingException('API not responded in time', '');
    }
  }

  // method to delete data from database
  Future<dynamic> clientDelete(
      {bool auth = true, required String apiRoute}) async {
    try {
      var response = await delete(EnvHelper.apiUrl + apiRoute,
              headers: headers(auth: auth))
          .timeout(const Duration(seconds: timeOutDuration));
      return processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', '');
    } on TimeoutException {
      throw ApiNotRespondingException('API not responded in time', '');
    }
  }

// method to put data to the database
  Future<dynamic> clientPut(
      {required bool auth,
      Map<String, dynamic> data = const {},
      required String apiRoute}) async {
    try {
      final response = await put(EnvHelper.apiUrl + apiRoute, jsonEncode(data),
              headers: headers(auth: auth))
          .timeout(const Duration(seconds: timeOutDuration));
      return processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', '');
    } on TimeoutException {
      throw ApiNotRespondingException('API not responded in time', '');
    }
  }

// methode to post data to the database
  Future<dynamic> clientPost(
      {required bool auth,
      required Map<String, dynamic> data,
      required String apiRoute}) async {
    try {
      final response = await post(
              (EnvHelper.apiUrl + apiRoute), jsonEncode(data),
              headers: headers(auth: auth))
          .timeout(const Duration(seconds: timeOutDuration));
      return processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', '');
    } on TimeoutException {
      throw ApiNotRespondingException('API not responded in time', '');
    }
  }

  Map<String, String> headers({auth = false}) => auth
      ? {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Token.get()}'
        }
      : {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        };

  dynamic processResponse(Response response) async {
     Map<String, dynamic> data = response.body;
      return data;
  }
}
