import 'package:cncours_quiz/app/core/theme/app_theme.dart';
import 'package:cncours_quiz/app/data/models/quiz_custom_ids.dart';
import 'package:cncours_quiz/app/data/models/quiz_result.dart';
import 'package:cncours_quiz/app/data/resources/question_resource.dart';
import 'package:cncours_quiz/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResumeCard extends StatelessWidget {
  final QuizResult? lastActivity;

  const ResumeCard({super.key, this.lastActivity});

  @override
  Widget build(BuildContext context) {
    if (lastActivity == null) {
      return _EmptyResume();
    }
    return _LastQuizCard(lastActivity: lastActivity!);
  }
}

class _EmptyResume extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.vertFaso.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.vertFaso.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.vertFaso.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_arrow_rounded,
                color: AppTheme.vertFaso, size: 32),
          ),
          const SizedBox(height: 14),
          const Text('Pas encore d\'historique',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(
            'Termine ton premier quiz pour voir ta progression ici.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).textTheme.bodyMedium?.color),
          ),
        ],
      ),
    );
  }
}

class _LastQuizCard extends StatelessWidget {
  final QuizResult lastActivity;
  const _LastQuizCard({required this.lastActivity});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _continueQuiz,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.orReussite.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.orReussite.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.orReussite.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.play_arrow_rounded, color: Colors.orange),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lastActivity.quizName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(
                    'Dernier score: ${lastActivity.score}/${lastActivity.total} (${lastActivity.percentage.toStringAsFixed(0)}%)',
                    style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodyMedium?.color),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.orReussite),
          ],
        ),
      ),
    );
  }

  void _continueQuiz() {
    Get.toNamed(Routes.QUIZ, arguments: {
      'quizId': CustomQuiz.last.id,
      'quizName': "${CustomQuiz.last.name}-${lastActivity.quizName}",
      'questions': lastActivity.questionResults
          .map((e) => (e as dynamic).question)
          .toList()
          .cast<QuestionResource>(),
    });
  }
}
