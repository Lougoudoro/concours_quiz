import 'package:cncours_quiz/app/core/widgets/shimmer_loading.dart';
import 'package:cncours_quiz/app/modules/dashboard/widgets/series_card.dart';
import 'package:flutter/material.dart';
import 'package:cncours_quiz/app/data/resources/serie_resource.dart';

class SeriesGrid extends StatelessWidget {
  final List<SerieResource> series;
  final bool isLoading;

  const SeriesGrid({
    super.key,
    required this.series,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && series.isEmpty) {
      return const _SeriesShimmer();
    }
    if (series.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 0.85,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => SeriesCard(
            serie: series[index],
            index: index,
          ),
          childCount: series.length,
        ),
      ),
    );
  }
}

class _SeriesShimmer extends StatelessWidget {
  const _SeriesShimmer();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            const SizedBox(height: 8),
            ...List.generate(
              3,
              (row) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  children: [
                    Expanded(
                      child: ShimmerLoading(
                        height: 160,
                        borderRadius: 18,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: ShimmerLoading(
                        height: 160,
                        borderRadius: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
