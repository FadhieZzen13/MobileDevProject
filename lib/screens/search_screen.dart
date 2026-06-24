import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../models/facility.dart';
import '../models/room.dart';
import 'room_detail_screen.dart';

/// Search function (Functional Requirement #7).
///
/// Searches room codes, Malay/English names and facility names; results update
/// live. Tapping a room result opens its detail.
class SearchScreen extends StatefulWidget {
  static const route = '/search';

  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  List<Object> _results = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() => _results = AppData.instance.search(value));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          autofocus: true,
                          onChanged: _onChanged,
                          decoration: InputDecoration(
                            hintText: 'Search rooms, labs, facilities',
                            prefixIcon: Icon(Icons.search, color: cs.primary),
                            suffixIcon: _controller.text.isEmpty
                                ? null
                                : IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _controller.clear();
                                      _onChanged('');
                                    },
                                  ),
                            filled: true,
                            fillColor: cs.surface,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 0),
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
                    ],
                  ),
                ),
                Expanded(child: _buildResults()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResults() {
    final cs = Theme.of(context).colorScheme;
    if (_controller.text.isEmpty) {
      return _Hint(icon: Icons.search, text: 'Type to search.', color: cs.outline);
    }
    if (_results.isEmpty) {
      return _Hint(
          icon: Icons.search_off, text: 'No matches found.', color: cs.outline);
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      itemCount: _results.length,
      itemBuilder: (context, i) {
        final item = _results[i];
        if (item is Room) {
          return _ResultRow(
            icon: Icons.meeting_room,
            title: item.nameEn.isNotEmpty
                ? item.nameEn
                : (item.name.isEmpty ? item.code : item.name),
            subtitle: item.name.isNotEmpty && item.name != item.nameEn
                ? '${item.name} · ${item.code} · Block ${item.block}'
                : '${item.code} · Block ${item.block}, ${item.floor}',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => RoomDetailScreen(room: item)),
            ),
          );
        }
        final facility = item as Facility;
        return _ResultRow(
          icon: Icons.apartment,
          title: facility.name,
          subtitle: 'Facility · ${facility.location}',
          onTap: null,
        );
      },
    );
  }
}

class _ResultRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  const _ResultRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
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
                child:
                    Icon(icon, size: 20, color: cs.onPrimaryContainer),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: text.bodySmall
                            ?.copyWith(color: cs.onSurfaceVariant)),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(Icons.chevron_right, color: cs.outline),
            ],
          ),
        ),
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  const _Hint({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 12),
          Text(text, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
