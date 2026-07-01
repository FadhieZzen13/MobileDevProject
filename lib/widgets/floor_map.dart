import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../data/floor_plans.dart';
import '../data/route_guide.dart';
import '../models/room.dart';
import '../screens/room_detail_screen.dart';
import '../screens/route_screen.dart';

/// Renders a [FloorArt] as a 2D floor plan styled like the printed FSKTM
/// directory boards: a beige board background, all rooms in the floor's accent
/// colour (green for ground, orange for level 1, blue for level 2), brown
/// service rooms, red toilets and white staircases with step lines. Tapping a
/// room opens a bilingual bottom sheet with quick actions.
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

  // Board colour per floor level — matches the physical directory boards.
  Color _floorColor() {
    if (floor.toLowerCase().contains('ground')) return const Color(0xFF5A9F8B);
    if (floor.contains('2')) return const Color(0xFF5D8EC4);
    return const Color(0xFFE88A4D);
  }

  // Soft block label shown at the bottom of the board.
  String _blockLabel() => 'BLOK $block';

  @override
  Widget build(BuildContext context) {
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
            color: const Color(0xFFDCD0B6), // beige board
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFB8A988), width: 1.2),
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
                // Block label bottom-center.
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 2,
                  child: IgnorePointer(
                    child: Text(
                      _blockLabel(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: Color(0xFF6B5A3A),
                      ),
                    ),
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
    // Corridor (Ruang Legar) — solid darker beige lane behind the rooms.
    if (cell.type == CellType.corridor) {
      return Container(color: const Color(0xFFBFB091));
    }

    // Suite outline (Dean's wing on A1) — same floor colour as the rooms but
    // outlined, drawn behind the nested rooms.
    if (cell.type == CellType.suite) {
      return Container(
        decoration: BoxDecoration(
          color: floorColor.withValues(alpha: 0.12),
          border: Border.all(color: floorColor, width: 1.2),
        ),
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 1),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(cell.label,
              style: TextStyle(
                  fontSize: 8,
                  color: floorColor,
                  fontWeight: FontWeight.w700)),
        ),
      );
    }

    // Stairs — white box with horizontal step lines (matches the board).
    if (cell.type == CellType.stairs) {
      return CustomPaint(
        painter: _StairsPainter(),
      );
    }

    late Color bg;
    late Color border;
    late Color fg;
    IconData? icon;

    switch (cell.type) {
      case CellType.room:
        bg = highlighted
            ? Color.alphaBlend(Colors.white.withValues(alpha: 0.20), floorColor)
            : floorColor;
        border = Color.alphaBlend(
            Colors.black.withValues(alpha: 0.35), floorColor);
        fg = Colors.white;
        break;
      case CellType.toilet:
        bg = const Color(0xFFE63946);
        border = const Color(0xFF922A32);
        fg = Colors.white;
        icon = Icons.wc;
        break;
      case CellType.service:
        bg = const Color(0xFF7A5C4D);
        border = const Color(0xFF4A3528);
        fg = Colors.white;
        break;
      case CellType.kafeteria:
        bg = const Color(0xFFE7DDC4);
        border = const Color(0xFFB8A988);
        fg = const Color(0xFF6B5A3A);
        icon = Icons.restaurant;
        break;
      case CellType.door:
        bg = Colors.white;
        border = const Color(0xFF6B5A3A);
        fg = const Color(0xFF3A3A3A);
        icon = Icons.login;
        break;
      case CellType.stairs:
      case CellType.corridor:
      case CellType.suite:
        bg = Colors.transparent;
        border = Colors.transparent;
        fg = Colors.black;
        break;
    }

    final box = Container(
      decoration: BoxDecoration(
        color: bg,
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

/// Paints a white stair cell with horizontal step lines, mirroring the look
/// of the staircases on the FSKTM directory boards.
class _StairsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = Colors.white;
    final stroke = Paint()
      ..color = const Color(0xFF2A2A2A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    final rect = Offset.zero & size;
    canvas.drawRect(rect, fill);
    canvas.drawRect(rect, stroke);
    // Step lines — aim for ~5–7 visible steps.
    final stepCount = (size.height / 8).clamp(4, 9).round();
    final step = size.height / stepCount;
    for (int i = 1; i < stepCount; i++) {
      final y = i * step;
      canvas.drawLine(Offset(2, y), Offset(size.width - 2, y), stroke);
    }
  }

  @override
  bool shouldRepaint(covariant _StairsPainter oldDelegate) => false;
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
    // Marker cells (toilet, kafeteria, door): icon + optional label.
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
