import 'package:cncours_quiz/app/core/theme/app_theme.dart';
import 'package:cncours_quiz/app/data/resources/serie_resource.dart';
import 'package:cncours_quiz/app/modules/dashboard/gamification_controller.dart';
import 'package:cncours_quiz/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SeriesCard extends StatelessWidget {
  final SerieResource serie;
  final int index;

  static const _cardColors = [
    [Color(0xFF009E49), Color(0xFF00B86B)],
    [Color(0xFFFFB800), Color(0xFFFFD000)],
    [Color(0xFF6C63FF), Color(0xFF8B83FF)],
    [Color(0xFFE74C3C), Color(0xFFFF6B6B)],
    [Color(0xFF1E88E5), Color(0xFF42A5F5)],
    [Color(0xFFFF6F00), Color(0xFFFF8F00)],
  ];

  const SeriesCard({super.key, required this.serie, this.index = 0});

  @override
  Widget build(BuildContext context) {
    final progress = Get.find<GamificationController>()
        .getSeriesProgress(serie.id.toString());
    final colors = _cardColors[index % _cardColors.length];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: _open,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.surfaceCardSombre : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: colors.first.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: colors.first.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.book, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    serie.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    serie.description,
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
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
                        backgroundColor: colors.first.withOpacity(0.15),
                        valueColor: AlwaysStoppedAnimation(colors.last),
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
                    color: colors.first,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _open() {
    Get.toNamed(Routes.SERIE, arguments: serie);
  }
}
