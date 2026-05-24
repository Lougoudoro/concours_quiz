
import 'package:cncours_quiz/app/core/client/my_client.dart';

class CrudProvider extends MyClient {
  final String resource;
  final bool auth;
  CrudProvider({required this.resource, this.auth=true});


// function to get records
  Future<dynamic> list() async {
    return await checkResponse(()=>clientGet(apiRoute: resource, auth: auth));
  }

  // function to show a record
  Future<dynamic> show({required int id}) async {
    return  await checkResponse(()=>clientGet(apiRoute: "$resource/$id/show", auth: auth));
  }


  // function to edit a record
  Future<dynamic> edit({required String id}) async {
    return  await checkResponse(()=>clientGet(apiRoute: "$resource/$id/edit", auth: auth));
  }

  // // function to remove a record
  Future<dynamic> remove({required String id}) async {
    return  await checkResponse(()=>clientDelete(apiRoute: "$resource/$id"));
  }

// Function to update a record
  Future<dynamic> modify({Map<String, dynamic> data = const {}, required String id}) async {
    return  await checkResponse(()=>clientPut(auth: auth, apiRoute: "$resource/$id"));
  }

// Function to create a record
  Future<dynamic> create({required Map<String, dynamic> data}) async {
   return await checkResponse(()=>clientPost(auth: auth, data: data, apiRoute: resource));
  }

  // @override
  // void onClose() {
  //   baseController=Get.re<BaseController<M,R>>(BaseController());
  // }
}
