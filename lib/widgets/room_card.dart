import 'package:flutter/material.dart';

import '../models/room.dart';
import '../screens/room_detail_screen.dart';

/// A tappable card summarising a [Room]; opens [RoomDetailScreen] when tapped.
class RoomCard extends StatelessWidget {
  final Room room;

  const RoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(_iconForType(room.type)),
        ),
        title: Text(room.code),
        subtitle: Text('${room.type} • Block ${room.block}, ${room.floor}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RoomDetailScreen(room: room)),
        ),
      ),
    );
  }

  IconData _iconForType(String type) {
    final t = type.toLowerCase();
    if (t.contains('lab')) return Icons.computer;
    if (t.contains('lecturer')) return Icons.person;
    if (t.contains('meeting') || t.contains('discussion')) return Icons.groups;
    return Icons.meeting_room;
  }
}
