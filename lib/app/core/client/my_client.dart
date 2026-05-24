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
    switch (response.statusCode) {
      case 200:
        var responseJson = await response.bodyBytes!.first;
        var decodedResponse = jsonDecode(utf8.decode(responseJson));
        return decodedResponse;
      case 201:
        var responseJson = await response.bodyBytes!.first;
        var decodedResponse = jsonDecode(utf8.decode(responseJson));
        return decodedResponse;
      case 400:
      case 405:
      case 401:
        var responseJson = await response.bodyBytes!.first;
        var decodedResponse = jsonDecode(utf8.decode(responseJson));
        return decodedResponse;
      case 403:
      case 422:
        var responseJson = await response.bodyBytes!.first;
        var decodedResponse = jsonDecode(utf8.decode(responseJson));
        return decodedResponse;
      // throw BadRequestException(utf8.decode(await response.bodyBytes!.first),
      //     response.request!.url.toString());
      case 500:
        throw BadRequestException(utf8.decode(await response.bodyBytes!.first),
            response.request!.url.toString());
      default:
        throw FetchDataException(
            'Error occured with code : ${response.statusCode}',
            response.request!.url.toString());
    }
    // Add this line
  }

  Future<dynamic> checkResponse(Function query) async {
    print('kkkk');
    try {
      showLoading('dssd');
      print('kkkk2');

      print('object00000');
      var response = await query();

      hideLoading();

      if (response == null) {
        return Future.error(response);
      } else {
        return response; // we have to adapt for meta
      }
    } catch (exception) {
      handleError(exception);
    }
  }

  void handleError(error) {
    hideLoading();
    if (error is BadRequestException) {
      var message = error.message;
      DialogHelper.showErroDialog(description: message);
    } else if (error is FetchDataException) {
      var message = error.message;
      DialogHelper.showErroDialog(description: message);
    } else if (error is ApiNotRespondingException) {
      DialogHelper.showErroDialog(
          description: 'Oops! It took longer to respond.');
    } else {
      DialogHelper.showErroDialog(description: 'Erreur inconnu!');
    }
  }

  showLoading(String? message) {
    print('message');
    // DialogHelper.showLoading(message: message);
    print('message444');
  }

  hideLoading() {
    DialogHelper.hideLoading();
  }
}
