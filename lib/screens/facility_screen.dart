import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../models/facility.dart';
import '../widgets/asset_image_box.dart';

/// Facilities information (Functional Requirement #6).
///
/// Lists faculty facilities (labs, lecturer rooms, surau, pantry, parking,
/// recycling corner, …) each with name, location, description and image/icon.
class FacilityScreen extends StatelessWidget {
  static const route = '/facilities';

  const FacilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final facilities = AppData.instance.facilities;

    return Scaffold(
      appBar: AppBar(title: const Text('Facilities')),
      body: facilities.isEmpty
          ? const Center(child: Text('No facilities listed yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: facilities.length,
              itemBuilder: (context, i) =>
                  _FacilityCard(facility: facilities[i]),
            ),
    );
  }
}

class _FacilityCard extends StatelessWidget {
  final Facility facility;
  const _FacilityCard({required this.facility});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AssetImageBox(
              fileName: facility.image,
              height: 72,
              width: 72,
              placeholderIcon: _iconFor(facility.icon),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(facility.name, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.place, size: 16),
                      const SizedBox(width: 4),
                      Expanded(child: Text(facility.location)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(facility.description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Maps a small set of icon names from JSON to Material icons.
  IconData _iconFor(String name) {
    switch (name) {
      case 'local_parking':
        return Icons.local_parking;
      case 'recycling':
        return Icons.recycling;
      case 'restaurant':
        return Icons.restaurant;
      case 'mosque':
        return Icons.mosque;
      case 'computer':
        return Icons.computer;
      default:
        return Icons.apartment;
    }
  }
}
