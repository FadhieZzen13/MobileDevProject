import 'app_data.dart';

/// Coordinate model of FSKTM Blocks A and B plus a heading-aware routing engine.
///
/// Geometry comes from the faculty directory boards: each block is a central
/// corridor (Ruang Legar) running from the main entrance inward. Rooms line the
/// WEST (left when facing inward) and EAST (right) walls. Every node has an
/// `along` position (0 = the entrance / arrival end, increasing inward).
///
/// Crucially, left/right is NOT stored per room. It is computed from the
/// direction you are walking: a room on the EAST wall is on your right when you
/// head inward and on your left when you head back toward the entrance. This is
/// why the office complex correctly reads as "on your left" when reached from
/// the kafeteria staircase.
///
/// Blocks A and B connect only on the ground floor (through the kafeteria);
/// their staircases are separate, so crossing blocks routes via the ground.

enum NodeKind { room, stairs, toilet, surau, kafeteria, foodStall, office }

enum Wall { west, east, none }

class MapNode {
  final String id; // room code, or landmark id ('A_front', 'toilet@A1', …)
  final NodeKind kind;
  final Wall wall;
  final int along;
  final String? label; // for non-room nodes
  final String? stairId; // for kind == stairs

  const MapNode(this.id, this.kind, this.wall, this.along,
      {this.label, this.stairId});
}

class FloorPlan {
  final String key; // 'G', 'A1', 'A2', 'B1', 'B2'
  final String block; // 'A', 'B', 'G' (G = whole ground floor)
  final int rank; // 0 ground, 1, 2
  final List<MapNode> nodes;
  const FloorPlan(this.key, this.block, this.rank, this.nodes);
}

class BuildingMap {
  BuildingMap._();

  static const _officeMembers = {
    'A1.01', 'A1.02', 'A1.03', 'A1.04', 'A1.05', 'A1.06', 'A1.07', 'A1.08',
    'A1.09', 'A1.12', 'A1.13', 'A1.14', 'A1.15',
  };
  static const _officeId = 'A1_office';

  // Shorthands for terse node construction.
  static MapNode _r(String code, Wall w, int along) =>
      MapNode(code, NodeKind.room, w, along);
  static MapNode _stair(String id, String label, int along) =>
      MapNode(id, NodeKind.stairs, Wall.none, along, label: label, stairId: id);

