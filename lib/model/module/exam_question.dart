import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class Question2 {
  String text;
  String? img;
  String? hint;
  List<String> answers;

  Question2({
    required this.text,
    required this.answers,
    this.hint,
    this.img,
  });

  bool get checkQuestion;
  Map<String, dynamic> get toJson;
  Widget get questionWidget;
}

class TrueFalseQuestion extends Question2 {
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
            answers: answers);

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
        "rightAnswer": rightAnswer,
        "answers": answers
      };

  @override
  bool get checkQuestion => rightAnswer == chosenAnswer;

  @override
  Widget get questionWidget => Container();
}

class OneChoiceQuestion extends Question2 {
  int rightAnswer;
  int? chosenAnswer;

  OneChoiceQuestion(
      {required String text,
      required List<String> answers,
      String? img,
      String? hint,
      required this.rightAnswer})
      : super(
            text: text,
            img: img,
            answers: answers,
            hint: hint);

  @override
  bool get checkQuestion => rightAnswer == chosenAnswer;

  factory OneChoiceQuestion.fromJson(Map<String, dynamic> json) {
    return OneChoiceQuestion(
        text: json['text'],
        img: json['img'],
        hint: json['hint'],
        rightAnswer: json['rightAnswer'],
        answers: json['answers']);
  }

  @override
  Map<String, dynamic> get toJson => {
        "type": "OneChoiceQuestion",
        "text": text,
        "img": img,
        "hint": hint,
        "rightAnswer": rightAnswer,
        "answers": answers
      };

  @override
  Widget get questionWidget => Container();
}

class MultipleChoiceQuestion extends Question2 {
  List<int> rightAnswer;
  late List<int> chosenAnswer;

  MultipleChoiceQuestion(
      {required String text,
      required List<String> answers,
      String? img,
      String? hint,
      required this.rightAnswer})
      : super(
            text: text,
            img: img,
            answers: answers,
            hint: hint){
    chosenAnswer = List.filled(rightAnswer.length,0);
  }

  @override
  bool get checkQuestion{
    // Set<int> rightAnswerSet = rightAnswer.toSet();
    // Set<int> chosenAnswerSet = chosenAnswer.toSet();
    // int rightAnswersLen = chosenAnswerSet.intersection(rightAnswerSet).length;
    // return rightAnswersLen == rightAnswerSet.length;
    return  const ListEquality().equals(rightAnswer,chosenAnswer);
  }

  factory MultipleChoiceQuestion.fromJson(Map<String, dynamic> json) {
    return MultipleChoiceQuestion(
        text: json['text'],
        img: json['img'],
        hint: json['hint'],
        rightAnswer: json['rightAnswer'],
        answers: json['answers']);
  }

  @override
  Map<String, dynamic> get toJson => {
        "type": "MultipleChoiceQuestion",
        "text": text,
        "img": img,
        "hint": hint,
        "rightAnswer": rightAnswer,
        "answers": answers
      };

  @override
  Widget get questionWidget => Container();
}

// ---------------------------------------------------------------
class Quiz {
  Quiz({
    required this.questions,
    required timeOutMinutes,
    required this.title,
    this.description,
    required this.id,}){
    timeout = Duration(minutes: timeOutMinutes);
  }

  late  List<MultipleChoiceQuestion> questions;
  late  Duration timeout;
  late  String title;
  final String id;
  late  String? description;

  set setTimeout(int minutes) {
   timeout = Duration(minutes: minutes) ;
  }

}

// class Question {
//   Question({
//     required this.questionText,
//     required this.image,
//     required this.answers,
//     required this.correctAnswer,
//   });
//
//   final String questionText;
//   final String image;
//   final List<String> answers;
//   final int correctAnswer;
// }
  //  -------------------------  example of data

// List<Question> questions = [
//   Question(
//       questionText: 'What is the most easy programming language ?',
//       image: 'none',
//       answers: ['C++', 'Python', 'Java', 'Kotlin'],
//       correctAnswer: 1),
//   Question(
//       questionText: 'Flutter Apps Use ..... programming language.',
//       image: 'https://assets-global.website-files.com/5e469aaf314e562ff1146d3f/5feb0f4527cc9976b63dd88c_big-bang-mockup.png',
//       answers: ['C#', 'Ruby', 'Java', 'Dart', 'Other'],
//       correctAnswer: 3),
//   Question(
//       questionText: 'Solve this equation : \n2+2 = ....',
//       image: 'none',
//       answers: ['4', '6', '8', '10'],
//       correctAnswer: 0),
//   Question(
//       questionText: 'HTML consider as Programming Language',
//       image: 'none',
//       answers: ['Yes', 'No'],
//       correctAnswer: 1),
// ];

Quiz testQuiz = Quiz(
    id: 'fe586wf68gf6d6p6l4gr46gs',
    questions: questions,
    timeOutMinutes:  2,

    title: 'IOT First Session Quiz');


List<MultipleChoiceQuestion> questions = [
  MultipleChoiceQuestion(
      text: 'What is the most easy programming language ?',
      hint: 'from simple point of view',
      answers: ['C++', 'Python', 'Java', 'Kotlin'],
      rightAnswer: [0,1,0,0]),
  MultipleChoiceQuestion(
      text: 'Flutter Apps Use ..... programming language.',
      img: 'https://assets-global.website-files.com/5e469aaf314e562ff1146d3f/5feb0f4527cc9976b63dd88c_big-bang-mockup.png',
      answers: ['C#', 'Ruby', 'Java', 'Dart', 'Other'],
      rightAnswer: [0,0,0,1,0]),
  MultipleChoiceQuestion(
      text: 'Solve this equation : \n2+2 = ....',
      hint: 'Do not use calculator',
      answers: ['4', '6', '8', '10'],
      rightAnswer: [1,0,0,0]),
  MultipleChoiceQuestion(
      text: 'HTML consider as Programming Language',
      answers: ['Yes', 'No'],
      rightAnswer: [0,1]),
  MultipleChoiceQuestion(
      text: 'Select all numbers can divide by 3 !',
      hint: 'Do not use calculator',
      answers: ['3', '4', '9', '12'],
      rightAnswer: [1,0,1,1]),
];

