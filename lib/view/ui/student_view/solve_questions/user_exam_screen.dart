import 'dart:async';
import 'package:auto_id/view/ui/student_view/solve_questions/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../model/module/exam_question.dart';
import '../../../shared/functions/navigation_functions.dart';

class UserExamScreen extends StatefulWidget {
  const UserExamScreen(this.quiz,{Key? key}) : super(key: key);
  final Quiz quiz ;
  @override
  _UserExamScreenState createState() => _UserExamScreenState();
}

class _UserExamScreenState extends State<UserExamScreen> {
  final PageController _controller = PageController(initialPage: 0);
  late List<int> studentAnswers ;


  @override
  void initState() {
    super.initState();
    studentAnswers = List.filled(widget.quiz.questions.length, -1);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TimerWidget(widget.quiz.timeout,widget.quiz.title),
              const SizedBox(height: 20,),
              Expanded(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (pageIndex){
                  },
                  controller: _controller,
                  children: List.generate(widget.quiz.questions.length, (page) => SingleChildScrollView(
                      child: Column(
                        children: [
                          Visibility(
                            visible: widget.quiz.questions[page].image != 'none',
                            child: InteractiveViewer(
                              child: CachedNetworkImage(
                                imageUrl: widget.quiz.questions[page].image ,
                                progressIndicatorBuilder: (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                const Icon(Icons.error, size: 30,),
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.white30,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(widget.quiz.questions[page].questionText,
                                style: const TextStyle(fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),),
                            ),
                          ),
                          const SizedBox(height: 20,),
                          ListView.builder(
                            shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: widget.quiz.questions[page].answers.length,
                              itemBuilder: (ctx,index){
                                return InkWell(
                                  onTap: (){
                                    setState(() {
                                      studentAnswers[page] = index;
                                    });
                                  },
                                  child: Card(
                                    //color: selectedIndex == index? Colors.black45.withOpacity(0.2) : null,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                                        side: BorderSide(
                                            width: studentAnswers[page] == index? 2:1,
                                            color: studentAnswers[page] == index? Colors.blue :Colors.black45
                                        )),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        widget.quiz.questions[page].answers[index]
                                        ,style:  TextStyle(fontSize: 18,
                                          color: studentAnswers[page] == index? Colors.blue : Colors.black),),
                                    ),
                                  ),
                                );
                              }),
                        ],
                      ),
                    ))
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(_controller,widget.quiz.questions.length,studentAnswers)
    );
  }
}

class TimerWidget extends StatefulWidget {
  const TimerWidget(this.timeOut,this.title,{Key? key}) : super(key: key);
  final Duration timeOut;
  final String title;
  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}
class _TimerWidgetState extends State<TimerWidget> {

  String txt = '....';
  double progressValue = 1;
  late Timer _timer ;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {

        setState(() {
          Duration timeRemaining = Duration(seconds: widget.timeOut.inSeconds - timer.tick);
          txt = '${timeRemaining.inMinutes}:${timeRemaining.inSeconds%60}';
          progressValue = (widget.timeOut.inSeconds - timer.tick)/widget.timeOut.inSeconds;

          if(timer.tick >= widget.timeOut.inSeconds){
            timer.cancel();
            txt = 'Timeout';
          }
        });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children:  [
              SizedBox(
                  width: 200,
                  child: Text(widget.title,
                    style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
              const Spacer(),
              Text(txt,
                style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.green),),
            ],
          ),
        ),
         LinearProgressIndicator(
          value: progressValue,
          minHeight: 3,
          color: Colors.blue,
          backgroundColor: Colors.white,
        ),
      ],
    );
  }
}

class BottomNavigation extends StatefulWidget {
   const BottomNavigation(this._controller,this.quizLength,this.studentAnswers,{Key? key}) : super(key: key);
   final PageController _controller ;
   final int quizLength;
   final List<int> studentAnswers;

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late List<int> questionsCircles ; // 0 'NotAnswered' ,  1 'Active' ,  2 'Answered',

  @override
  void initState() {
    super.initState();
    questionsCircles = List.filled(widget.quizLength, 0);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                    onPressed: () => backButton(),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue.withOpacity(0.1))),
                    icon: const Icon(Icons.arrow_back_ios),
                    label:  Text( widget._controller.page == 0  ? 'Exit':'Back',style: TextStyle(fontSize: 20),)),
                Text('Question ${(widget._controller.page??0).ceil() + 1 }/${widget.quizLength}'),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextButton.icon(
                      onPressed: () => nextButton(),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.blue.withOpacity(0.1))),
                      icon: const Icon(Icons.arrow_back_ios),
                      label: Text( widget.quizLength-1 == widget._controller.page ? 'Submit':'Next',style: const TextStyle(fontSize: 20),)),
                ),


              ],),

            Wrap(
              children:
              List.generate(widget.quizLength,
                      (index) => InkWell(
                    onTap: () => onQuestionTap(index),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.circle,size: 30,
                          // 0 'NotAnswered' ,  1 'Active' ,  2 'Answered',
                          //color:  [Colors.black,Colors.blue,Colors.green][ questionsCircles[index] ],),
                          color:  index == (widget._controller.page??0) ? Colors.blue :
                          widget.studentAnswers[index] == -1 ? Colors.black: Colors.indigo,
                        ),
                        Text('${index+1}',style: const TextStyle(color: Colors.white,fontSize: 12),),
                      ],),
                  ))
              ,)
          ],
        ),
      ),
    );
  }

  void nextButton(){
    widget._controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeIn).then((value) => setState(() {}));

    if( widget._controller.page  == widget.quizLength - 1 ){
      navigateAndReplace(context,ResultScreen(testQuiz,widget.studentAnswers));
    }
  }

  void backButton(){
    widget._controller.previousPage(duration: const Duration(milliseconds: 400),
        curve: Curves.easeIn).then((value) => setState(() {}));
  }

  void onQuestionTap(index) {
    widget._controller.animateToPage(index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeIn).then((value) =>  setState(() {
    }));

  }
}
