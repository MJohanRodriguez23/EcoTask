import 'package:flutter/material.dart';
import 'package:to_do_ufpso/utils/app_theme.dart';

class EcoLogo extends StatelessWidget {
  final double size;

  const EcoLogo({
    super.key,
    this.size = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.secondary,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        Icons.eco,
        color: Colors.white,
        size: size * 0.6,
      ),
    );
  }
}