  static final List<FloorPlan> floors = [
    // Ground floor: Block A (entrance south), kafeteria, then Block B.
    FloorPlan('G', 'G', 0, [
      _stair('A_front', 'front entrance staircase', 0),
      _r('A0.11', Wall.west, 1),
      _r('A0.12', Wall.west, 2),
      _r('A0.13', Wall.west, 3),
      _r('A0.09 & A0.10', Wall.east, 1),
      _r('A0.10A', Wall.east, 2),
      _r('A0.09A', Wall.east, 3),
      _r('A0.06 & A0.07', Wall.west, 4),
      _r('A0.04 & A0.05', Wall.east, 4),
      _r('A0.14 & A0.15', Wall.west, 5),
      _r('A0.02', Wall.west, 6),
      _r('A0.01', Wall.east, 6),
      MapNode('toilet@A_G', NodeKind.toilet, Wall.west, 7, label: 'toilet'),
      _stair('A_rear', 'kafeteria-side staircase', 8),
      MapNode('kafeteria', NodeKind.kafeteria, Wall.none, 9, label: 'kafeteria'),
      MapNode('foodstall', NodeKind.foodStall, Wall.west, 9,
          label: 'food stall'),
      _r('B0.07', Wall.east, 11),
      _r('B0.08', Wall.east, 12),
      _r('B0.10 & B0.11', Wall.east, 13),
      _r('B0.04', Wall.west, 11),
      _r('B0.05', Wall.west, 12),
      _r('B0.01 & B0.02', Wall.west, 13),
      _stair('B_right', 'Block B staircase (by the toilet)', 14),
      MapNode('toilet@B_G', NodeKind.toilet, Wall.east, 14, label: 'toilet'),
      _stair('B_left', 'Block B left staircase', 14),
    ]),

    // Block A, Level 1: office complex spans the east wall.
    FloorPlan('A1', 'A', 1, [
      _stair('A_front', 'front staircase', 0),
      _r('A1.16', Wall.west, 1),
      _r('A1.24', Wall.west, 2),
      _r('A1.17', Wall.west, 3),
      _r('A1.19', Wall.west, 4),
      _r('A1.27', Wall.west, 5),
      MapNode('A1.29', NodeKind.surau, Wall.west, 6),
      MapNode('A1.30', NodeKind.surau, Wall.west, 7),
      MapNode('toilet@A1', NodeKind.toilet, Wall.east, 6, label: 'toilet'),
      MapNode(_officeId, NodeKind.office, Wall.east, 4,
          label: 'main staff offices'),
      _stair('A_rear', 'kafeteria-side staircase', 8),
    ]),

    // Block A, Level 2.
    FloorPlan('A2', 'A', 2, [
      _stair('A_front', 'front staircase', 0),
      _r('A2.18', Wall.east, 1),
      _r('A2.10', Wall.east, 1),
      _r('A2.24', Wall.west, 1),
      _r('A2.28', Wall.west, 1),
      _r('A2.21', Wall.east, 3),
      _r('A2.14', Wall.east, 3),
      _r('A2.25', Wall.west, 3),
      _r('A2.26', Wall.west, 3),
      _r('A2.23', Wall.east, 5),
      _r('A2.15', Wall.east, 5),
      _r('A2.32', Wall.west, 4),
      _r('A2.33', Wall.west, 5),
      MapNode('toilet@A2', NodeKind.toilet, Wall.west, 6, label: 'toilet'),
      _stair('A_rear', 'kafeteria-side staircase', 6),
    ]),

    // Block B, Level 1: arrive at B_right (toilet in front), inward = deeper.
    FloorPlan('B1', 'B', 1, [
      _stair('B_right', 'Block B staircase (by the toilet)', 0),
      MapNode('toilet@B1', NodeKind.toilet, Wall.east, 0, label: 'toilet'),
      _r('B1.10 & B1.11', Wall.east, 1),
      _r('B1.07 & B1.08', Wall.west, 1),
      _r('B1.04 & B1.05', Wall.east, 3),
      _r('B1.01 & B1.02', Wall.west, 3),
      _stair('B_left', 'Block B left staircase', 4),
    ]),

    // Block B, Level 2.
    FloorPlan('B2', 'B', 2, [
      _stair('B_right', 'Block B staircase (by the toilet)', 0),
      MapNode('toilet@B2', NodeKind.toilet, Wall.east, 0, label: 'toilet'),
      _r('B2.10 & B2.12', Wall.east, 1),
      _r('B2.07 & B2.09', Wall.west, 1),
      _r('B2.04 & B2.05', Wall.east, 3),
      _r('B2.01', Wall.west, 3),
      _r('B2.02', Wall.west, 4),
      _stair('B_left', 'Block B left staircase', 5),
    ]),
  ];

  static FloorPlan _floor(String key) => floors.firstWhere((f) => f.key == key);

  /// The plan to render for a given block + floor selection.
  static FloorPlan? floorFor(String block, String floor) {
    if (floor.toLowerCase().contains('ground')) return _floor('G');
    final rank = floor.contains('2') ? 2 : 1;
    final key = '$block$rank';
    final i = floors.indexWhere((f) => f.key == key);
    return i < 0 ? null : floors[i];
  }

  static (FloorPlan, MapNode)? _locate(String id) {
    final target = _officeMembers.contains(id) ? _officeId : id;
    for (final f in floors) {
      final i = f.nodes.indexWhere((n) => n.id == target);
      if (i >= 0) return (f, f.nodes[i]);
    }
    return null;
  }

