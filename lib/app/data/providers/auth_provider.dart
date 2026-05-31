import 'package:cncours_quiz/app/core/client/my_client.dart';
import 'package:get/get.dart';

class AuthProvider {
  final MyClient _client = Get.find<MyClient>();

  Future<dynamic> login({required Map<String, dynamic> data}) async {
    return _client.clientPost( data: data, apiRoute: "/login");
  }

  Future<dynamic> register({required Map<String, dynamic> data}) async {
    return _client.clientPost( data: data, apiRoute: "/register");
  }

  Future<dynamic> logout() async {
    return _client.clientPost( data: {}, apiRoute: "/logout");
  }

  Future<dynamic> user() async {
    return _client.clientGet( apiRoute: "/user");
  }

  Future<dynamic> changePassword({required Map<String, dynamic> data}) async {
    return _client.clientPost(
         data: data, apiRoute: "/change-password");
  }

  Future<dynamic> updateProfile({required Map<String, dynamic> data}) async {
    return _client.clientPut(
         data: data, apiRoute: "/update-profile");
  }

  Future<dynamic> uploadPhoto({required String filePath}) async {
    return _client.clientUpload(
      
      apiRoute: "/update-profile-photo",
      fileField: "profile_photo",
      filePath: filePath,
    );
  }

  Future<dynamic> deletePhoto() async {
    return _client.clientDeletePhoto(
      
      apiRoute: "/delete-profile-photo",
    );
  }
}
