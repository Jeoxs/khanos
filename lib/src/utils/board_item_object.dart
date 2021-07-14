import 'package:khanos/src/models/task_model.dart';

class BoardItemObject {
  String title;
  TaskModel taskContent;

  BoardItemObject({this.title, this.taskContent}) {
    if (this.title == null) {
      this.title = "";
    }
    if (this.taskContent == null) {
      this.taskContent = null;
    }
  }
}
