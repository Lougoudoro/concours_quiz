import 'dart:async';
import 'package:cncours_quiz/app/core/client/error_handler.dart';
import 'package:cncours_quiz/app/data/models/question_result.dart';
import 'package:cncours_quiz/app/data/providers/quiz_provider.dart';
import 'package:cncours_quiz/app/routes/app_pages.dart';
import 'package:cncours_quiz/app/data/resources/question_resource.dart';
import 'package:cncours_quiz/app/data/models/quiz_result.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../history/history_controller.dart';

class ExamController extends GetxController with WidgetsBindingObserver {
  final int quizId;
  final String quizName;
  final List<QuestionResource>? initialQuestions;
  final int totalSeconds;
  late QuizProvider quizProvider;

  ExamController({
    required this.quizId,
    required this.quizName,
    this.initialQuestions,
    required this.totalSeconds,
  });

  var questions = <QuestionResource>[].obs;
  var currentIndex = 0.obs;
  var selectedAnswerIds = <int>{}.obs;
  var isValidated = false.obs;
  var results = <QuestionResult>[].obs;

  var remainingSeconds = 0.obs;
  Timer? _countdownTimer;
  var isTimeUp = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    quizProvider = QuizProvider();
    loadQuestions();
    _startCountdown();
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
    }, context: 'ExamController.fetchQuestions');
  }

  Future<void> submitResult() async {
    
  }

  void _startCountdown() {
    remainingSeconds.value = totalSeconds;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        _onTimeUp();
      }
    });
  }

  void _onTimeUp() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    isTimeUp.value = true;

    if (!isValidated.value && selectedAnswerIds.isNotEmpty) {
      _validateAndRecord();
    }

    _submitExam();
  }

  void _validateAndRecord() {
    isValidated.value = true;
    results.add(QuestionResult(
      question: currentQuestion,
      userAnswerIds: Set<int>.from(selectedAnswerIds),
    ));
  }

  void _submitExam() {
    for (var i = currentIndex.value + 1; i < questions.length; i++) {
      results.add(QuestionResult(
        question: questions[i],
        userAnswerIds: {},
      ));
    }

    final elapsed = Duration(seconds: totalSeconds - remainingSeconds.value);
    final result = QuizResult(
      quizName: quizName,
      questionResults: results.toList(),
      totalTime: elapsed,
      quizId: quizId,
    );

    try {
      Get.find<HistoryController>().addResult(result);
    } catch (e) {
      // Ignorer si pas injecté
    }

    Get.offNamed(Routes.RESULTS, arguments: result);
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
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  void _resumeTimer() {
    if (!isTimeUp.value && _countdownTimer == null) {
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (remainingSeconds.value > 0) {
          remainingSeconds.value--;
        } else {
          _onTimeUp();
        }
      });
    }
  }

  String get remainingFormatted {
    final seconds = remainingSeconds.value;
    final d = Duration(seconds: seconds);
    final h = d.inHours.toString().padLeft(2, '0');
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (d.inHours > 0) return '$h:$m:$s';
    return '$m:$s';
  }

  QuestionResource get currentQuestion => questions[currentIndex.value];
  bool get isLastQuestion => currentIndex.value == questions.length - 1;
  double get progressValue =>
      (currentIndex.value + 1) / (questions.isEmpty ? 1 : questions.length);

  void toggleAnswer(int answerId) {
    if (isValidated.value || isTimeUp.value) return;

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
    if (selectedAnswerIds.isEmpty || isTimeUp.value) return;

    isValidated.value = true;
    final isCorrect = _checkIsCorrect();

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
    if (isLastQuestion || isTimeUp.value) return;

    currentIndex.value++;
    selectedAnswerIds.clear();
    isValidated.value = false;
  }

  void submitExam() {
    _countdownTimer?.cancel();
    _submitExam();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _countdownTimer?.cancel();
    super.onClose();
  }
}
