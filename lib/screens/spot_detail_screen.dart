import 'package:flutter/material.dart';

import '../data/spot_store.dart';
import '../directions.dart';
import '../models/study_spot.dart';
import '../spot_style.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/spot_image.dart';

class SpotDetailScreen extends StatelessWidget {
  const SpotDetailScreen({super.key, required this.spotId});

  final String spotId;

  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    StudySpot? spot;
    for (final item in store.spots) {
      if (item.id == spotId) {
        spot = item;
        break;
      }
    }
    if (spot == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            const PageHeader(title: 'Study spot'),
            Expanded(
              child: Center(
                child: Text(
                  'That spot is no longer here.',
                  style: nunito(weight: FontWeight.w700, color: AppColors.muted),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final current = spot;
    final noise = noiseLabel(current);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: AppColors.navy,
            foregroundColor: Colors.white,
            leading: IconButton(
              style: IconButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back_rounded, color: AppColors.navy),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  style: IconButton.styleFrom(backgroundColor: Colors.white),
                  tooltip: current.favorite
                      ? 'Remove from favorites'
                      : 'Save to favorites',
                  onPressed: () => store.toggleFavorite(current.id),
                  icon: Icon(
                    current.favorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: current.favorite ? AppColors.coral : AppColors.navy,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: SpotImage(spot: current),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    current.name,
                    style: nunito(size: 26, weight: FontWeight.w800, height: 1.1),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${current.area} · ${formatMiles(current.distanceMiles)}',
                    style: nunito(weight: FontWeight.w700, color: AppColors.muted),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      StatusBadge(spot: current),
                      TagPill(tag: categoryLabel(current.category)),
                      if (current.isPrivate) const TagPill(tag: 'Only you'),
                    ],
                  ),
                  if (current.photos.length > 1) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 72,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: current.photos.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 8),
                        itemBuilder: (context, index) => ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            current.photos[index],
                            width: 72,
                            height: 72,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  TagWrap(tags: current.tags),
                  if (current.note.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: cardDecoration(color: AppColors.blush, radius: 18),
                      child: Text(
                        current.note,
                        style: nunito(size: 14, weight: FontWeight.w700, height: 1.35),
                      ),
                    ),
                  ],
                  if (noise != null) ...[
                    const SizedBox(height: 14),
                    _DetailRow(label: 'Noise level', value: noise),
                  ],
                  if (current.safety != null) ...[
                    const SizedBox(height: 10),
                    _DetailRow(
                      label: 'Safety',
                      value: safetyLabel(current.safety!),
                    ),
                  ],
                  const SizedBox(height: 18),
                  PrimaryButton(
                    label: 'Get Directions',
                    icon: Icons.near_me_rounded,
                    onPressed: () => openDirections(context, current),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: nunito(weight: FontWeight.w700, color: AppColors.muted),
        ),
        const Spacer(),
        Text(value, style: nunito(weight: FontWeight.w800)),
      ],
    );
  }
}
