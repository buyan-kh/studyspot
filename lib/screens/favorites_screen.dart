import 'package:flutter/material.dart';

import '../data/spot_store.dart';
import '../models/study_spot.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/nest_header.dart';
import '../widgets/spot_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  SpotCategory? _category;

  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    final saved = store.spots.where((spot) => spot.favorite).length;
    final spots = filterSpots(
      store.spots,
      category: _category,
      favoritesOnly: true,
    );

    return Column(
      children: [
        const NestHeader(),
        Expanded(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Favorites',
                        style: nunito(size: 28, weight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your saved study spots, all in one place.',
                        style: nunito(
                          size: 14,
                          weight: FontWeight.w700,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 52,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    children: [
                      SelectChip(
                        label: 'All $saved',
                        selected: _category == null,
                        onTap: () => setState(() => _category = null),
                      ),
                      const SizedBox(width: 8),
                      for (final item in const [
                        (SpotCategory.library, 'Libraries'),
                        (SpotCategory.cafe, 'Cafes'),
                        (SpotCategory.studyRoom, 'Study Rooms'),
                        (SpotCategory.outdoor, 'Outdoors'),
                      ]) ...[
                        SelectChip(
                          label: item.$2,
                          selected: _category == item.$1,
                          onTap: () => setState(() {
                            _category = _category == item.$1 ? null : item.$1;
                          }),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ],
                  ),
                ),
              ),
              if (spots.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 120),
                    child: Text(
                      saved == 0
                          ? 'Save a spot with the heart and it will live here.'
                          : 'No saved spots in this filter.',
                      textAlign: TextAlign.center,
                      style: nunito(
                        weight: FontWeight.w700,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
                  sliver: SliverList.separated(
                    itemCount: spots.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => SpotCard(spot: spots[index]),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
