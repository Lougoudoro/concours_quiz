import 'package:flutter/material.dart';

class ShimmerLoading extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoading({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -1, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor =
        isDark ? const Color(0xFF1F2B47) : const Color(0xFFE9ECEF);
    final highlightColor =
        isDark ? const Color(0xFF2A3A5A) : const Color(0xFFF5F6F7);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              colors: [baseColor, highlightColor, baseColor],
              stops: [
                _animation.value - 0.5,
                _animation.value,
                _animation.value + 0.5,
              ].map((s) => s.clamp(0.0, 1.0)).toList(),
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        );
      },
    );
  }
}

class QuizShimmer extends StatelessWidget {
  const QuizShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerLoading(height: 24, width: 120),
          const SizedBox(height: 24),
          const ShimmerLoading(height: 28),
          const SizedBox(height: 12),
          const ShimmerLoading(height: 20, width: 200),
          const SizedBox(height: 24),
          ...List.generate(
              4,
              (i) =>const Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ShimmerLoading(
                      height: 56,
                      borderRadius: 14,
                    ),
                  )),
        ],
      ),
    );
  }
}

class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(children: [
            const ShimmerLoading(height: 40, width: 40, borderRadius: 20),
            const SizedBox(width: 12),
            Expanded(child: ShimmerLoading(height: 18, width: 150)),
          ]),
          const SizedBox(height: 24),
          const ShimmerLoading(height: 180, borderRadius: 22),
          const SizedBox(height: 24),
          Row(children: [
            Expanded(child: ShimmerLoading(height: 160, borderRadius: 16)),
            const SizedBox(width: 12),
            Expanded(child: ShimmerLoading(height: 160, borderRadius: 16)),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: ShimmerLoading(height: 160, borderRadius: 16)),
            const SizedBox(width: 12),
            Expanded(child: ShimmerLoading(height: 160, borderRadius: 16)),
          ]),
        ],
      ),
    );
  }
}
