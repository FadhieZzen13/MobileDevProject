import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../models/green_tip.dart';

/// Green Awareness module (Functional Requirement #8).
///
/// The one screen where green leads the palette. Supports UPM's campus green
/// sustainability initiative via paperless navigation, recycling and
/// energy/water saving tips. This is the project's green-tech integration.
class GreenScreen extends StatelessWidget {
  static const route = '/green';

  const GreenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final tips = AppData.instance.greenTips;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    Text('Sustainability',
                        style: text.bodyMedium
                            ?.copyWith(color: cs.onSecondaryContainer)),
                  ],
                ),
                const SizedBox(height: 2),
                Text('Green campus', style: text.headlineSmall),
                const SizedBox(height: 16),

                // Intro: the core green-tech idea (paperless navigation).
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cs.secondaryContainer,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.eco,
                          size: 28, color: cs.onSecondaryContainer),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'This app promotes a paperless, greener FSKTM by '
                          'replacing printed maps and directories with digital '
                          'navigation.',
                          style: text.bodyMedium?.copyWith(
                              color: cs.onSecondaryContainer, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                if (tips.isEmpty)
                  const Center(child: Text('No green tips added yet.'))
                else
                  ...tips.map((t) => _TipCard(tip: t)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final GreenTip tip;
  const _TipCard({required this.tip});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: cs.secondaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_iconFor(tip.icon),
                  size: 20, color: cs.onSecondaryContainer),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tip.title,
                      style: text.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  Text(tip.description,
                      style: text.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant, height: 1.5)),
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
      case 'recycling':
        return Icons.recycling;
      case 'water':
        return Icons.water_drop_outlined;
      case 'electricity':
        return Icons.bolt;
      case 'paperless':
        return Icons.description_outlined;
      case 'walk':
        return Icons.directions_walk;
      default:
        return Icons.eco;
    }
  }
}
