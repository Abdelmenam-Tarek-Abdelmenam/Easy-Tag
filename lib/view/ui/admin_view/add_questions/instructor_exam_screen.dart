import 'dart:io';
import 'package:auto_id/model/module/exam_question.dart';
import 'package:auto_id/view/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../bloc/admin_exam_bloc/admin_exam_bloc.dart';
import '../../../shared/functions/image_functions.dart';
import '../../../shared/functions/navigation_functions.dart';
import '../../../shared/widgets/app_bar.dart';
import '../add_group/widgets/view_photo.dart';

class InstructorExamScreen extends StatefulWidget {
  const InstructorExamScreen({Key? key}) : super(key: key);

  @override
  _InstructorExamScreenState createState() => _InstructorExamScreenState();
}

class _InstructorExamScreenState extends State<InstructorExamScreen> {
  ImageHelper imageHelper = ImageHelper();
  Quiz quiz = testQuiz;

  final PageController _pageController = PageController(initialPage: 0);
  int currentPage = 0;
  bool loading = false;

  late TextEditingController quizController =
      TextEditingController(text: quiz.title);
  late TextEditingController quizDescriptionController =
      TextEditingController(text: quiz.description);
  late TextEditingController quizTimeController =
      TextEditingController(text: quiz.timeout.inMinutes.toString());

  late List<TextEditingController> questionController = List.generate(
      quiz.questions.length,
      (index) => TextEditingController(text: quiz.questions[index].text));
  late List<TextEditingController> questionHintController = List.generate(
      quiz.questions.length,
      (index) => TextEditingController(text: quiz.questions[index].hint));

