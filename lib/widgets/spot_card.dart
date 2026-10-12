import 'package:flutter/material.dart';

import '../data/spot_store.dart';
import '../directions.dart';
import '../models/study_spot.dart';
import '../open_spot.dart';
import '../theme.dart';
import 'common.dart';
import 'spot_image.dart';

class SpotCard extends StatelessWidget {
  const SpotCard({super.key, required this.spot});

  final StudySpot spot;

  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => openSpotDetail(context, spot.id),
        child: Ink(
          decoration: cardDecoration(),
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 96,
                height: 104,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SpotImage(spot: spot),
                      ),
                    ),
                    Positioned(
                      left: 4,
                      right: 4,
                      bottom: 4,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: StatusBadge(spot: spot),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            spot.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: nunito(
                              size: 15,
                              weight: FontWeight.w800,
                              height: 1.15,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formatMiles(spot.distanceMiles),
                          style: nunito(
                            size: 12,
                            weight: FontWeight.w700,
                            color: AppColors.muted,
                          ),
                        ),
                        _HeartButton(spot: spot),
                      ],
                    ),
                    Text(
                      spot.area,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: nunito(
                        size: 12,
                        weight: FontWeight.w700,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TagWrap(tags: spot.tags, max: 4),
                    if (spot.note.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        spot.note,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: nunito(
                          size: 12,
                          weight: FontWeight.w600,
                          color: AppColors.muted,
                          height: 1.25,
                        ),
                      ),
                    ],
                    if (spot.isPrivate)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          'Only you',
                          style: nunito(
                            size: 11,
                            weight: FontWeight.w800,
                            color: AppColors.coralDeep,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.more_horiz_rounded,
                  color: AppColors.muted,
                ),
                onSelected: (value) {
                  if (value == 'details') {
                    openSpotDetail(context, spot.id);
                  } else if (value == 'favorite') {
                    store.toggleFavorite(spot.id);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'details',
                    child: Text('View details'),
                  ),
                  PopupMenuItem(
                    value: 'favorite',
                    child: Text(
                      spot.favorite
                          ? 'Remove from favorites'
                          : 'Save to favorites',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeartButton extends StatelessWidget {
  const _HeartButton({required this.spot});

  final StudySpot spot;

  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    return IconButton(
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      tooltip: spot.favorite ? 'Remove from favorites' : 'Save to favorites',
      onPressed: () => store.toggleFavorite(spot.id),
      icon: Icon(
        spot.favorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        color: spot.favorite ? AppColors.coral : AppColors.muted,
        size: 20,
      ),
    );
  }
}

class SpotPreviewCard extends StatelessWidget {
  const SpotPreviewCard({super.key, required this.spot});

  final StudySpot spot;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: cardDecoration(radius: 22),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: 74,
                  height: 74,
                  child: SpotImage(spot: spot),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            spot.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: nunito(
                              size: 15,
                              weight: FontWeight.w800,
                              height: 1.15,
                            ),
                          ),
                        ),
                        Text(
                          formatMiles(spot.distanceMiles),
                          style: nunito(
                            size: 12,
                            weight: FontWeight.w700,
                            color: AppColors.muted,
                          ),
                        ),
                        _HeartButton(spot: spot),
                      ],
                    ),
                    const SizedBox(height: 4),
                    TagWrap(tags: spot.tags, max: 3),
                    const SizedBox(height: 6),
                    StatusBadge(spot: spot),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  compact: true,
                  label: 'View Details',
                  onPressed: () => openSpotDetail(context, spot.id),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SecondaryButton(
                  compact: true,
                  label: 'Get Directions',
                  icon: Icons.near_me_rounded,
                  onPressed: () => openDirections(context, spot),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
