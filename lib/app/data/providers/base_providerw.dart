import 'package:cncours_quiz/app/core/client/app_exception.dart';
import 'package:cncours_quiz/app/core/client/my_client.dart';
import 'package:cncours_quiz/app/core/controllers/base_controller.dart';
import 'package:cncours_quiz/app/core/helpers/dialog_helper.dart';
import 'package:get/get.dart';
class BaseProviderw<M, R> extends MyClient {
  final String resource;
  M Function(dynamic) mE;
  R Function(dynamic) rE;
  BaseController<M,R> baseController=Get.put<BaseController<M,R>>(BaseController());


  BaseProviderw({required this.resource,required this.mE,required this.rE});


// function to get records
  Future<void> list({bool auth = true}) async {
    await checkResponse(()=>clientGet(apiRoute: resource, auth: auth)).then((data){
      baseController.listing.value=data.map<R>(rE).toList();
    });
  }

  // function to show a record
  Future<void> show({bool auth = true, required int id}) async {
    await checkResponse(()=>clientGet(apiRoute: "$resource/$id/show", auth: auth)).then((value) {
      baseController.showing.value=rE(value);
    });
  }


  // function to edit a record
  Future<void> edit({bool auth = true, required String id}) async {
    await checkResponse(()=>clientGet(apiRoute: "$resource/$id/edit", auth: auth)).then((value) {
      baseController.editing.value=mE(value);
      });
  }

  // // function to remove a record
  Future<void> remove({bool auth = true, required String id}) async {
    await checkResponse(()=>clientDelete(apiRoute: "$resource/$id")).then((value) {
      baseController.removed.value=rE(value);
    });
  }

// Function to update a record
  Future<void> modify({bool auth = true, Map<String, dynamic> data = const {}, required String id}) async {
      await checkResponse(()=>clientPut(auth: auth, apiRoute: "$resource/$id")).then((value) {
        baseController.modified.value=rE(value);
      });
  }

// Function to create a record
  Future<void> create({bool auth = true, required Map<String, dynamic> data}) async {
    await checkResponse(()=>clientPost(auth: auth, data: data, apiRoute: resource)).then((value) {
      baseController.created.value=rE(value);
    });
  }

  Future<dynamic> checkResponse(Function query) async {
    print('kkkk');
    try {
      showLoading('....');
      print('kkkk2');
      var response = await query();
      hideLoading();
      if (response == null) {
        return Future.error(response);
      } else {
        return response['data']; // we have to adapt for meta
      }
    } catch (exception) {
      print('kkkk22');
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
    print(message);
    // DialogHelper.showLoading(message: message);
  }

  hideLoading() {
    DialogHelper.hideLoading();
  }

  // @override
  // void onClose() {
  //   baseController=Get.re<BaseController<M,R>>(BaseController());
  // }
}
