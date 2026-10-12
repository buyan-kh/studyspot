import 'package:flutter/material.dart';

import '../models/study_spot.dart';
import '../models/user_profile.dart';
import 'seed_spots.dart';

class SpotStore extends ChangeNotifier {
  SpotStore() : spots = [...seedSpots];

  List<StudySpot> spots;
  UserProfile profile = UserProfile.demo();
  bool signedIn = true;
  int tab = 0;
  int spotsAdded = 3;
  String? pendingMapSpotId;

  void openTab(int index) {
    if (tab == index) return;
    tab = index;
    notifyListeners();
  }

  void toggleFavorite(String id) {
    spots = [
      for (final spot in spots)
        if (spot.id == id) spot.copyWith(favorite: !spot.favorite) else spot,
    ];
    notifyListeners();
  }

  void addSpot(StudySpot spot) {
    spots = [spot, ...spots];
    spotsAdded += 1;
    if (profile.goalDone < profile.goalTotal) {
      profile = profile.copyWith(goalDone: profile.goalDone + 1);
    }
    pendingMapSpotId = spot.id;
    tab = 0;
    notifyListeners();
  }

  String? takePendingSelection() {
    final id = pendingMapSpotId;
    pendingMapSpotId = null;
    return id;
  }

  void updateProfile(UserProfile next) {
    profile = next;
    notifyListeners();
  }

  void setShowLocation(bool value) {
    if (profile.showLocation == value) return;
    profile = profile.copyWith(showLocation: value);
    notifyListeners();
  }

  void signOut() {
    signedIn = false;
    notifyListeners();
  }

  void signIn() {
    signedIn = true;
    tab = 0;
    notifyListeners();
  }

  int get savedCount => spots.where((spot) => spot.favorite).length;
}

class StoreScope extends InheritedNotifier<SpotStore> {
  const StoreScope({
    super.key,
    required SpotStore store,
    required super.child,
  }) : super(notifier: store);

  static SpotStore of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<StoreScope>();
    assert(scope != null, 'StoreScope not found');
    return scope!.notifier!;
  }
}

List<StudySpot> filterSpots(
  List<StudySpot> spots, {
  SpotCategory? category,
  Set<String> amenities = const {},
  String query = '',
  bool favoritesOnly = false,
}) {
  final needle = query.trim().toLowerCase();
  final matched = spots.where((spot) {
    if (favoritesOnly && !spot.favorite) return false;
    if (category != null && spot.category != category) return false;
    for (final amenity in amenities) {
      if (!spotHasTag(spot, amenity)) return false;
    }
    if (needle.isEmpty) return true;
    final haystack = [
      spot.name,
      spot.area,
      spot.note,
      categoryLabel(spot.category),
      ...spot.tags,
    ].join(' ').toLowerCase();
    return haystack.contains(needle);
  }).toList();

  if (!favoritesOnly) {
    matched.sort((a, b) {
      final byDistance = a.distanceMiles.compareTo(b.distanceMiles);
      if (byDistance != 0) return byDistance;
      return a.name.compareTo(b.name);
    });
  }
  return matched;
}
