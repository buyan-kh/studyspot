import 'package:flutter/material.dart';

import 'screens/spot_detail_screen.dart';

void openSpotDetail(BuildContext context, String spotId) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => SpotDetailScreen(spotId: spotId),
    ),
  );
}
