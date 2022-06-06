import 'dart:async';
import 'package:auto_id/view/ui/student_view/solve_questions/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import '../../../../model/module/exam_question.dart';
import '../../../shared/functions/navigation_functions.dart';
import '../../../shared/widgets/dialog.dart';

class UserExamScreen extends StatefulWidget {
  const UserExamScreen(this.quiz, {Key? key}) : super(key: key);
  final Quiz quiz;

  @override
  _UserExamScreenState createState() => _UserExamScreenState();
}

class _UserExamScreenState extends State<UserExamScreen> {
  final PageController _controller = PageController(initialPage: 0);
  String txt = '....';
  double progressValue = 1;
  late Timer _timer;

  @override
  void initState() {
    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    super.initState();
    _timer = Timer.periodic(
        const Duration(seconds: 1), (timer) => timerTick(timer, context));
  }

  @override
  dispose() {
    _timer.cancel();
    super.dispose();
    FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () => dialog(context),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 200,
                              child: Text(
                                widget.quiz.title,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )),
                          const Spacer(),
                          Text(
                            txt,
                            style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
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
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: PageView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _controller,
                      children: List.generate(
                          widget.quiz.questions.length,
                          (page) => SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Visibility(
                                      visible:
                                          widget.quiz.questions[page].img ==
                                                  null
                                              ? false
                                              : true,
                                      child: InteractiveViewer(
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              widget.quiz.questions[page].img ??
                                                  '',
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(
                                            Icons.error,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            widget.quiz.questions[page].text,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue),
                                          ),
                                        ),
                                        widget.quiz.questions[page].hint == null
                                            ? Container()
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                child: Text(
                                                  widget.quiz.questions[page]
                                                          .hint ??
                                                      '',
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black87),
                                                ),
                                              ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: widget.quiz.questions[page]
                                            .answers.length,
                                        itemBuilder: (ctx, index) {
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                if (widget.quiz.questions[page]
                                                    .chosenAnswer[index]) {
                                                  widget.quiz.questions[page]
                                                      .chosenAnswer[index];
                                                } else {
                                                  widget.quiz.questions[page]
                                                      .chosenAnswer[index];
                                                }
                                              });
                                            },
                                            child: Card(
                                              //color: selectedIndex == index? Colors.black45.withOpacity(0.2) : null,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                  side: BorderSide(
                                                      width: widget
                                                                  .quiz
                                                                  .questions[page]
                                                                  .chosenAnswer[
                                                              index]
                                                          ? 2
                                                          : 1,
                                                      color: widget
                                                              .quiz
                                                              .questions[page]
                                                              .chosenAnswer[index]
                                                          ? Colors.blue
                                                          : Colors.black45)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Text(
                                                  widget.quiz.questions[page]
                                                      .answers[index],
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: widget
                                                              .quiz
                                                              .questions[page]
                                                              .chosenAnswer[index]
                                                          ? Colors.blue
                                                          : Colors.black),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                              ))),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: FutureBuilder(builder: (ctx, snapshot) {
        return SingleChildScrollView(
          child: Container(
            color: const Color(0xff205375),
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
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                          icon: const Icon(Icons.arrow_back_ios),
                          label: Text(
                            (_controller.page ?? 0) == 0 ? 'Exit' : 'Back',
                            style: const TextStyle(fontSize: 20),
                          )),
                      Text(
                        'Question ${(_controller.page ?? 0).ceil() + 1}/${widget.quiz.questions.length}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextButton.icon(
                            onPressed: () => nextButton(),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white)),
                            icon: const Icon(Icons.arrow_back_ios),
                            label: Text(
                              widget.quiz.questions.length - 1 ==
                                      _controller.page
                                  ? 'Submit'
                                  : 'Next',
                              style: const TextStyle(fontSize: 20),
                            )),
                      ),
                    ],
                  ),
                  Wrap(
                    children: List.generate(
                        widget.quiz.questions.length,
                        (index) => InkWell(
                              onTap: () => onQuestionTap(index),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 35,
                                    color: index == (_controller.page ?? 0)
                                        ? const Color(0xffEFEFEF)
                                        : Colors.blue.withOpacity(0),
                                  ),
                                  Icon(
                                    Icons.circle,
                                    size: 30,
                                    color: !widget
                                            .quiz.questions[index].chosenAnswer
                                            .contains(true)
                                        ? const Color(0xff112B3C)
                                        : const Color(0xffFF8C32),
                                  ),
                                  Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ],
                              ),
                            )),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  void nextButton() {
    _controller
        .nextPage(
            duration: const Duration(milliseconds: 400), curve: Curves.easeIn)
        .then((value) => setState(() {}));

    if (_controller.page == widget.quiz.questions.length - 1) {
      gotoResults(context, widget.quiz);
    }
  }

  void backButton() {
    _controller
        .previousPage(
            duration: const Duration(milliseconds: 400), curve: Curves.easeIn)
        .then((value) => setState(() {}));

    if (_controller.page == 0) {
      dialog(context).then((value) {
        if (value) {
          Navigator.pop(context);
        }
      });
    }
  }

  void onQuestionTap(index) {
    _controller
        .animateToPage(index,
            duration: const Duration(milliseconds: 400), curve: Curves.easeIn)
        .then((value) => setState(() {}));
  }

  void gotoResults(context, quiz) {
    navigateAndReplaceNormal(context, ResultScreen(quiz, _timer.tick));
  }

  void timerTick(Timer timer, BuildContext context) {
    setState(() {
      Duration timeRemaining =
          Duration(seconds: widget.quiz.timeout.inSeconds - timer.tick);
      txt = '${timeRemaining.inMinutes}:${timeRemaining.inSeconds % 60}';
      progressValue = (widget.quiz.timeout.inSeconds - timer.tick) /
          widget.quiz.timeout.inSeconds;

      if (timer.tick >= widget.quiz.timeout.inSeconds) {
        timer.cancel();
        txt = 'Timeout';
        Timer(const Duration(seconds: 1), () {
          gotoResults(context, widget.quiz);
        });
      }
    });
  }
}
