import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../data/floor_plans.dart';
import '../data/route_guide.dart';
import '../models/room.dart';
import '../screens/room_detail_screen.dart';
import '../screens/route_screen.dart';

/// Renders a [FloorArt] as a scaled 2D floor plan that resembles the faculty
/// directory boards. Rooms abut (separated by borders), the corridor is
/// highlighted, and tapping a room shows its bilingual name with quick actions.
/// An optional [highlightCode] paints one room in the brand colour.
class FloorMapView extends StatelessWidget {
  final String block;
  final String floor;
  final String? highlightCode;

  const FloorMapView({
    super.key,
    required this.block,
    required this.floor,
    this.highlightCode,
  });

  // Board-like colour per floor level.
  Color _floorColor() {
    if (floor.toLowerCase().contains('ground')) return const Color(0xFF1B9E84);
    if (floor.contains('2')) return const Color(0xFF2F7FCB);
    return const Color(0xFFE2683C);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final art = FloorPlans.of(block, floor);
    if (art == null) return const SizedBox.shrink();
    final floorColor = _floorColor();

    return LayoutBuilder(
      builder: (context, constraints) {
        final inner = constraints.maxWidth - 12;
        final scale = inner / art.vw;
        final height = art.vh * scale;
        return Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: SizedBox(
            width: inner,
            height: height,
            child: Stack(
              children: [
                for (final cell in art.cells)
                  Positioned(
                    left: cell.x * scale,
                    top: cell.y * scale,
                    width: cell.w * scale,
                    height: cell.h * scale,
                    child: _Cell(
                      cell: cell,
                      floorColor: floorColor,
                      highlighted: highlightCode != null &&
                          cell.roomCode == highlightCode,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Cell extends StatelessWidget {
  final PlanCell cell;
  final Color floorColor;
  final bool highlighted;
  const _Cell({
    required this.cell,
    required this.floorColor,
    required this.highlighted,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Corridor is a translucent highlighted lane behind the rooms.
    if (cell.type == CellType.corridor) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF3D9A3).withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(3),
        ),
      );
    }

    // Suite is an outlined container drawn behind its rooms.
    if (cell.type == CellType.suite) {
      return Container(
        decoration: BoxDecoration(
          color: floorColor.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: floorColor, width: 1.4),
        ),
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 1),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(cell.label,
              style: TextStyle(
                  fontSize: 8,
                  color: floorColor,
                  fontWeight: FontWeight.w600)),
        ),
      );
    }

    late Color bg;
    late Color border;
    late Color fg;
    IconData? icon;

    switch (cell.type) {
      case CellType.room:
        bg = highlighted ? cs.primary : floorColor.withValues(alpha: 0.90);
        border = highlighted
            ? cs.primary
            : Color.alphaBlend(Colors.black.withValues(alpha: 0.30), floorColor);
        fg = Colors.white;
        break;
      case CellType.toilet:
        bg = const Color(0xFFD8504C);
        border = const Color(0xFF9E2F2C);
        fg = Colors.white;
        icon = Icons.wc;
        break;
      case CellType.stairs:
        bg = cs.surfaceContainerHighest;
        border = cs.outline;
        fg = cs.onSurfaceVariant;
        icon = Icons.stairs;
        break;
      case CellType.service:
        bg = const Color(0xFF7A5C70);
        border = const Color(0xFF553F4E);
        fg = Colors.white;
        break;
      case CellType.kafeteria:
        bg = cs.surfaceContainerHighest;
        border = cs.outlineVariant;
        fg = cs.onSurfaceVariant;
        icon = Icons.restaurant;
        break;
      case CellType.door:
        bg = Colors.transparent;
        border = cs.outlineVariant;
        fg = cs.onSurfaceVariant;
        icon = Icons.login;
        break;
      case CellType.corridor:
      case CellType.suite:
        bg = Colors.transparent;
        border = Colors.transparent;
        fg = cs.onSurface;
        break;
    }

    final box = Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: border, width: 0.8),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(2),
      child: _CellLabel(
        code: cell.roomCode,
        label: cell.label,
        icon: icon,
        fg: fg,
      ),
    );

    if (cell.roomCode == null) return box;
    final room = AppData.instance.roomByCode(cell.roomCode!);
    if (room == null) return box;
    return InkWell(
      onTap: () => _showRoomSheet(context, room),
      child: box,
    );
  }
}

/// Bilingual room popup (English name first, Malay below) with quick actions.
void _showRoomSheet(BuildContext context, Room room) {
  final cs = Theme.of(context).colorScheme;
  final text = Theme.of(context).textTheme;
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (sheet) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              room.nameEn.isNotEmpty
                  ? room.nameEn
                  : (room.name.isEmpty ? room.code : room.name),
              style: text.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            if (room.name.isNotEmpty && room.name != room.nameEn)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(room.name,
                    style: text.bodyMedium
                        ?.copyWith(color: cs.onSurfaceVariant)),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                _MiniPill(
                    label: room.code,
                    bg: cs.primaryContainer,
                    fg: cs.onPrimaryContainer),
                if (room.type.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  _MiniPill(
                      label: room.type,
                      bg: cs.surfaceContainerHighest,
                      fg: cs.onSurfaceVariant),
                ],
                const Spacer(),
                Text('Block ${room.block} · ${room.floor}',
                    style: text.bodySmall
                        ?.copyWith(color: cs.onSurfaceVariant)),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(sheet);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => RoomDetailScreen(room: room)),
                      );
                    },
                    icon: const Icon(Icons.info_outline, size: 18),
                    label: const Text('Details'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(sheet);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RouteScreen(
                              initialTo: RouteGuide.placeForRoom(room)),
                        ),
                      );
                    },
                    icon: const Icon(Icons.directions, size: 18),
                    label: const Text('Directions'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class _MiniPill extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  const _MiniPill({required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(label,
          style:
              TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg)),
    );
  }
}

class _CellLabel extends StatelessWidget {
  final String? code;
  final String label;
  final IconData? icon;
  final Color fg;
  const _CellLabel({
    required this.code,
    required this.label,
    required this.icon,
    required this.fg,
  });

  @override
  Widget build(BuildContext context) {
    // Marker cells (stairs, toilet, kafeteria, door): icon + optional label.
    if (code == null) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) Icon(icon, size: 13, color: fg),
            if (label.isNotEmpty &&
                label != 'Stairs' &&
                label != 'Toilet' &&
                label != 'WC')
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Text(label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 8, color: fg, fontWeight: FontWeight.w600)),
              ),
          ],
        ),
      );
    }
    // Room cells: code on top, short English name below.
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(code!,
              style: TextStyle(
                  fontSize: 9.5, color: fg, fontWeight: FontWeight.w700)),
          if (label.isNotEmpty)
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 8, color: fg, height: 1.05)),
        ],
      ),
    );
  }
}
