import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communicate_this/QuestionListWidget.dart';
import 'package:communicate_this/QuestionsRepository.dart';
import 'package:communicate_this/bloc.dart';
import 'package:flutter/material.dart';

class QuizListBloc extends Bloc {
  Stream<List<Quiz>> get quizes => Firestore.instance
      .collection("quiz")
      .snapshots()
      .map((snapshot) => snapshot.documents
          .map((doc) => Quiz(doc.documentID, doc.data["name"] as String))
          .toList());

  @override
  void dispose() {}
}

class QuizListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Quiz>>(
      stream: BlocProvider.of<QuizListBloc>(context).quizes,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _quizList(snapshot.data);
        }
        if (snapshot.hasError) {
          throw Exception(snapshot.error);
        }

        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text("None.");
          case ConnectionState.waiting:
            return const Text("Waiting.");
          default:
            throw Exception(
                "Unexpected connectionState: ${snapshot.connectionState}");
        }
      },
    );
  }

  Widget _quizList(List<Quiz> items) => ListView.builder(
      itemCount: items.length,
      itemBuilder: (c, index) {
        return _QuizListItemWidget(items[index]);
      });
}

class _QuizListItemWidget extends StatelessWidget {
  final Quiz _quiz;

  const _QuizListItemWidget(this._quiz, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, QuestionListWidget.route,
            arguments: QuestionListScreenArguments(_quiz.id, _quiz.name));
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(children: [
            Text(_quiz.name),
          ]),
        ),
      ),
    );
  }
}
