import 'package:cncours_quiz/app/data/providers/crud_provider.dart';
import 'package:get/get.dart';

class CrudController<M, R> extends GetxController with StateMixin<List<R>> {
  final String resource;
  M Function(dynamic) mE;
  R Function(dynamic) rE;
  CrudController({required this.resource, required this.mE, required this.rE});

  late CrudProvider crud;
  // state
  RxList<R> listing = RxList<R>([]);
  RxBool listingLoading = RxBool(false);
  Rx<M?> editing = Rx<M?>(null);
  Rx<R?> showing = Rx<R?>(null);
  Rx<R?> removed = Rx<R?>(null);
  Rx<R?> created = Rx<R?>(null);
  Rx<R?> modified = Rx<R?>(null);
  RxList<String> links = RxList<String>([]);
  Rx<Map<String, dynamic>> meta = Rx<Map<String, dynamic>>({});

  @override
  void onInit() {
    super.onInit();
    crud = CrudProvider(resource: resource, auth: false);
  }

// function to get records
  Future<void> list({bool load = false}) async {
    listingLoading.value = load;
    try {
      final response = await crud.list();
      if (response case {'data': final List data}) {
        listing.assignAll(data.map<R>(rE));
      }
    } catch (e) {
      print('CrudController.list error: $e');
    } finally {
      listingLoading.value = false;
    }
  }

  // function to show a record
  Future<void> show({required int id}) async {
    await crud
        .show(id: id)
        .then((response) => showing.value = rE(response['data']));
  }

  // function to edit a record
  Future<void> edit({bool auth = true, required String id}) async {
    await crud
        .edit(id: id)
        .then((response) => editing.value = mE(response['data']));
  }

  // // function to remove a record
  Future<void> remove({bool auth = true, required String id}) async {
    await crud
        .remove(id: id)
        .then((response) => removed.value = rE(response['data']));
  }

// Function to update a record
  Future<void> modify(
      {Map<String, dynamic> data = const {}, required String id}) async {
    await crud
        .modify(data: data, id: id)
        .then((response) => modified.value = rE(response['data']));
  }

// Function to create a record
  Future<void> create({required Map<String, dynamic> data}) async {
    await crud
        .create(data: data)
        .then((response) => created.value = rE(response['data']));
  }
}
