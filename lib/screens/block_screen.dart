import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../widgets/floor_map.dart';
import '../widgets/room_card.dart';

/// Block navigation + floor information (Functional Requirements #3 and #4).
///
/// Shows a segmented floor selector for the chosen [block]; selecting a floor
/// reveals its map image and the list of rooms on that floor. [initialFloor]
/// lets other screens (e.g. room detail) open straight to a given floor.
class BlockScreen extends StatefulWidget {
  final String block;
  final String? initialFloor;

  const BlockScreen({super.key, required this.block, this.initialFloor});

  @override
  State<BlockScreen> createState() => _BlockScreenState();
}

class _BlockScreenState extends State<BlockScreen> {
  late List<String> _floors;
  late int _selected;

  @override
  void initState() {
    super.initState();
    _floors = AppData.instance.floorsForBlock(widget.block);
    final idx = widget.initialFloor == null
        ? 0
        : _floors.indexOf(widget.initialFloor!);
    _selected = idx < 0 ? 0 : idx;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    if (_floors.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Block ${widget.block}')),
        body: const Center(child: Text('No floor data for this block yet.')),
      );
    }

    final floor = _floors[_selected];
    final rooms = AppData.instance.roomsForFloor(widget.block, floor);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            Text('Block ${widget.block}',
                                style: text.bodyMedium
                                    ?.copyWith(color: cs.onSurfaceVariant)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text('Floors', style: text.headlineSmall),
                        const SizedBox(height: 14),
                        _FloorSegments(
                          floors: _floors,
                          selected: _selected,
                          onSelect: (i) => setState(() => _selected = i),
                        ),
                        const SizedBox(height: 14),
                        FloorMapView(block: widget.block, floor: floor),
                        const SizedBox(height: 14),
                      ],
                    ),
                  ),
                ),
                if (rooms.isEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: Text('No rooms on this floor yet.')),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    sliver: SliverList.builder(
                      itemCount: rooms.length,
                      itemBuilder: (context, i) => RoomCard(room: rooms[i]),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Horizontal segmented control for picking a floor.
class _FloorSegments extends StatelessWidget {
  final List<String> floors;
  final int selected;
  final ValueChanged<int> onSelect;

  const _FloorSegments({
    required this.floors,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          for (int i = 0; i < floors.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onSelect(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutQuint,
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  margin: EdgeInsets.only(right: i == floors.length - 1 ? 0 : 4),
                  decoration: BoxDecoration(
                    color: i == selected ? cs.surface : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    floors[i],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          i == selected ? FontWeight.w600 : FontWeight.w400,
                      color:
                          i == selected ? cs.onSurface : cs.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
