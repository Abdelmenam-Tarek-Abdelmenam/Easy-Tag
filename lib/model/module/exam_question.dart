import 'package:flutter/material.dart';

abstract class Question {
  String text;
  String? img;
  String? hint;
  List<String> answers;
  int duration;

  Question({
    required this.text,
    required this.answers,
    required this.duration,
    this.hint,
    this.img,
  });

  bool get checkQuestion;
  Map<String, dynamic> get toJson;
  Widget get questionWidget;
}

class TrueFalseQuestion extends Question {
  bool rightAnswer;
  bool? chosenAnswer;

  TrueFalseQuestion(
      {required String text,
      required List<String> answers,
      required int duration,
      String? img,
      String? hint,
      required this.rightAnswer})
      : super(
            text: text,
            img: img,
            hint: hint,
            answers: answers,
            duration: duration);

  factory TrueFalseQuestion.fromJson(Map<String, dynamic> json) {
    return TrueFalseQuestion(
        text: json['text'],
        img: json['img'],
        duration: json['duration'],
        hint: json['hint'],
        rightAnswer: json['rightAnswer'],
        answers: json['answers']);
  }

  @override
  Map<String, dynamic> get toJson => {
        "type": "TrueFalseQuestion",
        "text": text,
        "img": img,
        "hint": hint,
        "duration": duration,
        "rightAnswer": rightAnswer,
        "answers": answers
      };

  @override
  bool get checkQuestion => rightAnswer == chosenAnswer;

  @override
  Widget get questionWidget => Container();
}

class OneChoiceQuestion extends Question {
  int rightAnswer;
  int? chosenAnswer;

  OneChoiceQuestion(
      {required String text,
      required List<String> answers,
      required int duration,
      String? img,
      String? hint,
      required this.rightAnswer})
      : super(
            text: text,
            img: img,
            answers: answers,
            duration: duration,
            hint: hint);

  @override
  bool get checkQuestion => rightAnswer == chosenAnswer;

  factory OneChoiceQuestion.fromJson(Map<String, dynamic> json) {
    return OneChoiceQuestion(
        text: json['text'],
        duration: json['duration'],
        img: json['img'],
        hint: json['hint'],
        rightAnswer: json['rightAnswer'],
        answers: json['answers']);
  }

  @override
  Map<String, dynamic> get toJson => {
        "type": "OneChoiceQuestion",
        "duration": duration,
        "text": text,
        "img": img,
        "hint": hint,
        "rightAnswer": rightAnswer,
        "answers": answers
      };

  @override
  Widget get questionWidget => Container();
}

class MultipleChoiceQuestion extends Question {
  List<int> rightAnswer;
  List<int>? chosenAnswer;

  MultipleChoiceQuestion(
      {required String text,
      required List<String> answers,
      required int duration,
      String? img,
      String? hint,
      required this.rightAnswer})
      : super(
            text: text,
            img: img,
            answers: answers,
            duration: duration,
            hint: hint);

  @override
  bool get checkQuestion {
    Set<int> rightAnswerSet = rightAnswer.toSet();
    Set<int>? chosenAnswerSet = chosenAnswer?.toSet();
    int? rightAnswersLen = chosenAnswerSet?.intersection(rightAnswerSet).length;
    return rightAnswersLen == rightAnswerSet.length;
  }

  factory MultipleChoiceQuestion.fromJson(Map<String, dynamic> json) {
    return MultipleChoiceQuestion(
        text: json['text'],
        img: json['img'],
        hint: json['hint'],
        duration: json['duration'],
        rightAnswer: json['rightAnswer'],
        answers: json['answers']);
  }

  @override
  Map<String, dynamic> get toJson => {
        "type": "MultipleChoiceQuestion",
        "text": text,
        "img": img,
        "hint": hint,
        "duration": duration,
        "rightAnswer": rightAnswer,
        "answers": answers
      };

  @override
  Widget get questionWidget => Container();
}
