import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Question {
  List<bool> rightAnswer;
  late List<bool> chosenAnswer;
  String text;
  String? img;
  String? hint;
  List<String> answers;

  Question(
      {required this.text,
      required this.answers,
      this.img,
      this.hint,
      required this.rightAnswer}) {
    resetAnswers;
  }

  bool get checkQuestion {
    return const ListEquality().equals(rightAnswer, chosenAnswer);
  }

  factory Question.empty() {
    return Question(
        text: "",
        answers: List.generate(4, (index) => ''),
        rightAnswer: List.generate(4, (index) => false));
  }

  bool get isEmpty => !rightAnswer.contains(true);
  void get resetAnswers {
    chosenAnswer = List.filled(rightAnswer.length, false);
  }

  bool get isSingleAnswer =>
      rightAnswer.where((element) => element).length == 1;

  void changeAnswer(int index) {
    chosenAnswer[index] = !chosenAnswer[index];
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
        text: json['text'],
        img: json['img'],
        hint: json['hint'],
        rightAnswer: List<bool>.from(json['rightAnswer']),
        answers: List<String>.from(json['answers']));
  }

  Map<String, dynamic> get toJson => {
        "text": text,
        "img": img,
        "hint": hint,
        "rightAnswer": rightAnswer,
        "answers": answers
      };

  Widget get questionWidget => Container();
}

class Quiz {
  late List<Question> questions;
  late Duration timeout;
  late String title;
  late String? description;

  set setTimeout(int? minutes) {
    if (minutes != null) timeout = Duration(minutes: minutes);
  }

  String get getRandomText => questions[0].answers[0].split(' ')[0];

  Quiz({
    required int timeOutMinutes,
    required this.questions,
    required this.title,
    this.description,
  }) {
    timeout = Duration(minutes: timeOutMinutes);
  }

  factory Quiz.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Quiz.empty();
    }
    return Quiz(
        questions: json['questions']
            .map<Question>((e) => Question.fromJson(e))
            .toList(),
        title: json['title'],
        description: json['description'],
        timeOutMinutes: json['timeOutMinutes']);
  }

  factory Quiz.empty() {
    return Quiz(
      questions: [],
      title: "",
      description: "",
      timeOutMinutes: 0,
    );
  }
  bool get isEmpty => questions.isEmpty;
  bool get checkWrongQuiz {
    if (questions.isEmpty) return true;
    for (Question question in questions) {
      if (question.isEmpty) return true;
    }
    return false;
  }

  int get minutes => timeout.inMinutes;
  int get length => questions.length;

  Map<String, dynamic> get toJson => {
        "questions": questions.map((e) => e.toJson).toList(),
        "title": title,
        "description": description,
        "timeOutMinutes": timeout.inMinutes
      };

  int get calculateScore {
    int score = 0;
    for (int i = 0; i < questions.length; i++) {
      if (questions[i].checkQuestion) {
        score++;
      }
    }
    return score;
  }
}

class StudentQuiz {
  Quiz quiz;
  bool takenBefore;
  int? score;

  StudentQuiz(this.quiz, this.takenBefore, this.score);
}

class AdminQuiz {
  Quiz quiz;
  List<int> scores;

  AdminQuiz(this.quiz, this.scores);

  factory AdminQuiz.empty() {
    return AdminQuiz(Quiz.empty(), []);
  }

  factory AdminQuiz.fromJson(Map<String, dynamic>? json) {
    if (json == null) return AdminQuiz.empty();

    Quiz quiz = Quiz.fromJson(json);
    List<String> removes = [
      'questions',
      'title',
      'description',
      'timeOutMinutes'
    ];
    json.removeWhere((key, value) => removes.contains(key));

    return AdminQuiz(quiz, List<int>.from(json.values));
  }
}
