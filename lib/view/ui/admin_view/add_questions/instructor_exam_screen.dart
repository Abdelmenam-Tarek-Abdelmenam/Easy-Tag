import 'package:flutter/material.dart';

class InstructorExamScreen extends StatefulWidget {
  const InstructorExamScreen({Key? key}) : super(key: key);

  @override
  _InstructorExamScreenState createState() => _InstructorExamScreenState();
}

class _InstructorExamScreenState extends State<InstructorExamScreen> {
  TextEditingController questionController = TextEditingController();
  List<TextEditingController> answerControllers = List.generate(4, (index) => TextEditingController());
  List<bool> correctAnswer = List.generate(4, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      bottomNavigationBar:  TextButton(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.blueAccent),),
          onPressed: () {},
          child: const Text('Finish',style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),)),
      appBar: AppBar(
        title: const Text('Add Quiz'),
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      body: GestureDetector(
        onTap: (){},
        child: Container(
          color: Colors.white,
          child: PageView(
            children: [
              SingleChildScrollView(
                child: Form(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        TextField(
                          controller: questionController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Question',
                            hintText: 'Enter the question',
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {},
                            child: Row(
                              children: const [
                                Text('Upload image'),
                                Spacer(),
                                Icon(Icons.image)
                              ],
                            )),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          child: Divider(
                            thickness: 2,
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
                          itemCount: answerControllers.length,
                          itemBuilder: (ctx, index) {
                            return Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: questionController,
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
                                    value: correctAnswer[index],
                                    onChanged: (value) {
                                      setState(() {
                                        correctAnswer[index] = value ?? false;
                                      });
                                    },
                                  ),
                                ),

                              ],
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(Colors.deepOrange)),
                                    onPressed: () {
                                      setState(() {
                                        if (answerControllers.length != 2) {
                                          answerControllers.removeLast();
                                          correctAnswer.removeLast();
                                        }
                                      });
                                    },
                                    child: const Icon(
                                      Icons.remove,
                                      size: 30,
                                    )),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all(Colors.blue)),
                                    onPressed: () {
                                      setState(() {
                                        if (answerControllers.length != 10) {
                                          answerControllers.add(TextEditingController());
                                          correctAnswer.add(false);
                                        }
                                      });
                                    },
                                    child: const Icon(
                                      Icons.add,
                                      size: 30,
                                    )),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Form(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        TextField(
                          controller: questionController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Question',
                            hintText: 'Enter the question',
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {},
                            child: Row(
                              children: const [
                                Text('Upload image'),
                                Spacer(),
                                Icon(Icons.image)
                              ],
                            )),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          child: Divider(
                            thickness: 2,
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
                          itemCount: answerControllers.length,
                          itemBuilder: (ctx, index) {
                            return Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: questionController,
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
                                    value: correctAnswer[index],
                                    onChanged: (value) {
                                      setState(() {
                                        correctAnswer[index] = value ?? false;
                                      });
                                    },
                                  ),
                                ),

                              ],
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(Colors.deepOrange)),
                                    onPressed: () {
                                      setState(() {
                                        if (answerControllers.length != 2) {
                                          answerControllers.removeLast();
                                          correctAnswer.removeLast();
                                        }
                                      });
                                    },
                                    child: const Icon(
                                      Icons.remove,
                                      size: 30,
                                    )),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all(Colors.blue)),
                                    onPressed: () {
                                      setState(() {
                                        if (answerControllers.length != 10) {
                                          answerControllers.add(TextEditingController());
                                          correctAnswer.add(false);
                                        }
                                      });
                                    },
                                    child: const Icon(
                                      Icons.add,
                                      size: 30,
                                    )),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
