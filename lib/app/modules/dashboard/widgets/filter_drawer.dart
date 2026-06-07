import 'package:cncours_quiz/app/core/controllers/auth_controller.dart';
import 'package:cncours_quiz/app/core/theme/app_theme.dart';
import 'package:cncours_quiz/app/data/resources/category_resource.dart';
import 'package:cncours_quiz/app/data/resources/concours_type_resource.dart';
import 'package:cncours_quiz/app/data/resources/serie_resource.dart';
import 'package:cncours_quiz/app/modules/dashboard/session_controller.dart';
import 'package:cncours_quiz/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterDrawer extends StatelessWidget {
  const FilterDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionController = Get.find<SessionController>();
    return Drawer(
      child: Column(
        children: [
          _DrawerHeader(sessionController: sessionController),
          Expanded(
            child: Obx(() {
              final session = sessionController.activeSession.value;
              if (session == null) {
                return _NoSessionState();
              }
              return _ConcoursTypeList(
                sessionController: sessionController,
                types: session.concoursTypes,
              );
            }),
          ),
          _DrawerFooter(),
        ],
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  final SessionController sessionController;
  const _DrawerHeader({required this.sessionController});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
        Get.toNamed(Routes.BRANDS);
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: Theme.of(context).brightness == Brightness.dark
                ? [AppTheme.fondSombre, AppTheme.surfaceCardSombre]
                : [AppTheme.vertFaso, const Color(0xFF1A6B3C)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Obx(() {
            final session = sessionController.activeSession.value;
            final brand = session?.brand;
            final hasLogo = brand != null &&
                brand.logoUrl != null &&
                brand.logoUrl!.isNotEmpty;
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  hasLogo
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(brand.logoUrl!,
                              width: 40,
                              height: 40,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) =>
                                  _BrandPlaceholder()),
                        )
                      : _BrandPlaceholder(),
                  const SizedBox(height: 10),
                  Text(
                    brand?.name ?? session?.name ?? 'Sélectionner une session',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  if (brand?.description != null &&
                      brand!.description.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        brand.description,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8), fontSize: 11),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.swap_horiz,
                          color: Colors.white.withOpacity(0.6), size: 12),
                      const SizedBox(width: 2),
                      Text(
                        'Changer',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.6), fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _BrandPlaceholder extends StatelessWidget {
  const _BrandPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.school, color: AppTheme.orReussite, size: 24),
    );
  }
}

class _NoSessionState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              child: const Icon(Icons.filter_alt_outlined,
                  color: AppTheme.orReussite, size: 48),
            ),
            const SizedBox(height: 20),
            const Text('Aucune session active',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(
              'Reviens bientôt, de nouvelles sessions de concours seront ajoutées.',
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
}

class _ConcoursTypeList extends StatelessWidget {
  final SessionController sessionController;
  final List<ConcoursTypeResource> types;
  const _ConcoursTypeList(
      {required this.sessionController, required this.types});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('FILTRAGE AVANCÉ',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 12)),
        ),
        ...types.map((type) => ListTile(
              leading: Icon(
                  type.statusValue == 'direct' ? Icons.group : Icons.work,
                  color: AppTheme.vertFaso),
              title: Text(type.name,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text("${type.getCategoriesCount} Categorie(s)"),
              trailing: const Icon(Icons.chevron_right, size: 18),
              onTap: () {
                Get.back();
                _navigateToCategories(type);
              },
            )),
      ],
    );
  }

  void _navigateToCategories(ConcoursTypeResource type) {
    final fc = Get.find<SessionController>();
    fc.selectConcoursType(type);
    Get.toNamed(Routes.SELECTION, arguments: {
      'title': type.name,
      'subtitle':
          type.statusValue == 'direct' ? 'Niveau d\'étude' : 'Secteur / Corps',
      'items': fc.availableSubCategories,
      'onSelect': (item) => _navigateToSeries(item as CategoryResource),
    });
  }

  void _navigateToSeries(CategoryResource sub) {
    final fc = Get.find<SessionController>();
    fc.selectSubCategory(sub);
    Get.toNamed(Routes.SELECTION, arguments: {
      'title': sub.name,
      'subtitle': sub.description,
      'items': fc.availableCollections,
      'onSelect': (item) => _navigateToQuizzes(item as SerieResource),
    },
    preventDuplicates: false);
  }

  void _navigateToQuizzes(SerieResource coll) {
    final fc = Get.find<SessionController>();
    fc.selectCollection(coll);
    Get.toNamed(Routes.SERIE, arguments: coll);
  }
}

class _DrawerFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Guide des concours'),
          onTap: () {
            Get.back();
            Get.toNamed(Routes.GUIDE);
          },
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.logout, color: AppTheme.rougeTerre),
          title: const Text('Se déconnecter',
              style: TextStyle(color: AppTheme.rougeTerre)),
          onTap: () {
            Get.back();
            Get.find<AuthController>().logout();
          },
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom),
      ],
    );
  }
}
