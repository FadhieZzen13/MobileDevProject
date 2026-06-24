import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../models/facility.dart';
import '../widgets/asset_image_box.dart';

/// Facilities information (Functional Requirement #6).
///
/// Lists faculty facilities (surau, pantry, parking, recycling, labs, …) each
/// with name, location, description and an image or icon.
class FacilityScreen extends StatelessWidget {
  static const route = '/facilities';

  const FacilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final facilities = AppData.instance.facilities;

    return Scaffold(
      appBar: AppBar(title: const Text('Facilities')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: facilities.isEmpty
              ? const Center(child: Text('No facilities listed yet.'))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
                  itemCount: facilities.length,
                  itemBuilder: (context, i) =>
                      _FacilityCard(facility: facilities[i]),
                ),
        ),
      ),
    );
  }
}

class _FacilityCard extends StatelessWidget {
  final Facility facility;
  const _FacilityCard({required this.facility});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final hasImage = facility.image.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasImage)
              AssetImageBox(
                fileName: facility.image,
                width: 64,
                height: 64,
                borderRadius: BorderRadius.circular(12),
              )
            else
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_iconFor(facility.icon),
                    color: cs.onSurfaceVariant, size: 22),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(facility.name,
                      style: text.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(Icons.place_outlined,
                          size: 14, color: cs.primary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(facility.location,
                            style: text.bodySmall
                                ?.copyWith(color: cs.onSurfaceVariant)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(facility.description,
                      style: text.bodyMedium?.copyWith(height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
