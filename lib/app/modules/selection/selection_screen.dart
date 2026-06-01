import 'package:cncours_quiz/app/data/resources/category_resource.dart';
import 'package:cncours_quiz/app/data/resources/serie_resource.dart';
import 'package:flutter/material.dart';
import 'package:cncours_quiz/app/core/theme/app_theme.dart';

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
                String name = '';
                String desc = '';
                IconData icon = Icons.chevron_right;

                if (item is CategoryResource) {
                  name = item.name;
                  desc =
                      '${item.series.length} formation${item.series.length > 1 ? 's' : ''} disponible${item.series.length > 1 ? 's' : ''}';
                  icon = Icons.layers_outlined;
                } else if (item is SerieResource) {
                  name = item.name;
                  desc =
                      '${item.quizzes.length} série${item.quizzes.length > 1 ? 's' : ''} de quiz';
                  icon = Icons.folder_open_outlined;
                }

                return _SelectionCard(
                  name: name,
                  description: desc,
                  icon: icon,
                  colors: colors,
                  onTap: () => onSelect(item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectionCard extends StatelessWidget {
  final String name;
  final String description;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onTap;

  const _SelectionCard({
    required this.name,
    required this.description,
    required this.icon,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
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
