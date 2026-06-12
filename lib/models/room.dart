/// A room or laboratory inside one of the faculty blocks.
///
/// Instances are created from `assets/data/rooms.json` via [Room.fromJson].
class Room {
  final String code;        // room number, e.g. "A0.01"
  final String name;        // Malay name from the directory sign
  final String nameEn;      // English name
  final String type;        // e.g. "Lab", "Office", "Lecture Hall"
  final String block;       // "A", "B" or "C"
  final String floor;       // "Ground", "Level 1", "Level 2"
  final String image;       // file name inside assets/images/ (may be empty)
  final String description;

  const Room({
    required this.code,
    required this.name,
    required this.nameEn,
    required this.type,
    required this.block,
    required this.floor,
    required this.image,
    required this.description,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      nameEn: json['nameEn'] as String? ?? '',
      type: json['type'] as String? ?? '',
      block: json['block'] as String? ?? '',
      floor: json['floor'] as String? ?? '',
      image: json['image'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}
