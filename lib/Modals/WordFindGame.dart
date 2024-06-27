import 'WordFindQues.dart';

class WordFindGame {
  List<WordFindQues> listQuestions = [];

  WordFindGame() {
    listQuestions = [
      WordFindQues(
        question: "What is name of this game?",
        answer: "mario",
        pathImage:
            "https://images.pexels.com/photos/163077/mario-yoschi-figures-funny-163077.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
      ),
      WordFindQues(
        question: "What is this animal?",
        answer: "cat",
        pathImage:
            "https://images.pexels.com/photos/617278/pexels-photo-617278.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
      ),
      WordFindQues(
        question: "What is this animal name?",
        answer: "wolf",
        pathImage:
            "https://as1.ftcdn.net/v2/jpg/02/48/64/04/1000_F_248640483_5KAZi0GqcWrBu6GOhFEAxk1quNEuOzHJ.jpg",
      ),
    ];
  }
}
