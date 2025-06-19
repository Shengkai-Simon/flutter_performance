import 'package:flutter/material.dart';

class AnimatedItemsGrid extends StatelessWidget {
  final int itemCount;
  final AnimationController animation;

  const AnimatedItemsGrid({
    super.key,
    required this.itemCount,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1.0,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            final double value = animation.value;
            final double phase = (index % 10) / 10;
            final double animValue = (value + phase) % 1.0;
            return Container(
              decoration: BoxDecoration(
                color: HSVColor.fromAHSV(
                  1.0,
                  (360 * animValue) % 360,
                  0.8,
                  0.8,
                ).toColor(),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4 + 4 * animValue,
                    spreadRadius: 2 * animValue,
                  ),
                ],
              ),
              transform: Matrix4.identity()
                ..scale(0.8 + 0.2 * animValue)
                ..rotateZ(animValue * 0.5),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14 + 4 * animValue,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