  late List<List<TextEditingController>> answerControllers = List.generate(
      quiz.questions.length,
      (index) => List.generate(
          quiz.questions[index].answers.length,
          (i) =>
              TextEditingController(text: quiz.questions[index].answers[i])));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Add Quiz', actions: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: OutlinedButton.icon(
              onPressed: () =>
                  context.read<AdminExamBloc>().add(const UploadQuizEvent()),
              icon: const Icon(Icons.done),
              label: const Text(
                'Done',
                style: TextStyle(fontSize: 18),
              )),
        ),
      ]),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    currentPage == 0
                        ? 'Title and Duration'
                        : 'Question $currentPage/${quiz.questions.length}',
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.w200),
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: removeQuestion,
                          icon: const Icon(
                            Icons.clear,
                            size: 30,
                            color: Colors.red,
                          )),
                      IconButton(
                          onPressed: addQuestion,
                          icon: const Icon(
                            Icons.add_circle_sharp,
                            size: 30,
                            color: Colors.green,
                          )),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  PageView(
                    controller: _pageController,
                    onPageChanged: onPageChanged,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      ColorManager.blackColor.withOpacity(0.4),
                                  blurRadius: 3,
                                  spreadRadius: 0)
                            ],
                            color: const Color(0xffEEEEEE),
                            borderRadius: BorderRadius.circular(15)),
                        child: SingleChildScrollView(
                          child: Form(
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                TextField(
                                  controller: quizController,
                                  onChanged: (text) {
                                    quiz.title = text;
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Quiz title',
                                    hintText: 'Enter the Quiz title',
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          controller: quizTimeController,
                                          onChanged: (text) {
                                            quiz.setTimeout = int.parse(text);
                                          },
                                          style: const TextStyle(fontSize: 40),
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintStyle: TextStyle(fontSize: 20),
                                            labelStyle: TextStyle(fontSize: 18),
                                            labelText: 'Quiz Time Duration',
                                            hintText: 'Enter minutes',
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: decreaseDuration,
                                      child: const Icon(
                                        Icons.remove,
                                        size: 40,
                                      ),
                                      style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.red),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  ColorManager.blackColor),
                                          fixedSize: MaterialStateProperty.all(
                                              const Size.square(70))),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    ElevatedButton(
                                      onPressed: increaseDuration,
                                      child: const Icon(
                                        Icons.add,
                                        size: 40,
                                      ),
                                      style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.green),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  ColorManager.blackColor),
                                          fixedSize: MaterialStateProperty.all(
                                              const Size.square(70))),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  controller: quizDescriptionController,
                                  onChanged: (text) {
                                    quiz.description = text;
                                  },
                                  keyboardType: TextInputType.multiline,
                                  minLines: 3,
                                  maxLines: 10,
                                  decoration: const InputDecoration(
                                    counterText: "Optional",
                                    border: OutlineInputBorder(),
                                    labelText: 'Quiz Description',
                                    hintText: 'Enter the Quiz Description',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ...quiz.questions
                          .asMap()
                          .map((i, question) => MapEntry(
                              i,
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 10),
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: ColorManager.blackColor
                                              .withOpacity(0.4),
                                          blurRadius: 3,
                                          spreadRadius: 0)
                                    ],
                                    color: const Color(0xffEEEEEE),
                                    borderRadius: BorderRadius.circular(15)),
                                child: SingleChildScrollView(
                                  child: Form(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          TextField(
                                            controller: questionController[i],
                                            onChanged: (text) {
                                              quiz.questions[i].text = text;
                                            },
                                            keyboardType:
                                                TextInputType.multiline,
                                            minLines: 1,
                                            maxLines: 8,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Question',
                                              hintText: 'Enter the question',
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          TextField(
                                            controller:
                                                questionHintController[i],
                                            onChanged: (text) {
                                              quiz.questions[i].hint = text;
                                            },
                                            keyboardType:
                                                TextInputType.multiline,
                                            minLines: 1,
                                            maxLines: 3,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Optional Hint',
                                              hintText: 'Enter the hint',
                                            ),
                                          ),
                                          quiz.questions[i].img == null
                                              ? TextButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(ColorManager
                                                                  .blackColor),
                                                      foregroundColor:
                                                          MaterialStateProperty
                                                              .all(Colors.white
                                                                  .withOpacity(
                                                                      0.8))),
                                                  onPressed: pickImageAndUpload,
                                                  child: Row(
                                                    children: const [
                                                      Text(
                                                          'Select and Upload image'),
                                                      Spacer(),
                                                      Icon(Icons.image),
                                                      Icon(Icons.upload),
                                                    ],
                                                  ))
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    TextButton(
                                                        onPressed:
                                                            viewQuestionImage,
                                                        child: Row(
                                                          children: const [
                                                            Text(
                                                                'Image uploaded '),
                                                            Icon(Icons.done),
                                                            Text(
                                                                ' click to view'),
                                                          ],
                                                        )),
                                                    IconButton(
                                                        onPressed:
                                                            removeImageQuestion,
                                                        icon: const Icon(
                                                          Icons.close,
                                                          color:
                                                              Colors.deepOrange,
                                                        ))
                                                  ],
                                                ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            child: Divider(
                                              thickness: 1,
                                            ),
                                          ),
                                          ListView.separated(
                                            separatorBuilder: (_, __) {
                                              return const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20),
                                                child: SizedBox(
                                                  height: 7,
                                                ),
                                              );
                                            },
                                            primary: false,
                                            shrinkWrap: true,
                                            itemCount:
                                                answerControllers[i].length,
                                            itemBuilder: (ctx, index) {
                                              return Row(
                                                children: [
                                                  Expanded(
                                                    child: TextField(
                                                      controller:
                                                          answerControllers[i]
                                                              [index],
                                                      onChanged: (text) {
                                                        quiz.questions[i]
                                                                .answers[
                                                            index] = text;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            const OutlineInputBorder(),
                                                        labelText:
                                                            'Answer ${index + 1}',
                                                        hintText:
                                                            'Enter the answer ${index + 1}',
                                                      ),
                                                    ),
                                                  ),
                                                  Transform.scale(
                                                    scale: 2,
                                                    child: Checkbox(
                                                      shape:
                                                          const CircleBorder(),
                                                      fillColor:
                                                          MaterialStateProperty
                                                              .all(
                                                                  Colors.green),
                                                      overlayColor:
                                                          MaterialStateProperty
                                                              .all(Colors.red),
                                                      value: quiz.questions[i]
                                                                  .rightAnswer[
                                                              index] ==
                                                          1,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          quiz.questions[i]
                                                                  .rightAnswer[
                                                              index] = (value ??
                                                                  false)
                                                              ? 1
                                                              : 0;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5),
                                                  child: ElevatedButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .deepOrange)),
                                                      onPressed:
                                                          removeLastAnswer,
                                                      child: const Text(
                                                          'remove last')),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  child: ElevatedButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .blue)),
                                                      onPressed: addAnswer,
                                                      child: const Text(
                                                          'add new')),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )))
                          .values
                          .toList(),
                    ],
                  ),
                  loading
                      ? Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.black87.withOpacity(0.75),
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  CircularProgressIndicator(
                                    strokeWidth: 1,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Uploading...',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextButton(
                                  onPressed: () {}, child: const Text('Cancel'))
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void pickImageAndUpload() async {
    XFile? photo = await imageHelper.takePhoto(context);
    if (photo != null) {
      setState(() {
        loading = true;
      });

      String link = await imageHelper.uploadFile(File(photo.path));

      setState(() {
        quiz.questions[currentPage - 1].img = link;
        loading = false;
      });
    }
  }

  void removeQuestion() {
    setState(() {
      if (currentPage == 0) {
        return;
      }
      quiz.questions.removeAt(currentPage - 1);
      if (currentPage > quiz.questions.length) {
        currentPage = quiz.questions.length;
      }
      refreshControllers();
    });
  }

  void addQuestion() {
    setState(() {
      quiz.questions.add(Question(
          text: '', answers: ['', '', '', ''], rightAnswer: [0, 0, 0, 0]));

      refreshControllers();
      currentPage = quiz.questions.length;
      _pageController.animateToPage(quiz.questions.length,
          duration: const Duration(seconds: 1), curve: Curves.ease);
    });
  }

  void viewQuestionImage() {
    navigateAndPush(context, ViewPhoto(quiz.questions[currentPage - 1].img!));
  }

  void removeImageQuestion() {
    setState(() {
      quiz.questions[currentPage - 1].img = null;
    });
  }

  void increaseDuration() {
    int minutes = int.parse(quizTimeController.text.trim());
    setState(() {
      quizTimeController.text = (minutes + 1).toString();
      quiz.setTimeout = minutes;
    });
  }

  void decreaseDuration() {
    int minutes = int.parse(quizTimeController.text.trim());
    if (minutes > 1) {
      setState(() {
        quizTimeController.text = (minutes - 1).toString();
        quiz.setTimeout = minutes;
      });
    }
  }

  void onPageChanged(int index) {
    setState(() {
      currentPage = index;
    });
  }

  void removeLastAnswer() {
    setState(() {
      if (answerControllers[currentPage - 1].length != 2) {
        answerControllers[currentPage - 1].removeLast();
        quiz.questions[currentPage - 1].rightAnswer.removeLast();
        quiz.questions[currentPage - 1].answers.removeLast();
      }
    });
  }

  void addAnswer() {
    setState(() {
      if (answerControllers[currentPage - 1].length != 10) {
        answerControllers[currentPage - 1].add(TextEditingController());
        quiz.questions[currentPage - 1].rightAnswer.add(0);
        quiz.questions[currentPage - 1].answers.add('');
      }
    });
  }

  void refreshControllers() {
    quizController = TextEditingController(text: quiz.title);
    quizDescriptionController = TextEditingController(text: quiz.description);
    quizTimeController =
        TextEditingController(text: quiz.timeout.inMinutes.toString());

    questionController = List.generate(quiz.questions.length,
        (index) => TextEditingController(text: quiz.questions[index].text));
    questionHintController = List.generate(quiz.questions.length,
        (index) => TextEditingController(text: quiz.questions[index].hint));

    answerControllers = List.generate(
        quiz.questions.length,
        (index) => List.generate(
            quiz.questions[index].answers.length,
            (i) =>
                TextEditingController(text: quiz.questions[index].answers[i])));
  }
}
