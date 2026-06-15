import 'package:cncours_quiz/app/data/resources/category_resource.dart';
import 'package:cncours_quiz/app/data/resources/serie_resource.dart';
import 'package:flutter/material.dart';
import 'package:cncours_quiz/app/core/theme/app_theme.dart';
import 'package:cncours_quiz/app/core/widgets/category_card.dart';
import 'package:cncours_quiz/app/core/widgets/serie_card.dart';

class SelectionScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<dynamic> items;
  final Function(dynamic) onSelect;

  const SelectionScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.items,
    required this.onSelect,
  });

  static const _palette = [
    [Color(0xFF009E49), Color(0xFF00B86B)],
    [Color(0xFFFFB800), Color(0xFFFFD000)],
    [Color(0xFF6C63FF), Color(0xFF8B83FF)],
    [Color(0xFFE74C3C), Color(0xFFFF6B6B)],
    [Color(0xFF1E88E5), Color(0xFF42A5F5)],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.vertFaso.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.filter_list,
                      color: AppTheme.vertFaso, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                final colors = _palette[index % _palette.length];

                if (item is CategoryResource) {
                  return CategoryCard(
                    category: item,
                    colors: colors,
                    onTap: () => onSelect(item),
                  );
                } else if (item is SerieResource) {
                  return SerieCard(
                    serie: item,
                    colors: colors,
                    onTap: () => onSelect(item),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
