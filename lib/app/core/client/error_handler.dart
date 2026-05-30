import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'api_exception.dart';
import 'app_exception.dart';

/// Centralized error handler and async runner.
///
/// Usage:
/// ```dart
/// final data = await ErrorHandler.guard(() => provider.fetch());
/// if (data == null) return; // error already shown
/// ```
class ErrorHandler {
  ErrorHandler._();

  // ─── Runner ───────────────────────────────────────────────────────

  /// Executes [operation] and catches any exception.
  ///
  /// Returns the result or `null` on failure. When [showError] is true
  /// (default) a beautiful UI is displayed automatically.
  static Future<T?> guard<T>(
    Future<T> Function() operation, {
    String? context,
    bool showError = true,
    VoidCallback? onRetry,
    void Function(AppException)? onError,
  }) async {
    try {
      return await operation();
    } catch (e, stack) {
      final exception = _normalize(e, stack);
      _log(exception, context: context);
      onError?.call(exception);
      if (showError) await _showErrorUI(exception, onRetry: onRetry);
      return null;
    }
  }

  /// Runs [operation] without returning a value. Same error handling.
  static Future<void> run(
    Future<void> Function() operation, {
    String? context,
    bool showError = true,
    VoidCallback? onRetry,
    void Function(AppException)? onError,
  }) async {
    try {
      await operation();
    } catch (e, stack) {
      final exception = _normalize(e, stack);
      _log(exception, context: context);
      onError?.call(exception);
      if (showError) await _showErrorUI(exception, onRetry: onRetry);
    }
  }

  // ─── Normalization ────────────────────────────────────────────────

  static AppException _normalize(dynamic error, StackTrace stack) {
    if (error is AppException) return error;

    if (error is SocketException || error is HttpException) {
      return NetworkException(
        originalError: error,
        stackTrace: stack,
      );
    }

    if (error is TimeoutException) {
      return const TimeoutException();
    }

    if (error is FormatException) {
      return DataParsingException(
        originalError: error,
        stackTrace: stack,
      );
    }

    return UnknownException(
      message: error.toString(),
      originalError: error,
      stackTrace: stack,
    );
  }

  // ─── Logging ──────────────────────────────────────────────────────

  static void _log(AppException e, {String? context}) {
    // ignore: avoid_print
    print('[${context ?? 'APP'}] ${e.runtimeType}: ${e.message}');
    if (e.stackTrace != null) {
      // ignore: avoid_print
      print(e.stackTrace.toString().split('\n').take(3).join('\n'));
    }
  }

  // ─── Beautiful Error UI ───────────────────────────────────────────

  static Future<void> _showErrorUI(
    AppException exception, {
    VoidCallback? onRetry,
  }) async {
    // Use snackbar for minor errors, dialog for serious ones
    if (exception is NetworkException || exception is TimeoutException) {
      _showErrorSnackbar(exception, onRetry: onRetry);
    } else {
      await _showErrorDialog(exception, onRetry: onRetry);
    }
  }

