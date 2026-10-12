import 'package:flutter/material.dart';

import '../models/study_spot.dart';
import '../spot_style.dart';
import '../theme.dart';

class CampusMap extends StatelessWidget {
  const CampusMap({
    super.key,
    required this.spots,
    this.selectedId,
    this.onSelect,
    this.onBackgroundTap,
    this.onOpen,
    this.onMapTap,
    this.onUseLocation,
    this.showUser = false,
    this.showLegend = false,
    this.compact = false,
    this.draftFraction,
  });

  final List<StudySpot> spots;
  final String? selectedId;
  final ValueChanged<StudySpot>? onSelect;
  final VoidCallback? onBackgroundTap;
  final VoidCallback? onOpen;
  final void Function(double x, double y)? onMapTap;
  final VoidCallback? onUseLocation;
  final bool showUser;
  final bool showLegend;
  final bool compact;
  final Offset? draftFraction;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            return Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapUp: (details) {
                      if (onMapTap != null) {
                        onMapTap!(
                          details.localPosition.dx / width,
                          details.localPosition.dy / height,
                        );
                        return;
                      }
                      if (onOpen != null) {
                        onOpen!();
                        return;
                      }
                      onBackgroundTap?.call();
                    },
                    child: const CustomPaint(painter: CampusMapPainter()),
                  ),
                ),
                if (showUser)
                  Positioned(
                    left: width * 0.50 - 16,
                    top: height * 0.52 - 16,
                    child: Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0x553B82F6),
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ),
                for (final spot in spots)
                  Positioned(
                    left: width * spot.mapX - 21,
                    top: height * spot.mapY - 21,
                    child: IgnorePointer(
                      ignoring: onSelect == null,
                      child: _Pin(
                        spot: spot,
                        selected: spot.id == selectedId,
                        onTap: () => onSelect?.call(spot),
                      ),
                    ),
                  ),
                if (draftFraction != null)
                  Positioned(
                    left: width * draftFraction!.dx - 18,
                    top: height * draftFraction!.dy - 18,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.coral,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: const Icon(
                        Icons.push_pin_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                if (showLegend)
                  const Positioned(left: 10, top: 10, child: _Legend()),
                if (compact)
                  Positioned(
                    left: 12,
                    bottom: 12,
                    right: 12,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.94),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          'Explore study spots near SJSU',
                          style: nunito(size: 12, weight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ),
                if (onUseLocation != null)
                  Positioned(
                    right: 10,
                    top: compact ? 10.0 : null,
                    bottom: compact ? null : 10.0,
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                      elevation: 2,
                      child: InkWell(
                        onTap: onUseLocation,
                        borderRadius: BorderRadius.circular(999),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.my_location_rounded,
                                size: 16,
                                color: AppColors.coral,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Use my location',
                                style: nunito(
                                  size: 11,
                                  weight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Pin extends StatelessWidget {
  const _Pin({
    required this.spot,
    required this.selected,
    required this.onTap,
  });

  final StudySpot spot;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final size = selected ? 42.0 : 34.0;
    return SizedBox(
      width: 42,
      height: 42,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          if (selected)
            Positioned(
              bottom: size + 4,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 140),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(color: Color(0x22000000), blurRadius: 8),
                    ],
                  ),
                  child: Text(
                    spot.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: nunito(size: 10, weight: FontWeight.w800, height: 1.15),
                  ),
                ),
              ),
            ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: statusColor(spot.status),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: const [
                  BoxShadow(color: Color(0x33000000), blurRadius: 6, offset: Offset(0, 2)),
                ],
              ),
              child: Icon(
                categoryIcon(spot.category),
                color: Colors.white,
                size: selected ? 20 : 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LegendRow(color: statusColor(SeatStatus.open), label: 'Open'),
          _LegendRow(
            color: statusColor(SeatStatus.almostFull),
            label: 'Almost Full',
          ),
          _LegendRow(color: statusColor(SeatStatus.full), label: 'Full'),
          _LegendRow(
            color: statusColor(SeatStatus.unknown),
            label: 'Unknown',
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(label, style: nunito(size: 11, weight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class CampusMapPainter extends CustomPainter {
  const CampusMapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFD7EED4),
    );

    final road = Paint()
      ..color = const Color(0xFFF6E7C4)
      ..strokeWidth = size.shortestSide * 0.045
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(size.width * 0.06, size.height * 0.50),
      Offset(size.width * 0.94, size.height * 0.50),
      road,
    );
    canvas.drawLine(
      Offset(size.width * 0.42, size.height * 0.06),
      Offset(size.width * 0.58, size.height * 0.94),
      road,
    );
    canvas.drawLine(
      Offset(size.width * 0.08, size.height * 0.78),
      Offset(size.width * 0.92, size.height * 0.30),
      Paint()
        ..color = const Color(0xFFF6E7C4)
        ..strokeWidth = size.shortestSide * 0.028
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.50, size.height * 0.52),
        width: size.width * 0.26,
        height: size.height * 0.18,
      ),
      Paint()..color = const Color(0xFFE7F6D0),
    );

    final quad = TextPainter(
      text: TextSpan(
        text: 'SJSU',
        style: TextStyle(
          color: const Color(0xFF6E8B62),
          fontSize: size.shortestSide * 0.045,
          fontWeight: FontWeight.w800,
          fontFamily: 'Nunito',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    quad.paint(
      canvas,
      Offset(size.width * 0.50 - quad.width / 2, size.height * 0.52 - quad.height / 2),
    );

    void building(double x, double y, double w, double h, String label) {
      final rect = Rect.fromCenter(
        center: Offset(size.width * x, size.height * y),
        width: size.width * w,
        height: size.height * h,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect.shift(const Offset(0, 2)), const Radius.circular(10)),
        Paint()..color = const Color(0x14000000),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(10)),
        Paint()..color = const Color(0xFFFFFBF6),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(rect.left, rect.top, rect.width, rect.height * 0.28),
          const Radius.circular(8),
        ),
        Paint()..color = const Color(0xFFF3C7B8),
      );
      final painter = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: const Color(0xFF5C6B80),
            fontSize: size.shortestSide * 0.028,
            fontWeight: FontWeight.w800,
            fontFamily: 'Nunito',
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: rect.width - 6);
      painter.paint(
        canvas,
        Offset(
          rect.center.dx - painter.width / 2,
          rect.center.dy - painter.height / 2 + rect.height * 0.08,
        ),
      );
    }

    building(0.58, 0.24, 0.28, 0.14, 'Library');
    building(0.80, 0.32, 0.22, 0.13, 'Engineering');
    building(0.18, 0.36, 0.18, 0.12, 'Voyager');
    building(0.68, 0.48, 0.18, 0.11, 'Lab');
    building(0.30, 0.64, 0.24, 0.13, 'Student Union');
    building(0.48, 0.80, 0.22, 0.11, 'Clark Hall');
    building(0.18, 0.82, 0.22, 0.11, 'Spartan Rec');

    final tree = Paint()..color = const Color(0xFF7EBF78);
    final treeDark = Paint()..color = const Color(0xFF5EAA6A);
    const trees = <(double, double)>[
      (0.08, 0.14),
      (0.16, 0.10),
      (0.90, 0.12),
      (0.84, 0.18),
      (0.08, 0.58),
      (0.92, 0.62),
      (0.10, 0.90),
      (0.88, 0.86),
      (0.36, 0.18),
      (0.72, 0.70),
    ];
    for (var i = 0; i < trees.length; i++) {
      final point = trees[i];
      canvas.drawCircle(
        Offset(size.width * point.$1, size.height * point.$2),
        size.shortestSide * (i.isEven ? 0.028 : 0.02),
        i.isEven ? tree : treeDark,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
