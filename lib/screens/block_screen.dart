import 'package:flutter/material.dart';

import '../data/app_data.dart';
import 'floor_screen.dart';

/// Block navigation (Functional Requirement #3).
///
/// Lists the floors available in the selected [block]. Tapping a floor opens
/// the [FloorScreen] for that floor.
class BlockScreen extends StatelessWidget {
  final String block;

  const BlockScreen({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    final floors = AppData.instance.floorsForBlock(block);

    return Scaffold(
      appBar: AppBar(title: Text('Block $block')),
      body: floors.isEmpty
          ? const Center(child: Text('No floor data for this block yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: floors.length,
              itemBuilder: (context, i) {
                final floor = floors[i];
                final roomCount =
                    AppData.instance.roomsForFloor(block, floor).length;
                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.layers)),
                    title: Text(floor),
                    subtitle: Text('$roomCount room(s)'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FloorScreen(block: block, floor: floor),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
