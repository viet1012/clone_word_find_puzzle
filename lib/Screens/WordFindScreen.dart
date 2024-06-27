import 'package:flutter/material.dart';

import '../Modals/WordFindGame.dart';
import '../Modals/WordFindQues.dart';

class WordFindScreen extends StatefulWidget {
  const WordFindScreen({super.key});

  @override
  State<WordFindScreen> createState() => _WordFindScreenState();
}

class _WordFindScreenState extends State<WordFindScreen> {
  late List<WordFindQues> listQuestions;

  @override
  void initState() {
    WordFindGame game = WordFindGame();
    listQuestions = game.listQuestions;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          color: Colors.green,
          child: Column(
            children: [
              Container(
                child: Row(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
