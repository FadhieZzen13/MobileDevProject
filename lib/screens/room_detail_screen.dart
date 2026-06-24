import 'package:flutter/material.dart';

import '../data/route_guide.dart';
import '../models/room.dart';
import '../widgets/asset_image_box.dart';
import 'block_screen.dart';
import 'route_screen.dart';

/// Room / lab details (Functional Requirement #5).
///
/// Leads with a hero image, then the bilingual name, a red code chip, meta
/// rows and the description. The primary action jumps to the room's floor.
class RoomDetailScreen extends StatelessWidget {
  final Room room;

  const RoomDetailScreen({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
              children: [
                // Hero image with a floating back button.
                Stack(
                  children: [
                    AssetImageBox(
                      fileName: room.image,
                      height: 200,
                      placeholderIcon: Icons.meeting_room,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: _BackChip(onTap: () => Navigator.pop(context)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Text(
                    room.nameEn.isNotEmpty
                        ? room.nameEn
                        : (room.name.isEmpty ? room.code : room.name),
                    style: text.headlineSmall),
                if (room.name.isNotEmpty && room.name != room.nameEn)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(room.name,
                        style: text.bodyMedium
                            ?.copyWith(color: cs.onSurfaceVariant)),
                  ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    _Pill(
                      label: room.code,
                      bg: cs.primaryContainer,
                      fg: cs.onPrimaryContainer,
                    ),
                    const SizedBox(width: 8),
                    _Pill(
                      label: room.type,
                      bg: cs.surfaceContainerHighest,
                      fg: cs.onSurfaceVariant,
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                _MetaRow(
                    icon: Icons.apartment,
                    label: 'Block',
                    value: 'Block ${room.block}'),
                _MetaRow(
                    icon: Icons.stairs_outlined,
                    label: 'Floor',
                    value: room.floor),

                const SizedBox(height: 16),
                Text(
                  room.description.isEmpty
                      ? 'No description available.'
                      : room.description,
                  style: text.bodyMedium?.copyWith(height: 1.6),
                ),
                const SizedBox(height: 20),

                FilledButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RouteScreen(
                          initialTo: RouteGuide.placeForRoom(room)),
                    ),
                  ),
                  icon: const Icon(Icons.directions),
                  label: const Text('Directions to here'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlockScreen(
                          block: room.block, initialFloor: room.floor),
                    ),
                  ),
                  icon: const Icon(Icons.map_outlined),
                  label: const Text('Show on floor map'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BackChip extends StatelessWidget {
  final VoidCallback onTap;
  const _BackChip({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: cs.surface,
          shape: BoxShape.circle,
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Icon(Icons.arrow_back, size: 19, color: cs.onSurface),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  const _Pill({required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 12.5, fontWeight: FontWeight.w600, color: fg)),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _MetaRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: cs.outlineVariant)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 19, color: cs.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label,
                style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant)),
          ),
          Text(value.isEmpty ? '-' : value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
