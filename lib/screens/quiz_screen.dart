import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/quiz_controller.dart';
import '../models/question.dart';
import '../theme/app_theme.dart';

class QuizScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;
  final List<Question>? questions;

  const QuizScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    this.questions,
  });

  @override
  Widget build(BuildContext context) {
    // We use Get.find if it's already there, or Get.put. 
    // Best is to use a GetView or initialize in the route.
    final controller = Get.put(QuizController(
      categoryId: categoryId,
      categoryName: categoryName,
      initialQuestions: questions,
    ), tag: categoryId); // Use tag to allow multiple instances if needed

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.questions.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.vertFaso),
            );
          }
          
          return Column(
            children: [
              _buildHeader(context, controller),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildQuestionTypeBadge(context, controller),
                      const SizedBox(height: 14),
                      _buildQuestionText(context, controller),
                      const SizedBox(height: 8),
                      if (controller.currentQuestion.type == QuestionType.qcm &&
                          controller.currentQuestion.correctAnswerIds.length > 1)
                        _buildMultiHint(),
                      const SizedBox(height: 4),
                      _buildAnswerOptions(context, controller),
                      if (controller.isValidated.value) ...[
                        const SizedBox(height: 20),
                        _buildJustification(context, controller)
                      ],
                    ],
                  ),
                ),
              ),
              _buildFooter(context, controller),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildMultiHint() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(children: [
        Icon(Icons.info_outline, size: 16, color: AppTheme.orReussite.withOpacity(0.8)),
        const SizedBox(width: 6),
        Text('Plusieurs réponses possibles',
            style: TextStyle(
                fontSize: 13,
                color: AppTheme.orReussite.withOpacity(0.8),
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic)),
      ]),
    );
  }

  Widget _buildHeader(BuildContext context, QuizController controller) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(
              bottom: BorderSide(
                  color: Theme.of(context).dividerTheme.color!.withOpacity(0.5)))),
      child: Column(children: [
        Row(children: [
          GestureDetector(
            onTap: () => _showQuitDialog(context),
            child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                    color: AppTheme.getSurfaceCardActive(Theme.of(context).brightness == Brightness.dark),
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.close,
                    color: Theme.of(context).textTheme.bodyMedium!.color, size: 20)),
          ),
          const Spacer(),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                  color: AppTheme.vertFaso.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20)),
              child: Text(controller.categoryName,
                  style: const TextStyle(
                      color: AppTheme.vertFaso,
                      fontSize: 12,
                      fontWeight: FontWeight.w600))),
          const Spacer(),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                  color: AppTheme.getSurfaceCardActive(Theme.of(context).brightness == Brightness.dark),
                  borderRadius: BorderRadius.circular(20)),
              child: Row(children: [
                const Icon(Icons.timer_outlined,
                    color: AppTheme.orReussite, size: 16),
                const SizedBox(width: 5),
                Text(controller.elapsedFormatted,
                    style: const TextStyle(
                        color: AppTheme.orReussite,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'monospace'))
              ])),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Text('Question ${controller.currentIndex.value + 1}',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge!.color)),
          const SizedBox(width: 4),
          Text('/ ${controller.questions.length}',
              style: TextStyle(
                  fontSize: 13, color: Theme.of(context).textTheme.bodyMedium!.color)),
          const Spacer(),
          Text('${(controller.progressValue * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                  fontWeight: FontWeight.w500)),
        ]),
        const SizedBox(height: 8),
        ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
                value: controller.progressValue,
                minHeight: 5,
                backgroundColor: Theme.of(context).dividerTheme.color,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppTheme.vertFaso))),
      ]),
    );
  }

  Widget _buildQuestionTypeBadge(BuildContext context, QuizController controller) {
    final isVF = controller.currentQuestion.type == QuestionType.vraiOuFaux;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: isVF
              ? AppTheme.orReussite.withOpacity(0.12)
              : AppTheme.vertFaso.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8)),
      child: Text(isVF ? '⚡ Vrai ou Faux' : '☑ QCM — Choix multiples',
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isVF ? AppTheme.orReussite : AppTheme.vertFaso)),
    );
  }

  Widget _buildQuestionText(BuildContext context, QuizController controller) {
    return Text(controller.currentQuestion.text,
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyLarge!.color,
            height: 1.5));
  }

  Widget _buildAnswerOptions(BuildContext context, QuizController controller) {
    if (controller.currentQuestion.type == QuestionType.vraiOuFaux) {
      return _buildVraiFauxOptions(context, controller);
    }
    return _buildQCMOptions(context, controller);
  }

  Widget _buildQCMOptions(BuildContext context, QuizController controller) {
    return Column(
      children: controller.currentQuestion.options.map((option) {
        final isSelected = controller.selectedAnswerIds.contains(option.id);
        Color borderColor = Theme.of(context).dividerTheme.color!;
        Color bgColor = Theme.of(context).cardTheme.color!;
        IconData? trailingIcon;
        Color? trailingIconColor;

        if (controller.isValidated.value) {
          if (option.isCorrect && isSelected) {
            borderColor = AppTheme.correctGreen;
            bgColor = AppTheme.correctGreen.withOpacity(0.1);
            trailingIcon = Icons.check_circle;
            trailingIconColor = AppTheme.correctGreen;
          } else if (!option.isCorrect && isSelected) {
            borderColor = AppTheme.incorrectRed;
            bgColor = AppTheme.incorrectRed.withOpacity(0.1);
            trailingIcon = Icons.cancel;
            trailingIconColor = AppTheme.incorrectRed;
          } else if (option.isCorrect && !isSelected) {
            borderColor = AppTheme.correctGreen.withOpacity(0.5);
            bgColor = AppTheme.correctGreen.withOpacity(0.05);
            trailingIcon = Icons.check_circle_outline;
            trailingIconColor = AppTheme.correctGreen.withOpacity(0.6);
          } else {
            borderColor = Theme.of(context).brightness == Brightness.dark ? AppTheme.neutralGrey : AppTheme.neutralGreyClair;
            bgColor = Theme.of(context).cardTheme.color!;
          }
        } else if (isSelected) {
          borderColor = AppTheme.vertFaso;
          bgColor = AppTheme.vertFaso.withOpacity(0.08);
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: borderColor,
                    width: controller.isValidated.value &&
                            (option.isCorrect || isSelected)
                        ? 2
                        : 1.5)),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: controller.isValidated.value
                    ? null
                    : () => controller.toggleAnswer(option.id),
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  child: Row(children: [
                    _buildCheckbox(context, controller, option, isSelected),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Text(option.text,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: controller.isValidated.value
                                    ? (option.isCorrect
                                        ? AppTheme.correctGreen
                                        : isSelected
                                            ? AppTheme.incorrectRed
                                            : Theme.of(context).textTheme.bodyMedium!.color)
                                    : Theme.of(context).textTheme.bodyLarge!.color,
                                height: 1.4))),
                    if (trailingIcon != null)
                      Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Icon(trailingIcon,
                              color: trailingIconColor, size: 22)),
                  ]),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCheckbox(BuildContext context,
      QuizController controller, AnswerOption option, bool isSelected) {
    Color checkboxColor;
    if (controller.isValidated.value) {
      checkboxColor = option.isCorrect
          ? AppTheme.correctGreen
          : isSelected
              ? AppTheme.incorrectRed
              : (Theme.of(context).brightness == Brightness.dark ? AppTheme.neutralGrey : AppTheme.neutralGreyClair);
    } else {
      checkboxColor = isSelected ? AppTheme.vertFaso : Colors.transparent;
    }
    final showCheck =
        isSelected || (controller.isValidated.value && option.isCorrect);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
          color: showCheck ? checkboxColor : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
              color: showCheck
                  ? checkboxColor
                  : Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.5),
              width: 2)),
      child: showCheck
          ? Icon(
              controller.isValidated.value
                  ? (option.isCorrect ? Icons.check : Icons.close)
                  : Icons.check,
              color: Colors.white,
              size: 16)
          : null,
    );
  }

  Widget _buildVraiFauxOptions(BuildContext context, QuizController controller) {
    return Row(
      children: controller.currentQuestion.options.map((option) {
        final isSelected = controller.selectedAnswerIds.contains(option.id);
        final isVrai = option.id == 'vrai';
        Color borderColor = Theme.of(context).dividerTheme.color!;
        Color bgColor = Theme.of(context).cardTheme.color!;
        Color iconColor = isVrai
            ? AppTheme.vertFaso.withOpacity(0.6)
            : AppTheme.rougeTerre.withOpacity(0.6);

        if (controller.isValidated.value) {
          if (option.isCorrect) {
            borderColor = AppTheme.correctGreen;
            bgColor = AppTheme.correctGreen.withOpacity(0.1);
            iconColor = AppTheme.correctGreen;
          } else if (isSelected) {
            borderColor = AppTheme.incorrectRed;
            bgColor = AppTheme.incorrectRed.withOpacity(0.1);
            iconColor = AppTheme.incorrectRed;
          }
        } else if (isSelected) {
          borderColor = isVrai ? AppTheme.vertFaso : AppTheme.rougeTerre;
          bgColor = (isVrai ? AppTheme.vertFaso : AppTheme.rougeTerre)
              .withOpacity(0.1);
          iconColor = isVrai ? AppTheme.vertFaso : AppTheme.rougeTerre;
        }

        return Expanded(
          child: Padding(
            padding:
                EdgeInsets.only(right: isVrai ? 6 : 0, left: isVrai ? 0 : 6),
            child: GestureDetector(
              onTap: controller.isValidated.value
                  ? null
                  : () => controller.toggleAnswer(option.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 28),
                decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: borderColor,
                        width: isSelected ||
                                (controller.isValidated.value &&
                                    option.isCorrect)
                            ? 2.5
                            : 1.5)),
                child: Column(children: [
                  Icon(isVrai ? Icons.check_circle_outline : Icons.cancel_outlined,
                      color: iconColor, size: 40),
                  const SizedBox(height: 10),
                  Text(option.text,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: isSelected ||
                                  (controller.isValidated.value &&
                                      option.isCorrect)
                              ? iconColor
                              : Theme.of(context).textTheme.bodyMedium!.color)),
                  const SizedBox(height: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                        color: isSelected
                            ? (isVrai ? AppTheme.vertFaso : AppTheme.rougeTerre)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: isSelected
                                ? (isVrai
                                    ? AppTheme.vertFaso
                                    : AppTheme.rougeTerre)
                                : Theme.of(context).textTheme.bodyMedium!.color!,
                            width: 2)),
                    child: isSelected
                        ? const Icon(Icons.check,
                            color: Colors.white, size: 16)
                        : null,
                  ),
                ]),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildJustification(BuildContext context, QuizController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppTheme.orReussite.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: AppTheme.orReussite.withOpacity(0.3), width: 1)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [
          Icon(Icons.lightbulb_outline, color: AppTheme.orReussite, size: 18),
          SizedBox(width: 6),
          Text('Explication',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.orReussite))
        ]),
        const SizedBox(height: 10),
        Text(controller.currentQuestion.justification,
            style: TextStyle(
                fontSize: 14, color: Theme.of(context).textTheme.bodyLarge!.color, height: 1.55)),
      ]),
    );
  }

  Widget _buildFooter(BuildContext context, QuizController controller) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(
              top: BorderSide(
                  color: Theme.of(context).dividerTheme.color!.withOpacity(0.5)))),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: controller.isValidated.value
              ? ElevatedButton.icon(
                  onPressed: controller.nextQuestion,
                  icon: Icon(
                      controller.isLastQuestion ? Icons.emoji_events : Icons.arrow_forward,
                      size: 20),
                  label: Text(controller.isLastQuestion
                      ? 'Voir les résultats'
                      : 'Question suivante'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: controller.isLastQuestion
                          ? AppTheme.orReussite
                          : AppTheme.vertFaso,
                      foregroundColor: controller.isLastQuestion
                          ? Colors.black87
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14))),
                )
              : ElevatedButton.icon(
                  onPressed: controller.selectedAnswerIds.isEmpty
                      ? null
                      : controller.validateAnswer,
                  icon: const Icon(Icons.check_circle_outline, size: 20),
                  label: const Text('Valider la réponse'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: controller.selectedAnswerIds.isEmpty
                          ? AppTheme.neutralGrey
                          : AppTheme.vertFaso,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Theme.of(context).brightness == Brightness.dark ? AppTheme.neutralGrey : AppTheme.neutralGreyClair,
                      disabledForegroundColor: Theme.of(context).textTheme.bodyMedium!.color,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14))),
                ),
        ),
      ),
    );
  }

  void _showQuitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardTheme.color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Quitter le test ?',
            style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color)),
        content: Text('Ta progression pour ce test sera perdue.',
            style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color)),
        actions: [
          TextButton(
              onPressed: () => Get.back(),
              child: const Text('Continuer', style: TextStyle(color: AppTheme.vertFaso))),
          TextButton(
              onPressed: () {
                Get.back();
                Get.back();
              },
              child: const Text('Quitter', style: TextStyle(color: AppTheme.rougeTerre))),
        ],
      ),
    );
  }
}
