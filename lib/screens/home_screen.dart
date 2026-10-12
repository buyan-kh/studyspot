import 'package:flutter/material.dart';

import '../data/spot_store.dart';
import '../models/study_spot.dart';
import '../theme.dart';
import '../widgets/amenity_sheet.dart';
import '../widgets/campus_map.dart';
import '../widgets/common.dart';
import '../widgets/nest_header.dart';
import '../widgets/spot_card.dart';
import 'profile_pages.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _search = TextEditingController();
  SpotCategory? _category;
  Set<String> _amenities = {};

  @override
  void initState() {
    super.initState();
    _search.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _openAmenities() async {
    final next = await showAmenitySheet(context, _amenities);
    if (next != null) setState(() => _amenities = next);
  }

  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    final spots = filterSpots(
      store.spots,
      category: _category,
      amenities: _amenities,
      query: _search.text,
    );

    return Column(
      children: [
        NestHeader(
          trailing: IconButton(
            tooltip: 'Notifications',
            onPressed: () => openNotifications(context),
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.navy,
            ),
          ),
        ),
        Expanded(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                  child: TextField(
                    controller: _search,
                    style: nunito(size: 15, weight: FontWeight.w700),
                    decoration: InputDecoration(
                      hintText: 'Search for a library, cafe, or study spot...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: IconButton(
                        tooltip: 'Filters',
                        onPressed: _openAmenities,
                        icon: Icon(
                          Icons.tune_rounded,
                          color: _amenities.isEmpty
                              ? AppColors.muted
                              : AppColors.coral,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 92,
                  child: Row(
                    children: [
                      for (final item in _homeCategories)
                        Expanded(
                          child: _CategoryButton(
                            label: item.label,
                            icon: item.icon,
                            color: item.color,
                            selected: item.category != null
                                ? _category == item.category
                                : _amenities.isNotEmpty,
                            onTap: () {
                              if (item.category == null) {
                                _openAmenities();
                                return;
                              }
                              setState(() {
                                _category = _category == item.category
                                    ? null
                                    : item.category;
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  child: SizedBox(
                    height: 210,
                    child: CampusMap(
                      spots: spots,
                      compact: true,
                      showUser: store.profile.showLocation,
                      onOpen: () => store.openTab(1),
                      onUseLocation: () {
                        store.setShowLocation(true);
                        store.openTab(1);
                      },
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 8, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Nearby Study Spots',
                          style: nunito(size: 20, weight: FontWeight.w800),
                        ),
                      ),
                      TextButton(
                        onPressed: () => store.openTab(1),
                        child: Text(
                          'See All',
                          style: nunito(
                            size: 14,
                            weight: FontWeight.w800,
                            color: AppColors.coral,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (spots.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 120),
                    child: Text(
                      'No spots match that search.',
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
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                  sliver: SliverList.separated(
                    itemCount: spots.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) =>
                        SpotCard(spot: spots[index]),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HomeCategory {
  const _HomeCategory({
    required this.label,
    required this.icon,
    required this.color,
    this.category,
  });

  final String label;
  final IconData icon;
  final Color color;
  final SpotCategory? category;
}

const _homeCategories = [
  _HomeCategory(
    label: 'Cafes',
    icon: Icons.coffee_rounded,
    color: Color(0xFFFFE4D6),
    category: SpotCategory.cafe,
  ),
  _HomeCategory(
    label: 'Libraries',
    icon: Icons.local_library_rounded,
    color: Color(0xFFE4EEFF),
    category: SpotCategory.library,
  ),
  _HomeCategory(
    label: 'Lounges',
    icon: Icons.weekend_rounded,
    color: Color(0xFFF3E6FF),
    category: SpotCategory.lounge,
  ),
  _HomeCategory(
    label: 'Study Rooms',
    icon: Icons.menu_book_rounded,
    color: Color(0xFFE5F8EE),
    category: SpotCategory.studyRoom,
  ),
  _HomeCategory(
    label: 'Outdoors',
    icon: Icons.park_rounded,
    color: Color(0xFFE7F6D8),
    category: SpotCategory.outdoor,
  ),
  _HomeCategory(
    label: 'More',
    icon: Icons.more_horiz_rounded,
    color: Color(0xFFF4F0EC),
  ),
];

class _CategoryButton extends StatelessWidget {
  const _CategoryButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
        child: Column(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.coral : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Icon(icon, color: AppColors.navy, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: nunito(
                size: 10,
                weight: FontWeight.w800,
                height: 1.05,
                color: selected ? AppColors.coral : AppColors.navy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
