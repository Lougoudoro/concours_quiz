import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/history_controller.dart';
import '../models/quiz_result.dart';
import '../theme/app_theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HistoryController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon historique'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() {
            if (controller.history.isEmpty) return const SizedBox.shrink();
            return IconButton(
              onPressed: () => _showClearDialog(context, controller),
              icon: const Icon(Icons.delete_outline, size: 20),
              tooltip: 'Tout effacer',
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.history.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.vertFaso.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.history,
                        color: AppTheme.vertFaso, size: 56),
                  ),
                  const SizedBox(height: 24),
                  const Text('Aucun historique',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text(
                    'Les quiz que tu termines apparaîtront ici.\nCommence un entraînement pour lançer !',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodyMedium?.color),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          physics: const BouncingScrollPhysics(),
          itemCount: controller.history.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final result = controller.history[index];
            return _HistoryCard(result: result);
          },
        );
      }),
    );
  }

  void _showClearDialog(BuildContext context, HistoryController controller) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardTheme.color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Effacer l\'historique ?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        content: const Text('Cette action est irréversible.'),
        actions: [
          TextButton(
              onPressed: () => Get.back(),
              child: const Text('Annuler',
                  style: TextStyle(color: AppTheme.neutralGrey))),
          TextButton(
              onPressed: () {
                controller.clearHistory();
                Get.back();
              },
              child: const Text('Effacer',
                  style: TextStyle(
                      color: AppTheme.rougeTerre,
                      fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final QuizResult result;
  const _HistoryCard({required this.result});

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String _formatDate(DateTime d) {
    final months = [
      'jan',
      'fév',
      'mar',
      'avr',
      'mai',
      'juin',
      'juil',
      'aoû',
      'sep',
      'oct',
      'nov',
      'déc'
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final passed = result.percentage >= 50;
    return GestureDetector(
      onTap: () => Get.toNamed('/results', arguments: result),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: passed
                ? AppTheme.correctGreen.withOpacity(0.2)
                : AppTheme.incorrectRed.withOpacity(0.2),
          ),
        ),
        child: Row(children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: passed
                  ? AppTheme.correctGreen.withOpacity(0.12)
                  : AppTheme.incorrectRed.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                '${result.percentage.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: passed ? AppTheme.correctGreen : AppTheme.incorrectRed,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(result.categoryName,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(children: [
                  Icon(Icons.task_alt,
                      size: 13,
                      color: Theme.of(context).textTheme.bodyMedium?.color),
                  const SizedBox(width: 4),
                  Text('${result.score}/${result.total}',
                      style: TextStyle(
                          fontSize: 12,
                          color:
                              Theme.of(context).textTheme.bodyMedium?.color)),
                  const SizedBox(width: 12),
                  Icon(Icons.timer_outlined,
                      size: 13,
                      color: Theme.of(context).textTheme.bodyMedium?.color),
                  const SizedBox(width: 4),
                  Text(_formatDuration(result.totalTime),
                      style: TextStyle(
                          fontSize: 12,
                          color:
                              Theme.of(context).textTheme.bodyMedium?.color)),
                  const SizedBox(width: 12),
                  Icon(Icons.calendar_today,
                      size: 12,
                      color: Theme.of(context).textTheme.bodyMedium?.color),
                  const SizedBox(width: 4),
                  Text(_formatDate(result.dateTime),
                      style: TextStyle(
                          fontSize: 12,
                          color:
                              Theme.of(context).textTheme.bodyMedium?.color)),
                ]),
              ],
            ),
          ),
          Icon(Icons.chevron_right,
              color: Theme.of(context).textTheme.bodyMedium?.color, size: 20),
        ]),
      ),
    );
  }
}
