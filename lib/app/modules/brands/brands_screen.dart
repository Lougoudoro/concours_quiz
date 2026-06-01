import 'package:cncours_quiz/app/core/theme/app_theme.dart';
import 'package:cncours_quiz/app/data/resources/brand_resource.dart';
import 'package:cncours_quiz/app/modules/dashboard/session_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BrandsScreen extends StatefulWidget {
  const BrandsScreen({super.key});

  @override
  State<BrandsScreen> createState() => _BrandsScreenState();
}

class _BrandsScreenState extends State<BrandsScreen> {
  final sessionController = Get.find<SessionController>();

  @override
  void initState() {
    super.initState();
    sessionController.fetchBrands();
  }

  Future<void> _selectBrand(BrandResource brand) async {
    if (brand.currentSession == null) return;

    final success = await sessionController.selectBrandSession(brand);
    if (success && mounted) {
      Get.back();
      Get.snackbar(
        'Session changée',
        'Vous utilisez maintenant "${brand.currentSession!.name}" de ${brand.name}',
        backgroundColor: AppTheme.vertFaso,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }

  void _showBrandDetails(BrandResource brand) {
    final isSelected = sessionController.activeBrand?.id == brand.id;
    final session = brand.currentSession;
    final hasSession = session != null;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        width: 64,
                        height: 64,
                        color: AppTheme.vertFaso.withOpacity(0.1),
                        child:
                            brand.logoUrl != null && brand.logoUrl!.isNotEmpty
                                ? Image.network(brand.logoUrl!,
                                    width: 64,
                                    height: 64,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => const Icon(
                                        Icons.school,
                                        color: AppTheme.vertFaso,
                                        size: 32))
                                : const Icon(Icons.school,
                                    color: AppTheme.vertFaso, size: 32),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(brand.name,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          if (brand.description.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(brand.description,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Theme.of(ctx)
                                          .textTheme
                                          .bodyMedium
                                          ?.color)),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (hasSession)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppTheme.vertFaso.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: AppTheme.vertFaso.withOpacity(0.15)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.vertFaso.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.play_circle_outline,
                                  color: AppTheme.vertFaso, size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(session.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  const SizedBox(height: 2),
                                  Text('Session active',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(ctx)
                                              .textTheme
                                              .bodyMedium
                                              ?.color)),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppTheme.vertFaso.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text('Active',
                                    style: TextStyle(
                                        color: AppTheme.vertFaso,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)),
                              ),
                          ],
                        ),
                        if (!isSelected) ...[
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(ctx);
                                _selectBrand(brand);
                              },
                              icon: const Icon(Icons.check_circle_outline,
                                  size: 20),
                              label: const Text('Sélectionner cette session'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.vertFaso,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                textStyle: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppTheme.borderSubtleSombre
                          : AppTheme.neutralGreyClair.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.block,
                              color: Colors.grey, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Text('Aucune session active pour le moment',
                            style: TextStyle(
                                fontSize: 14,
                                color:
                                    Theme.of(ctx).textTheme.bodyMedium?.color)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fournisseurs de sessions'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (sessionController.brandsLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (sessionController.brands.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.orReussite.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.store_mall_directory_outlined,
                        color: AppTheme.orReussite, size: 48),
                  ),
                  const SizedBox(height: 20),
                  const Text('Aucun fournisseur disponible',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text(
                    'Reviens bientôt, de nouveaux fournisseurs seront ajoutés.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).textTheme.bodyMedium?.color),
                  ),
                ],
              ),
            ),
          );
        }

        final activeBrand = sessionController.activeBrand;
        final brands = [...sessionController.brands]..sort((a, b) {
            if (activeBrand?.id == a.id) return -1;
            if (activeBrand?.id == b.id) return 1;
            return 0;
          });

        return RefreshIndicator(
          onRefresh: () => sessionController.fetchBrands(),
          child: ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: brands.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final brand = brands[index];
              final isSelected = activeBrand?.id == brand.id;
              final hasSession = brand.currentSession != null;

              return _BrandCard(
                brand: brand,
                isSelected: isSelected,
                hasSession: hasSession,
                isDark: isDark,
                onTap: () => _showBrandDetails(brand),
              );
            },
          ),
        );
      }),
    );
  }
}

class _BrandCard extends StatelessWidget {
  final BrandResource brand;
  final bool isSelected;
  final bool hasSession;
  final bool isDark;
  final VoidCallback onTap;

  const _BrandCard({
    required this.brand,
    required this.isSelected,
    required this.hasSession,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasLogo = brand.logoUrl != null && brand.logoUrl!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppTheme.vertFaso
                : Theme.of(context).dividerTheme.color!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 44,
                height: 44,
                color: AppTheme.vertFaso.withOpacity(0.1),
                child: hasLogo
                    ? Image.network(brand.logoUrl!,
                        width: 44,
                        height: 44,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(Icons.school,
                            color: AppTheme.vertFaso, size: 22))
                    : const Icon(Icons.school,
                        color: AppTheme.vertFaso, size: 22),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(brand.name,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                  Text(
                    hasSession
                        ? brand.currentSession!.name
                        : 'Aucune session active',
                    style: TextStyle(
                        fontSize: 12,
                        color: hasSession
                            ? AppTheme.vertFaso
                            : Theme.of(context).textTheme.bodyMedium?.color),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: AppTheme.vertFaso,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 14),
              )
            else
              const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
