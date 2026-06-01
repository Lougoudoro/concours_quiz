import 'package:cncours_quiz/app/data/resources/question_resource.dart';
import 'package:cncours_quiz/app/modules/exam/exam_controller.dart';
import 'package:get/get.dart';

class ExamBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.arguments == null) return;
    final args = Get.arguments as Map<String, dynamic>;
    final quizId = args['quizId'] as String;
    final questions = args['questions'] != null
        ? List<QuestionResource>.from(args['questions'])
        : null;

    Get.lazyPut<ExamController>(
      () => ExamController(
        quizId: quizId,
        quizName: args['quizName'] as String,
        initialQuestions: questions,
        totalSeconds: args['totalSeconds'] as int,
      ),
      tag: quizId,
    );
  }
}
