import 'dart:typed_data';

enum SpotCategory { cafe, library, studyRoom, lounge, outdoor, other }

enum SeatStatus { open, almostFull, full, unknown }

enum SafetyFeel { feelsSafe, neutral, notSafe }

class StudySpot {
  const StudySpot({
    required this.id,
    required this.name,
    required this.area,
    required this.distanceMiles,
    required this.status,
    required this.category,
    required this.tags,
    required this.note,
    required this.mapX,
    required this.mapY,
    this.assetImage,
    this.seats,
    this.waitlist = false,
    this.favorite = false,
    this.isPrivate = false,
    this.safety,
    this.photos = const [],
  });

  final String id;
  final String name;
  final String area;
  final double distanceMiles;
  final SeatStatus status;
  final SpotCategory category;
  final List<String> tags;
  final String note;
  final double mapX;
  final double mapY;
  final String? assetImage;
  final int? seats;
  final bool waitlist;
  final bool favorite;
  final bool isPrivate;
  final SafetyFeel? safety;
  final List<Uint8List> photos;

  StudySpot copyWith({bool? favorite}) {
    return StudySpot(
      id: id,
      name: name,
      area: area,
      distanceMiles: distanceMiles,
      status: status,
      category: category,
      tags: tags,
      note: note,
      mapX: mapX,
      mapY: mapY,
      assetImage: assetImage,
      seats: seats,
      waitlist: waitlist,
      favorite: favorite ?? this.favorite,
      isPrivate: isPrivate,
      safety: safety,
      photos: photos,
    );
  }
}

String categoryLabel(SpotCategory category) {
  return switch (category) {
    SpotCategory.cafe => 'Cafe',
    SpotCategory.library => 'Library',
    SpotCategory.studyRoom => 'Study Room',
    SpotCategory.lounge => 'Lounge',
    SpotCategory.outdoor => 'Outdoor',
    SpotCategory.other => 'Other',
  };
}

String statusLabel(StudySpot spot) {
  final name = switch (spot.status) {
    SeatStatus.open => 'Open',
    SeatStatus.almostFull => 'Almost Full',
    SeatStatus.full => 'Full',
    SeatStatus.unknown => 'Unknown',
  };
  if (spot.waitlist) return '$name · Waitlist';
  if (spot.seats != null) return '$name · ${spot.seats} seats';
  return name;
}

String formatMiles(double miles) => '${miles.toStringAsFixed(1)} mi';

String? noiseLabel(StudySpot spot) {
  const order = ['Busy', 'Moderate Noise', 'Quiet'];
  for (final tag in order) {
    if (spot.tags.contains(tag)) return tag;
  }
  return null;
}

String safetyLabel(SafetyFeel safety) {
  return switch (safety) {
    SafetyFeel.feelsSafe => 'Feels safe',
    SafetyFeel.neutral => 'Neutral',
    SafetyFeel.notSafe => 'Not safe',
  };
}

bool spotHasTag(StudySpot spot, String tag) {
  final needle = tag.toLowerCase();
  return spot.tags.any((item) => item.toLowerCase() == needle);
}
