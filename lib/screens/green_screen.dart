import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../models/green_tip.dart';

/// Green Awareness module (Functional Requirement #8).
///
/// Supports UPM's campus green sustainability initiative by presenting simple
/// tips on recycling, saving water/electricity and paperless navigation.
/// This is the project's green-technology integration element.
class GreenScreen extends StatelessWidget {
  static const route = '/green';

  const GreenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tips = AppData.instance.greenTips;

    return Scaffold(
      appBar: AppBar(title: const Text('Green Awareness')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: theme.colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.eco, size: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'This app promotes a paperless, greener FSKTM by replacing '
                      'printed maps and directories with digital navigation.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (tips.isEmpty)
            const Center(child: Text('No green tips added yet.'))
          else
            ...tips.map((t) => _TipCard(tip: t)),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final GreenTip tip;
  const _TipCard({required this.tip});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(child: Icon(_iconFor(tip.icon))),
        title: Text(tip.title),
        subtitle: Text(tip.description),
        isThreeLine: true,
      ),
    );
  }

  IconData _iconFor(String name) {
    switch (name) {
      case 'recycling':
        return Icons.recycling;
      case 'water':
        return Icons.water_drop;
      case 'electricity':
        return Icons.bolt;
      case 'paperless':
        return Icons.description;
      case 'walk':
        return Icons.directions_walk;
      default:
        return Icons.eco;
    }
  }
}
