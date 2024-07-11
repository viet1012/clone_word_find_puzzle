import 'package:flutter/material.dart';

class MatchstickItem extends StatefulWidget {
  final bool isActive;
  final VoidCallback onTap;

  const MatchstickItem({
    required this.isActive,
    required this.onTap,
  });

  @override
  _MatchstickItemState createState() => _MatchstickItemState();
}

class _MatchstickItemState extends State<MatchstickItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _colorAnimation = ColorTween(
      begin: Colors.transparent,
      end: Colors.teal,
    ).animate(_controller);

    if (widget.isActive) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(MatchstickItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              color: _colorAnimation.value,
              border: Border.all(color: Colors.brown, width: 2.0),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Center(
              child: SizedBox(
                width: 10,
                height: 50,
                child: RotatedBox(
                  quarterTurns: widget.isActive ? 2 : 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          widget.isActive ? Colors.white : Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
