import 'dart:async';
import 'package:cncours_quiz/app/core/client/error_handler.dart';
import 'package:cncours_quiz/app/data/providers/quiz_provider.dart';
import 'package:cncours_quiz/app/routes/app_pages.dart';
import 'package:cncours_quiz/app/data/resources/question_resource.dart';
import 'package:cncours_quiz/app/data/models/quiz_result.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../history/history_controller.dart';

class QuizController extends GetxController with WidgetsBindingObserver {
  final String quizId;
  final String quizName;
  final List<QuestionResource>? initialQuestions;
  late QuizProvider quizProvider;

  QuizController({
    required this.quizId,
    required this.quizName,
    this.initialQuestions,
  });

  // State
  var questions = <QuestionResource>[].obs;
  var currentIndex = 0.obs;
  var selectedAnswerIds = <int>{}.obs;
  var isValidated = false.obs;
  var results = <QuestionResult>[].obs;

  // Timer state
  var elapsedSeconds = 0.obs;
  Timer? _timer;
  final Stopwatch stopwatch = Stopwatch();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    quizProvider = QuizProvider();
    loadQuestions();
    startQuiz();
  }

  void loadQuestions() async {
    if (initialQuestions != null && initialQuestions!.isNotEmpty) {
      questions.assignAll(initialQuestions!);
      return;
    }
    await fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    await ErrorHandler.run(() async {
      final response = await quizProvider.questions(id: quizId);
      if (response case {'data': final List data}) {
        questions.assignAll(
          data.map<QuestionResource>((json) => QuestionResource.fromJson(json)),
        );
      }
    }, context: 'QuizController.fetchQuestions');
  }

  void startQuiz() {
    stopwatch.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      elapsedSeconds.value = stopwatch.elapsed.inSeconds;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _pauseTimer();
    } else if (state == AppLifecycleState.resumed) {
      _resumeTimer();
    }
  }

  void _pauseTimer() {
    if (stopwatch.isRunning) {
      stopwatch.stop();
      _timer?.cancel();
      _timer = null;
    }
  }

  void _resumeTimer() {
    if (!stopwatch.isRunning && !isValidated.value && !isLastQuestion) {
      stopwatch.start();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        elapsedSeconds.value = stopwatch.elapsed.inSeconds;
      });
    }
  }

  String get elapsedFormatted {
    final seconds = elapsedSeconds.value;
    final d = Duration(seconds: seconds);
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  QuestionResource get currentQuestion => questions[currentIndex.value];
  bool get isLastQuestion => currentIndex.value == questions.length - 1;
  double get progressValue =>
      (currentIndex.value + 1) / (questions.isEmpty ? 1 : questions.length);

  void toggleAnswer(int answerId) {
    if (isValidated.value) return;

    if (currentQuestion.isVraiOuFaux) {
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
    final isCorrect = _checkIsCorrect();

    // Feedback haptique
    if (isCorrect) {
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.mediumImpact();
    }

    results.add(QuestionResult(
      question: currentQuestion,
      userAnswerIds: Set<int>.from(selectedAnswerIds),
    ));
  }

  bool _checkIsCorrect() {
    final correctIds = currentQuestion.correctAnswerIds;
    if (selectedAnswerIds.length != correctIds.length) return false;
    return selectedAnswerIds.every((id) => correctIds.contains(id));
  }

  void nextQuestion() {
    if (isLastQuestion) {
      stopwatch.stop();
      _timer?.cancel();

      final result = QuizResult(
        quizName: quizName,
        questionResults: results.toList(),
        totalTime: stopwatch.elapsed,
      );

      // Sauvegarde dans l'historique
      try {
        Get.find<HistoryController>().addResult(result);
      } catch (e) {
        // Ignorer si pas injecté (ex: tests)
      }

      Get.offNamed(Routes.RESULTS, arguments: result);
      return;
    }

    currentIndex.value++;
    selectedAnswerIds.clear();
    isValidated.value = false;
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    stopwatch.stop();
    super.onClose();
  }
}
