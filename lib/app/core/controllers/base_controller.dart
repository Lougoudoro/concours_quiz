import 'package:get/get.dart';

class BaseController<M,R> extends GetxController with StateMixin<List<R>> {


  // state
  RxString test="test".obs;
  RxList<R> listing=RxList<R>([]);
  Rx<M?> editing=Rx<M?>(null);
  Rx<R?> showing=Rx<R?>(null);
  Rx<R?> removed=Rx<R?>(null);
  Rx<R?> created=Rx<R?>(null);
  Rx<R?> modified=Rx<R?>(null);
  RxList<String> links=RxList<String> ([]);
  Rx<Map<String, dynamic>> meta=Rx<Map<String, dynamic>>({});



  @override
  void onInit() {
    super.onInit();
  }

}
