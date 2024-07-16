import 'WordFindQues.dart';

class WordFindGame {
  List<WordFindQues> listQuestions = [];

  WordFindGame() {
    listQuestions = [
      WordFindQues(
        question: "What is name of this game?",
        answer: "mario",
        pathImage: "assets/images/mario_img.jpeg",
      ),
      WordFindQues(
        question: "What is this animal?",
        answer: "cat",
        pathImage: "assets/images/cat_img.jpeg",
      ),
      WordFindQues(
        question: "What is this animal name?",
        answer: "wolf",
        pathImage: "assets/images/wolf_img.jpg",
      ),
    ];
  }
}
