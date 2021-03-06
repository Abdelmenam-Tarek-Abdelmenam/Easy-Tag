import 'dart:async';
import 'package:auto_id/bloc/student_exam_bloc/student_exam_bloc.dart';
import 'package:auto_id/view/shared/widgets/app_bar.dart';
import 'package:auto_id/view/ui/student_view/solve_questions/user_exam_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/functions/navigation_functions.dart';

class IntroExamScreen extends StatefulWidget {
  const IntroExamScreen(this.id, {Key? key}) : super(key: key);
  final String id;

  @override
  _IntroExamScreenState createState() => _IntroExamScreenState();
}

class _IntroExamScreenState extends State<IntroExamScreen> {
  bool startCounter = false;

  @override
  void initState() {
    context.read<StudentExamBloc>().getCourseQuestion(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Quiz'),
      body: BlocConsumer<StudentExamBloc, StudentExamStates>(
        listener: (_, state) {
          if (state.status == StudentExamStatus.loadedUpload) {
            navigateAndReplaceNormal(context, UserExamScreen(state.quiz));
          } else if (state.status == StudentExamStatus.error) {
            startCounter = false;
          }
        },
        builder: (context, state) {
          switch (state.status) {
            case StudentExamStatus.quizLoading:
              return const Center(child: CircularProgressIndicator());
            case StudentExamStatus.noExam:
              return const Center(child: Text("No Exam for this course"));
            case StudentExamStatus.error:
              return const Center(child: Text("An Error happened "));
            case StudentExamStatus.getBefore:
              return Center(
                  child: Text(
                      "You get this exam before with score ${state.score}"));
            default:
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: startCounter
                    ? state.status == StudentExamStatus.loadingUpload
                        ? const Center(child: CircularProgressIndicator())
                        : Center(
                            child: SizedBox(
                                width: 300, height: 300, child: Container()

                                //           Lottie.asset(
                                //               'images/lottie/counter.json',
                                //               repeat: true,
                                // width: 300,
                                // height: 300,
                                //             ),
                                ),
                          )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    state.quiz.title,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  Text(
                                    '${state.quiz.questions.length} question in ${state.quiz.timeout.inMinutes} min',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  const Text(
                                    'when you are ready click start',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  const Text(
                                    "Note\nAfter clicking on start you can't attempt the quiz again",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepOrange),
                                  ),
                                ],
                              ),
                            ),
                            startButton(),
                          ],
                        ),
                      ),
              );
          }
        },
      ),
    );
  }

  Widget startButton() => TextButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(const Size(120, 120)),
        shape: MaterialStateProperty.all(
          const CircleBorder(
            side: BorderSide(
              width: 1,
              color: Colors.blue,
            ),
          ),
        ),
      ),
      onPressed: () => start(context),
      child: const Text(
        'Start',
        style: TextStyle(fontSize: 30),
      ));

  void start(BuildContext context) {
    setState(() {
      startCounter = true;
    });
    Timer(const Duration(seconds: 1), () {
      context.read<StudentExamBloc>().publishResults(0);
    });
  }
}
