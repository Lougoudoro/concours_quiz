import 'package:cncours_quiz/app/core/widgets/shimmer_loading.dart';
import 'package:cncours_quiz/app/data/resources/question_resource.dart';
import 'package:cncours_quiz/app/data/resources/option_resource.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cncours_quiz/app/modules/quiz/quiz_controller.dart';
import 'package:cncours_quiz/app/core/theme/app_theme.dart';
import 'package:get_storage/get_storage.dart';

class LessonScreen extends StatelessWidget {
  final int quizId;
  final String quizName;
  final bool isExam;

  const LessonScreen({
    super.key,
    required this.quizId,
    required this.quizName,
    this.isExam = false,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QuizController>(tag: quizId.toString());

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          final questions = controller.questions;
          if (questions.isEmpty && controller.questions.isEmpty) {
            return const QuizShimmer();
          }
          return Column(
            children: [
              _buildHeader(context, questions.length),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  itemCount: questions.length,
                  itemBuilder: (_, index) =>
                      _buildQuestionCard(context, index, questions[index]),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int total) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
            bottom: BorderSide(
                color: Theme.of(context).dividerTheme.color!.withOpacity(0.5))),
      ),
      child: Row(
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
                Text(quizName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text('$total question${total > 1 ? 's' : ''}',
                    style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodyMedium?.color)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.vertFaso.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child:  Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.menu_book_outlined,
                    color: AppTheme.vertFaso, size: 16),
                const SizedBox(width: 4),
                Text(isExam?'Corretions':'Cours',
                    style: const TextStyle(
                        color: AppTheme.vertFaso,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(
      BuildContext context, int index, QuestionResource question) {
    final correctOptions = question.options.where((o) => o.isCorrect).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: Theme.of(context).dividerTheme.color!.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader(context, index, question, correctOptions),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(question.content,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        height: 1.45)),
                const SizedBox(height: 16),
                _buildAnswersSection(context, question, correctOptions),
              ],
            ),
          ),
          if (question.justification.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildJustification(context, question),
          ],
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildCardHeader(BuildContext context, int index,
      QuestionResource question, List<OptionResource> correctOptions) {
    final isVF = question.isVraiOuFaux;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.vertFaso.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text('${index + 1}',
                  style: const TextStyle(
                      color: AppTheme.vertFaso,
                      fontWeight: FontWeight.w700,
                      fontSize: 14)),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isVF
                  ? AppTheme.orReussite.withOpacity(0.12)
                  : AppTheme.vertFaso.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(isVF ? 'Vrai ou Faux' : 'QCM — Choix multiples',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isVF ? AppTheme.orReussite : AppTheme.vertFaso)),
          ),
          const Spacer(),
          Icon(Icons.check_circle,
              color: AppTheme.correctGreen.withOpacity(0.6), size: 18),
          const SizedBox(width: 4),
          Text(
            '${correctOptions.length} bonne${correctOptions.length > 1 ? 's' : ''} réponse${correctOptions.length > 1 ? 's' : ''}',
            style: TextStyle(
                fontSize: 11,
                color: AppTheme.correctGreen.withOpacity(0.8),
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswersSection(BuildContext context, QuestionResource question,
      List<OptionResource> correctOptions) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.neutralGreyClair.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.neutralGrey.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           const Row(
              children: [
                Icon(Icons.checklist, size: 16, color: AppTheme.neutralGrey),
                const SizedBox(width: 6),
                Text('Toutes les options',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.neutralGrey)),
              ],
            ),
            const SizedBox(height: 10),
            ...question.options.map((opt) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Icon(opt.isCorrect ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: opt.isCorrect
                              ? AppTheme.correctGreen
                              : Theme.of(context).textTheme.bodyMedium?.color ??
                        Colors.grey,
                          size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(opt.content,
                            style: TextStyle(
                                fontSize: 14,
                                color: opt.isCorrect
                                    ? AppTheme.correctGreen
                                    : null,
                                fontWeight: FontWeight.w600,
                                height: 1.4)),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      );
}

  Widget _buildJustification(BuildContext context, QuestionResource question) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.orReussite.withOpacity(0.08),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
        border: Border(
            top: BorderSide(color: AppTheme.orReussite.withOpacity(0.2))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb_outline,
                  color: AppTheme.orReussite, size: 16),
              SizedBox(width: 6),
              Text('Explication',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.orReussite)),
            ],
          ),
          const SizedBox(height: 8),
          Text(question.justification,
              style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  height: 1.55)),
          const SizedBox(height: 12),
          _buildReportButton(context, question),
        ],
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
                  .bodyMedium!
                  .color!
                  .withOpacity(0.5)),
          const SizedBox(width: 4),
          Text('Signaler une erreur',
              style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .color!
                      .withOpacity(0.5),
                  decoration: TextDecoration.underline,
                  decorationColor: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .color!
                      .withOpacity(0.5))),
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
              Text(question.content,
                  style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
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
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                        fontStyle: FontStyle.italic,
                        height: 1.4)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: messageController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Décris l\'erreur...',
                  hintStyle: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .color!
                          .withOpacity(0.5)),
                  filled: true,
                  fillColor: Theme.of(context).cardTheme.color,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Theme.of(context).dividerTheme.color!),
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
      'question_text': question.content,
      'justification': question.justification,
      'message': message,
      'timestamp': DateTime.now().toIso8601String(),
    });
    box.write('question_reports', reports);
  }
}
