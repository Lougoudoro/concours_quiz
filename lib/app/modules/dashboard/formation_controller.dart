import 'package:cncours_quiz/app/data/models/formation.dart';
import 'package:get/get.dart';

class FormationController extends GetxController {
  // ─── État ──────────────────────────────────────────────────────────
  final Rx<Session?> activeSession = Rx<Session?>(null);
  
  // Sélections actuelles
  final Rx<ConcoursType?> selectedConcoursType = Rx<ConcoursType?>(null);
  final Rx<SubCategory?> selectedSubCategory = Rx<SubCategory?>(null);
  final Rx<Collection?> selectedCollection = Rx<Collection?>(null);
  final Rx<Serie?> selectedSerie = Rx<Serie?>(null);

  // ─── Getters de Filtrage Dynamique ──────────────────────────────────
  
  // Liste des types (Directs / Professionnels) pour la session active
  List<ConcoursType> get availableConcoursTypes => 
      activeSession.value?.concoursTypes ?? [];

  // Liste des sous-catégories (Niveaux ou Secteurs)
  List<SubCategory> get availableSubCategories => 
      selectedConcoursType.value?.subCategories ?? [];

  // Liste des collections
  List<Collection> get availableCollections => 
      selectedSubCategory.value?.collections ?? [];

  // Liste des séries
  List<Serie> get availableSeries => 
      selectedCollection.value?.series ?? [];

  // ─── Méthodes de Sélection ──────────────────────────────────────────
  
  void setSession(Session session) {
    activeSession.value = session;
    _resetSelections();
  }

  void selectConcoursType(ConcoursType type) {
    selectedConcoursType.value = type;
    selectedSubCategory.value = null; // Réinitialise la suite
    selectedCollection.value = null;
    selectedSerie.value = null;
  }

  void selectSubCategory(SubCategory sub) {
    selectedSubCategory.value = sub;
    selectedCollection.value = null;
    selectedSerie.value = null;
  }

  void selectCollection(Collection coll) {
    selectedCollection.value = coll;
    selectedSerie.value = null;
  }

  void selectSerie(Serie serie) {
    selectedSerie.value = serie;
  }

  void _resetSelections() {
    selectedConcoursType.value = null;
    selectedSubCategory.value = null;
    selectedCollection.value = null;
    selectedSerie.value = null;
  }

}
