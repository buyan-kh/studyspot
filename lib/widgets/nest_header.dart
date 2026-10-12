import 'package:flutter/material.dart';

import '../theme.dart';

class NestHeader extends StatelessWidget {
  const NestHeader({super.key, this.trailing, this.onBack});

  final Widget? trailing;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
        child: Row(
          children: [
            if (onBack != null)
              IconButton(
                onPressed: onBack,
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.navy,
                ),
              ),
            const HouseMark(),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Wordmark(size: 22),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Find your spot. Feel at home. ♥',
                      style: nunito(
                        size: 12,
                        weight: FontWeight.w700,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
            const SizedBox(width: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/logo.png',
                width: 58,
                height: 58,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Wordmark extends StatelessWidget {
  const Wordmark({super.key, this.size = 28});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Study',
            style: nunito(size: size, weight: FontWeight.w800, height: 1),
          ),
          TextSpan(
            text: 'Nest',
            style: nunito(
              size: size,
              weight: FontWeight.w800,
              height: 1,
              color: AppColors.coral,
            ),
          ),
        ],
      ),
    );
  }
}

class HouseMark extends StatelessWidget {
  const HouseMark({super.key, this.size = 42});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: const _HousePainter(),
    );
  }
}

class _HousePainter extends CustomPainter {
  const _HousePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, s, s),
        Radius.circular(s * 0.28),
      ),
      Paint()..color = const Color(0xFFFFE8DC),
    );

    final roof = Path()
      ..moveTo(s * 0.16, s * 0.46)
      ..lineTo(s * 0.50, s * 0.16)
      ..lineTo(s * 0.84, s * 0.46)
      ..close();
    canvas.drawPath(roof, Paint()..color = AppColors.coral);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(s * 0.24, s * 0.42, s * 0.52, s * 0.40),
        Radius.circular(s * 0.08),
      ),
      Paint()..color = const Color(0xFFFFF8F3),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(s * 0.42, s * 0.56, s * 0.16, s * 0.26),
        Radius.circular(s * 0.08),
      ),
      Paint()..color = AppColors.coral,
    );

    final paw = Paint()..color = AppColors.navy;
    canvas.drawCircle(Offset(s * 0.50, s * 0.36), s * 0.035, paw);
    canvas.drawCircle(Offset(s * 0.44, s * 0.30), s * 0.018, paw);
    canvas.drawCircle(Offset(s * 0.50, s * 0.28), s * 0.018, paw);
    canvas.drawCircle(Offset(s * 0.56, s * 0.30), s * 0.018, paw);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
