import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/app_data.dart';
import '../theme/theme_provider.dart';
import '../widgets/asset_image_box.dart';
import 'block_screen.dart';
import 'facility_screen.dart';
import 'search_screen.dart';
import 'green_screen.dart';

/// Home screen (Functional Requirement #2).
///
/// Provides the main navigation menu, block selection, a search entry point,
/// and a faculty overview image/map.
class HomeScreen extends StatelessWidget {
  static const route = '/home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final blocks = AppData.instance.blocks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('FSKTM Navigation'),
        actions: [
          IconButton(
            tooltip: 'Toggle dark mode',
            icon: Icon(themeProvider.isDark
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: () => context.read<ThemeProvider>().toggle(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Faculty overview image / map.
          const AssetImageBox(
            fileName: 'faculty_map.png',
            height: 180,
            placeholderIcon: Icons.map_outlined,
          ),
          const SizedBox(height: 16),

          // Search bar — tapping opens the dedicated search screen.
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, SearchScreen.route),
            child: AbsorbPointer(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search rooms, labs or facilities…',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          Text('Select a Block',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              for (final block in blocks) ...[
                Expanded(
                  child: _BlockButton(block: block),
                ),
                if (block != blocks.last) const SizedBox(width: 12),
              ],
            ],
          ),
          const SizedBox(height: 24),

          Text('Explore', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          _MenuTile(
            icon: Icons.apartment,
            title: 'Facilities',
            subtitle: 'Labs, surau, pantry, parking, recycling…',
            onTap: () => Navigator.pushNamed(context, FacilityScreen.route),
          ),
          _MenuTile(
            icon: Icons.search,
            title: 'Search',
            subtitle: 'Find a room, lab or facility by name',
            onTap: () => Navigator.pushNamed(context, SearchScreen.route),
          ),
          _MenuTile(
            icon: Icons.eco,
            title: 'Green Awareness',
            subtitle: 'Sustainability tips for a greener campus',
            onTap: () => Navigator.pushNamed(context, GreenScreen.route),
          ),
        ],
      ),
    );
  }
}

class _BlockButton extends StatelessWidget {
  final String block;
  const _BlockButton({required this.block});

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => BlockScreen(block: block)),
      ),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 24),
      ),
      child: Text('Block $block',
          style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
