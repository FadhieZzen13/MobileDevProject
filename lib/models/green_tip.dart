/// A single sustainability tip shown in the Green Awareness module.
///
/// Instances are created from `assets/data/green_tips.json`.
class GreenTip {
  final String title;
  final String category; // e.g. "Recycling", "Save Water", "Save Electricity"
  final String description;
  final String icon; // optional Material icon name, e.g. "recycling"

  const GreenTip({
    required this.title,
    required this.category,
    required this.description,
    required this.icon,
  });

  factory GreenTip.fromJson(Map<String, dynamic> json) {
    return GreenTip(
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? '',
      description: json['description'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
    );
  }
}
