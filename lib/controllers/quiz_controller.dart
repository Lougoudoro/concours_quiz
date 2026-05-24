import 'dart:async';
import 'package:get/get.dart';
import '../models/question.dart';
import '../models/quiz_result.dart';
import '../data/sample_questions.dart';

class QuizController extends GetxController {
  final String categoryId;
  final String categoryName;

  QuizController({required this.categoryId, required this.categoryName});

  // State
  var questions = <Question>[].obs;
  var currentIndex = 0.obs;
  var selectedAnswerIds = <String>{}.obs;
  var isValidated = false.obs;
  var results = <QuestionResult>[].obs;
  
  // Timer state
  var elapsedSeconds = 0.obs;
  Timer? _timer;
  final Stopwatch stopwatch = Stopwatch();

  @override
  void onInit() {
    super.onInit();
    loadQuestions();
    startQuiz();
  }

  void loadQuestions() {
    questions.value = SampleQuestions.getQuestionsForCategory(categoryId);
  }

  void startQuiz() {
    stopwatch.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      elapsedSeconds.value = stopwatch.elapsed.inSeconds;
    });
  }

  String get elapsedFormatted {
    // Accessing .value here makes this property reactive when used inside Obx
    final seconds = elapsedSeconds.value;
    final d = Duration(seconds: seconds);
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Question get currentQuestion => questions[currentIndex.value];
  bool get isLastQuestion => currentIndex.value == questions.length - 1;
  double get progressValue => (currentIndex.value + 1) / questions.length;

  void toggleAnswer(String answerId) {
    if (isValidated.value) return;

    if (currentQuestion.type == QuestionType.vraiOuFaux) {
      selectedAnswerIds.clear();
      selectedAnswerIds.add(answerId);
    } else {
      if (selectedAnswerIds.contains(answerId)) {
        selectedAnswerIds.remove(answerId);
      } else {
        selectedAnswerIds.add(answerId);
      }
    }
  }

  void validateAnswer() {
    if (selectedAnswerIds.isEmpty) return;

    isValidated.value = true;
    results.add(QuestionResult(
      question: currentQuestion,
      userAnswerIds: Set.from(selectedAnswerIds),
    ));
  }

  void nextQuestion() {
    if (isLastQuestion) {
      stopwatch.stop();
      _timer?.cancel();
      Get.offNamed('/results', arguments: QuizResult(
        categoryName: categoryName,
        questionResults: results,
        totalTime: stopwatch.elapsed,
      ));
      return;
    }

    currentIndex.value++;
    selectedAnswerIds.clear();
    isValidated.value = false;
  }

  @override
  void onClose() {
    _timer?.cancel();
    stopwatch.stop();
    super.onClose();
  }
}
