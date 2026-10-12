import 'package:flutter/material.dart';

import '../data/spot_store.dart';
import '../models/study_spot.dart';
import '../spot_style.dart';
import '../theme.dart';
import '../widgets/amenity_sheet.dart';
import '../widgets/campus_map.dart';
import '../widgets/common.dart';
import '../widgets/nest_header.dart';
import '../widgets/spot_card.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _search = TextEditingController();
  SpotCategory? _category;
  Set<String> _amenities = {};
  String? _selectedId = 'mlk';
  String? _appliedPending;

  @override
  void initState() {
    super.initState();
    _search.addListener(() => setState(() {}));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final pending = StoreScope.of(context).takePendingSelection();
    if (pending != null && pending != _appliedPending) {
      _appliedPending = pending;
      _selectedId = pending;
    }
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

  void _toggleAmenity(String tag) {
    setState(() {
      final next = {..._amenities};
      if (!next.add(tag)) next.remove(tag);
      _amenities = next;
    });
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
    StudySpot? selected;
    for (final spot in spots) {
      if (spot.id == _selectedId) {
        selected = spot;
        break;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 96),
      child: Column(
        children: [
          const NestHeader(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _search,
              style: nunito(size: 15, weight: FontWeight.w700),
              decoration: InputDecoration(
                hintText: 'Search this area',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: IconButton(
                  tooltip: 'Filters',
                  onPressed: _openAmenities,
                  icon: Icon(
                    Icons.tune_rounded,
                    color: _amenities.isEmpty ? AppColors.muted : AppColors.coral,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                SelectChip(
                  label: 'All',
                  selected: _category == null,
                  onTap: () => setState(() => _category = null),
                ),
                const SizedBox(width: 8),
                for (final category in const [
                  SpotCategory.library,
                  SpotCategory.cafe,
                  SpotCategory.studyRoom,
                  SpotCategory.outdoor,
                ]) ...[
                  SelectChip(
                    label: category == SpotCategory.library
                        ? 'Libraries'
                        : category == SpotCategory.cafe
                        ? 'Cafes'
                        : category == SpotCategory.studyRoom
                        ? 'Study Rooms'
                        : 'Outdoors',
                    selected: _category == category,
                    onTap: () => setState(() {
                      _category = _category == category ? null : category;
                    }),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                for (final tag in quickAmenities) ...[
                  SelectChip(
                    label: tag,
                    icon: amenityIcon(tag),
                    selected: _amenities.contains(tag),
                    onTap: () => _toggleAmenity(tag),
                  ),
                  const SizedBox(width: 8),
                ],
                SelectChip(
                  label: 'More',
                  selected: _amenities.any((tag) => !quickAmenities.contains(tag)),
                  onTap: _openAmenities,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CampusMap(
                spots: spots,
                selectedId: selected?.id,
                showLegend: true,
                showUser: store.profile.showLocation,
                onSelect: (spot) => setState(() => _selectedId = spot.id),
                onBackgroundTap: () => setState(() => _selectedId = null),
                onUseLocation: () => store.setShowLocation(true),
              ),
            ),
          ),
          if (selected != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: SpotPreviewCard(spot: selected),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
              child: Text(
                'Tap a pin to see a study spot.',
                style: nunito(weight: FontWeight.w700, color: AppColors.muted),
              ),
            ),
        ],
      ),
    );
  }
}
