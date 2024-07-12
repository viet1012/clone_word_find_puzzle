import 'package:clone_word_find_puzzle/common.dart';
import 'package:flutter/material.dart';

import '../Widgets/AppBarWidget.dart';
import '../Widgets/ButtonWidget.dart';

class NumberPuzzleScreen extends StatefulWidget {
  @override
  _NumberPuzzleScreenState createState() => _NumberPuzzleScreenState();
}

class _NumberPuzzleScreenState extends State<NumberPuzzleScreen> {
  List<int> numbers =
      List.generate(9, (index) => index); // gridSize = 3, total 9 cells
  int gridSize = 3;

  @override
  void initState() {
    super.initState();
    numbers = [1, 2, 3, 4, 5, 6, 7, 8, 0];
    // numbers.shuffle();
  }

  void _onTileTap(int index) {
    if (_canMove(index)) {
      setState(() {
        _swapWithEmpty(index);
        if (_isSolved()) {
          Common.showCompletionDialog(context, () {
            loadNextRound(context);
          });
        }
      });
    }
  }

  bool _canMove(int index) {
    int emptyIndex = numbers.indexOf(0);
    int row = index ~/ gridSize;
    int col = index % gridSize;
    int emptyRow = emptyIndex ~/ gridSize;
    int emptyCol = emptyIndex % gridSize;

    return (row == emptyRow && (col - emptyCol).abs() == 1) ||
        (col == emptyCol && (row - emptyRow).abs() == 1);
  }

  void _swapWithEmpty(int index) {
    int emptyIndex = numbers.indexOf(0);
    numbers[emptyIndex] = numbers[index];
    numbers[index] = 0;
  }

  bool _isSolved() {
    for (int i = 0; i < numbers.length - 1; i++) {
      if (numbers[i] != i + 1) {
        return false;
      }
    }
    if (numbers.last == 0) {
      Common.showCompletionDialog(context, () {
        loadNextRound(context);
      });
      return true;
    }
    return false;
  }

  void _resetGame() {
    setState(() {
      numbers.shuffle();
    });
  }

  void loadNextRound(BuildContext dialogContext) {
    Navigator.of(dialogContext).pop();
    setState(() {
      gridSize = 4; // Thay đổi kích thước lưới cho vòng tiếp theo
      numbers = List.generate(gridSize * gridSize, (index) => index);
      numbers.shuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: "Game 04",
        onPressed: () {
          Common.showInstructionsDialog(
            context,
            '- The goal is to arrange the tiles in numerical order from 1 to 8, with the empty space at the bottom right corner.\n\n'
            '- Tap a tile adjacent to the empty space to move it into the empty space. Keep moving the tiles until you solve the puzzle!',
          );
        },
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade50, Colors.teal.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridSize,
                    childAspectRatio: 1,
                  ),
                  itemCount: gridSize * gridSize,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _onTileTap(index),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: numbers[index] == 0
                              ? Colors.white
                              : Colors.teal.shade600,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            numbers[index] == 0
                                ? ''
                                : numbers[index].toString(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
              ReloadButton(
                onPressed: _resetGame,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
