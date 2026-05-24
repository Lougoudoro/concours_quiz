import 'package:cncours_quiz/app/data/models/question.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class BookmarkController extends GetxController {
  final _box = GetStorage();
  final _key = 'bookmarked_questions';

  final RxList<Question> bookmarks = <Question>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadBookmarks();
  }

  void _loadBookmarks() {
    final stored = _box.read<List>(_key) ?? [];
    bookmarks.assignAll(stored
        .map((e) => Question.fromJson(e as Map<String, dynamic>))
        .toList());
  }

  bool isBookmarked(String questionId) =>
      bookmarks.any((q) => q.id == questionId);

  void toggle(Question question) {
    if (isBookmarked(question.id)) {
      bookmarks.removeWhere((q) => q.id == question.id);
    } else {
      bookmarks.add(question);
    }
    _save();
  }

  void _save() {
    _box.write(_key, bookmarks.map((q) => q.toJson()).toList());
  }
}
