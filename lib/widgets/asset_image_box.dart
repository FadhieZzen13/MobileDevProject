import 'package:flutter/material.dart';

/// Shows an image from `assets/images/[fileName]`, falling back to a neutral
/// placeholder when the file is missing or [fileName] is empty.
///
/// This lets the team build and run the app before every photo/map has been
/// added — missing images simply render as an icon instead of crashing.
class AssetImageBox extends StatelessWidget {
  final String fileName;
  final double? height;
  final double? width;
  final IconData placeholderIcon;
  final BorderRadius borderRadius;

  const AssetImageBox({
    super.key,
    required this.fileName,
    this.height,
    this.width,
    this.placeholderIcon = Icons.image_outlined,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Widget placeholder() => Container(
          height: height,
          width: width,
          color: scheme.surfaceContainerHighest,
          alignment: Alignment.center,
          child: Icon(placeholderIcon, size: 48, color: scheme.outline),
        );

    return ClipRRect(
      borderRadius: borderRadius,
      child: fileName.isEmpty
          ? placeholder()
          : Image.asset(
              'assets/images/$fileName',
              height: height,
              width: width,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => placeholder(),
            ),
    );
  }
}
