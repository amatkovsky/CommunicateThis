import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionsRepository {
  Stream<List<Question>> observeQuestions() => Firestore.instance
      .collection("test_questions")
      .snapshots()
      .map((snapshot) => snapshot.documents
          .map(
              (doc) => Question(doc.documentID, doc.data["question"] as String))
          .toList());

  Future<void> postQuestion(String questionText) {
    return Firestore.instance
        .collection("test_question")
        .add({"question": questionText});
  }

/*
  Firestore.instance.collection("test_questions").getDocuments().then(
        (value) => value.documents
            .map((doc) => Question(doc.documentID, doc.data["question"]))
            .toList())
    .then((value) => _sink.add(value));
   */

}

class Question {
  final String id;
  final String question;

  Question(this.id, this.question);
}
