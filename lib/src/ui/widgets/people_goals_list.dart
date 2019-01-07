import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../blocs/goals_bloc_provider.dart';
import 'package:firestore_demo/src/models/other_goal.dart';

class PeopleGoalsListScreen extends StatefulWidget {
  @override
  _PeopleGoalsListState createState() {
    return _PeopleGoalsListState();
  }
}

class _PeopleGoalsListState extends State<PeopleGoalsListScreen> {
  GoalsBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = GoalsBlocProvider.of(context);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0.0, 0.0),
      child: StreamBuilder(
        stream: _bloc.othersGoalList(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> docs = snapshot.data.documents;
            List<OtherGoal> goalsList = _bloc.mapToList(docList: docs);
            if (goalsList.isNotEmpty) {
              return buildList(goalsList);
            } else {
              return Text("No Goals");
            }
          } else {
            return Text("No Goals");
          }
        },
      ),
    );
  }

  ListView buildList(List<OtherGoal> goalsList) {
    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: goalsList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              goalsList[index].title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(goalsList[index].message),
            trailing: Text(
              goalsList[index].email,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        });
  }
}
