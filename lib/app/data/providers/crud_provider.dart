
import 'package:cncours_quiz/app/core/client/my_client.dart';
import 'package:get/get.dart';

class CrudProvider {
    final MyClient _client = Get.find<MyClient>();
  final String resource;
  CrudProvider({required this.resource});


// function to get records
  Future<dynamic> list() async {
    return await _client.clientGet(apiRoute: "/$resource");
  }

  // function to show a record
  Future<dynamic> show({required int id}) async {
    return  await  _client.clientGet(apiRoute: "/$resource/$id/show");
  }


  // function to edit a record
  Future<dynamic> edit({required String id}) async {
    return  await  _client.clientGet(apiRoute: "/$resource/$id/edit");
  }

  // // function to remove a record
  Future<dynamic> remove({required String id}) async {
    return   _client.clientDelete(apiRoute: "/$resource/$id");
  }

// Function to update a record
  Future<dynamic> modify({Map<String, dynamic> data = const {}, required String id}) async {
    return  await  _client.clientPut( apiRoute: "/$resource/$id");
  }

// Function to create a record
  Future<dynamic> create({required Map<String, dynamic> data}) async {
   return await  _client.clientPost( data: data, apiRoute: "/$resource");
  }

  // @override
  // void onClose() {
  //   baseController=Get.re<BaseController<M,R>>(BaseController());
  // }
}
