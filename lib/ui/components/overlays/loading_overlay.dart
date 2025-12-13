// lib/ui/components/overlays/loading_overlay.dart
import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final double opacity;
  final Color color;
  final Widget child;

  const LoadingOverlay({
    super.key,
    this.isLoading = false,
    this.opacity = 0.5,
    this.color = Colors.black,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Opacity(
            opacity: opacity,
            child: ModalBarrier(dismissible: false, color: color),
          ),
        if (isLoading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
