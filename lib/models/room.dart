/// A room or laboratory inside one of the faculty blocks.
///
/// Instances are created from `assets/data/rooms.json` via [Room.fromJson].
class Room {
  final String code; // e.g. "SE Lab 1"
  final String type; // e.g. "Lab", "Lecturer Room", "Meeting Room"
  final String block; // "A", "B" or "C"
  final String floor; // e.g. "Ground", "Level 1"
  final String image; // file name inside assets/images/ (may be empty)
  final String description;

  const Room({
    required this.code,
    required this.type,
    required this.block,
    required this.floor,
    required this.image,
    required this.description,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      code: json['code'] as String? ?? '',
      type: json['type'] as String? ?? '',
      block: json['block'] as String? ?? '',
      floor: json['floor'] as String? ?? '',
      image: json['image'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}
