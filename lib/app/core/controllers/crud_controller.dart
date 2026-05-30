import 'package:cncours_quiz/app/core/client/error_handler.dart';
import 'package:cncours_quiz/app/core/helpers/storage_helper.dart';
import 'package:cncours_quiz/app/data/providers/crud_provider.dart';
import 'package:get/get.dart';

class CrudController<M, R> extends GetxController with StateMixin<List<R>> {
  final String resource;
  M Function(dynamic) mE;
  R Function(dynamic) rE;
  CrudController({required this.resource, required this.mE, required this.rE});

  late CrudProvider crud;
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

  Future<void> list({bool load = false}) async {
    listingLoading.value = load;
    bool success = false;
    await ErrorHandler.run(() async {
      final response = await crud.list();
      if (response case {'data': final List data}) {
        listing.assignAll(data.map<R>(rE));
        _cacheListing();
        success = true;
      }
    }, context: 'CrudController.list');
    if (!success && listing.isEmpty) {
      _loadCachedListing();
    }
    listingLoading.value = false;
  }

  void _cacheListing() {
    final data = listing
        .map((e) => (e as dynamic).toJson() as Map<String, dynamic>)
        .toList();
    StorageHelper.set(_cacheKey, data);
  }

  void _loadCachedListing() {
    final cached = StorageHelper.get(_cacheKey);
    if (cached is List) {
      listing.assignAll(cached.map((e) => rE(e as Map<String, dynamic>)));
    }
  }

  String get _cacheKey => StorageHelper.cachedCrudListKey(resource);

  Future<void> show({required int id}) async {
    await ErrorHandler.run(() async {
      final response = await crud.show(id: id);
      showing.value = rE(response['data']);
    }, context: 'CrudController.show');
  }

  Future<void> edit({bool auth = true, required String id}) async {
    await ErrorHandler.run(() async {
      final response = await crud.edit(id: id);
      editing.value = mE(response['data']);
    }, context: 'CrudController.edit');
  }

  Future<void> remove({bool auth = true, required String id}) async {
    await ErrorHandler.run(() async {
      final response = await crud.remove(id: id);
      removed.value = rE(response['data']);
    }, context: 'CrudController.remove');
  }

  Future<void> modify({
    Map<String, dynamic> data = const {},
    required String id,
  }) async {
    await ErrorHandler.run(() async {
      final response = await crud.modify(data: data, id: id);
      modified.value = rE(response['data']);
    }, context: 'CrudController.modify');
  }

  Future<void> create({required Map<String, dynamic> data}) async {
    await ErrorHandler.run(() async {
      final response = await crud.create(data: data);
      created.value = rE(response['data']);
    }, context: 'CrudController.create');
  }
}
