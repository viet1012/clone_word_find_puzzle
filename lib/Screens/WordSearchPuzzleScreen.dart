import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../common.dart';

class WordSearchPuzzleScreen extends StatefulWidget {
  @override
  _WordSearchPuzzleScreenState createState() => _WordSearchPuzzleScreenState();
}

class _WordSearchPuzzleScreenState extends State<WordSearchPuzzleScreen> {
  final List<List<String>> wordLists = [
    ['CAT', 'DOG', 'BIRD', 'FISH'],
    ['TREE', 'FLOWER', 'GRASS', 'LEAF'],
    ['CAR', 'BIKE', 'BUS', 'GIFT'],
  ];

  final List<List<List<String>>> puzzleLists = [
    [
      ['C', 'A', 'T', 'X'],
      ['D', 'O', 'G', 'O'],
      ['B', 'I', 'R', 'D'],
      ['F', 'I', 'S', 'H']
    ],
    [
      ['T', 'R', 'E', 'E', 'V', 'E'],
      ['F', 'L', 'O', 'W', 'E', 'R'],
      ['G', 'R', 'A', 'S', 'S', 'H'],
      ['L', 'E', 'A', 'F', 'E', 'A']
    ],
    [
      ['C', 'A', 'R', 'B'],
      ['B', 'I', 'K', 'E'],
      ['B', 'U', 'S', 'T'],
      ['G', 'I', 'F', 'T']
    ],
  ];

  int currentPuzzleIndex = 0;
  final Set<int> completedPuzzles = {};

  late List<String> words;
  late List<List<String>> puzzle;
  late List<List<bool>> selected;
  late List<List<bool>> correct;

  List<Offset> currentSelection = [];
  List<String> foundWords = [];
  final audioCache = AudioPlayer();

  @override
  void initState() {
    super.initState();
    loadPuzzle(currentPuzzleIndex);
  }

  void loadPuzzle(int index) {
    setState(() {
      words = wordLists[index];
      puzzle = puzzleLists[index];
      selected = List.generate(
          puzzle.length, (_) => List.generate(puzzle[0].length, (_) => false));
      correct = List.generate(
          puzzle.length, (_) => List.generate(puzzle[0].length, (_) => false));
      foundWords.clear();
      currentSelection.clear();
    });
  }

  void handleTap(int row, int col) {
    if (completedPuzzles.contains(currentPuzzleIndex)) {
      return;
    }

    setState(() {
      if (selected[row][col]) {
        selected[row][col] = false;
        currentSelection.remove(Offset(row.toDouble(), col.toDouble()));
      } else {
        selected[row][col] = true;
        currentSelection.add(Offset(row.toDouble(), col.toDouble()));
      }
      checkWord();
    });
  }

  void checkWord() {
    String currentWord = currentSelection
        .map((offset) => puzzle[offset.dx.toInt()][offset.dy.toInt()])
        .join();

    for (String word in words) {
      if (currentWord == word && !foundWords.contains(word)) {
        audioCache.play(AssetSource('sounds/correct_sound.mp3'));

        setState(() {
          foundWords.add(word);
          for (var offset in currentSelection) {
            if (word.contains(puzzle[offset.dx.toInt()][offset.dy.toInt()])) {
              correct[offset.dx.toInt()][offset.dy.toInt()] = true;
            }
          }
        });
        currentSelection.clear();
        if (foundWords.length == words.length) {
          completedPuzzles.add(currentPuzzleIndex);
          Common.showCompletionDialog(context, nextPuzzle);
        }
      }
    }
  }

  void resetGame() {
    loadPuzzle(currentPuzzleIndex);
  }

  void nextPuzzle() {
    if (currentPuzzleIndex < puzzleLists.length - 1) {
      setState(() {
        currentPuzzleIndex = (currentPuzzleIndex + 1) % puzzleLists.length;
        loadPuzzle(currentPuzzleIndex);
      });
    }
  }

  void previousPuzzle() {
    if (currentPuzzleIndex > 0) {
      setState(() {
        currentPuzzleIndex =
            (currentPuzzleIndex - 1 + puzzleLists.length) % puzzleLists.length;
        loadPuzzle(currentPuzzleIndex);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Find Game'),
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.teal[50],
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Find the hidden words in the puzzle!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        const Divider(
                          color: Colors.teal,
                          thickness: 2,
                          height: 20,
                        ),
                        SizedBox(
                          height: 60,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 8),
                            itemCount: words.length,
                            itemBuilder: (context, index) {
                              return Chip(
                                label: Text(
                                  words[index],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                backgroundColor: Colors.teal.shade100,
                                elevation: 2,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back_ios,
                                  color: currentPuzzleIndex > 0
                                      ? Colors.teal
                                      : Colors.grey),
                              onPressed: currentPuzzleIndex > 0
                                  ? previousPuzzle
                                  : null,
                              iconSize: 36,
                            ),
                            SizedBox(width: 20),
                            IconButton(
                              icon: Icon(Icons.arrow_forward_ios,
                                  color: currentPuzzleIndex <
                                          puzzleLists.length - 1
                                      ? Colors.teal
                                      : Colors.grey),
                              onPressed:
                                  currentPuzzleIndex < puzzleLists.length - 1
                                      ? nextPuzzle
                                      : null,
                              iconSize: 36,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: puzzle[0].length,
                    ),
                    itemCount: puzzle.length * puzzle[0].length,
                    itemBuilder: (context, index) {
                      int row = index ~/ puzzle[0].length;
                      int col = index % puzzle[0].length;
                      return GestureDetector(
                        onTap: () => handleTap(row, col),
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: correct[row][col]
                                ? Colors.green
                                : selected[row][col]
                                    ? Colors.teal.shade300
                                    : Colors.teal.shade50,
                            border: Border.all(color: Colors.teal),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            puzzle[row][col],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (completedPuzzles.contains(currentPuzzleIndex))
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.7),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle,
                        color: Colors.green, size: 100),
                    const SizedBox(height: 20),
                    const Text(
                      'Puzzle Completed!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: nextPuzzle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text('Next Puzzle'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
