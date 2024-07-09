import 'dart:math';

import 'package:clone_word_find_puzzle/common.dart';
import 'package:flutter/material.dart';

import '../Widgets/MatchsticksGrid.dart';

class MatchesPuzzleScreen extends StatefulWidget {
  @override
  _MatchesPuzzleScreenState createState() => _MatchesPuzzleScreenState();
}

class _MatchesPuzzleScreenState extends State<MatchesPuzzleScreen> {
  List<String> equations = [
    '5 + 3 = 8',
    '4 + 2 = 6',
    '7 - 2 = 5',
    // Add more equations as needed
  ];

  int currentEquationIndex = 0; // Track the index of the current equation
  String currentEquation = ''; // Current equation to display
  List<bool> matchsticks = []; // Matchsticks for current equation
  int expectedMatchstickCount = 0; // Expected number of matchsticks

  @override
  void initState() {
    super.initState();
    loadNextPuzzle(); // Load the first puzzle when the screen initializes
  }

  void loadNextPuzzle() {
    setState(() {
      currentEquation =
          equations[currentEquationIndex]; // Load the current equation
      expectedMatchstickCount = countMatchsticks(
          currentEquation); // Calculate the expected number of matchsticks
      matchsticks = generateMatchsticks(
          expectedMatchstickCount); // Generate matchsticks for the equation

      // Move to the next equation or loop back to the start
      currentEquationIndex = (currentEquationIndex + 1) % equations.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matches Puzzle'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        color: Colors.teal[50],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Tap the correct number of matchsticks:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                currentEquation,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: MatchsticksGrid(
                  matchsticks: matchsticks,
                  onTap: (index) {
                    setState(() {
                      // Toggle matchstick state (on/off)
                      matchsticks[index] = !matchsticks[index];
                    });
                  },
                ),
              ), // Display matchsticks grid
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
                onPressed: () {
                  bool solutionCorrect = validateSolution();
                  if (solutionCorrect) {
                    Common.showCompletionDialog(context, loadNextPuzzle);
                  } else {
                    Common.showErrorDialog(context);
                  }
                },
                child: const Text(
                  'Check Solution',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateSolution() {
    int activeMatchstickCount =
        matchsticks.where((matchstick) => matchstick).length;
    return activeMatchstickCount == expectedMatchstickCount;
  }

  List<bool> generateMatchsticks(int expectedCount) {
    Random random = Random();
    int matchstickCount = random.nextInt(11) + 10;
    return List<bool>.filled(matchstickCount, false);
  }

  int countMatchsticks(String equation) {
    List<String> parts = equation.split('=');
    if (parts.length != 2) {
      throw Exception('Invalid equation format');
    }
    int result = int.parse(parts[1].trim());
    return result;
  }
}
