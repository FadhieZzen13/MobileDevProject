import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../widgets/asset_image_box.dart';
import '../widgets/room_card.dart';

/// Floor information (Functional Requirement #4).
///
/// Shows a simple floor map image and the list of rooms/labs/facilities on the
/// given [floor] of [block] using [RoomCard] (ListView).
class FloorScreen extends StatelessWidget {
  final String block;
  final String floor;

  const FloorScreen({super.key, required this.block, required this.floor});

  @override
  Widget build(BuildContext context) {
    final rooms = AppData.instance.roomsForFloor(block, floor);
    // Convention: floor map images are named like "block_a_ground.png".
    final mapName =
        'block_${block.toLowerCase()}_${floor.toLowerCase().replaceAll(' ', '_')}.png';

    return Scaffold(
      appBar: AppBar(title: Text('Block $block • $floor')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AssetImageBox(
            fileName: mapName,
            height: 160,
            placeholderIcon: Icons.map_outlined,
          ),
          const SizedBox(height: 16),
          if (rooms.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: Text('No rooms listed for this floor yet.')),
            )
          else
            ...rooms.map((r) => RoomCard(room: r)),
        ],
      ),
    );
  }
}
