/// A faculty facility such as a surau, pantry, parking area or recycling corner.
///
/// Instances are created from `assets/data/facilities.json`.
class Facility {
  final String name;
  final String location; // human-readable location, e.g. "Block A, Ground Floor"
  final String description;
  final String image; // file name inside assets/images/ (may be empty)
  final String icon; // optional Material icon name fallback, e.g. "local_parking"

  // Structured location used by the directions feature. Empty / null when the
  // facility is not on a routable floor (e.g. an outdoor car park).
  final String block; // "A", "B", "C" or "" if not applicable
  final String floor; // "Ground", "Level 1", … or "" if not applicable
  final int? order; // corridor position on its floor, if known

  const Facility({
    required this.name,
    required this.location,
    required this.description,
    required this.image,
    required this.icon,
    this.block = '',
    this.floor = '',
    this.order,
  });

  /// Whether this facility has enough location data to be used in directions.
  bool get isRoutable => block.isNotEmpty && floor.isNotEmpty;

  factory Facility.fromJson(Map<String, dynamic> json) {
    return Facility(
      name: json['name'] as String? ?? '',
      location: json['location'] as String? ?? '',
      description: json['description'] as String? ?? '',
      image: json['image'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      block: json['block'] as String? ?? '',
      floor: json['floor'] as String? ?? '',
      order: json['order'] as int?,
    );
  }
}
