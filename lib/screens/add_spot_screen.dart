import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../data/spot_store.dart';
import '../models/study_spot.dart';
import '../spot_style.dart';
import '../theme.dart';
import '../widgets/campus_map.dart';
import '../widgets/common.dart';
import '../widgets/nest_header.dart';

class AddSpotScreen extends StatefulWidget {
  const AddSpotScreen({super.key});

  @override
  State<AddSpotScreen> createState() => _AddSpotScreenState();
}

class _AddSpotScreenState extends State<AddSpotScreen> {
  final _name = TextEditingController();
  final _location = TextEditingController();
  final _notes = TextEditingController();
  ImagePicker? _picker;

  SpotCategory? _category;
  SafetyFeel? _safety;
  final Set<String> _amenities = {};
  final List<Uint8List> _photos = [];
  Offset? _pinFraction;
  String? _nameError;
  String? _locationError;
  String? _categoryError;

  @override
  void dispose() {
    _name.dispose();
    _location.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pinOnMap() async {
    final pin = await Navigator.of(context).push<Offset>(
      MaterialPageRoute(builder: (_) => const MapPinScreen()),
    );
    if (pin == null || !mounted) return;
    setState(() {
      _pinFraction = pin;
      if (_location.text.trim().isEmpty) {
        _location.text = 'Pinned on campus map';
      }
      _locationError = null;
    });
  }

  Future<void> _addPhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Photo library'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;
    try {
      final file = await (_picker ??= ImagePicker()).pickImage(
        source: source,
        maxWidth: 1600,
        imageQuality: 75,
      );
      if (file == null || !mounted) return;
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      setState(() => _photos.add(bytes));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open that photo.')),
      );
    }
  }

  void _submit() {
    final name = _name.text.trim();
    final location = _location.text.trim();
    setState(() {
      _nameError = name.isEmpty ? 'Add a spot name.' : null;
      _locationError = location.isEmpty ? 'Add a location or drop a pin.' : null;
      _categoryError = _category == null ? 'Choose a category.' : null;
    });
    if (name.isEmpty || location.isEmpty || _category == null) return;

    final store = StoreScope.of(context);
    final x = _pinFraction?.dx ?? (0.2 + _unit(name) * 0.6);
    final y = _pinFraction?.dy ?? (0.22 + _unit('$name-y') * 0.55);
    final spot = StudySpot(
      id: 'user-${DateTime.now().microsecondsSinceEpoch}',
      name: name,
      area: location,
      distanceMiles: _miles(x, y),
      status: SeatStatus.unknown,
      category: _category!,
      tags: _amenities.toList(),
      note: _notes.text.trim(),
      mapX: x.clamp(0.08, 0.92),
      mapY: y.clamp(0.08, 0.92),
      isPrivate: !store.profile.shareSpots,
      safety: _safety,
      photos: [..._photos],
    );

    _name.clear();
    _location.clear();
    _notes.clear();
    setState(() {
      _category = null;
      _safety = null;
      _amenities.clear();
      _photos.clear();
      _pinFraction = null;
      _nameError = null;
      _locationError = null;
      _categoryError = null;
    });
    store.addSpot(spot);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added $name')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const NestHeader(),
        Expanded(
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add a Study Spot',
                          style: nunito(size: 28, weight: FontWeight.w800, height: 1.05),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Share a new spot with the StudyNest community!',
                          style: nunito(
                            size: 13,
                            weight: FontWeight.w700,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const FieldLabel('Spot Name'),
              AppTextField(
                controller: _name,
                hint: 'e.g. Dr. Martin Luther King Jr. Library',
                error: _nameError,
                textCapitalization: TextCapitalization.words,
                onChanged: (_) {
                  if (_nameError != null) setState(() => _nameError = null);
                },
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Expanded(child: FieldLabel('Location')),
                  TextButton.icon(
                    onPressed: _pinOnMap,
                    icon: const Icon(Icons.push_pin_rounded, size: 16),
                    label: Text(_pinFraction == null ? 'Pin on Map' : 'Pinned'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF2E9D6A),
                      backgroundColor: const Color(0xFFE7F8EE),
                      visualDensity: VisualDensity.compact,
                      shape: const StadiumBorder(),
                    ),
                  ),
                ],
              ),
              AppTextField(
                controller: _location,
                hint: 'Search address or drop a pin',
                error: _locationError,
                onChanged: (_) {
                  if (_locationError != null) {
                    setState(() => _locationError = null);
                  }
                },
              ),
              if (_pinFraction != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 2),
                  child: Text(
                    'Pin saved on the campus map',
                    style: nunito(
                      size: 12,
                      weight: FontWeight.w800,
                      color: const Color(0xFF2E9D6A),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              const FieldLabel('Category'),
              Row(
                children: [
                  for (final category in SpotCategory.values)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: _ChoiceTile(
                          label: categoryLabel(category),
                          icon: categoryIcon(category),
                          selected: _category == category,
                          onTap: () => setState(() {
                            _category = category;
                            _categoryError = null;
                          }),
                        ),
                      ),
                    ),
                ],
              ),
              if (_categoryError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 2),
                  child: Text(
                    _categoryError!,
                    style: nunito(
                      size: 12,
                      weight: FontWeight.w700,
                      color: AppColors.coralDeep,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              const FieldLabel('Add Photos'),
              SizedBox(
                height: 86,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    if (_photos.length < 3)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: _addPhoto,
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: 84,
                            height: 84,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.line),
                            ),
                            child: const Icon(
                              Icons.add_a_photo_outlined,
                              color: AppColors.muted,
                            ),
                          ),
                        ),
                      ),
                    for (var i = 0; i < _photos.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.memory(
                                _photos[i],
                                width: 84,
                                height: 84,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => setState(() => _photos.removeAt(i)),
                                child: const DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.close_rounded, size: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const FieldLabel('Amenities (select all that apply)'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final tag in addAmenities)
                    SelectChip(
                      label: tag,
                      icon: amenityIcon(tag),
                      selected: _amenities.contains(tag),
                      onTap: () => setState(() {
                        if (!_amenities.add(tag)) _amenities.remove(tag);
                      }),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              const FieldLabel('Safety'),
              Row(
                children: [
                  for (final safety in SafetyFeel.values)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: _ChoiceTile(
                          label: safetyLabel(safety),
                          icon: switch (safety) {
                            SafetyFeel.feelsSafe => Icons.verified_user_rounded,
                            SafetyFeel.neutral => Icons.horizontal_rule_rounded,
                            SafetyFeel.notSafe => Icons.report_rounded,
                          },
                          selected: _safety == safety,
                          color: switch (safety) {
                            SafetyFeel.feelsSafe => AppColors.green,
                            SafetyFeel.neutral => AppColors.muted,
                            SafetyFeel.notSafe => AppColors.red,
                          },
                          onTap: () => setState(() {
                            _safety = _safety == safety ? null : safety;
                          }),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              const FieldLabel('Notes (optional)'),
              AppTextField(
                controller: _notes,
                hint: 'Anything helpful (best times, environment, tips...)',
                maxLines: 4,
                maxLength: 300,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 108),
          child: PrimaryButton(
            label: 'Add Spot',
            icon: Icons.place_rounded,
            onPressed: _submit,
          ),
        ),
      ],
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.color = AppColors.coral,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? color.withValues(alpha: 0.12) : Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: selected ? color : AppColors.line),
          ),
          child: Column(
            children: [
              Icon(icon, size: 20, color: selected ? color : AppColors.navy),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: nunito(
                  size: 10,
                  weight: FontWeight.w800,
                  height: 1.05,
                  color: selected ? color : AppColors.navy,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MapPinScreen extends StatelessWidget {
  const MapPinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _MapPinBody();
  }
}

class _MapPinBody extends StatefulWidget {
  const _MapPinBody();

  @override
  State<_MapPinBody> createState() => _MapPinBodyState();
}

class _MapPinBodyState extends State<_MapPinBody> {
  Offset? _pin;

  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const PageHeader(
            title: 'Pin on Map',
            subtitle: 'Tap the campus map to drop a pin.',
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CampusMap(
                spots: store.spots,
                draftFraction: _pin,
                showUser: store.profile.showLocation,
                onMapTap: (x, y) => setState(() => _pin = Offset(x, y)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: PrimaryButton(
              label: 'Use this pin',
              icon: Icons.push_pin_rounded,
              onPressed: _pin == null
                  ? null
                  : () => Navigator.pop(context, _pin),
            ),
          ),
        ],
      ),
    );
  }
}

double _unit(String seed) {
  var hash = 17;
  for (final unit in seed.codeUnits) {
    hash = (hash * 33 + unit) & 0x7fffffff;
  }
  return (hash % 1000) / 1000;
}

double _miles(double x, double y) {
  final dx = x - 0.50;
  final dy = y - 0.52;
  final miles = math.sqrt(dx * dx + dy * dy) * 1.6;
  final rounded = (miles * 10).round() / 10;
  return rounded < 0.1 ? 0.1 : rounded;
}
