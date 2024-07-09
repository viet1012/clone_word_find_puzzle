import 'WordFindChar.dart';

class WordFindQues {
  String question;
  String pathImage;
  String answer;
  bool isDone = false;
  bool isFull = false;
  List<WordFindChar> puzzles = [];
  List<String> arrayBtns = [];

  WordFindQues({
    required this.pathImage,
    required this.question,
    required this.answer,
  });

  void setWordFindChar(List<WordFindChar> puzzles) => this.puzzles = puzzles;

  void setIsDone() => isDone = true;

  bool fieldCompleteCorrect() {
    for (var puzzle in puzzles) {
      if (puzzle.currentValue != puzzle.correctValue) {
        return false;
      }
    }
    return true;
  }

  WordFindQues clone() {
    return WordFindQues(
      answer: answer,
      pathImage: pathImage,
      question: question,
    );
  }
}
