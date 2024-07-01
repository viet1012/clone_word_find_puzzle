import 'dart:math';

import 'package:flutter/material.dart';

import '../Modals/WordFindChar.dart';
import '../Modals/WordFindQues.dart';

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
                  child: Icon(
                    Icons.healing_outlined,
                    size: 45,
                    color: Colors.yellow[200],
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () => generatePuzzle(left: true),
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 45,
                        color: Colors.yellow[200],
                      ),
                    ),
                    InkWell(
                      onTap: () => generatePuzzle(next: true),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 45,
                        color: Colors.yellow[200],
                      ),
                    ),
                  ],
                )
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
                  // maxHeight: size.width / 2.5,
                ),
                child: Image.network(
                  currentQues.pathImage,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1,
                crossAxisCount: 8,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: 16, // later change
              shrinkWrap: true,
              itemBuilder: (context, index) {
                bool statusBtn = currentQues.puzzles
                        .indexWhere((puzzle) => puzzle.currentIndex == index) >=
                    0;

                return LayoutBuilder(
                  builder: (context, constraints) {
                    Color color =
                        statusBtn ? Colors.white70 : Color(0xff7EE7FD);

                    return Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // margin: ,
                      alignment: Alignment.center,
                      child: TextButton(
                        //  height: constraints.biggest.height,
                        child: Text(
                          "${currentQues.arrayBtns[index]}".toUpperCase(),
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          // if (!statusBtn) setBtnClick(index);
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

  void generateHint() {}

  void generatePuzzle({
    List<WordFindQues>? loop,
    bool next = false,
    bool left = false,
  }) {
    // Let's finish up generate puzzle
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

    setState(() {});

    final List<String> wl = [currentQues.answer];

    // Generate random word grid as a replacement
    Random random = Random();
    final int gridWidth = 16; // Width of the word grid
    final int gridHeight = 1; // Height of the word grid

    List<List<String>> randomGrid = List.generate(
      gridHeight,
      (row) => List.generate(
        gridWidth,
        (col) {
          int randomIndex = random.nextInt(
              26); // Generate random letter index (assuming 26 letters)
          return String.fromCharCode(
              65 + randomIndex); // Convert to random uppercase letter
        },
      ),
    );

    currentQues.arrayBtns = randomGrid.expand((list) => list).toList();
    currentQues.arrayBtns.shuffle(); // Shuffle the grid to hide the answer

    bool isDone = currentQues.isDone;

    if (!isDone) {
      currentQues.puzzles = List.generate(wl[0].split("").length, (index) {
        return WordFindChar(correctValue: currentQues.answer.split("")[index]);
      });
    }

    hintCount = 0; // Number of hints per question we hit
    setState(() {});
  }
}
