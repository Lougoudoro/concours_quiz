import 'package:cncours_quiz/app/core/client/error_handler.dart';
import 'package:cncours_quiz/app/core/helpers/storage_helper.dart';
import 'package:cncours_quiz/app/data/providers/session_provider.dart';
import 'package:cncours_quiz/app/data/resources/academic_session_resource.dart';
import 'package:cncours_quiz/app/data/resources/brand_resource.dart';
import 'package:cncours_quiz/app/data/resources/category_resource.dart';
import 'package:cncours_quiz/app/data/resources/concours_type_resource.dart';
import 'package:cncours_quiz/app/data/resources/quiz_resource.dart';
import 'package:cncours_quiz/app/data/resources/serie_resource.dart';
import 'package:get/get.dart';

class SessionController extends GetxController {
  late SessionProvider provider;

  final Rx<AcademicSessionResource?> activeSession =
      Rx<AcademicSessionResource?>(null);

  final Rx<ConcoursTypeResource?> selectedConcoursType =
      Rx<ConcoursTypeResource?>(null);
  final Rx<CategoryResource?> selectedSubCategory = Rx<CategoryResource?>(null);
  final Rx<SerieResource?> selectedCollection = Rx<SerieResource?>(null);
  final Rx<QuizResource?> selectedSerie = Rx<QuizResource?>(null);

  final RxList<BrandResource> brands = RxList<BrandResource>([]);
  final RxBool brandsLoading = RxBool(false);

  List<ConcoursTypeResource> get availableConcoursTypes =>
      activeSession.value?.concoursTypes ?? [];

  List<CategoryResource> get availableSubCategories =>
      selectedConcoursType.value?.categories ?? [];

  List<SerieResource> get availableCollections =>
      selectedSubCategory.value?.series ?? [];

  List<QuizResource> get availableSeries =>
      selectedCollection.value?.quizzes ?? [];

  BrandResource? get activeBrand => activeSession.value?.brand;

  @override
  void onInit() {
    super.onInit();
    provider = SessionProvider();
    fetchSelectedSession();
  }

  Future<void> fetchSelectedSession() async {
    bool success = false;
    await ErrorHandler.run(() async {
      final response = await provider.selectedSession();
      if (response['success'] == true) {
        setSession(AcademicSessionResource.fromJson(response['data']));
        _cacheSession();
        success = true;
      }
    }, context: 'SessionController.fetchSelectedSession');
    if (!success && activeSession.value == null) {
      _loadCachedSession();
    }
  }

  Future<void> fetchBrands() async {
    brandsLoading.value = true;
    await ErrorHandler.run(() async {
      final response = await provider.brands();
      if (response['success'] == true) {
        final data = response['data'] as List;
        brands.assignAll(data.map((e) => BrandResource.fromJson(e)));
      }
    }, context: 'SessionController.fetchBrands');
    brandsLoading.value = false;
  }

  Future<bool> selectBrandSession(BrandResource brand) async {
    final session = brand.currentSession;
    if (session == null) return false;

    bool success = false;
    await ErrorHandler.run(() async {
      final response = await provider.selectSession(session.id as int);
      if (response['success'] == true) {
        setSession(AcademicSessionResource.fromJson(response['data']));
        _cacheSession();
        success = true;
      }
    }, context: 'SessionController.selectBrandSession');
    return success;
  }

  void _cacheSession() {
    if (activeSession.value != null) {
      StorageHelper.set(
          StorageHelper.cachedSessionKey, activeSession.value!.toJson());
    }
  }

  void _loadCachedSession() {
    final cached = StorageHelper.get(StorageHelper.cachedSessionKey);
    if (cached is Map<String, dynamic>) {
      setSession(AcademicSessionResource.fromJson(cached));
    }
  }

  void setSession(AcademicSessionResource session) {
    activeSession.value = session;
    _resetSelections();
  }

  void selectConcoursType(ConcoursTypeResource type) {
    selectedConcoursType.value = type;
    selectedSubCategory.value = null;
    selectedCollection.value = null;
    selectedSerie.value = null;
  }

  void selectSubCategory(CategoryResource sub) {
    selectedSubCategory.value = sub;
    selectedCollection.value = null;
    selectedSerie.value = null;
  }

  void selectCollection(SerieResource coll) {
    selectedCollection.value = coll;
    selectedSerie.value = null;
  }

  void selectSerie(QuizResource serie) {
    selectedSerie.value = serie;
  }

  void _resetSelections() {
    selectedConcoursType.value = null;
    selectedSubCategory.value = null;
    selectedCollection.value = null;
    selectedSerie.value = null;
  }
}
