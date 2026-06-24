import 'app_data.dart';
import 'building_map.dart';
import '../models/room.dart';

// Re-export the step types so screens can keep importing just route_guide.
export 'building_map.dart' show StepKind, RouteStep;

/// A point the user can route to or from: a room or a routable landmark.
class Place {
  final String label; // English name (shown first)
  final String labelMs; // Malay name (for search; may equal label)
  final String nodeId; // id understood by BuildingMap (room code or landmark id)
  final String code; // room code, or '' for landmarks
  final String block;
  final String floor;
  final bool isFacility; // true for landmarks (toilet, kafeteria)

  const Place({
    required this.label,
    this.labelMs = '',
    required this.nodeId,
    required this.code,
    required this.block,
    required this.floor,
    required this.isFacility,
  });

  String get sublabel => isFacility
      ? 'Block $block, $floor'
      : '$code · Block $block, $floor';
}

/// Builds the pickable places and generates directions via [BuildingMap].
class RouteGuide {
  RouteGuide._();

  static Place placeForRoom(Room r) => Place(
        label: r.nameEn.isNotEmpty
            ? r.nameEn
            : (r.name.isEmpty ? r.code : r.name),
        labelMs: r.name,
        nodeId: r.code,
        code: r.code,
        block: r.block,
        floor: r.floor,
        isFacility: false,
      );

  /// All places the user can pick as a start or destination: every routable
  /// room plus the toilets and kafeteria.
  static List<Place> places() {
    final out = <Place>[];
    for (final r in AppData.instance.rooms) {
      if (!BuildingMap.isRoutable(r.code)) continue;
      out.add(placeForRoom(r));
    }
    for (final st in BuildingMap.landmarkNodes()) {
      final plan = BuildingMap.floorOf(st.id);
      final rank = plan?.rank ?? 0;
      final floor = rank == 0 ? 'Ground' : 'Level $rank';
      final block = st.id.contains('A') ? 'A' : st.id.contains('B') ? 'B' : '';
      final label = st.kind == NodeKind.kafeteria ? 'Kafeteria' : 'Toilet';
      out.add(Place(
        label: label,
        nodeId: st.id,
        code: '',
        block: block,
        floor: floor,
        isFacility: true,
      ));
    }
    return out;
  }

  /// Turn-by-turn directions from [from] to [to].
  static List<RouteStep> directions(Place from, Place to) {
    final built = BuildingMap.directions(from.nodeId, to.nodeId);
    if (built != null) return built;
    // Fallback for any node missing from the map.
    return [
      RouteStep(StepKind.start, 'Start at ${from.label}.'),
      RouteStep(StepKind.walk, 'Make your way toward ${to.label}.'),
      RouteStep(StepKind.arrive, "You've arrived at ${to.label}."),
    ];
  }
}
