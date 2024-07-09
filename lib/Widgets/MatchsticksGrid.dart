import 'package:flutter/material.dart';

import 'MatchstickItem.dart';

class MatchsticksGrid extends StatelessWidget {
  final List<bool> matchsticks;
  final Function(int) onTap;

  const MatchsticksGrid({
    required this.matchsticks,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          childAspectRatio: 1.0,
        ),
        itemCount: matchsticks.length,
        itemBuilder: (BuildContext context, int index) {
          return MatchstickItem(
            isActive: matchsticks[index],
            onTap: () => onTap(index),
          );
        },
      ),
    );
  }
}
