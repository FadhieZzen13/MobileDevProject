import 'package:flutter/material.dart';

import '../models/room.dart';
import '../screens/room_detail_screen.dart';

/// A tappable row summarising a [Room]; opens [RoomDetailScreen] when tapped.
///
/// Uses the Malay name as the title with the room code + type as the subtitle,
/// matching the design blueprint's room-row component.
class RoomCard extends StatelessWidget {
  final Room room;

  const RoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RoomDetailScreen(room: room)),
        ),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_iconForType(room.type),
                    size: 20, color: cs.onPrimaryContainer),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.nameEn.isNotEmpty
                          ? room.nameEn
                          : (room.name.isEmpty ? room.code : room.name),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                        room.name.isNotEmpty && room.name != room.nameEn
                            ? '${room.name} · ${room.code}'
                            : '${room.code} · ${room.type}',
                        style: text.bodySmall
                            ?.copyWith(color: cs.onSurfaceVariant)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: cs.outline),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForType(String type) {
    final t = type.toLowerCase();
    if (t.contains('lab')) return Icons.computer;
    if (t.contains('lecture')) return Icons.co_present;
    if (t.contains('office') || t.contains('dean')) return Icons.badge;
    if (t.contains('surau')) return Icons.mosque;
    if (t.contains('meeting') || t.contains('discussion')) return Icons.groups;
    if (t.contains('storage') || t.contains('store')) return Icons.inventory_2;
    return Icons.meeting_room;
  }
}
