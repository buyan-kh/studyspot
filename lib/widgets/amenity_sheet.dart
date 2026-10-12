import 'package:flutter/material.dart';

import '../spot_style.dart';
import '../theme.dart';
import 'common.dart';

Future<Set<String>?> showAmenitySheet(
  BuildContext context,
  Set<String> initial,
) {
  return showModalBottomSheet<Set<String>>(
    context: context,
    isScrollControlled: true,
    builder: (context) => AmenitySheet(initial: initial),
  );
}

class AmenitySheet extends StatefulWidget {
  const AmenitySheet({super.key, required this.initial});

  final Set<String> initial;

  @override
  State<AmenitySheet> createState() => _AmenitySheetState();
}

class _AmenitySheetState extends State<AmenitySheet> {
  late Set<String> _selected = {...widget.initial};

  void _toggle(String tag) {
    setState(() {
      if (_selected.contains(tag)) {
        _selected.remove(tag);
      } else {
        _selected.add(tag);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 0.62;
    return SafeArea(
      child: SizedBox(
        height: height,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.line,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Amenities',
                style: nunito(size: 22, weight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                'Show spots that have all of these.',
                style: nunito(
                  size: 13,
                  weight: FontWeight.w600,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final tag in filterAmenities)
                        SelectChip(
                          label: tag,
                          icon: amenityIcon(tag),
                          selected: _selected.contains(tag),
                          onTap: () => _toggle(tag),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      label: 'Clear',
                      onPressed: () => setState(_selected.clear),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: PrimaryButton(
                      label: 'Apply',
                      onPressed: () => Navigator.pop(context, _selected),
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
