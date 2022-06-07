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
        rightAnswer: json['rightAnswer'],
        answers: json['answers']);
  }

  Map<String, dynamic> get toJson => {
        "type": "MultipleChoiceQuestion",
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
