import 'package:flutter/material.dart';

import 'models/study_spot.dart';
import 'theme.dart';

const quickAmenities = ['Wi-Fi', 'Outlets', 'Computers', 'Food', 'Quiet'];

const addAmenities = [
  'Wi-Fi',
  'Outlets',
  'Computers',
  'TV / Monitors',
  'Food',
  'Desks',
  'Quiet',
  'Moderate Noise',
  'Busy',
  'Outdoor Seating',
];

const filterAmenities = [
  ...addAmenities,
  'Whiteboards',
  'Group Friendly',
  'Great Coffee',
  'Good Weather',
  'Outdoor',
];

IconData categoryIcon(SpotCategory category) {
  return switch (category) {
    SpotCategory.cafe => Icons.coffee_rounded,
    SpotCategory.library => Icons.local_library_rounded,
    SpotCategory.studyRoom => Icons.menu_book_rounded,
    SpotCategory.lounge => Icons.weekend_rounded,
    SpotCategory.outdoor => Icons.park_rounded,
    SpotCategory.other => Icons.more_horiz_rounded,
  };
}

Color categoryTint(SpotCategory category) {
  return switch (category) {
    SpotCategory.cafe => const Color(0xFFFFE4D6),
    SpotCategory.library => const Color(0xFFE4EEFF),
    SpotCategory.studyRoom => const Color(0xFFE5F8EE),
    SpotCategory.lounge => const Color(0xFFF3E6FF),
    SpotCategory.outdoor => const Color(0xFFE7F6D8),
    SpotCategory.other => const Color(0xFFF4F0EC),
  };
}

Color statusColor(SeatStatus status) {
  return switch (status) {
    SeatStatus.open => AppColors.green,
    SeatStatus.almostFull => AppColors.orange,
    SeatStatus.full => AppColors.red,
    SeatStatus.unknown => AppColors.yellow,
  };
}

Color statusBackground(SeatStatus status) {
  return switch (status) {
    SeatStatus.open => const Color(0xFFE5F8EE),
    SeatStatus.almostFull => const Color(0xFFFFF3D8),
    SeatStatus.full => const Color(0xFFFFE8EC),
    SeatStatus.unknown => const Color(0xFFFFF6D8),
  };
}

Color statusForeground(SeatStatus status) {
  return switch (status) {
    SeatStatus.open => const Color(0xFF1F9D5A),
    SeatStatus.almostFull => const Color(0xFFC47D00),
    SeatStatus.full => const Color(0xFFE14B5A),
    SeatStatus.unknown => const Color(0xFFA07D00),
  };
}

IconData amenityIcon(String tag) {
  switch (tag) {
    case 'Wi-Fi':
      return Icons.wifi_rounded;
    case 'Outlets':
      return Icons.power_rounded;
    case 'Computers':
      return Icons.computer_rounded;
    case 'TV / Monitors':
      return Icons.tv_rounded;
    case 'Food':
      return Icons.restaurant_rounded;
    case 'Desks':
      return Icons.event_seat_rounded;
    case 'Quiet':
      return Icons.volume_off_rounded;
    case 'Moderate Noise':
      return Icons.graphic_eq_rounded;
    case 'Busy':
      return Icons.volume_up_rounded;
    case 'Outdoor Seating':
    case 'Outdoor':
      return Icons.deck_rounded;
    case 'Whiteboards':
      return Icons.draw_rounded;
    case 'Group Friendly':
      return Icons.groups_rounded;
    case 'Great Coffee':
      return Icons.coffee_rounded;
    case 'Good Weather':
      return Icons.wb_sunny_rounded;
    default:
      return Icons.label_rounded;
  }
}

Color tagBackground(String tag) {
  final value = tag.toLowerCase();
  if (value.contains('wi-fi') || value.contains('wifi')) {
    return const Color(0xFFE7F0FF);
  }
  if (value.contains('quiet')) return const Color(0xFFE5F8EE);
  if (value.contains('outlet')) return const Color(0xFFFFF4D8);
  if (value.contains('computer') || value.contains('whiteboard')) {
    return const Color(0xFFF0E9FF);
  }
  if (value.contains('food') || value.contains('coffee')) {
    return const Color(0xFFFFE8D6);
  }
  if (value.contains('noise') || value.contains('busy')) {
    return const Color(0xFFFFE8EE);
  }
  if (value.contains('outdoor') || value.contains('weather')) {
    return const Color(0xFFE5F6E8);
  }
  if (value.contains('group')) return const Color(0xFFEAF0FF);
  return AppColors.chip;
}
