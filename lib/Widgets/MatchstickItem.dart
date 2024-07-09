import 'package:flutter/material.dart';

class MatchstickItem extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;

  const MatchstickItem({
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? Colors.brown : Colors.transparent,
          border: Border.all(color: Colors.brown, width: 2.0),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Center(
          child: SizedBox(
            width: 10,
            height: 50,
            child: RotatedBox(
              quarterTurns: isActive ? 2 : 0,
              child: Container(
                decoration: BoxDecoration(
                  color: isActive ? Colors.orange : Colors.transparent,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
