import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Subject {
  String courseTitle;
  String courseCode;
  String gradeAchieved;
  double gradePoints = 10.0;
  double courseCredits;
  String semester;

  Subject({
    required this.courseTitle,
    required this.courseCode,
    required this.gradeAchieved,
    required this.courseCredits,
    required this.semester,
  }) {
    calculateGradePoints();
  }

  void calculateGradePoints() {
    switch (gradeAchieved) {
      case 'A':
        gradePoints = 10.0;
        break;
      case 'A-':
        gradePoints = 9.0;
        break;
      case 'B':
        gradePoints = 8.0;
        break;
      case 'B-':
        gradePoints = 7.0;
        break;
      case 'C':
        gradePoints = 6.0;
        break;
      case 'C-':
        gradePoints = 5.0;
        break;
      case 'D':
        gradePoints = 4.0;
        break;
      case 'E':
        gradePoints = 3.0;
      default:
        gradePoints = 0.0;
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CGPA Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Subject> subjects = [];
  double totalCredits = 0.0;
  double totalGradePoints = 0.0;

  bool isDarkMode = false;

  get semController => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         appBar: AppBar(
                     title: const Text('CGPA Calculator'),
                     actions: [
                     IconButton(
                           icon: const Icon(Icons.brightness_4),
                             onPressed: () {
                             setState(() {
                             isDarkMode = !isDarkMode;
    });
    },
    ),
    ],
      ),
      body: ListView.builder(
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Course: ${subjects[index].courseTitle}',
                         semanticsLabel: 'Code: ${subjects[index].courseCode}\n'),
                subtitle: Text ('Grade: ${subjects[index].gradeAchieved}\n',
                semanticsLabel: 'Credits: ${subjects[index].courseCredits}'),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _showAddSubjectDialog();
            },
            tooltip: 'Add Subject',
            child: Icon(Icons.add),
          ),
          SizedBox(height: 16.0),
          FloatingActionButton(
            onPressed: () {
              _calculateCGPA();
            },
            tooltip: 'Calculate CGPA',
            child: Icon(Icons.calculate),
          ),
        ],
      ),
    );
  }

  void _showAddSubjectDialog() {
    TextEditingController titleController = TextEditingController();
    TextEditingController codeController = TextEditingController();
    TextEditingController gradeController = TextEditingController();
    TextEditingController creditsController = TextEditingController();
    TextEditingController semController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Subject'),
          content: Column(
            children: [
              TextField(
                controller: semController,
                decoration: const InputDecoration(labelText: 'Semester Selected'),
              ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Course Title'),
              ),
              TextField(
                controller: codeController,
                decoration: const InputDecoration(labelText: 'Course Code'),
              ),
              TextField(
                controller: gradeController,
                decoration: const InputDecoration(labelText: 'Grade Achieved'),
              ),
              TextField(
                controller: creditsController,
                decoration: const InputDecoration(labelText: 'Course Credits'),
                keyboardType: TextInputType.number,
              ),

            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addSubject(
                  titleController.text,
                  codeController.text,
                  gradeController.text,
                  double.parse(creditsController.text),
                  semController.text,
                );
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addSubject(
      String title,
      String code,
      String grade,
      double credits,
      String sem,
      ) {
    Subject newSubject = Subject(
      courseTitle: title,
      courseCode: code,
      gradeAchieved: grade,
      courseCredits: credits,
      semester: sem,
    );

    setState(() {
      subjects.add(newSubject);
      totalCredits += credits;
      totalGradePoints += newSubject.gradePoints * credits;
    });
  }

  void _calculateCGPA() {
    if (totalCredits == 0.0) {
      _showMessage('Add at least one subject before calculating CGPA');
      return;
    }

    double cgpa = totalGradePoints / totalCredits;

    _showMessage('Your CGPA is: ${cgpa.toStringAsFixed(2)}');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3600),
    ));
  }
}
