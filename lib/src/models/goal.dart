class Goal {
  final String _title;
  final String _message;
  int _id;

  Goal(this._title, this._message){
    this._id = DateTime.now().millisecondsSinceEpoch;
  }

  String get title => _title;

  String get message => _message;

  int get id => _id;
}
