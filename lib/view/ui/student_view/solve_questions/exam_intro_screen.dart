import 'dart:async';

import 'package:auto_id/view/shared/widgets/app_bar.dart';
import 'package:auto_id/view/ui/student_view/solve_questions/user_exam_screen.dart';
import 'package:flutter/material.dart';
import '../../../../model/module/exam_question.dart';
import '../../../shared/functions/navigation_functions.dart';
import 'package:lottie/lottie.dart';

class IntroExamScreen extends StatefulWidget {
  const IntroExamScreen(this.quiz,{Key? key}) : super(key: key);
  final Quiz quiz;

  @override
  _IntroExamScreenState createState() => _IntroExamScreenState();
}

class _IntroExamScreenState extends State<IntroExamScreen> with TickerProviderStateMixin{
  bool startCounter = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Quiz'),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: startCounter? Lottie.asset('images/lottie/counter.json',
         repeat: false,
        )
            :Wrap(
          spacing: 20,
          runSpacing: 20,
          runAlignment: WrapAlignment.center,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children:  [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  const SizedBox(height: 20,),
                  Text(widget.quiz.title,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w300),),
                  Text('${widget.quiz.questions.length} question in ${widget.quiz.timeout.inMinutes} min',
                    style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w300),),

                  const Text('when you are ready click start',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w300),),

                  const Text("Note\nAfter clicking on start you can't attempt the quiz again",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.deepOrange),),
                ],
              ),
            ),
            TextButton(
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(const Size(120,120)),
                  shape: MaterialStateProperty.all(
                    const CircleBorder(
                      side: BorderSide(
                        width: 1,
                        color: Colors.blue,),),),),
                onPressed: () => startButton(),
                child: const Text('Start',style: TextStyle(fontSize: 30),)),
          ],
        ),
      ),
    );
  }

  void startButton(){
    setState(() {
      startCounter = true;
    });
    Timer(const Duration(seconds: 3),(){
      navigateAndReplaceNormal(context,UserExamScreen(testQuiz));
    });

    // write the id of the quiz to user to not attend again
  }
}