  static String _blockOf(String id) {
    if (id.startsWith('A')) return 'A';
    if (id.startsWith('B')) return 'B';
    if (id.contains('A')) return 'A';
    return 'B';
  }

  static bool isRoutable(String id) => _locate(id) != null;

  static FloorPlan? floorOf(String id) => _locate(id)?.$1;

  static String label(String id, {bool destination = false}) {
    if (_officeMembers.contains(id)) {
      final r = AppData.instance.roomByCode(id);
      final name = r?.name ?? id;
      return destination
          ? 'the main staff offices ($name, $id is signposted inside)'
          : 'the main staff offices';
    }
    final hit = _locate(id);
    if (hit == null) return id;
    final n = hit.$2;
    switch (n.kind) {
      case NodeKind.room:
      case NodeKind.surau:
        final r = AppData.instance.roomByCode(id);
        return r == null ? id : '${r.name} (${r.code})';
      case NodeKind.toilet:
        return 'the toilet';
      case NodeKind.kafeteria:
        return 'the kafeteria';
      case NodeKind.foodStall:
        return 'the food stall';
      case NodeKind.office:
        return 'the main staff offices';
      case NodeKind.stairs:
        return n.label ?? 'the staircase';
    }
  }

  // ---- Routing ------------------------------------------------------------

  static String _floorName(int rank) =>
      rank == 0 ? 'the ground floor' : 'Level $rank';

  /// Reported turn/side for a wall given the walking direction.
  static String _sideOf(Wall wall, bool inward) {
    if (wall == Wall.east) return inward ? 'right' : 'left';
    if (wall == Wall.west) return inward ? 'left' : 'right';
    return '';
  }

  static MapNode _stairNode(FloorPlan f, String stairId) =>
      f.nodes.firstWhere((n) => n.stairId == stairId);

  static String _nearestStair(FloorPlan f, MapNode node, String block) {
    final ids = block == 'A' ? ['A_front', 'A_rear'] : ['B_right', 'B_left'];
    String best = ids.first;
    int bestDist = 1 << 30;
    for (final id in ids) {
      final i = f.nodes.indexWhere((n) => n.stairId == id);
      if (i < 0) continue;
      final d = (f.nodes[i].along - node.along).abs();
      if (d < bestDist) {
        bestDist = d;
        best = id;
      }
    }
    return best;
  }

  static bool _notable(MapNode n) =>
      n.kind == NodeKind.room ||
      n.kind == NodeKind.surau ||
      n.kind == NodeKind.toilet ||
      n.kind == NodeKind.office ||
      n.kind == NodeKind.kafeteria;

  /// Pick a landmark passed between [from] and [to], nearest to the target.
  static MapNode? _passing(FloorPlan f, MapNode from, MapNode to) {
    final lo = from.along < to.along ? from.along : to.along;
    final hi = from.along < to.along ? to.along : from.along;
    final cands = f.nodes
        .where((n) =>
            n.along > lo && n.along < hi && _notable(n) && n.id != to.id)
        .toList()
      ..sort((a, b) =>
          (a.along - to.along).abs().compareTo((b.along - to.along).abs()));
    return cands.isEmpty ? null : cands.first;
  }

  /// One walk instruction along the corridor from [from] to [to].
  static RouteStep _walk(FloorPlan f, MapNode from, MapNode to,
      {String? fromLabel}) {
    final inward = to.along >= from.along;
    final dir = inward
        ? 'further along the corridor'
        : 'back along the corridor toward the entrance';
    final intro = fromLabel != null ? 'From the $fromLabel, head' : 'Head';
    final buf = StringBuffer('$intro $dir');

    final lm = _passing(f, from, to);
    if (lm != null) {
      buf.write(', passing ${label(lm.id)}');
      final s = _sideOf(lm.wall, inward);
      if (s.isNotEmpty) buf.write(' on your $s');
    }

    if (to.kind == NodeKind.stairs) {
      buf.write('; continue to the ${label(to.id)}.');
    } else {
      final s = _sideOf(to.wall, inward);
      if (s.isNotEmpty) {
        buf.write('; turn $s into ${label(to.id, destination: true)}.');
      } else {
        buf.write('; continue to ${label(to.id, destination: true)}.');
      }
    }
    return RouteStep(StepKind.walk, buf.toString());
  }

