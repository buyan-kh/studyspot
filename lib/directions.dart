import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/study_spot.dart';

Future<void> openDirections(BuildContext context, StudySpot spot) async {
  final query = Uri.encodeComponent('${spot.name}, San Jose, CA');
  final uri = Uri.parse(
    'https://www.google.com/maps/search/?api=1&query=$query',
  );
  try {
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      _showFailure(context);
    }
  } catch (_) {
    if (context.mounted) _showFailure(context);
  }
}

void _showFailure(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Could not open maps.')),
  );
}