  static void _showErrorSnackbar(
    AppException exception, {
    VoidCallback? onRetry,
  }) {
    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 4),
      borderRadius: 16,
      overlayBlur: 0,
      snackStyle: SnackStyle.FLOATING,
      titleText: const SizedBox.shrink(),
      messageText: _ErrorBanner(
        icon: exception is NetworkException
            ? Icons.wifi_off_rounded
            : Icons.timer_outlined,
        iconColor: const Color(0xFFFFB800),
        title: exception.message,
        subtitle: exception is NetworkException
            ? 'Vérifiez votre connexion internet'
            : 'Réessayez dans quelques instants',
        actionLabel: onRetry != null ? 'Réessayer' : null,
        onAction: onRetry,
      ),
    );
  }

  static Future<void> _showErrorDialog(
    AppException exception, {
    VoidCallback? onRetry,
  }) async {
    final isDark = Get.isDarkMode;

    IconData icon;
    Color iconColor;
    String title;

    switch (exception.runtimeType) {
      case const (ApiException):
        final api = exception as ApiException;
        icon = _iconForStatusCode(api.statusCode);
        iconColor = _colorForStatusCode(api.statusCode);
        title = _titleForStatusCode(api.statusCode);
      case const (DataParsingException):
        icon = Icons.bug_report_rounded;
        iconColor = const Color(0xFFFFB800);
        title = 'Erreur de données';
      default:
        icon = Icons.error_outline_rounded;
        iconColor = const Color(0xFFC8102E);
        title = 'Erreur';
    }

    await Get.dialog(
      PopScope(
        canPop: true,
        child: Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              width: 340,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF16213E) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 32,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _AnimatedErrorIcon(icon: icon, color: iconColor),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? const Color(0xFFF0F0F0)
                          : const Color(0xFF212529),
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    exception.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: isDark
                          ? const Color(0xFFB0B0C0)
                          : const Color(0xFF6C757D),
                      height: 1.5,
                    ),
                  ),
                  if (exception is ApiException &&
                      _hasErrors(exception.errors)) ...[
                    const SizedBox(height: 14),
                    _ValidationErrors(errors: exception.errors, isDark: isDark),
                  ],
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      if (onRetry != null) ...[
                        Expanded(
                          child: _DialogButton(
                            label: 'Réessayer',
                            isPrimary: true,
                            onTap: () {
                              Get.back();
                              onRetry();
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: _DialogButton(
                          label: 'Fermer',
                          isPrimary: onRetry == null,
                          onTap: () => Get.back(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────

  static IconData _iconForStatusCode(int? code) {
    if (code == null) return Icons.error_outline_rounded;
    if (code == 401 || code == 403) return Icons.lock_outline_rounded;
    if (code == 404) return Icons.search_off_rounded;
    if (code == 422) return Icons.warning_amber_rounded;
    if (code == 429) return Icons.hourglass_bottom_rounded;
    if (code >= 500) return Icons.cloud_off_rounded;
    return Icons.error_outline_rounded;
  }

  static Color _colorForStatusCode(int? code) {
    if (code == null) return const Color(0xFFC8102E);
    if (code == 401) return const Color(0xFFFFB800);
    if (code == 422) return const Color(0xFFFFB800);
    if (code == 429) return const Color(0xFFFFB800);
    if (code >= 500) return const Color(0xFFC8102E);
    return const Color(0xFFC8102E);
  }

  static bool _hasErrors(dynamic errors) {
    if (errors == null) return false;
    if (errors is List) return errors.isNotEmpty;
    if (errors is Map) return errors.isNotEmpty;
    return false;
  }

  static String _titleForStatusCode(int? code) {
    if (code == null) return 'Erreur';
    if (code == 400) return 'Requête invalide';
    if (code == 401) return 'Session expirée';
    if (code == 403) return 'Accès refusé';
    if (code == 404) return 'Introuvable';
    if (code == 409) return 'Conflit';
    if (code == 422) return 'Données invalides';
    if (code == 429) return 'Trop de requêtes';
    if (code >= 500) return 'Erreur serveur';
    return 'Erreur';
  }
}

// ─── Private Widgets ─────────────────────────────────────────────────

class _AnimatedErrorIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  const _AnimatedErrorIcon({required this.icon, required this.color});

  @override
  State<_AnimatedErrorIcon> createState() => _AnimatedErrorIconState();
}

class _AnimatedErrorIconState extends State<_AnimatedErrorIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnim = CurvedAnimation(
      parent: _controller,
      curve: const ElasticOutCurve(0.8),
    );
    _opacityAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.3)),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => Opacity(
        opacity: _opacityAnim.value,
        child: Transform.scale(
          scale: _scaleAnim.value,
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(widget.icon, color: widget.color, size: 36),
          ),
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const _DialogButton({
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: isPrimary
          ? ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF009E49),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: Text(label),
            )
          : OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF009E49),
                side: const BorderSide(color: Color(0xFF009E49)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: Text(label),
            ),
    );
  }
}

class _ValidationErrors extends StatelessWidget {
  final dynamic errors;
  final bool isDark;

  const _ValidationErrors({required this.errors, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final items = _getErrorItems(errors, 3);
    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFC8102E).withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: items.map((msg) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ',
                    style: TextStyle(color: Color(0xFFC8102E), fontSize: 13)),
                Expanded(
                  child: Text(
                    msg,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? const Color(0xFFF0F0F0)
                          : const Color(0xFF212529),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  List<String> _getErrorItems(dynamic errors, int max) {
    if (errors == null) return [];
    if (errors is List) {
      return errors.take(max).map((e) => e.toString()).toList();
    }
    if (errors is Map) {
      return errors.entries.take(max).map((e) {
        final value = e.value;
        if (value is List && value.isNotEmpty) return value.join(', ');
        return value.toString();
      }).toList();
    }
    return [errors.toString()];
  }
}

class _ErrorBanner extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _ErrorBanner({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF16213E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: iconColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFFF0F0F0)
                        : const Color(0xFF212529),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? const Color(0xFFB0B0C0)
                        : const Color(0xFF6C757D),
                  ),
                ),
              ],
            ),
          ),
          if (actionLabel != null) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF009E49),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                actionLabel!,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
