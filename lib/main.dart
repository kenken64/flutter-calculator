// import package
// ignore_for_file: library_private_types_in_public_api

import 'package:calculator/button.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

// main entry of the app
void main() => runApp(const MyApp());

// This is the calculator main widget
class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var userQuestion = '';
  var userAnswer = '';

  final myTextStyle = TextStyle(fontSize: 30, color: Colors.deepPurple[900]);

  final List<String> buttons = [
    'C',
    'DEL',
    '%',
    '/',
    '7',
    '8',
    '9',
    'x',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '0',
    '.',
    '',
    '='
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
        backgroundColor: Colors.deepPurple[100],
        body: Column(
            children: <Widget>[
              Expanded(
                  child: Container(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            const SizedBox(
                              height: 2,
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  userQuestion,
                                  style: const TextStyle(fontSize: 30, color: Colors.deepPurple)
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  userAnswer,
                                  style: const TextStyle(fontSize: 30, color: Colors.deepPurple)
                              ),
                            ),
                          ]
                      )
                  )
              ),
              Expanded(
                  flex: 3,
                  child: Container(
                    child: GridView.builder(
                        primary: false,
                        itemCount: buttons.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4),
                        itemBuilder: (BuildContext context, int index) {
                          // clear button
                          if(index == 0){
                            return MyButton(
                              buttonTapped: (){
                                print('clear button');
                                setState((){
                                  userQuestion = '';
                                  userAnswer = '';
                                });
                              },
                              buttonText: buttons[index],
                              color: Colors.green,
                              textColor: Colors.white,
                            );
                          }

                          // Delete button
                          else if (index == 1){
                            return MyButton(
                              buttonTapped: (){
                                setState((){
                                  userQuestion = userQuestion
                                      .substring(0, userQuestion.length-1);
                                });
                              },
                              buttonText: buttons[index],
                              color: Colors.red,
                              textColor: Colors.white,
                            );
                          }

                          // Equal button
                          else if (index == buttons.length - 1){
                            return MyButton(
                              buttonTapped: (){
                                equalPressed();
                              },
                              buttonText: buttons[index],
                              color: Colors.deepPurple,
                              textColor: Colors.white,
                            );
                          }

                          // Rest of the buttons
                          else {
                            return MyButton(
                              buttonTapped: (){
                                  setState((){
                                    userQuestion += buttons[index];
                                  });
                              },
                              buttonText: buttons[index],
                              color: isOperator(buttons[index])
                                  ? Colors.deepPurple
                                  : Colors.deepPurple[50],
                              textColor: isOperator(buttons[index])
                                  ? Colors.white
                                  : Colors.deepPurple,

                            );
                          }
                        }
                    ),
                  )
              )
            ]
        )
    );
  }

  bool isOperator(String x){
    if (x == '%' || x == '/' || x == 'x' || x == '-' || x == '+' || x == '='){
      return true;
    }
    return false;
  }

  void equalPressed() {
    String finalQuestion = userQuestion;
    finalQuestion = finalQuestion.replaceAll('x', '*');
    finalQuestion = finalQuestion.replaceAll('%', '*0.01');

    Parser p = Parser();
    Expression exp = p.parse(finalQuestion);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    setState((){
      userAnswer = eval.toString();
    });
  }
}
