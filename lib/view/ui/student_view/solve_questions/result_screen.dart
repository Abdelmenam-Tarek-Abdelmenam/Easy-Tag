import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../../model/module/exam_question.dart';


class ResultScreen extends StatefulWidget {
   const ResultScreen(this.quiz,this.studentAnswers,{Key? key}) : super(key: key);

  final Quiz quiz ;
  final List<int> studentAnswers ;
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 50,),
                const Text('Quiz Result',
                  style: TextStyle(fontSize: 30),),
                SizedBox.square(
                  dimension: 280,
                  child: CircularPercentIndicator(
                    radius: 120,
                    lineWidth: 3,
                    animation: true,
                    circularStrokeCap: CircularStrokeCap.round,
                    curve: Curves.bounceIn,
                    linearGradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                      Colors.blue,
                      Colors.lightBlue,
                    ]),
                    percent: 0.7,
                    animationDuration: 10,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(widget.studentAnswers.length.toString(),
                              style: const TextStyle(fontSize: 80,
                                  color: Colors.black45,
                              ),),
                            Text('/${widget.quiz.questions.length}',
                              style: const TextStyle(fontSize: 30),),
                          ],
                        ),
                        const Text('100%',
                          style: TextStyle(fontSize: 25),),
                      ],
                    ),
                    //progressColor: Colors.green,
                  ),
                ),
                const SizedBox(height: 30,),
                Wrap(children:
                  List.generate(widget.quiz.questions.length,
                          (index) => Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(Icons.circle,size: 30,
                                color:  widget.quiz.questions[index].correctAnswer == widget.studentAnswers[index] ? Colors.green : Colors.deepOrange,
                              ),
                              Text('${index+1}',style: const TextStyle(color: Colors.white,fontSize: 12),),
                            ],))
                  ,),
                const SizedBox(height: 30,),
                ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(180,40)),
                      shape: MaterialStateProperty.all(
                         const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          side: BorderSide(
                            width: 0,
                            color: Colors.blue,),),),),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Text('Finish',style: TextStyle(fontSize: 25),),
                        Icon(Icons.done_rounded,size: 40,),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
