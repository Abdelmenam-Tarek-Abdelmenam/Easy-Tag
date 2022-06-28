import 'package:auto_id/model/module/exam_question.dart';
import 'package:auto_id/view/shared/responsive.dart';
import 'package:auto_id/view/ui/admin_view/add_questions/widgets/duration_buttons.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../resources/color_manager.dart';

class QuizDetailsPage extends StatelessWidget {
  final Quiz quiz;
  const QuizDetailsPage(this.quiz, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.all( Responsive.isMobile(context)? 10: 40),
      margin: const EdgeInsets.all(10),
      decoration:  BoxDecoration(
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
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              titleForm(),
              const SizedBox(
                height: 10,
              ),
              durationForm(),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: TextEditingController(text: quiz.title),
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
    );
  }

  Widget titleForm() => TextField(
        controller: TextEditingController(text: quiz.title),
        onChanged: (text) {
          quiz.title = text;
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Quiz title',
          hintText: 'Enter the Quiz title',
        ),
      );

  Widget durationForm() => StatefulBuilder(
      builder: (context, setState) => Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller:
                        TextEditingController(text: quiz.minutes.toString()),
                    keyboardType: TextInputType.number,
                    onChanged: (text) {
                      quiz.setTimeout = int.tryParse(text.trim());
                    },
                    style: const TextStyle(fontSize: 40),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
              DurationButton(
                  onPressed: () => setState(() {
                        quiz.setTimeout = quiz.timeout.inMinutes - 1;
                      }),
                  icon: Icons.remove,
                  color: Colors.red),
              const SizedBox(
                width: 10,
              ),
              DurationButton(
                  onPressed: () => setState(() {
                        quiz.setTimeout = quiz.timeout.inMinutes + 1;
                      }),
                  icon: Icons.add,
                  color: Colors.green),
            ],
          ));

  Widget descriptionForm() => TextField(
        controller: TextEditingController(text: quiz.title),
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
      );
}
