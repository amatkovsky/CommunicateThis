import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communicate_this/bloc.dart';
import 'package:flutter/material.dart';

import 'QuestionsRepository.dart';

class QuestionListBloc extends Bloc {
  Stream<List<Question>> get questions => Firestore.instance
      .collection("test_questions")
      .snapshots()
      .map((snapshot) => snapshot.documents
          .map(
              (doc) => Question(doc.documentID, doc.data["question"] as String))
          .toList());

  @override
  void dispose() {}
}

class QuestionListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Question>>(
      stream: BlocProvider.of<QuestionListBloc>(context).questions,
      builder: (context, AsyncSnapshot<List<Question>> snapshot) {
        if (snapshot.hasData) {
          return _questionList(snapshot.data);
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

  Widget _questionList(List<Question> items) => ListView.builder(
      itemCount: items.length,
      itemBuilder: (c, index) {
        return _QuestionListItemWidget(items[index]);
      });
}

class _QuestionListItemWidget extends StatelessWidget {
  final Question _question;

  const _QuestionListItemWidget(this._question, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.antiAlias,
        child: GestureDetector(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Column(children: [
                Text(_question.question),
              ]),
            )));
  }
}
