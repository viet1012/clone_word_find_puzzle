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
      appBar: AppBar(
        title: Text('Word Find Game'),
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
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
                child: ElevatedButton(
                  onPressed: () {
                    // reload button action
                    setState(() {
                      listQuestions =
                          listQuestions.map((ques) => ques.clone()).toList();
                      globalKey.currentState?.generatePuzzle();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  ),
                  child: const Text(
                    "Reload",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
