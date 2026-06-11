import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../models/facility.dart';
import '../models/room.dart';
import 'room_detail_screen.dart';

/// Search function (Functional Requirement #7).
///
/// Lets the user search room names, lab names and facility names. Results
/// update live as the query changes. Tapping a room result opens its detail.
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
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              autofocus: true,
              onChanged: _onChanged,
              decoration: InputDecoration(
                hintText: 'Search rooms, labs or facilities…',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controller.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          _onChanged('');
                        },
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(child: _buildResults()),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (_controller.text.isEmpty) {
      return const Center(child: Text('Type to search.'));
    }
    if (_results.isEmpty) {
      return const Center(child: Text('No matches found.'));
    }
    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (context, i) {
        final item = _results[i];
        if (item is Room) {
          return ListTile(
            leading: const Icon(Icons.meeting_room),
            title: Text(item.code),
            subtitle:
                Text('${item.type} • Block ${item.block}, ${item.floor}'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RoomDetailScreen(room: item),
              ),
            ),
          );
        }
        final facility = item as Facility;
        return ListTile(
          leading: const Icon(Icons.apartment),
          title: Text(facility.name),
          subtitle: Text(facility.location),
        );
      },
    );
  }
}
