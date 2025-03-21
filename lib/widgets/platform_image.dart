import 'package:flutter/material.dart';

class PlatformImage extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  const PlatformImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: errorBuilder ?? _defaultErrorBuilder,
    );
  }

  Widget _defaultErrorBuilder(BuildContext context, Object error, StackTrace? stackTrace) {
    return Container(
      width: width,
      height: height,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Icon(
        Icons.image_not_supported,
        size: 48,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
} 