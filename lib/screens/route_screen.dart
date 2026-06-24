import 'package:flutter/material.dart';

import '../data/route_guide.dart';

/// Directions screen: pick a start and destination, get text turn-by-turn
/// instructions composed by [RouteGuide]. Either endpoint can be pre-filled
/// (e.g. opening "Directions to here" from a room detail sets [initialTo]).
class RouteScreen extends StatefulWidget {
  final Place? initialFrom;
  final Place? initialTo;

  const RouteScreen({super.key, this.initialFrom, this.initialTo});

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  Place? _from;
  Place? _to;

  @override
  void initState() {
    super.initState();
    _from = widget.initialFrom;
    _to = widget.initialTo;
  }

  Future<void> _pick(bool isFrom) async {
    final picked = await Navigator.push<Place>(
      context,
      MaterialPageRoute(
        builder: (_) => _PlacePicker(
          title: isFrom ? 'Choose start' : 'Choose destination',
        ),
      ),
    );
    if (picked == null) return;
    setState(() => isFrom ? _from = picked : _to = picked);
  }

  void _swap() => setState(() {
        final t = _from;
        _from = _to;
        _to = t;
      });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final steps =
        (_from != null && _to != null) ? RouteGuide.directions(_from!, _to!) : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Directions')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
            children: [
              // From / To selectors with a swap button.
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Column(
                  children: [
                    _Field(
                      icon: Icons.trip_origin,
                      iconColor: cs.onSurfaceVariant,
                      hint: 'Start point',
                      place: _from,
                      onTap: () => _pick(true),
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 44),
                        Expanded(child: Divider(color: cs.outlineVariant, height: 1)),
                        IconButton(
                          tooltip: 'Swap',
                          onPressed: (_from != null || _to != null) ? _swap : null,
                          icon: const Icon(Icons.swap_vert),
                        ),
                      ],
                    ),
                    _Field(
                      icon: Icons.place,
                      iconColor: cs.primary,
                      hint: 'Destination',
                      place: _to,
                      onTap: () => _pick(false),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              if (steps == null)
                _EmptyHint()
              else ...[
                Text(
                  'Block ${_from!.block} → Block ${_to!.block} · ${steps.length} steps',
                  style: text.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: 10),
                for (int i = 0; i < steps.length; i++)
                  _StepTile(index: i + 1, step: steps[i], isLast: i == steps.length - 1),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String hint;
  final Place? place;
  final VoidCallback onTap;
  const _Field({
    required this.icon,
    required this.iconColor,
    required this.hint,
    required this.place,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: 14),
            Expanded(
              child: place == null
                  ? Text(hint,
                      style: text.bodyLarge?.copyWith(color: cs.outline))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(place!.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        Text(place!.sublabel,
                            style: text.bodySmall
                                ?.copyWith(color: cs.onSurfaceVariant)),
                      ],
                    ),
            ),
            Icon(Icons.chevron_right, color: cs.outline),
          ],
        ),
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  final int index;
  final RouteStep step;
  final bool isLast;
  const _StepTile(
      {required this.index, required this.step, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final arrive = step.kind == StepKind.arrive;
    final accent = arrive ? cs.secondary : cs.primary;
    final accentBg = arrive ? cs.secondaryContainer : cs.primaryContainer;
    final accentInk = arrive ? cs.onSecondaryContainer : cs.onPrimaryContainer;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon node + connecting line.
          Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: accentBg, shape: BoxShape.circle),
                child: Icon(_icon(step.kind), size: 19, color: accentInk),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: cs.outlineVariant),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 18),
              child: Text(step.text,
                  style: text.bodyMedium?.copyWith(
                      height: 1.45,
                      color: arrive ? accent : cs.onSurface,
                      fontWeight: arrive ? FontWeight.w600 : FontWeight.w400)),
            ),
          ),
        ],
      ),
    );
  }

  IconData _icon(StepKind k) {
    switch (k) {
      case StepKind.start:
        return Icons.trip_origin;
      case StepKind.walk:
        return Icons.directions_walk;
      case StepKind.turn:
        return Icons.turn_right;
      case StepKind.stairs:
        return Icons.stairs;
      case StepKind.arrive:
        return Icons.flag;
    }
  }
}

class _EmptyHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          Icon(Icons.directions, size: 40, color: cs.outline),
          const SizedBox(height: 12),
          Text('Choose a start and destination\nto get directions.',
              textAlign: TextAlign.center,
              style: TextStyle(color: cs.outline, height: 1.5)),
        ],
      ),
    );
  }
}

/// Full-screen searchable list for picking a [Place].
class _PlacePicker extends StatefulWidget {
  final String title;
  const _PlacePicker({required this.title});

  @override
  State<_PlacePicker> createState() => _PlacePickerState();
}

class _PlacePickerState extends State<_PlacePicker> {
  final _controller = TextEditingController();
  late final List<Place> _all = RouteGuide.places();
  List<Place> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filtered = _all;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String q) {
    final query = q.trim().toLowerCase();
    setState(() {
      _filtered = query.isEmpty
          ? _all
          : _all
              .where((p) =>
                  p.label.toLowerCase().contains(query) ||
                  p.labelMs.toLowerCase().contains(query) ||
                  p.code.toLowerCase().contains(query))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  onChanged: _onChanged,
                  decoration: InputDecoration(
                    hintText: 'Search a room or facility',
                    prefixIcon: Icon(Icons.search, color: cs.primary),
                    filled: true,
                    fillColor: cs.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: cs.outlineVariant),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: cs.outlineVariant),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  itemCount: _filtered.length,
                  itemBuilder: (context, i) {
                    final p = _filtered[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        onTap: () => Navigator.pop(context, p),
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
                                child: Icon(
                                    p.isFacility
                                        ? Icons.apartment
                                        : Icons.meeting_room,
                                    size: 20,
                                    color: cs.onPrimaryContainer),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(p.label,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: text.bodyLarge?.copyWith(
                                            fontWeight: FontWeight.w600)),
                                    Text(p.sublabel,
                                        style: text.bodySmall?.copyWith(
                                            color: cs.onSurfaceVariant)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
