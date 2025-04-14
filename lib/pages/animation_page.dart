import 'package:flutter/material.dart';
import '../widgets/animated_items_grid.dart';

class AnimationPage extends StatefulWidget {
  const AnimationPage({super.key});

  @override
  State<AnimationPage> createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage> with SingleTickerProviderStateMixin {
  bool _isAnimating = false;
  int _itemCount = 30;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleAnimation() {
    setState(() {
      _isAnimating = !_isAnimating;
      if (_isAnimating) {
        _animationController.repeat(reverse: true);
      } else {
        _animationController.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Text('Element Count: '),
                  Expanded(
                    child: Slider(
                      value: _itemCount.toDouble(),
                      min: 1,
                      max: 100,
                      divisions: 99,
                      label: _itemCount.toString(),
                      onChanged: (value) {
                        setState(() {
                          _itemCount = value.toInt();
                        });
                      },
                    ),
                  ),
                  Text('$_itemCount'),
                ],
              ),
              ElevatedButton(
                onPressed: _toggleAnimation,
                child: Text(_isAnimating ? 'Stop Animation' : 'Start Animation'),
              ),
            ],
          ),
        ),
        Expanded(
          child: _isAnimating
              ? AnimatedItemsGrid(
            itemCount: _itemCount,
            animation: _animationController,
          )
              : const Center(child: Text('Click the "Start Animation" button to begin the test.')),
        ),
      ],
    );
  }
}
