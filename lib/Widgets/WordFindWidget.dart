import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../Modals/WordFindChar.dart';
import '../Modals/WordFindQues.dart';
import '../common.dart';

class WordFindWidget extends StatefulWidget {
  final Size size;
  final List<WordFindQues> listQuestions;

  WordFindWidget(this.size, this.listQuestions, {required Key key})
      : super(key: key);

  @override
  WordFindWidgetState createState() => WordFindWidgetState();
}

class WordFindWidgetState extends State<WordFindWidget> {
  late Size size;
  late List<WordFindQues> listQuestions;
  int indexQues = 0; // current index question
  int hintCount = 0;
  final audioCache = AudioPlayer();
  @override
  void initState() {
    super.initState();
    size = widget.size;
    listQuestions = widget.listQuestions;
    generatePuzzle();
  }

  @override
  Widget build(BuildContext context) {
    WordFindQues currentQues = listQuestions[indexQues];
    return Container(
      width: double.maxFinite,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => generateHint(),
                  child: const Icon(
                    Icons.healing_outlined,
                    size: 45,
                    color: Colors.teal,
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () => generatePuzzle(left: true),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        size: 45,
                        color: Colors.teal,
                      ),
                    ),
                    InkWell(
                      onTap: () => generatePuzzle(next: true),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        size: 45,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(
                  maxWidth: size.width / 2 * 1.5,
                ),
                child: Image.network(
                  currentQues.pathImage,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text(
              "${currentQues.question ?? ''}",
              style: const TextStyle(
                fontSize: 25,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            alignment: Alignment.center,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: currentQues.puzzles.map((puzzle) {
                    // later change color based condition
                    Color? color;

                    if (currentQues.isDone)
                      color = Colors.green[300];
                    else if (puzzle.hintShow)
                      color = Colors.yellow[100];
                    else if (currentQues.isFull)
                      color = Colors.red;
                    else
                      color = Color(0xff7EE7FD);

                    return InkWell(
                      onTap: () {
                        if (puzzle.hintShow || currentQues.isDone) return;
                        audioCache.play(AssetSource('sounds/click_sound.mp3'));

                        currentQues.isFull = false;
                        puzzle.clearValue();
                        setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: constraints.biggest.width / 7 - 6,
                        height: constraints.biggest.width / 7 - 6,
                        margin: const EdgeInsets.all(3),
                        child: Text(
                          "${puzzle.currentValue ?? ''}".toUpperCase(),
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1,
                crossAxisCount: 8,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: currentQues.arrayBtns.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                bool statusBtn = currentQues.puzzles
                        .indexWhere((puzzle) => puzzle.currentIndex == index) >=
                    0;

                return LayoutBuilder(
                  builder: (context, constraints) {
                    Color color =
                        statusBtn ? Colors.black : const Color(0xff7EE7FD);

                    return Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: TextButton(
                        child: Text(
                          "${currentQues.arrayBtns[index]}".toUpperCase(),
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          // handle button press
                          if (!statusBtn) {
                            setBtnClick(index);
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void generatePuzzle({
    List<WordFindQues>? loop,
    bool next = false,
    bool left = false,
  }) {
    if (loop != null) {
      indexQues = 0;
      this.listQuestions.addAll(loop);
    } else {
      if (next && indexQues < listQuestions.length - 1)
        indexQues++;
      else if (left && indexQues > 0)
        indexQues--;
      else if (indexQues >= listQuestions.length - 1) return;

      setState(() {});

      if (this.listQuestions[indexQues].isDone) return;
    }

    WordFindQues currentQues = listQuestions[indexQues];

    // Generate list of characters including answer characters and random characters
    final String answer = currentQues.answer.toUpperCase();
    List<String> characters = answer.split('');

    Random random = Random();
    while (characters.length < 16) {
      characters.add(String.fromCharCode(65 + random.nextInt(26)));
    }

    // Shuffle the characters to make the puzzle grid
    characters.shuffle();

    currentQues.arrayBtns = characters;

    bool isDone = currentQues.isDone;
    if (!isDone) {
      currentQues.puzzles = List.generate(answer.length, (index) {
        return WordFindChar(correctValue: answer[index]);
      });
    }

    hintCount = 0;
    setState(() {});
  }

  Future<void> setBtnClick(int index) async {
    WordFindQues currentQues = listQuestions[indexQues];
    await audioCache.play(AssetSource('sounds/click_sound.mp3'));

    int currentIndexEmpty =
        currentQues.puzzles.indexWhere((puzzle) => puzzle.currentValue == null);

    if (currentIndexEmpty >= 0) {
      currentQues.puzzles[currentIndexEmpty].currentIndex = index;
      currentQues.puzzles[currentIndexEmpty].currentValue =
          currentQues.arrayBtns[index];
      if (currentQues.fieldCompleteCorrect()) {
        audioCache.play(AssetSource('sounds/correct_sound.mp3'));
        currentQues.isDone = true;
        setState(() {});
        if (indexQues >= listQuestions.length - 1) {
          await Future.delayed(Duration(seconds: 1));
          Common.showCompletionDialog(context, resetGame);
        } else {
          await Future.delayed(Duration(seconds: 1));
          generatePuzzle(next: true);
        }
      } else if (currentQues.puzzles
          .every((puzzle) => puzzle.currentValue != null)) {
        audioCache.play(AssetSource('sounds/error_sound.mp3'));
        Common.showErrorDialog(context);
      }

      setState(() {});
    }
  }

  void resetGame() {
    setState(() {
      indexQues = 0;
      hintCount = 0;
      listQuestions.forEach((ques) {
        ques.isDone = false;
        ques.puzzles.forEach((puzzle) {
          puzzle.clearValue();
        });
      });
      generatePuzzle();
    });
  }

  generateHint() async {
    WordFindQues currentQues = listQuestions[indexQues];
    for (var item in currentQues.puzzles) {
      print("item:  ${item.correctValue}");
    }
    List<WordFindChar> puzzleNoHints = currentQues.puzzles
        .where((puzzle) => !puzzle.hintShow && puzzle.currentIndex == null)
        .toList();

    if (puzzleNoHints.isNotEmpty) {
      hintCount++;
      int indexHint = Random().nextInt(puzzleNoHints.length);
      int countTemp = 0;
      print("hint $indexHint");

      currentQues.puzzles = currentQues.puzzles.map((puzzle) {
        if (!puzzle.hintShow && puzzle.currentIndex == null) countTemp++;

        if (indexHint == countTemp - 1) {
          puzzle.hintShow = true;
          puzzle.currentValue = puzzle.correctValue;

          puzzle.currentIndex = currentQues.arrayBtns
              .indexWhere((btn) => btn == puzzle.correctValue);
        }

        return puzzle;
      }).toList();

      // check if complete
      if (currentQues.fieldCompleteCorrect()) {
        currentQues.isDone = true;
        setState(() {});
        await Future.delayed(const Duration(seconds: 1));
        generatePuzzle(next: true);
      }

      // my wrong..not refresh.. damn..haha
      setState(() {});
    }
  }
}
