import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/room.dart';
import '../models/facility.dart';
import '../models/green_tip.dart';

/// Loads all local JSON data once and exposes simple query helpers.
///
/// There is no backend in this project; everything comes from the bundled
/// JSON files under `assets/data/`. Call [load] once at app start (the splash
/// screen does this) and then read from the cached lists.
class AppData {
  AppData._();
  static final AppData instance = AppData._();

  List<Room> rooms = [];
  List<Facility> facilities = [];
  List<GreenTip> greenTips = [];

  bool _loaded = false;

  /// Reads and parses the three JSON asset files. Safe to call more than once.
  Future<void> load() async {
    if (_loaded) return;

    final roomsRaw = await rootBundle.loadString('assets/data/rooms.json');
    final facilitiesRaw =
        await rootBundle.loadString('assets/data/facilities.json');
    final tipsRaw = await rootBundle.loadString('assets/data/green_tips.json');

    rooms = (jsonDecode(roomsRaw) as List)
        .map((e) => Room.fromJson(e as Map<String, dynamic>))
        .toList();
    facilities = (jsonDecode(facilitiesRaw) as List)
        .map((e) => Facility.fromJson(e as Map<String, dynamic>))
        .toList();
    greenTips = (jsonDecode(tipsRaw) as List)
        .map((e) => GreenTip.fromJson(e as Map<String, dynamic>))
        .toList();

    _loaded = true;
  }

  /// The three blocks covered by the app, in order.
  List<String> get blocks => const ['A', 'B', 'C'];

  /// Distinct floors that have at least one room in [block], preserving the
  /// order in which they first appear in the data.
  List<String> floorsForBlock(String block) {
    final seen = <String>{};
    final result = <String>[];
    for (final r in rooms) {
      if (r.block == block && seen.add(r.floor)) {
        result.add(r.floor);
      }
    }
    return result;
  }

  /// All rooms located on [floor] of [block].
  List<Room> roomsForFloor(String block, String floor) {
    return rooms.where((r) => r.block == block && r.floor == floor).toList();
  }

  /// Case-insensitive search across room codes/types and facility names.
  /// Returns a mixed list of [Room] and [Facility] objects.
  List<Object> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];

    final results = <Object>[];
    for (final r in rooms) {
      if (r.code.toLowerCase().contains(q) ||
          r.name.toLowerCase().contains(q) ||
          r.nameEn.toLowerCase().contains(q) ||
          r.type.toLowerCase().contains(q)) {
        results.add(r);
      }
    }
    for (final f in facilities) {
      if (f.name.toLowerCase().contains(q)) {
        results.add(f);
      }
    }
    return results;
  }
}
