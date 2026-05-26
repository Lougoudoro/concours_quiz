import 'package:cncours_quiz/app/data/resources/question_resource.dart';
import 'package:cncours_quiz/app/modules/quiz/quiz_controller.dart';
import 'package:get/get.dart';

class QuizBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.arguments == null) return;
    final args = Get.arguments as Map<String, dynamic>;
    final categoryId = args['categoryId'] as String;
    final questions = args['questions'] != null
        ? List<QuestionResource>.from(args['questions'])
        : null;

    Get.lazyPut<QuizController>(
      () => QuizController(
        categoryId: categoryId,
        categoryName: args['categoryName'] as String,
        initialQuestions: questions,
      ),
      tag: categoryId,
    );
  }
}
