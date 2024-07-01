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
    bool complete =
        puzzles.where((puzzle) => puzzle.currentValue == null).isEmpty;

    if (!complete) {
      this.isFull = false;
      return complete;
    }

    this.isFull = true;

    String answeredString =
        this.puzzles.map((puzzle) => puzzle.currentValue).join("");

    return answeredString == this.answer;
  }

  WordFindQues clone() {
    return WordFindQues(
      answer: answer,
      pathImage: pathImage,
      question: question,
    );
  }
}
