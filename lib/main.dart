import 'package:flutter/material.dart';
import 'quizbrain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Quizzler'),
          backgroundColor: Colors.blue[900],
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  QuizBrain quiz = QuizBrain();
  List<Icon> scores = [];
  bool showAlert = false;

  void checkAnswer(pickedAnswer) {
    bool correctAnswer = quiz.getAnswer();

    if (correctAnswer == pickedAnswer) {
      scores.add(Icon(
        Icons.check,
        color: Colors.green,
      ));
    } else {
      scores.add(Icon(
        Icons.close,
        color: Colors.red,
      ));
    }
  }

  void resetUI() {
    setState(() {
      quiz = QuizBrain();
      scores.clear();
      showAlert = false;
    });
  }

  void showAlertPrompt() {
    setState(() {
      showAlert = true;
    });
    Alert(
      context: context,
      style: AlertStyle(
        backgroundColor: Colors.blue.shade900,
        titleStyle: TextStyle(color: Colors.white),
        descStyle: TextStyle(color: Colors.white),
      ),
      title: "Game Over",
      desc: "Play again?",
      buttons: [
        DialogButton(
          color: Colors.white,
          child: Text(
            "Restart",
            style: TextStyle(color: Colors.blue.shade900, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
            resetUI();
          },
        ),
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quiz.getQuestion(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Card(
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.green),
                ),
                onPressed: () {
                  setState(() {
                    quiz.punch();
                    if (quiz.buttonPressed < 13) {
                      quiz.nextQuestion();
                    } else {
                      showAlertPrompt();
                    }
                    checkAnswer(true);
                  });
                },
                child: Text(
                  'True',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Card(
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.red),
                ),
                onPressed: () {
                  setState(
                    () {
                      quiz.punch();
                      if (quiz.buttonPressed < 13) {
                        quiz.nextQuestion();
                      } else {
                        showAlertPrompt();
                      }
                      checkAnswer(false);
                    },
                  );
                },
                child: Text(
                  'False',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        Row(
          children: scores,
        ),
      ],
    );
  }
}
