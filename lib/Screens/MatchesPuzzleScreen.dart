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
    '10 - 4 = 6',
    '7 - 6 = 1',
  ];

  int currentEquationIndex = 0; // Track the index of the current equation
  String currentEquation = ''; // Current equation to display
  String displayedEquation = ''; // Equation with dynamic result
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
      matchsticks =
          generateMatchsticks(); // Generate matchsticks for the equation

      // Initialize displayed equation
      displayedEquation = currentEquation.replaceFirst(
          RegExp(r'\d+$'), '...'); // Replace result with dots

      // Move to the next equation or loop back to the start
      currentEquationIndex = (currentEquationIndex + 1) % equations.length;
    });
  }

  void updateDisplayedEquation() {
    int activeMatchstickCount =
        matchsticks.where((matchstick) => matchstick).length;

    setState(() {
      if (activeMatchstickCount == 0) {
        displayedEquation =
            currentEquation.replaceFirst(RegExp(r'\d+$'), '...');
      } else {
        displayedEquation = currentEquation.replaceFirst(
            RegExp(r'\d+$'), activeMatchstickCount.toString());
      }
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
              const SizedBox(height: 20),
              const Text(
                'Tap the correct number of matchsticks:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border.all(width: 1.5, color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  displayedEquation,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: MatchsticksGrid(
                  matchsticks: matchsticks,
                  onTap: (index) {
                    setState(() {
                      // Toggle matchstick state (on/off)
                      matchsticks[index] = !matchsticks[index];
                    });
                    updateDisplayedEquation(); // Update displayed equation with new active matchstick count
                  },
                ),
              ), // Display matchsticks grid
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  bool solutionCorrect = validateSolution();
                  if (solutionCorrect) {
                    Common.showCompletionDialog(context, loadNextPuzzle);
                  } else {
                    Common.showErrorDialog(context, reset);
                  }
                },
                child: const Text(
                  'Check Solution',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 20),
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

  List<bool> generateMatchsticks() {
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

  void reset() {
    setState(() {
      currentEquationIndex = 0;
      loadNextPuzzle();
    });
  }
}