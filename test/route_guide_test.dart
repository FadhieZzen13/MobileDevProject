import 'package:flutter_test/flutter_test.dart';

import 'package:fsktm_nav/data/app_data.dart';
import 'package:fsktm_nav/data/building_map.dart';
import 'package:fsktm_nav/data/route_guide.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async => AppData.instance.load());

  test('same block, different floor includes a staircase step', () {
    final steps = BuildingMap.directions('B0.07', 'B1.10 & B1.11')!;
    expect(steps.first.kind, StepKind.start);
    expect(steps.last.kind, StepKind.arrive);
    expect(steps.any((s) => s.kind == StepKind.stairs), isTrue);
  });

  test('cross-block cross-floor descends then ascends (two stair steps)', () {
    final steps = BuildingMap.directions('A2.21', 'B2.04 & B2.05')!;
    final stairSteps = steps.where((s) => s.kind == StepKind.stairs).toList();
    expect(stairSteps.length, greaterThanOrEqualTo(2));
    expect(steps.last.text, contains('B2.04 & B2.05'));
  });

  test('same-floor walk mentions the corridor and a side', () {
    final steps = BuildingMap.directions('A2.18', 'A2.15')!;
    final walk = steps.firstWhere((s) => s.kind == StepKind.walk);
    expect(walk.text.toLowerCase(), contains('corridor'));
    expect(
        walk.text.contains('left') || walk.text.contains('right'), isTrue);
  });

  test('office members route to the connected office complex', () {
    final steps = BuildingMap.directions('A0.01', 'A1.05')!;
    expect(steps.last.text.toLowerCase(), contains('main staff offices'));
    expect(steps.any((s) => s.kind == StepKind.stairs), isTrue);
  });

  test('a toilet is a routable destination', () {
    final steps = BuildingMap.directions('A0.01', 'toilet@A1')!;
    expect(steps.last.text, contains('toilet'));
  });

  test('places list is non-empty and includes landmarks', () {
    final places = RouteGuide.places();
    expect(places.length, greaterThan(40));
    expect(places.any((p) => p.isFacility), isTrue);
  });
}
