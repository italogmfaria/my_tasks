import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PlatformWarningBanner extends StatelessWidget {
  final String message;
  final Widget child;

  const PlatformWarningBanner({
    super.key,
    required this.message,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: const Color(0x1AEF233C),
          child: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: AppColors.redPantone,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: AppColors.redPantone400,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}

class SQLiteTabWrapper extends StatelessWidget {
  final Widget child;

  const SQLiteTabWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return PlatformWarningBanner(
        message: 'SQLite não está disponível no navegador. Usando armazenamento em memória (os dados serão perdidos ao recarregar).',
        child: child,
      );
    }
    return child;
  }
}

class FileTabWrapper extends StatelessWidget {
  final Widget child;

  const FileTabWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return PlatformWarningBanner(
        message: 'Armazenamento em arquivo não está disponível no navegador. Usando SharedPreferences como alternativa (dados persistem).',
        child: child,
      );
    }
    return child;
  }
}

