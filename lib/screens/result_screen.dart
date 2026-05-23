/// Écran C : Résultat Global et Correction
///
/// Affiche :
/// - Score final avec animation circulaire
/// - Durée totale du test
/// - Liste des questions avec accordéon (ExpansionTile)
///   pour la justification textuelle
library;

import 'package:flutter/material.dart';

import '../models/quiz_result.dart';
import '../theme/app_theme.dart';

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
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
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

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // En-tête
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 38, height: 38,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceCardActive,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.close,
                          color: AppTheme.textSecondary, size: 20),
                    ),
                  ),
                  const Spacer(),
                  Text('Résultats — ${result.categoryName}',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary)),
                  const Spacer(),
                  const SizedBox(width: 38),
                ],
              ),
            ),

            // Corps scrollable
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                child: Column(
                  children: [
                    // ─── Carte de score ──────────────────────
                    _buildScoreCard(result, passed),
                    const SizedBox(height: 12),

                    // Statistiques rapides
                    _buildStatsRow(result),
                    const SizedBox(height: 28),

                    // ─── Liste des questions (accordéon) ─────
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Correction détaillée',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary)),
                    ),
                    const SizedBox(height: 14),
                    ...result.questionResults.asMap().entries.map(
                          (entry) =>
                              _buildQuestionTile(entry.key, entry.value),
                        ),
                  ],
                ),
              ),
            ),

            // Bouton retour accueil
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              decoration: BoxDecoration(
                color: AppTheme.fondSombre,
                border: Border(
                    top: BorderSide(
                        color: AppTheme.borderSubtle.withOpacity(0.5))),
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
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
              ),
            ),
          ],
        ),
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
          // Emoji + message
          Text(
            passed ? '🎉' : '💪',
            style: const TextStyle(fontSize: 42),
          ),
          const SizedBox(height: 8),
          Text(
            passed ? 'Félicitations !' : 'Continue tes efforts !',
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
          const SizedBox(height: 20),

          // Score circulaire animé
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
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.borderSubtle),
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
                style: const TextStyle(
                    fontSize: 11, color: AppTheme.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionTile(int index, QuestionResult qr) {
    final isCorrect = qr.isCorrect;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
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
            childrenPadding:
                const EdgeInsets.fromLTRB(16, 0, 16, 16),
            leading: Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: isCorrect
                    ? AppTheme.correctGreen.withOpacity(0.15)
                    : AppTheme.incorrectRed.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(
                  isCorrect ? Icons.check : Icons.close,
                  color: isCorrect
                      ? AppTheme.correctGreen
                      : AppTheme.incorrectRed,
                  size: 18,
                ),
              ),
            ),
            title: Text(
              'Q${index + 1}. ${qr.question.text}',
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            iconColor: AppTheme.textSecondary,
            collapsedIconColor: AppTheme.textSecondary,
            children: [
              // Réponses de l'utilisateur
              ...qr.question.options.map((opt) {
                final userSelected = qr.userAnswerIds.contains(opt.id);
                Color optColor = AppTheme.textSecondary;
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
                          opt.text,
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
              // Justification
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.orReussite.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppTheme.orReussite.withOpacity(0.2)),
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
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textPrimary,
                        height: 1.5,
                      ),
                    ),
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
