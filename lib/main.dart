import 'package:communicate_this/QuestionListWidget.dart';
import 'package:communicate_this/QuizListWidget.dart';
import 'package:communicate_this/bloc.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: "Quizes"),
        QuestionListWidget.route: (context) {
          final args = ModalRoute.of(context).settings.arguments
              as QuestionListScreenArguments;
          return BlocProvider(
              bloc: QuestionListBloc(args.quizId), child: QuestionListWidget());
        }
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: BlocProvider(bloc: QuizListBloc(), child: QuizListWidget()),
      ),
    );
  }
}
