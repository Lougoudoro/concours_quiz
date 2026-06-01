import 'package:cncours_quiz/app/core/theme/app_theme.dart';
import 'package:cncours_quiz/app/data/resources/serie_resource.dart';
import 'package:cncours_quiz/app/modules/dashboard/gamification_controller.dart';
import 'package:cncours_quiz/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SeriesCard extends StatelessWidget {
  final SerieResource serie;

  const SeriesCard({super.key, required this.serie});

  @override
  Widget build(BuildContext context) {
    final progress = Get.find<GamificationController>()
        .getSeriesProgress(serie.id.toString());
    return GestureDetector(
      onTap: _openSerie,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Theme.of(context).dividerTheme.color!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.book, color: AppTheme.vertFaso, size: 28),
            const SizedBox(height: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(serie.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(serie.description,
                      style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context).textTheme.bodyMedium?.color),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(
                        begin: 0,
                        end: progress > 0 ? (progress / 20).clamp(0, 1) : 0,
                      ),
                      duration: const Duration(milliseconds: 600),
                      builder: (context, value, _) => LinearProgressIndicator(
                        value: value,
                        minHeight: 4,
                        backgroundColor: Theme.of(context)
                            .dividerTheme
                            .color
                            ?.withOpacity(0.3),
                        valueColor:
                            const AlwaysStoppedAnimation(AppTheme.orReussite),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '$progress',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyMedium?.color),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openSerie() {
    Get.toNamed(Routes.SERIE, arguments: serie);
  }
}
