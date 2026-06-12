import 'package:flutter/material.dart';

import '../models/room.dart';
import '../widgets/asset_image_box.dart';

/// Room / lab details (Functional Requirement #5).
///
/// Displays the room code, type, floor/block location, image and description.
class RoomDetailScreen extends StatelessWidget {
  final Room room;

  const RoomDetailScreen({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(room.code)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AssetImageBox(
            fileName: room.image,
            height: 200,
            placeholderIcon: Icons.meeting_room,
          ),
          const SizedBox(height: 16),
          Text(room.name, style: theme.textTheme.headlineSmall),
          if (room.nameEn.isNotEmpty && room.nameEn != room.name)
            Text(room.nameEn,
                style: theme.textTheme.titleSmall
                    ?.copyWith(color: theme.colorScheme.outline)),
          const SizedBox(height: 16),
          _DetailRow(label: 'Room Code', value: room.code),
          _DetailRow(label: 'Room Type', value: room.type),
          _DetailRow(label: 'Block', value: 'Block ${room.block}'),
          _DetailRow(label: 'Floor', value: room.floor),
          const SizedBox(height: 16),
          Text('Description', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            room.description.isEmpty
                ? 'No description available.'
                : room.description,
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value.isEmpty ? '-' : value)),
        ],
      ),
    );
  }
}
