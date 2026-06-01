import 'package:cncours_quiz/app/data/resources/quiz_resource.dart';
import 'package:cncours_quiz/app/data/resources/serie_resource.dart';
import 'package:cncours_quiz/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cncours_quiz/app/core/theme/app_theme.dart';
import 'package:cncours_quiz/app/modules/history/history_controller.dart';

class SerieScreen extends StatelessWidget {
  final SerieResource serie;

  const SerieScreen({super.key, required this.serie});

  @override
  Widget build(BuildContext context) {
    final quizzes = serie.quizzes;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, quizzes),
            Expanded(
              child: quizzes.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                      itemCount: quizzes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, index) =>
                          _buildQuizCard(context, quizzes[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, List<QuizResource> quizzes) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppTheme.getSurfaceCardActive(
                        Theme.of(context).brightness == Brightness.dark),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.arrow_back,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                      size: 20),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(serie.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          if (serie.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 50),
              child: Text(serie.description,
                  style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyMedium?.color)),
            ),
          if (quizzes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 50),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    '${quizzes.length} quiz${quizzes.length > 1 ? 's' : ''} disponible${quizzes.length > 1 ? 's' : ''}',
                    style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).textTheme.bodyMedium?.color)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.quiz_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text('Aucun quiz disponible',
              style: TextStyle(fontSize: 16, color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildQuizCard(BuildContext context, QuizResource quiz) {
    return GestureDetector(
      onTap: () => _showQuizActions(context, quiz),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.vertFaso.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.vertFaso.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.quiz_outlined,
                  color: AppTheme.vertFaso, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(quiz.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  if (quiz.description.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(quiz.description,
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(quiz.typeLabel,
                    style: const TextStyle(
                        fontSize: 10,
                        color: AppTheme.vertFaso,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text('${quiz.getQuesionsCount()} Q',
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.vertFaso,
                        fontWeight: FontWeight.w600)),
              ],
            ),
            const Icon(Icons.chevron_right, color: AppTheme.vertFaso, size: 20),
          ],
        ),
      ),
    );
  }

  void _showQuizActions(BuildContext context, QuizResource quiz) {
    late final HistoryController historyCtrl;
    try {
      historyCtrl = Get.find<HistoryController>();
    } catch (_) {
      historyCtrl = HistoryController()..onInit();
    }
    final hasResult = historyCtrl.history.any(
      (r) => r.quizId == quiz.id.toString(),
    );

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(quiz.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              if (quiz.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 20),
                  child: Text(quiz.description,
                      style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(ctx).textTheme.bodyMedium?.color),
                      textAlign: TextAlign.center),
                ),
              const SizedBox(height: 8),
              if (quiz.isExam) ...[
                _ActionButton(
                  icon: Icons.play_arrow_rounded,
                  label: 'Démarrer',
                  color: AppTheme.vertFaso,
                  onTap: () {
                    Navigator.pop(ctx);
                    _startExam(quiz);
                  },
                ),
                if (hasResult) ...[
                  const SizedBox(height: 12),
                  _ActionButton(
                    icon: Icons.assignment_rounded,
                    label: 'Résultat',
                    color: AppTheme.orReussite,
                    onTap: () {
                      Navigator.pop(ctx);
                      _showResult(quiz);
                    },
                  ),
                ],
                const SizedBox(height: 12),
                _ActionButton(
                  icon: Icons.rate_review_outlined,
                  label: 'Correction',
                  color: AppTheme.rougeTerre,
                  onTap: () {
                    Navigator.pop(ctx);
                    _startLesson(quiz);
                  },
                ),
              ] else ...[
                _ActionButton(
                  icon: Icons.menu_book_outlined,
                  label: 'Cours',
                  color: AppTheme.vertFaso,
                  onTap: () {
                    Navigator.pop(ctx);
                    _startLesson(quiz);
                  },
                ),
                const SizedBox(height: 12),
                _ActionButton(
                  icon: Icons.quiz_outlined,
                  label: 'Test',
                  color: AppTheme.orReussite,
                  onTap: () {
                    Navigator.pop(ctx);
                    _startQuiz(quiz);
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _startLesson(QuizResource quiz) {
    Get.toNamed(Routes.LESSON, arguments: {
      'quizId': quiz.id.toString(),
      'quizName': quiz.title,
      'questions': quiz.questions,
      'isExam': quiz.isExam,
    });
  }

  void _startExam(QuizResource quiz) {
    Get.toNamed(Routes.EXAM, arguments: {
      'quizId': quiz.id.toString(),
      'quizName': quiz.title,
      'totalSeconds': quiz.duration ?? 0,
      'questions': quiz.questions,
    });
  }

  void _showResult(QuizResource quiz) {
    final historyCtrl = Get.find<HistoryController>();
    final result = historyCtrl.history.firstWhereOrNull(
      (r) => r.quizId == quiz.id.toString(),
    );
    if (result != null) {
      Get.toNamed(Routes.RESULTS, arguments: result);
    }
  }

  void _startQuiz(QuizResource quiz) {
    Get.toNamed(Routes.QUIZ, arguments: {
      'quizId': quiz.id.toString(),
      'quizName': quiz.title,
      'questions': quiz.questions,
    });
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 20),
        label: Text(label, style: const TextStyle(fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.12),
          foregroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
