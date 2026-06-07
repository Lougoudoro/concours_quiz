import 'package:cncours_quiz/app/data/resources/quiz_resource.dart';
import 'package:cncours_quiz/app/data/resources/serie_resource.dart';
import 'package:cncours_quiz/app/modules/history/history_controller.dart';
import 'package:cncours_quiz/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cncours_quiz/app/core/theme/app_theme.dart';

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
            _Header(serie: serie, quizzes: quizzes),
            Expanded(
              child: quizzes.isEmpty
                  ? const _EmptyState()
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                      itemCount: quizzes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, index) =>
                          _QuizCard(quiz: quizzes[index], index: index),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final SerieResource serie;
  final List<QuizResource> quizzes;
  const _Header({required this.serie, required this.quizzes});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(serie.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                        )),
                    if (serie.description.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(serie.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                      color: Theme.of(context).textTheme.bodyMedium?.color)),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (quizzes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.quiz_outlined, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          '${quizzes.length} quiz${quizzes.length > 1 ? 's' : ''}',
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
          ],
              ),
            ),
        ])
            );
        
      
    
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.vertFaso, Color(0xFF00B86B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child:
                const Icon(Icons.quiz_outlined, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 16),
          const Text('Aucun quiz disponible',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            'Reviens bientôt, de nouveaux quiz seront ajoutés.',
            style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).textTheme.bodyMedium?.color),
          ),
        ],
      ),
    );
  }
}

class _QuizCard extends StatelessWidget {
  final QuizResource quiz;
  final int index;
  const _QuizCard({required this.quiz, required this.index});

  @override
  Widget build(BuildContext context) {
    final isExam = quiz.isExam;
    return GestureDetector(
      onTap: () => _showActions(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.vertFaso.withOpacity(0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.vertFaso.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.vertFaso, Color(0xFF00B86B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isExam ? Icons.timer_outlined : Icons.menu_book_outlined,
                color: Colors.white,
                size: 22,
              ),
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
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _Tag(
                        label: quiz.typeLabel,
                        color: AppTheme.vertFaso,
                      ),
                      const SizedBox(width: 6),
                      _Tag(
                        label: '${quiz.getQuesionsCount()} Q',
                        color: AppTheme.orReussite,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right,
                color: Theme.of(context).textTheme.bodyMedium?.color, size: 20),
          ],
        ),
      ),
    );
  }

  void _showActions(BuildContext context) {
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
                      fontSize: 20, fontWeight: FontWeight.bold),
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
                _ActionBtn(
                  icon: Icons.play_arrow_rounded,
                  label: 'Démarrer l\'examen',
                  color: AppTheme.rougeTerre,
                  onTap: () {
                    Navigator.pop(ctx);
                    _startExam(quiz);
                  },
                ),
                if (hasResult) ...[
                  const SizedBox(height: 10),
                  _ActionBtn(
                    icon: Icons.assignment_rounded,
                    label: 'Voir le résultat',
                    color: AppTheme.orReussite,
                    onTap: () {
                      Navigator.pop(ctx);
                      _showResult(quiz);
                    },
                  ),
                ],
              ] else ...[
                const SizedBox(height: 10),
                _ActionBtn(
                  icon: Icons.quiz_outlined,
                  label: 'Test de connaissances',
                  color: AppTheme.rougeTerre,
                  onTap: () {
                    Navigator.pop(ctx);
                    _startQuiz(quiz);
                  },
                ),
              ],

                const SizedBox(height: 10),
                _ActionBtn(
                  icon: Icons.menu_book_outlined,
                  label: 'Mode correction',
                  color: AppTheme.vertFaso,
                  onTap: () {
                    Navigator.pop(ctx);
                    _startLesson(quiz);
                  },
                ),
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

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  const _Tag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn({
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
        label: Text(label, style: const TextStyle(fontSize: 15)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.12),
          foregroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
          side: BorderSide(color: color.withOpacity(0.2)),
        ),
      ),
    );
  }
}
