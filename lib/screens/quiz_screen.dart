/// Écran B : Interface de Test — Le cœur du système
///
/// Choix UX :
/// - Checkbox pour sélection multiple libre (QCM)
/// - Deux grandes cartes exclusives (Vrai/Faux)
/// - Validation avec feedback immédiat (vert/rouge)
/// - Chronomètre + progression en en-tête
/// - Justification post-validation
library;

import 'dart:async';
import 'package:flutter/material.dart';

import '../data/sample_questions.dart';
import '../models/question.dart';
import '../models/quiz_result.dart';
import '../theme/app_theme.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const QuizScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  late final List<Question> _questions;
  int _currentIndex = 0;
  final Set<String> _selectedAnswerIds = {};
  bool _isValidated = false;
  final List<QuestionResult> _results = [];

  late final Stopwatch _stopwatch;
  late final Timer _timer;
  String _elapsedFormatted = '00:00';

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _questions = SampleQuestions.getQuestionsForCategory(widget.categoryId);
    _stopwatch = Stopwatch()..start();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          final m = _stopwatch.elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
          final s = _stopwatch.elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
          _elapsedFormatted = '$m:$s';
        });
      }
    });
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _timer.cancel();
    _stopwatch.stop();
    _fadeController.dispose();
    super.dispose();
  }

  Question get _currentQuestion => _questions[_currentIndex];
  bool get _isLastQuestion => _currentIndex == _questions.length - 1;
  double get _progressValue => (_currentIndex + 1) / _questions.length;

  void _toggleAnswer(String answerId) {
    if (_isValidated) return;
    setState(() {
      if (_currentQuestion.type == QuestionType.vraiOuFaux) {
        _selectedAnswerIds.clear();
        _selectedAnswerIds.add(answerId);
      } else {
        if (_selectedAnswerIds.contains(answerId)) {
          _selectedAnswerIds.remove(answerId);
        } else {
          _selectedAnswerIds.add(answerId);
        }
      }
    });
  }

  void _validateAnswer() {
    if (_selectedAnswerIds.isEmpty) return;
    setState(() {
      _isValidated = true;
      _results.add(QuestionResult(question: _currentQuestion, userAnswerIds: Set.from(_selectedAnswerIds)));
    });
  }

  void _nextQuestion() {
    if (_isLastQuestion) {
      _stopwatch.stop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            quizResult: QuizResult(categoryName: widget.categoryName, questionResults: _results, totalTime: _stopwatch.elapsed),
          ),
        ),
      );
      return;
    }
    _fadeController.reverse().then((_) {
      setState(() { _currentIndex++; _selectedAnswerIds.clear(); _isValidated = false; });
      _fadeController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildQuestionTypeBadge(),
                      const SizedBox(height: 14),
                      _buildQuestionText(),
                      const SizedBox(height: 8),
                      if (_currentQuestion.type == QuestionType.qcm && _currentQuestion.correctAnswerIds.length > 1)
                        _buildMultiHint(),
                      const SizedBox(height: 4),
                      _buildAnswerOptions(),
                      if (_isValidated) ...[const SizedBox(height: 20), _buildJustification()],
                    ],
                  ),
                ),
              ),
            ),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMultiHint() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(children: [
        Icon(Icons.info_outline, size: 16, color: AppTheme.orReussite.withOpacity(0.8)),
        const SizedBox(width: 6),
        Text('Plusieurs réponses possibles', style: TextStyle(fontSize: 13, color: AppTheme.orReussite.withOpacity(0.8), fontWeight: FontWeight.w500, fontStyle: FontStyle.italic)),
      ]),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(color: AppTheme.fondSombre, border: Border(bottom: BorderSide(color: AppTheme.borderSubtle.withOpacity(0.5)))),
      child: Column(children: [
        Row(children: [
          GestureDetector(
            onTap: () => _showQuitDialog(context),
            child: Container(width: 38, height: 38, decoration: BoxDecoration(color: AppTheme.surfaceCardActive, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.close, color: AppTheme.textSecondary, size: 20)),
          ),
          const Spacer(),
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5), decoration: BoxDecoration(color: AppTheme.vertFaso.withOpacity(0.15), borderRadius: BorderRadius.circular(20)), child: Text(widget.categoryName, style: const TextStyle(color: AppTheme.vertFaso, fontSize: 12, fontWeight: FontWeight.w600))),
          const Spacer(),
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5), decoration: BoxDecoration(color: AppTheme.surfaceCardActive, borderRadius: BorderRadius.circular(20)), child: Row(children: [const Icon(Icons.timer_outlined, color: AppTheme.orReussite, size: 16), const SizedBox(width: 5), Text(_elapsedFormatted, style: const TextStyle(color: AppTheme.orReussite, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'monospace'))])),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Text('Question ${_currentIndex + 1}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
          const SizedBox(width: 4),
          Text('/ ${_questions.length}', style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
          const Spacer(),
          Text('${(_progressValue * 100).toStringAsFixed(0)}%', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
        ]),
        const SizedBox(height: 8),
        ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(value: _progressValue, minHeight: 5, backgroundColor: AppTheme.borderSubtle, valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.vertFaso))),
      ]),
    );
  }

  Widget _buildQuestionTypeBadge() {
    final isVF = _currentQuestion.type == QuestionType.vraiOuFaux;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: isVF ? AppTheme.orReussite.withOpacity(0.12) : AppTheme.vertFaso.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
      child: Text(isVF ? '⚡ Vrai ou Faux' : '☑ QCM — Choix multiples', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isVF ? AppTheme.orReussite : AppTheme.vertFaso)),
    );
  }

  Widget _buildQuestionText() {
    return Text(_currentQuestion.text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textPrimary, height: 1.5));
  }

  Widget _buildAnswerOptions() {
    if (_currentQuestion.type == QuestionType.vraiOuFaux) return _buildVraiFauxOptions();
    return _buildQCMOptions();
  }

  Widget _buildQCMOptions() {
    return Column(
      children: _currentQuestion.options.map((option) {
        final isSelected = _selectedAnswerIds.contains(option.id);
        Color borderColor = AppTheme.borderSubtle;
        Color bgColor = AppTheme.surfaceCard;
        IconData? trailingIcon;
        Color? trailingIconColor;

        if (_isValidated) {
          if (option.isCorrect && isSelected) {
            borderColor = AppTheme.correctGreen; bgColor = AppTheme.correctGreen.withOpacity(0.1);
            trailingIcon = Icons.check_circle; trailingIconColor = AppTheme.correctGreen;
          } else if (!option.isCorrect && isSelected) {
            borderColor = AppTheme.incorrectRed; bgColor = AppTheme.incorrectRed.withOpacity(0.1);
            trailingIcon = Icons.cancel; trailingIconColor = AppTheme.incorrectRed;
          } else if (option.isCorrect && !isSelected) {
            borderColor = AppTheme.correctGreen.withOpacity(0.5); bgColor = AppTheme.correctGreen.withOpacity(0.05);
            trailingIcon = Icons.check_circle_outline; trailingIconColor = AppTheme.correctGreen.withOpacity(0.6);
          } else {
            borderColor = AppTheme.neutralGrey; bgColor = AppTheme.surfaceCard;
          }
        } else if (isSelected) {
          borderColor = AppTheme.vertFaso; bgColor = AppTheme.vertFaso.withOpacity(0.08);
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250), curve: Curves.easeInOut,
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(14), border: Border.all(color: borderColor, width: _isValidated && (option.isCorrect || isSelected) ? 2 : 1.5)),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _isValidated ? null : () => _toggleAnswer(option.id),
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  child: Row(children: [
                    _buildCheckbox(option, isSelected),
                    const SizedBox(width: 12),
                    Expanded(child: Text(option.text, style: TextStyle(fontSize: 15, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400, color: _isValidated ? (option.isCorrect ? AppTheme.correctGreen : isSelected ? AppTheme.incorrectRed : AppTheme.textSecondary) : AppTheme.textPrimary, height: 1.4))),
                    if (trailingIcon != null) Padding(padding: const EdgeInsets.only(left: 8), child: Icon(trailingIcon, color: trailingIconColor, size: 22)),
                  ]),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCheckbox(AnswerOption option, bool isSelected) {
    Color checkboxColor;
    if (_isValidated) {
      checkboxColor = option.isCorrect ? AppTheme.correctGreen : isSelected ? AppTheme.incorrectRed : AppTheme.neutralGrey;
    } else {
      checkboxColor = isSelected ? AppTheme.vertFaso : Colors.transparent;
    }
    final showCheck = isSelected || (_isValidated && option.isCorrect);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200), width: 24, height: 24,
      decoration: BoxDecoration(color: showCheck ? checkboxColor : Colors.transparent, borderRadius: BorderRadius.circular(6), border: Border.all(color: showCheck ? checkboxColor : AppTheme.textSecondary.withOpacity(0.5), width: 2)),
      child: showCheck ? Icon(_isValidated ? (option.isCorrect ? Icons.check : Icons.close) : Icons.check, color: Colors.white, size: 16) : null,
    );
  }

  Widget _buildVraiFauxOptions() {
    return Row(
      children: _currentQuestion.options.map((option) {
        final isSelected = _selectedAnswerIds.contains(option.id);
        final isVrai = option.id == 'vrai';
        Color borderColor = AppTheme.borderSubtle;
        Color bgColor = AppTheme.surfaceCard;
        Color iconColor = isVrai ? AppTheme.vertFaso.withOpacity(0.6) : AppTheme.rougeTerre.withOpacity(0.6);

        if (_isValidated) {
          if (option.isCorrect) { borderColor = AppTheme.correctGreen; bgColor = AppTheme.correctGreen.withOpacity(0.1); iconColor = AppTheme.correctGreen; }
          else if (isSelected) { borderColor = AppTheme.incorrectRed; bgColor = AppTheme.incorrectRed.withOpacity(0.1); iconColor = AppTheme.incorrectRed; }
        } else if (isSelected) {
          borderColor = isVrai ? AppTheme.vertFaso : AppTheme.rougeTerre;
          bgColor = (isVrai ? AppTheme.vertFaso : AppTheme.rougeTerre).withOpacity(0.1);
          iconColor = isVrai ? AppTheme.vertFaso : AppTheme.rougeTerre;
        }

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isVrai ? 6 : 0, left: isVrai ? 0 : 6),
            child: GestureDetector(
              onTap: _isValidated ? null : () => _toggleAnswer(option.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 28),
                decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderColor, width: isSelected || (_isValidated && option.isCorrect) ? 2.5 : 1.5)),
                child: Column(children: [
                  Icon(isVrai ? Icons.check_circle_outline : Icons.cancel_outlined, color: iconColor, size: 40),
                  const SizedBox(height: 10),
                  Text(option.text, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: isSelected || (_isValidated && option.isCorrect) ? iconColor : AppTheme.textSecondary)),
                  const SizedBox(height: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200), width: 22, height: 22,
                    decoration: BoxDecoration(color: isSelected ? (isVrai ? AppTheme.vertFaso : AppTheme.rougeTerre) : Colors.transparent, borderRadius: BorderRadius.circular(6), border: Border.all(color: isSelected ? (isVrai ? AppTheme.vertFaso : AppTheme.rougeTerre) : AppTheme.textSecondary, width: 2)),
                    child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                  ),
                ]),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildJustification() {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppTheme.orReussite.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.orReussite.withOpacity(0.3), width: 1)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [Icon(Icons.lightbulb_outline, color: AppTheme.orReussite, size: 18), SizedBox(width: 6), Text('Explication', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.orReussite))]),
        const SizedBox(height: 10),
        Text(_currentQuestion.justification, style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary, height: 1.55)),
      ]),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(color: AppTheme.fondSombre, border: Border(top: BorderSide(color: AppTheme.borderSubtle.withOpacity(0.5)))),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity, height: 54,
          child: _isValidated
              ? ElevatedButton.icon(
                  onPressed: _nextQuestion,
                  icon: Icon(_isLastQuestion ? Icons.emoji_events : Icons.arrow_forward, size: 20),
                  label: Text(_isLastQuestion ? 'Voir les résultats' : 'Question suivante'),
                  style: ElevatedButton.styleFrom(backgroundColor: _isLastQuestion ? AppTheme.orReussite : AppTheme.vertFaso, foregroundColor: _isLastQuestion ? Colors.black87 : Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                )
              : ElevatedButton.icon(
                  onPressed: _selectedAnswerIds.isEmpty ? null : _validateAnswer,
                  icon: const Icon(Icons.check_circle_outline, size: 20),
                  label: const Text('Valider la réponse'),
                  style: ElevatedButton.styleFrom(backgroundColor: _selectedAnswerIds.isEmpty ? AppTheme.neutralGrey : AppTheme.vertFaso, foregroundColor: Colors.white, disabledBackgroundColor: AppTheme.neutralGrey, disabledForegroundColor: AppTheme.textSecondary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                ),
        ),
      ),
    );
  }

  void _showQuitDialog(BuildContext context) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: AppTheme.surfaceCard, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Quitter le test ?', style: TextStyle(color: AppTheme.textPrimary)),
      content: const Text('Ta progression pour ce test sera perdue.', style: TextStyle(color: AppTheme.textSecondary)),
      actions: [
        TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Continuer', style: TextStyle(color: AppTheme.vertFaso))),
        TextButton(onPressed: () { Navigator.of(ctx).pop(); Navigator.of(context).pop(); }, child: const Text('Quitter', style: TextStyle(color: AppTheme.rougeTerre))),
      ],
    ));
  }
}
