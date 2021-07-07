import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kanboard/src/models/subtask_model.dart';
import 'package:kanboard/src/models/task_model.dart';
import 'package:kanboard/src/providers/subtask_provider.dart';
import 'package:kanboard/src/providers/task_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:kanboard/src/utils/widgets_utils.dart';
import 'package:kanboard/src/utils/theme_utils.dart';

class SubtaskPage extends StatefulWidget {
  @override
  _SubtaskPageState createState() => _SubtaskPageState();
}

class _SubtaskPageState extends State<SubtaskPage> {
  TaskModel task = new TaskModel();
  final taskProvider = new TaskProvider();
  final subtaskProvider = new SubtaskProvider();
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    final Map taskArgs = ModalRoute.of(context).settings.arguments;
    task = taskArgs['task'];
    return Scaffold(
      appBar: normalAppBar(task.title),
      body: Container(
        width: double.infinity,
        child: _subtaskList(int.parse(task.id)),
      ),
    );
  }

  _subtaskList(int taskId) {
    return FutureBuilder(
        future: subtaskProvider.getSubtasks(taskId),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            final List<SubtaskModel> subtasks = snapshot.data;
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 15, left: 20),
                  child: Text(
                    'Subtasks',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 20),
                    itemCount: subtasks.length,
                    itemBuilder: (BuildContext context, int i) {
                      return GestureDetector(
                        onTap: () async {
                          _enabled = false;
                          subtaskProvider.processSubtask(subtasks[i]);
                          setState(() {
                            _enabled = true;
                          });
                        },
                        child: Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          child: _taskElement(
                              subtasks[i].title, subtasks[i].status),
                          secondaryActions: <Widget>[
                            SlideAction(
                              child: Container(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: CustomColors.TrashRedBackground),
                                  child: Image.asset('assets/images/trash.png'),
                                ),
                              ),
                              onTap: () => print('Delete'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                Expanded(
                  child: Shimmer.fromColors(
                    child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                leading: Icon(Icons.check_box_outline_blank),
                                title: Text('Subtask #$index ...'),
                              ),
                              Divider(height: 2.0),
                            ],
                          );
                        }),
                    baseColor: Colors.grey[500],
                    highlightColor: Colors.grey[700],
                  ),
                ),
              ],
            );
          }
        });
  }

  Widget _taskElement(String title, String status) {
    Icon _subtaskIcon;
    switch (status) {
      case "0":
        _subtaskIcon = Icon(Icons.check_box_outline_blank);
        break;
      case "1":
        _subtaskIcon = Icon(Icons.watch_later_outlined);
        break;
      case "2":
        _subtaskIcon = Icon(Icons.check_box_outlined);
        break;
    }
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 15),
      padding: EdgeInsets.fromLTRB(5, 13, 5, 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _subtaskIcon,
          Container(
            width: 250,
            child: Text(title,
                style: TextStyle(
                  fontSize: 15,
                  decoration:
                      (status == "2" ? TextDecoration.lineThrough : null),
                ),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          stops: [0.015, 0.015],
          colors: [(status == "2" ? Colors.grey : Colors.blue), Colors.white],
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
        boxShadow: [
          BoxShadow(
            color: CustomColors.GreyBorder,
            blurRadius: 10.0,
            spreadRadius: 5.0,
            offset: Offset(0.0, 0.0),
          ),
        ],
      ),
    );
  }
}
