import 'package:cloud_firestore/cloud_firestore.dart';

import 'firestore_provider.dart';
import 'mlkit_provider.dart';
class Repository{
  final _firestoreProvider = FirestoreProvider();
  final _mlkitProvider = MLkitProvider();

  Future<int> authenticateUser(String email, String password) => _firestoreProvider.authenticateUser(email,password);
  Future<void> registerUser(String email, String password) => _firestoreProvider.registerUser(email, password);
  Future<String> extractText(var image) => _mlkitProvider.getImage(image);
  Future<void> uploadGoal(String email, String title, String goal) => _firestoreProvider.uploadGoal(title, email, goal);
  Stream<DocumentSnapshot> myGoalList(String email) => _firestoreProvider.myGoalList(email);
  Stream<QuerySnapshot> othersGoalList() => _firestoreProvider.othersGoalList();

   removeGoal(String title, email) => _firestoreProvider.removeGoal(title, email);
}