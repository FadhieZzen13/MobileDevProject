import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/app_data.dart';
import '../theme/theme_provider.dart';
import 'block_screen.dart';
import 'facility_screen.dart';
import 'search_screen.dart';
import 'green_screen.dart';
import 'route_screen.dart';

/// Home screen (Functional Requirement #2).
///
/// Landing page: greeting, search entry, block wayfinding tiles, facility
/// quick-chips and the green-sustainability banner. Content is centred and
/// width-capped so it never stretches awkwardly on a wide tablet.
class HomeScreen extends StatelessWidget {
  static const route = '/home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
              children: [
                // Header: location + greeting + dark-mode toggle.
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('FSKTM, UPM',
                              style: text.bodyMedium
                                  ?.copyWith(color: cs.onSurfaceVariant)),
                          Text('Where to?', style: text.headlineMedium),
                        ],
                      ),
                    ),
                    _CircleButton(
                      icon: themeProvider.isDark
                          ? Icons.light_mode_outlined
                          : Icons.dark_mode_outlined,
                      tooltip: 'Toggle dark mode',
                      onTap: () => context.read<ThemeProvider>().toggle(),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Search pill (opens the dedicated search screen).
                _SearchPill(
                  onTap: () =>
                      Navigator.pushNamed(context, SearchScreen.route),
                ),
                const SizedBox(height: 10),
                _DirectionsButton(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RouteScreen()),
                  ),
                ),

                _SectionLabel('Blocks'),
                Row(
                  children: [
                    for (final block in AppData.instance.blocks) ...[
                      Expanded(child: _BlockTile(block: block)),
                      if (block != AppData.instance.blocks.last)
                        const SizedBox(width: 8),
                    ],
                  ],
                ),

                _SectionLabel('Facilities'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final f in AppData.instance.facilities.take(5))
                      _FacilityChip(
                        label: f.name,
                        onTap: () => Navigator.pushNamed(
                            context, FacilityScreen.route),
                      ),
                  ],
                ),

                const SizedBox(height: 22),
                _GreenBanner(
                  onTap: () => Navigator.pushNamed(context, GreenScreen.route),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchPill extends StatelessWidget {
  final VoidCallback onTap;
  const _SearchPill({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          children: [
            Icon(Icons.search, size: 20, color: cs.primary),
            const SizedBox(width: 10),
            Text('Search rooms, labs, facilities',
                style: TextStyle(color: cs.outline, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class _DirectionsButton extends StatelessWidget {
  final VoidCallback onTap;
  const _DirectionsButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: cs.primaryContainer,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(Icons.directions, size: 20, color: cs.onPrimaryContainer),
            const SizedBox(width: 10),
            Text('Get directions',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: cs.onPrimaryContainer)),
            const Spacer(),
            Icon(Icons.arrow_forward, size: 18, color: cs.onPrimaryContainer),
          ],
        ),
      ),
    );
  }
}

class _BlockTile extends StatelessWidget {
  final String block;
  const _BlockTile({required this.block});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final roomCount =
        AppData.instance.rooms.where((r) => r.block == block).length;
    final floorCount = AppData.instance.floorsForBlock(block).length;
    final empty = roomCount == 0;

    return InkWell(
      onTap: empty
          ? null
          : () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BlockScreen(block: block)),
              ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              block,
              style: text.headlineSmall?.copyWith(
                color: empty ? cs.outline : cs.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              empty ? 'soon' : '$roomCount rooms\n$floorCount floors',
              style: text.bodySmall?.copyWith(
                  color: empty ? cs.outline : cs.onSurfaceVariant,
                  height: 1.3),
            ),
          ],
        ),
      ),
    );
  }
}

class _FacilityChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _FacilityChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Text(label,
            style: TextStyle(fontSize: 12.5, color: cs.onSurface)),
      ),
    );
  }
}

class _GreenBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _GreenBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cs.secondaryContainer,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: cs.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.eco, color: cs.onSecondary, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Green campus',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: cs.onSecondaryContainer)),
                  Text('Paperless tips & recycling',
                      style: TextStyle(
                          fontSize: 12.5,
                          color: cs.onSecondaryContainer.withValues(alpha: 0.85))),
                ],
              ),
            ),
            Icon(Icons.arrow_forward, color: cs.onSecondaryContainer, size: 20),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 22, 0, 10),
      child: Text(text,
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: cs.onSurfaceVariant)),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  const _CircleButton(
      {required this.icon, required this.tooltip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: cs.surface,
            shape: BoxShape.circle,
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Icon(icon, size: 20, color: cs.onSurfaceVariant),
        ),
      ),
    );
  }
}
