import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(IndianMonumentsQuiz());
}

class IndianMonumentsQuiz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Indian Monuments Quiz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  // List of questions and their respective answers
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Which monument is in Agra?',
      'options': ['Taj Mahal', 'Qutub Minar', 'Red Fort', 'Hawa Mahal'],
      'correctAnswer': 'Taj Mahal'
    },
    {
      'question': 'Which city is home to the Red Fort?',
      'options': ['Mumbai', 'Delhi', 'Kolkata', 'Jaipur'],
      'correctAnswer': 'Delhi'
    },
    {
      'question': 'The Gateway of India is located in which city?',
      'options': ['Mumbai', 'Chennai', 'Kolkata', 'Varanasi'],
      'correctAnswer': 'Mumbai'
    },
    // Add more questions here
    {
      'question': 'The Hawa Mahal is in which Indian city?',
      'options': ['Jaipur', 'Agra', 'Delhi', 'Mumbai'],
      'correctAnswer': 'Jaipur'
    },
    {
      'question': 'Which monument is known as the "Victory Tower"?',
      'options': ['Qutub Minar', 'Charminar', 'India Gate', 'Buland Darwaza'],
      'correctAnswer': 'Qutub Minar'
    },
    {
      'question':
          'In which state is the famous temple complex of Hampi located?',
      'options': ['Karnataka', 'Tamil Nadu', 'Andhra Pradesh', 'Kerala'],
      'correctAnswer': 'Karnataka'
    },
    // Add more questions here
  ];

  // Variable to track the current question
  int _questionIndex = 0;

  // Function to handle selecting an option
  void _selectOption(String selectedAnswer) {
    setState(() {
      // Check if the selected answer is correct
      if (selectedAnswer == questions[_questionIndex]['correctAnswer']) {
        // Increment score or perform any other action
      }
      // Move to the next question
      _questionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Indian Monuments Quiz'),
      ),
      body: _questionIndex < questions.length
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  questions[_questionIndex]['question'],
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(height: 20.0),
                ...(questions[_questionIndex]['options'] as List<String>)
                    .map((option) {
                  return ElevatedButton(
                    onPressed: () => _selectOption(option),
                    child: Text(option),
                  );
                }).toList(),
              ],
            )
          : Center(
              child: Text(
                'Quiz Completed!',
                style: TextStyle(fontSize: 24.0),
              ),
            ),
    );
  }
}
