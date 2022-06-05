import 'package:auto_id/view/resources/color_manager.dart';
import 'package:auto_id/view/shared/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../../model/module/exam_question.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen(this.quiz, this.timeScore, {Key? key}) : super(key: key);
  final Quiz quiz;
  final int timeScore;

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool showResult = false;
  int studentScore = 0;

  @override
  void initState() {
    super.initState();
    calcScore();

    // here upload result to firebase
    // use shared preferences if no network state
    // take considerations for this : user start the quiz but close the app before upload the result
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Quiz Result'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(0),
                        color: Colors.black12),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                          child: Text(
                        widget.quiz.title,
                        style: const TextStyle(fontSize: 20),
                      )),
                    )),
                Wrap(
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  children: [
                    SizedBox.square(
                      dimension: 280,
                      child: CircularPercentIndicator(
                        onAnimationEnd: () {
                          setState(() {
                            showResult = true;
                          });
                        },
                        radius: 120,
                        lineWidth: 3,
                        animation: true,
                        circularStrokeCap: CircularStrokeCap.round,
                        curve: Curves.easeOut,
                        linearGradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0xff0AA1DD),
                              Color(0xff2155CD),
                            ]),
                        percent: studentScore / widget.quiz.questions.length,
                        animationDuration: 800,
                        center: AnimatedSwitcher(
                          switchInCurve: Curves.elasticOut,
                          duration: const Duration(milliseconds: 800),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                                scale: animation, child: child);
                          },
                          child: showResult
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          studentScore.toString(),
                                          style: const TextStyle(
                                            fontSize: 80,
                                            color: ColorManager.blackColor,
                                          ),
                                        ),
                                        Text(
                                          '/${widget.quiz.questions.length}',
                                          style: const TextStyle(
                                              fontSize: 30,
                                              color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${((studentScore / widget.quiz.questions.length) * 100).toStringAsFixed(2)}%',
                                      style: const TextStyle(
                                          fontSize: 25,
                                          color: Color(0xff143F6B)),
                                    ),
                                    Text(
                                      '${widget.timeScore ~/ 60} min, ${widget.timeScore % 60} sec',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Color(0xff143F6B)),
                                    ),
                                  ],
                                )
                              : Container(),
                        ),
                        //progressColor: Colors.green,
                      ),
                    ),
                    Column(
                      children: [
                        const Text('Correct Answers'),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Wrap(
                            children: List.generate(
                                widget.quiz.questions.length,
                                (index) => Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          size: 30,
                                          color: widget.quiz.questions[index]
                                                  .checkQuestion
                                              ? const Color(0xff6BCB77)
                                              : Colors.deepOrange,
                                        ),
                                        Text(
                                          '${index + 1}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ],
                                    )),
                          ),
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all(
                                  const Size(180, 40)),
                              shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  side: BorderSide(
                                    width: 0,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Text(
                                  'Finish',
                                  style: TextStyle(fontSize: 25),
                                ),
                                Icon(
                                  Icons.done_rounded,
                                  size: 40,
                                ),
                              ],
                            )),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void calcScore() {
    for (Question element in widget.quiz.questions) {
      if (element.checkQuestion) {
        studentScore++;
      }
    }
  }
}
