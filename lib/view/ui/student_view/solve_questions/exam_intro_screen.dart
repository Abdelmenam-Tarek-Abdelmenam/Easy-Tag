import 'package:auto_id/view/ui/student_view/solve_questions/user_exam_screen.dart';
import 'package:flutter/material.dart';
import '../../../../model/module/exam_question.dart';
import '../../../shared/functions/navigation_functions.dart';


class IntroExamScreen extends StatefulWidget {
  const IntroExamScreen(this.quiz,{Key? key}) : super(key: key);
  final Quiz quiz;

  @override
  _IntroExamScreenState createState() => _IntroExamScreenState();
}

class _IntroExamScreenState extends State<IntroExamScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0,backgroundColor: Colors.white,),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              const Text('Quiz',style: TextStyle(fontSize: 50,fontWeight: FontWeight.w100),),
              const SizedBox(height: 20,),
              Text(widget.quiz.title,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w300),),
               Text('${widget.quiz.questions.length} question in ${widget.quiz.timeout.inMinutes} min',
                style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w300),),
              const SizedBox(height: 20,),
              const Text('when you are ready click start',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w300),),
              const SizedBox(height: 20,),
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
              const SizedBox(height: 20,),
              const Text("Note\nAfter clicking on start you can't attempt the quiz again",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.deepOrange),),
            ],
          ),
        ),
      ),
    );
  }

  void startButton(){
    navigateAndReplace(context,UserExamScreen(testQuiz));
    // write the id of the quiz to user to not attend again
  }
}