  static RouteStep _stairsStep(String stairId, int fromRank, int toRank) {
    final lbl = floors
        .expand((f) => f.nodes)
        .firstWhere((n) => n.stairId == stairId)
        .label!;
    final up = toRank > fromRank;
    final n = (toRank - fromRank).abs();
    final fl = n == 1 ? 'one floor' : '$n floors';
    return RouteStep(StepKind.stairs,
        'Take the $lbl ${up ? 'up' : 'down'} $fl to ${_floorName(toRank)}.');
  }

  /// Turn-by-turn directions between two node ids, or null if unknown.
  static List<RouteStep>? directions(String fromId, String toId) {
    final f = _locate(fromId);
    final t = _locate(toId);
    if (f == null || t == null) return null;
    if (f.$1.key == t.$1.key && f.$2.id == t.$2.id) {
      return [RouteStep(StepKind.arrive, "You're already at ${label(toId)}.")];
    }

    final steps = <RouteStep>[
      RouteStep(StepKind.start, 'Start at ${label(fromId)}.'),
    ];
    final fFloor = f.$1, fNode = f.$2;
    final tFloor = t.$1, tNode = t.$2;
    final fBlock = _blockOf(fromId), tBlock = _blockOf(toId);

    if (fFloor.key == tFloor.key) {
      steps.add(_walk(fFloor, fNode, tNode));
    } else if (fBlock == tBlock) {
      final stair = _nearestStair(fFloor, fNode, fBlock);
      steps.add(_walk(fFloor, fNode, _stairNode(fFloor, stair)));
      steps.add(_stairsStep(stair, fFloor.rank, tFloor.rank));
      steps.add(_walk(tFloor, _stairNode(tFloor, stair), tNode,
          fromLabel: label(stair)));
    } else {
      final g = _floor('G');
      MapNode gFrom;
      if (fFloor.rank != 0) {
        final stair = _nearestStair(fFloor, fNode, fBlock);
        steps.add(_walk(fFloor, fNode, _stairNode(fFloor, stair)));
        steps.add(_stairsStep(stair, fFloor.rank, 0));
        gFrom = _stairNode(g, stair);
      } else {
        gFrom = g.nodes.firstWhere((n) => n.id == fNode.id);
      }

      final bridge = tBlock == 'B' ? 'B_right' : _nearestStair(tFloor, tNode, 'A');
      final gTo = tFloor.rank == 0
          ? g.nodes.firstWhere((n) => n.id == tNode.id)
          : _stairNode(g, bridge);

      if (gFrom.id != gTo.id) steps.add(_walk(g, gFrom, gTo));

      if (tFloor.rank != 0) {
        steps.add(_stairsStep(bridge, 0, tFloor.rank));
        steps.add(_walk(tFloor, _stairNode(tFloor, bridge), tNode,
            fromLabel: label(bridge)));
      }
    }

    steps.add(RouteStep(StepKind.arrive, "You've arrived at ${label(toId)}."));
    return steps;
  }

  /// Routable landmark nodes (toilets + kafeteria) the user can pick.
  static Iterable<MapNode> landmarkNodes() => floors
      .expand((f) => f.nodes)
      .where((n) =>
          n.kind == NodeKind.toilet || n.kind == NodeKind.kafeteria);
}

enum StepKind { start, walk, turn, stairs, arrive }

class RouteStep {
  final StepKind kind;
  final String text;
  const RouteStep(this.kind, this.text);
}
