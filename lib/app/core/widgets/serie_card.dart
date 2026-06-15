import 'package:flutter/material.dart';
import 'package:cncours_quiz/app/core/theme/app_theme.dart';
import 'package:cncours_quiz/app/data/resources/serie_resource.dart';

class SerieCard extends StatelessWidget {
  final SerieResource serie;
  final VoidCallback onTap;
  final List<Color> colors;

  const SerieCard({
    super.key,
    required this.serie,
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final quizzesCount = serie.quizzes.length;
    final description =
        '$quizzesCount série${quizzesCount > 1 ? 's' : ''} de quiz';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colors.first.withOpacity(0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: colors.first.withOpacity(0.05),
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
                gradient: LinearGradient(
                  colors: colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.folder_open_outlined, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    serie.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colors.first.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child:
                  Icon(Icons.arrow_forward_ios, size: 14, color: colors.first),
            ),
          ],
        ),
      ),
    );
  }
}
