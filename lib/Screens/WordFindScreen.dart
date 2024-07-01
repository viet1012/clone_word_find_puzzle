import 'package:flutter/material.dart';

import '../Modals/WordFindGame.dart';
import '../Modals/WordFindQues.dart';
import '../Widgets/WordFindWidget.dart';

class WordFindScreen extends StatefulWidget {
  const WordFindScreen({super.key});

  @override
  State<WordFindScreen> createState() => _WordFindScreenState();
}

class _WordFindScreenState extends State<WordFindScreen> {
  // make list question for puzzle
  // make class 1st
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
      body: SafeArea(
        child: Container(
          color: Colors.green,
          child: Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      color: Colors.blue,
                      // lets make our word find widget
                      // sent list to our widget
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
                child: TextButton(
                  onPressed: () {
                    // reload btn test
                  },
                  child: Text("reload"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
