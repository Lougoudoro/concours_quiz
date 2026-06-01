import 'package:cncours_quiz/app/data/models/quiz_result.dart';
import 'package:cncours_quiz/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'history_controller.dart';
import 'package:cncours_quiz/app/core/theme/app_theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key, this.showBackButton = true});
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HistoryController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon historique'),
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Get.back(),
              )
            : null,
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
          return _EmptyHistory();
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          physics: const BouncingScrollPhysics(),
          itemCount: controller.history.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final result = controller.history[index];
            return _HistoryCard(result: result, index: index);
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

class _EmptyHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.vertFaso, Color(0xFF00B86B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.vertFaso.withOpacity(0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.history, color: Colors.white, size: 48),
            ),
            const SizedBox(height: 24),
            const Text('Aucun historique',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(
              'Les quiz que tu termines apparaîtront ici.\nCommence un entraînement pour lancer !',
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
}

class _HistoryCard extends StatelessWidget {
  final QuizResult result;
  final int index;
  const _HistoryCard({required this.result, required this.index});

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String _formatDate(DateTime d) {
    const months = [
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
    final pct = result.percentage;
    final scoreColor = pct >= 80
        ? AppTheme.correctGreen
        : pct >= 50
            ? AppTheme.orReussite
            : AppTheme.incorrectRed;

    return GestureDetector(
      onTap: () => Get.toNamed(Routes.RESULTS, arguments: result),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: scoreColor.withOpacity(0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: scoreColor.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _ScoreRing(percentage: pct, color: scoreColor),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(result.quizName,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.task_alt,
                        text: '${result.score}/${result.total}',
                        color: scoreColor,
                      ),
                      const SizedBox(width: 10),
                      _InfoChip(
                        icon: Icons.timer_outlined,
                        text: _formatDuration(result.totalTime),
                        color: AppTheme.orReussite,
                      ),
                      const SizedBox(width: 10),
                      _InfoChip(
                        icon: Icons.calendar_today,
                        text: _formatDate(result.dateTime),
                        color: Theme.of(context).textTheme.bodyMedium?.color ??
                            Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right,
                color: Theme.of(context).textTheme.bodyMedium?.color, size: 20),
          ],
        ),
      ),
    );
  }
}

class _ScoreRing extends StatelessWidget {
  final double percentage;
  final Color color;
  const _ScoreRing({required this.percentage, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 52,
      child: CustomPaint(
        painter: _RingProgressPainter(
          progress: percentage / 100,
          color: color,
        ),
        child: Center(
          child: Text(
            '${percentage.toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

class _RingProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  _RingProgressPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    const stroke = 4.0;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = color.withOpacity(0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708,
      6.28319 * progress,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingProgressPainter old) => old.progress != progress;
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  const _InfoChip({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 3),
        Text(
          text,
          style: TextStyle(fontSize: 11, color: color),
        ),
      ],
    );
  }
}
