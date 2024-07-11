import 'package:clone_word_find_puzzle/common.dart';
import 'package:flutter/material.dart';

import '../Modals/WordFindGame.dart';
import '../Modals/WordFindQues.dart';
import '../Widgets/AppBarWidget.dart';
import '../Widgets/ButtonWidget.dart';
import '../Widgets/WordFindWidget.dart';

class WordFindScreen extends StatefulWidget {
  const WordFindScreen({super.key});

  @override
  State<WordFindScreen> createState() => _WordFindScreenState();
}

class _WordFindScreenState extends State<WordFindScreen> {
  GlobalKey<WordFindWidgetState> globalKey = GlobalKey();
  late List<WordFindQues> listQuestions;

  @override
  void initState() {
    WordFindGame game = WordFindGame();
    listQuestions = game.listQuestions;
    print("Số lượng câu hỏi: ${listQuestions.length}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
          title: 'Game 01',
          onPressed: () {
            Common.showInstructionsDialog(context,
                '- Arrange the letters in the grid to reveal the hidden word(s). Each puzzle provides an image clue to guide you.');
          }),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade50, Colors.teal.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      color: Colors.teal[50],
                      child: WordFindWidget(
                        constraints.biggest,
                        listQuestions.map((ques) => ques.clone()).toList(),
                        key: globalKey,
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: ReloadButton(onPressed: () {
                  setState(() {
                    listQuestions =
                        listQuestions.map((ques) => ques.clone()).toList();
                    globalKey.currentState?.generatePuzzle();
                  });
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
