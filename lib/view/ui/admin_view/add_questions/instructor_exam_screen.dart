import 'dart:io';
import 'package:auto_id/model/module/exam_question.dart';
import 'package:auto_id/view/resources/color_manager.dart';
import 'package:auto_id/view/shared/functions/dialogs.dart';
import 'package:auto_id/view/ui/admin_view/add_questions/widgets/histogram.dart';
import 'package:auto_id/view/ui/admin_view/add_questions/widgets/quiz_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../bloc/admin_exam_cubit/admin_exam_bloc.dart';
import '../../../shared/functions/image_functions.dart';
import '../../../shared/functions/navigation_functions.dart';
import '../../../shared/widgets/app_bar.dart';
import '../add_group/widgets/view_photo.dart';

class InstructorExamScreen extends StatelessWidget {
  final String id;
  final ImageHelper imageHelper = ImageHelper();
  final PageController _pageController = PageController(initialPage: 0);

  InstructorExamScreen(this.id, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (_) => AdminExamBloc(id)..getCourseQuestion(id),
      child: BlocConsumer<AdminExamBloc, AdminExamStates>(
        listener: (context, state) {
          if (state.status == AdminExamStatus.addQuestion) {
            _pageController.animateToPage(state.quiz.questions.length,
                duration: const Duration(seconds: 1), curve: Curves.ease);
          } else if (state.status == AdminExamStatus.uploadedQuiz) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) => Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                child: const Icon(Icons.file_copy_outlined),
                onPressed: () {
                  context.read<AdminExamBloc>().getQuestionFromFile();
                },
              ),
              FloatingActionButton(
                child: const Icon(Icons.save_outlined),
                onPressed: () {
                  customChoiceDialog(context,
                      title: "Confirmation",
                      content: "Are you sure you want to upload the quiz?",
                      yesFunction: () =>
                          context.read<AdminExamBloc>().saveQuiz());
                },
              ),
              FloatingActionButton(
                child: const Icon(Icons.remove_red_eye_outlined),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return Dialog(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Histogram(state.scores,
                              'Scores for ${state.scores.length} students'),
                          //  contentPadding: const EdgeInsets.all(0.0),
                        );
                      });
                },
              ),
              FloatingActionButton(
                child: const Icon(Icons.delete_outline_outlined),
                onPressed: () {
                  customChoiceDialog(context,
                      title: "Warning",
                      content: "Are you sure you want to delete the exam",
                      yesFunction: () {});
                },
              )
            ],
          ),
          appBar: appBar('Add Quiz', actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: OutlinedButton.icon(
                  onPressed: () =>
                      context.read<AdminExamBloc>().addQuizToFireStore(),
                  icon: state.status == AdminExamStatus.uploadingQuiz
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.done),
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
            child: Builder(
              builder: (context) {
                AdminExamBloc cubit = context.read<AdminExamBloc>();
                switch (state.status) {
                  case AdminExamStatus.quizLoading:
                    return const Center(child: CircularProgressIndicator());
                  case AdminExamStatus.error:
                    return const Text("An Error happened ");
                  default:
                    return Column(
                      children: [
                        _getTitle(context, state.activePage, state.quiz.length),
                        Expanded(
                          child: PageView(
                            controller: _pageController,
                            onPageChanged: (index) => cubit.changePage(index),
                            children: [
                              QuizDetailsPage(state.quiz),
                              ...List.generate(state.quiz.length, (i) => i)
                                  .map((i) => questionDesign(context, cubit, i))
                            ],
                          ),
                        ),
                      ],
                    );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget questionDesign(
      BuildContext context, AdminExamBloc cubit, int questionIndex) {
    Quiz quiz = cubit.state.quiz;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: ColorManager.blackColor.withOpacity(0.4),
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
                  controller: TextEditingController(
                      text: quiz.questions[questionIndex].text),
                  onChanged: (text) {
                    quiz.questions[questionIndex].text = text;
                  },
                  keyboardType: TextInputType.multiline,
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
                  controller: TextEditingController(
                      text: quiz.questions[questionIndex].hint),
                  onChanged: (text) {
                    quiz.questions[questionIndex].hint = text;
                  },
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Optional Hint',
                    hintText: 'Enter the hint',
                  ),
                ),
                cubit.state.status == AdminExamStatus.loadingImage
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: LinearProgressIndicator(
                          minHeight: 8,
                        ),
                      )
                    : questionImage(
                        context, cubit, quiz.questions[questionIndex].img),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Divider(
                    thickness: 1,
                  ),
                ),
                ListView.separated(
                  separatorBuilder: (_, __) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        height: 7,
                      ),
                    );
                  },
                  primary: false,
                  shrinkWrap: true,
                  itemCount: quiz.questions[questionIndex].answers.length,
                  itemBuilder: (ctx, index) {
                    return Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(
                                text: quiz
                                    .questions[questionIndex].answers[index]),
                            onChanged: (text) {
                              quiz.questions[questionIndex].answers[index] =
                                  text;
                            },
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Answer ${index + 1}',
                              hintText: 'Enter the answer ${index + 1}',
                            ),
                          ),
                        ),
                        Transform.scale(
                          scale: 2,
                          child: Checkbox(
                            shape: const CircleBorder(),
                            fillColor: MaterialStateProperty.all(Colors.green),
                            overlayColor: MaterialStateProperty.all(Colors.red),
                            value: quiz
                                .questions[questionIndex].rightAnswer[index],
                            onChanged: (value) {
                              cubit.changeAnswerState(index, value ?? false);
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.deepOrange)),
                            onPressed: cubit.removeLastAnswer,
                            child: const Text('remove last')),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.blue)),
                            onPressed: cubit.addAnswer,
                            child: const Text('add new')),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget questionImage(BuildContext context, AdminExamBloc cubit, String? img) {
    return img == null
        ? TextButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(ColorManager.blackColor),
                foregroundColor:
                    MaterialStateProperty.all(Colors.white.withOpacity(0.8))),
            onPressed: () =>
                pickImageAndUpload(context, cubit.state.activePage),
            child: Row(
              children: const [
                Text('Select and Upload image'),
                Spacer(),
                Icon(Icons.image),
                Icon(Icons.upload),
              ],
            ))
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () => navigateAndPush(context, ViewPhoto(img)),
                  child: Row(
                    children: const [
                      Text('Image uploaded '),
                      Icon(Icons.done),
                      Text(' click to view'),
                    ],
                  )),
              IconButton(
                  onPressed: cubit.removeImageQuestion,
                  icon: const Icon(
                    Icons.close,
                    color: Colors.deepOrange,
                  ))
            ],
          );
  }

  Widget _getTitle(BuildContext context, int page, int? len) => Padding(
        padding: const EdgeInsets.only(left: 15, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              page == -1 ? 'Quiz details' : 'Question ${page + 1}/$len',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w200),
            ),
            Row(
              children: [
                IconButton(
                    onPressed: context.read<AdminExamBloc>().removeQuestion,
                    icon: const Icon(
                      Icons.clear,
                      size: 30,
                      color: Colors.red,
                    )),
                IconButton(
                    onPressed: context.read<AdminExamBloc>().addQuestion,
                    icon: const Icon(
                      Icons.add_circle_sharp,
                      size: 30,
                      color: Colors.green,
                    )),
              ],
            )
          ],
        ),
      );

  void pickImageAndUpload(BuildContext context, int index) async {
    XFile? photo = await imageHelper.takePhoto(context);
    if (photo != null) {
      context.read<AdminExamBloc>().changeQuestionState();
      String link = await imageHelper.uploadFile(File(photo.path));
      context.read<AdminExamBloc>().changeQuestionImage(link, index);
    }
  }
}
