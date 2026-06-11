/// A faculty facility such as a surau, pantry, parking area or recycling corner.
///
/// Instances are created from `assets/data/facilities.json`.
class Facility {
  final String name;
  final String location; // human-readable location, e.g. "Block A, Ground Floor"
  final String description;
  final String image; // file name inside assets/images/ (may be empty)
  final String icon; // optional Material icon name fallback, e.g. "local_parking"

  const Facility({
    required this.name,
    required this.location,
    required this.description,
    required this.image,
    required this.icon,
  });

  factory Facility.fromJson(Map<String, dynamic> json) {
    return Facility(
      name: json['name'] as String? ?? '',
      location: json['location'] as String? ?? '',
      description: json['description'] as String? ?? '',
      image: json['image'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
    );
  }
}
