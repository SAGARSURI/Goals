import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/goal.dart';
import '../models/other_goal.dart';
import '../utils/strings.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class GoalsBloc {
  final _repository = Repository();
  final _title = BehaviorSubject<String>();
  final _goalMessage = BehaviorSubject<String>();
  final _showProgress = BehaviorSubject<bool>();

  Observable<String> get name => _title.stream.transform(_validateName);

  Observable<String> get goalMessage =>
      _goalMessage.stream.transform(_validateMessage);

  Observable<bool> get showProgress => _showProgress.stream;

  Function(String) get changeName => _title.sink.add;

  Function(String) get changeGoalMessage => _goalMessage.sink.add;

  final _validateMessage = StreamTransformer<String, String>.fromHandlers(
      handleData: (goalMessage, sink) {
    if (goalMessage.length > 10) {
      sink.add(goalMessage);
    } else {
      sink.addError(StringConstant.goalValidateMessage);
    }
  });

  final _validateName = StreamTransformer<String, String>.fromHandlers(
      handleData: (String name, sink) {
    if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]').hasMatch(name)) {
      sink.addError(StringConstant.nameValidateMessage);
    } else {
      sink.add(name);
    }
  });

  void submit(String email) {
    _showProgress.sink.add(true);
    _repository
        .uploadGoal(email, _title.value, _goalMessage.value)
        .then((value) {
      _showProgress.sink.add(false);
    });
  }

  void extractText(var image) {
    _repository.extractText(image).then((text) {
      _goalMessage.sink.add(text);
    });
  }

  Stream<DocumentSnapshot> myGoalsList(String email) {
    return _repository.myGoalList(email);
  }

  Stream<QuerySnapshot> othersGoalList() {
    return _repository.othersGoalList();
  }

  //dispose all open sink
  void dispose() async {
    await _goalMessage.drain();
    _goalMessage.close();
    await _title.drain();
    _title.close();
    await _showProgress.drain();
    _showProgress.close();
  }

  //Convert map to goal list
  List mapToList({DocumentSnapshot doc, List<DocumentSnapshot> docList}) {
    if (docList != null) {
      List<OtherGoal> goalList = [];
      docList.forEach((document) {
        String email = document.data[StringConstant.emailField];
        Map<String, String> goals =
            document.data[StringConstant.goalField] != null
                ? document.data[StringConstant.goalField].cast<String, String>()
                : null;
        if (goals != null) {
          goals.forEach((title, message) {
            OtherGoal otherGoal = OtherGoal(email, title, message);
            goalList.add(otherGoal);
          });
        }
      });
      return goalList;
    } else {
      Map<String, String> goals = doc.data[StringConstant.goalField] != null
          ? doc.data[StringConstant.goalField].cast<String, String>()
          : null;
      List<Goal> goalList = [];
      if (goals != null) {
        goals.forEach((title, message) {
          Goal goal = Goal(title, message);
          goalList.add(goal);
        });
      }
      return goalList;
    }
  }

  //Remove item from the goal list
  void removeGoal(String title, String email) {
    return _repository.removeGoal(title, email);
  }
}
