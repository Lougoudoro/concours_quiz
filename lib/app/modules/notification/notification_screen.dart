import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cncours_quiz/app/core/theme/app_theme.dart';
import 'notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all_outlined, size: 20),
            onPressed: () => controller.markAllRead(),
            tooltip: 'Tout marquer comme lu',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.vertFaso.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.notifications_none,
                    color: AppTheme.vertFaso, size: 56),
              ),
              const SizedBox(height: 24),
              const Text('Aucune notification',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(
                'Tu seras notifié ici des nouveaux concours,\nquiz disponibles et résultats.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
