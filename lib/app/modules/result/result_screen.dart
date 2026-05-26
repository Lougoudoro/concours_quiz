import 'package:cncours_quiz/app/data/resources/question_resource.dart';
import 'package:cncours_quiz/app/data/models/quiz_result.dart';
import 'package:cncours_quiz/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:confetti/confetti.dart';

import 'package:cncours_quiz/app/core/theme/app_theme.dart';

class ResultScreen extends StatefulWidget {
  final QuizResult quizResult;

  const ResultScreen({super.key, required this.quizResult});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scoreAnimation;
  late ConfettiController _confettiController;

  // --- NOUVEAU : État du filtre (Axe 3) ---
  bool _showOnlyErrors = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scoreAnimation = Tween<double>(
      begin: 0,
      end: widget.quizResult.percentage / 100,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));

    _animController.forward();

    if (widget.quizResult.percentage == 100) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.quizResult;
    final passed = result.percentage >= 50;

    // --- Filtrage des résultats ---
    final filteredResults = _showOnlyErrors
        ? result.questionResults
            .asMap()
            .entries
            .where((e) => !e.value.isCorrect)
            .toList()
        : result.questionResults.asMap().entries.toList();

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // En-tête
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppTheme.getSurfaceCardActive(
                                Theme.of(context).brightness ==
                                    Brightness.dark),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.close,
                              color:
                                  Theme.of(context).textTheme.bodyMedium!.color,
                              size: 20),
                        ),
                      ),
                      const Spacer(),
                      Text('Résultats — ${result.categoryName}',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .color)),
                      const Spacer(),
                      const SizedBox(width: 38),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                    child: Column(
                      children: [
                        _buildScoreCard(result, passed),
                        const SizedBox(height: 12),
                        _buildStatsRow(result),
                        const SizedBox(height: 28),

                        // --- Correction avec Filtre Diagnostic (Axe 3) ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Correction détaillée',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color)),

                            // Bouton de bascule Diagnostic
                            if (result.score < result.total)
                              TextButton.icon(
                                onPressed: () => setState(
                                    () => _showOnlyErrors = !_showOnlyErrors),
                                icon: Icon(
                                    _showOnlyErrors
                                        ? Icons.visibility
                                        : Icons.filter_list,
                                    size: 16,
                                    color: AppTheme.rougeTerre),
                                label: Text(
                                    _showOnlyErrors
                                        ? 'Voir Tout'
                                        : 'Mes Erreurs',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.rougeTerre)),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  backgroundColor:
                                      AppTheme.rougeTerre.withOpacity(0.1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        if (filteredResults.isEmpty && _showOnlyErrors)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Column(
                              children: [
                                Icon(Icons.check_circle_outline,
                                    size: 48, color: AppTheme.correctGreen),
                                SizedBox(height: 12),
                                Text('Aucune erreur à réviser ! 🎉',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          )
                        else
                          ...filteredResults.map(
                            (entry) =>
                                _buildQuestionTile(entry.key, entry.value),
                          ),
                      ],
                    ),
                  ),
                ),

                // Boutons d'action
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    border: Border(
                        top: BorderSide(
                            color: Theme.of(context)
                                    .dividerTheme
                                    .color
                                    ?.withOpacity(0.5) ??
                                Colors.transparent)),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (result.score < result.total) ...[
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton.icon(
                              onPressed: () => _retryErrors(result),
                              icon: const Icon(Icons.replay, size: 20),
                              label: const Text('Réviser mes erreurs'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.orReussite,
                                foregroundColor: Colors.black87,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton.icon(
                            onPressed: () => Get.offAllNamed('/dashboard'),
                            icon: const Icon(Icons.home_outlined, size: 20),
                            label: const Text('Retour à l\'accueil'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.vertFaso,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                AppTheme.vertFaso,
                AppTheme.orReussite,
                AppTheme.rougeTerre,
                Colors.white,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(QuizResult result, bool passed) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: passed
              ? [const Color(0xFF0D4F28), const Color(0xFF1A6B3C)]
              : [const Color(0xFF4A1020), const Color(0xFF6B1A2C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: (passed ? AppTheme.vertFaso : AppTheme.rougeTerre)
                .withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            passed ? (result.percentage == 100 ? '🏆' : '🎉') : '💪',
            style: const TextStyle(fontSize: 42),
          ),
          const SizedBox(height: 8),
          Text(
            result.percentage == 100
                ? 'Score Parfait !'
                : (passed ? 'Félicitations !' : 'Continue tes efforts !'),
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          const SizedBox(height: 20),
          AnimatedBuilder(
            animation: _scoreAnimation,
            builder: (context, child) {
              return SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: _scoreAnimation.value,
                        strokeWidth: 10,
                        strokeCap: StrokeCap.round,
                        backgroundColor: Colors.white.withOpacity(0.15),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          passed ? AppTheme.orReussite : AppTheme.incorrectRed,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${result.score}/${result.total}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${result.percentage.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: passed
                                ? AppTheme.orReussite
                                : AppTheme.incorrectRed,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(QuizResult result) {
    return Row(
      children: [
        _buildStatChip(
          Icons.timer_outlined,
          _formatDuration(result.totalTime),
          'Durée',
          AppTheme.orReussite,
        ),
        const SizedBox(width: 10),
        _buildStatChip(
          Icons.check_circle_outline,
          '${result.score}',
          'Correctes',
          AppTheme.correctGreen,
        ),
        const SizedBox(width: 10),
        _buildStatChip(
          Icons.cancel_outlined,
          '${result.total - result.score}',
          'Erreurs',
          AppTheme.incorrectRed,
        ),
      ],
    );
  }

  Widget _buildStatChip(
      IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color:
                  Theme.of(context).dividerTheme.color ?? Colors.transparent),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700, color: color)),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).textTheme.bodyMedium?.color)),
          ],
        ),
      ),
    );
  }

  Widget _buildReportButton(BuildContext context, QuestionResource question) {
    return GestureDetector(
      onTap: () => _showReportDialog(context, question),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flag_outlined,
              size: 13,
              color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withOpacity(0.5) ??
                  Colors.grey),
          const SizedBox(width: 4),
          Text('Signaler une erreur',
              style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withOpacity(0.5) ??
                      Colors.grey,
                  decoration: TextDecoration.underline,
                  decorationColor: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withOpacity(0.5) ??
                      Colors.grey)),
        ],
      ),
    );
  }

  void _showReportDialog(BuildContext context, QuestionResource question) {
    final messageController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardTheme.color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(children: [
          Icon(Icons.flag, color: AppTheme.rougeTerre, size: 20),
          SizedBox(width: 8),
          Expanded(
              child: Text('Signaler une erreur',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
        ]),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(question.text,
                  style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      height: 1.4)),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.orReussite.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(question.justification,
                    style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontStyle: FontStyle.italic,
                        height: 1.4)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: messageController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Décris l'erreur...",
                  hintStyle: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withOpacity(0.5)),
                  filled: true,
                  fillColor: Theme.of(context).cardTheme.color,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Theme.of(context).dividerTheme.color ??
                            Colors.grey),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Get.back(),
              child: const Text('Annuler',
                  style: TextStyle(color: AppTheme.neutralGrey))),
          TextButton(
              onPressed: () {
                _saveReport(question, messageController.text.trim());
                Get.back();
                Get.snackbar(
                  'Signalement envoyé',
                  'Merci, nous examinerons cette question.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppTheme.vertFaso,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 3),
                );
              },
              child: const Text('Envoyer',
                  style: TextStyle(
                      color: AppTheme.rougeTerre,
                      fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  void _saveReport(QuestionResource question, String message) {
    final box = GetStorage();
    final reports = box.read<List>('question_reports') ?? [];
    reports.add({
      'question_id': question.id,
      'question_text': question.text,
      'justification': question.justification,
      'message': message,
      'timestamp': DateTime.now().toIso8601String(),
    });
    box.write('question_reports', reports);
  }

  void _retryErrors(QuizResult result) {
    final wrongQuestions = result.questionResults
        .where((qr) => !qr.isCorrect)
        .map((qr) => qr.question)
        .toList();
    if (wrongQuestions.isEmpty) return;
    Get.toNamed(Routes.QUIZ, arguments: {
      'categoryId': 'revision',
      'categoryName': 'Révision — ${result.categoryName}',
      'questions': wrongQuestions,
    });
  }

  Widget _buildQuestionTile(int index, QuestionResult qr) {
    final isCorrect = qr.isCorrect;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isCorrect
                ? AppTheme.correctGreen.withOpacity(0.3)
                : AppTheme.incorrectRed.withOpacity(0.3),
          ),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            leading: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isCorrect
                    ? AppTheme.correctGreen.withOpacity(0.15)
                    : AppTheme.incorrectRed.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(
                  isCorrect ? Icons.check : Icons.close,
                  color:
                      isCorrect ? AppTheme.correctGreen : AppTheme.incorrectRed,
                  size: 18,
                ),
              ),
            ),
            title: Text(
              'Q${index + 1}. ${qr.question.text}',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.bodyLarge?.color),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            iconColor: Theme.of(context).textTheme.bodyMedium?.color,
            collapsedIconColor: Theme.of(context).textTheme.bodyMedium?.color,
            children: [
              ...qr.question.options.map((opt) {
                final userSelected = qr.userAnswerIds.contains(opt.id);
                Color optColor =
                    Theme.of(context).textTheme.bodyMedium?.color ??
                        Colors.grey;
                IconData optIcon = Icons.radio_button_unchecked;

                if (opt.isCorrect) {
                  optColor = AppTheme.correctGreen;
                  optIcon = Icons.check_circle;
                } else if (userSelected) {
                  optColor = AppTheme.incorrectRed;
                  optIcon = Icons.cancel;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Icon(optIcon, color: optColor, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          opt.content,
                          style: TextStyle(
                            fontSize: 13,
                            color: optColor,
                            fontWeight: userSelected || opt.isCorrect
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                      if (userSelected && !opt.isCorrect)
                        const Text(' (ta réponse)',
                            style: TextStyle(
                                fontSize: 11,
                                color: AppTheme.incorrectRed,
                                fontStyle: FontStyle.italic)),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.orReussite.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: AppTheme.orReussite.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(children: [
                      Icon(Icons.lightbulb_outline,
                          color: AppTheme.orReussite, size: 15),
                      SizedBox(width: 6),
                      Text('Explication',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.orReussite)),
                    ]),
                    const SizedBox(height: 8),
                    Text(
                      qr.question.justification,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildReportButton(context, qr.question),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
