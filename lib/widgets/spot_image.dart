import 'package:flutter/material.dart';

import '../models/study_spot.dart';
import '../spot_style.dart';
import '../theme.dart';

class SpotImage extends StatelessWidget {
  const SpotImage({super.key, required this.spot, this.fit = BoxFit.cover});

  final StudySpot spot;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final fallback = ColoredBox(
      color: categoryTint(spot.category),
      child: Center(
        child: Icon(
          categoryIcon(spot.category),
          color: AppColors.coralDeep,
          size: 28,
        ),
      ),
    );
    if (spot.photos.isNotEmpty) {
      return Image.memory(
        spot.photos.first,
        fit: fit,
        gaplessPlayback: true,
        errorBuilder: (_, _, _) => fallback,
      );
    }
    final asset = spot.assetImage;
    if (asset == null) return fallback;
    return Image.asset(
      asset,
      fit: fit,
      errorBuilder: (_, _, _) => fallback,
    );
  }
}
