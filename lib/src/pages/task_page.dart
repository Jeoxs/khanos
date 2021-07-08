import 'package:flutter/material.dart';
import 'package:kanboard/src/models/column_model.dart';
import 'package:kanboard/src/models/task_model.dart';
import 'package:kanboard/src/providers/column_provider.dart';
import 'package:kanboard/src/providers/subtask_provider.dart';
import 'package:kanboard/src/providers/task_provider.dart';
import 'package:kanboard/src/utils/datetime_utils.dart';
import 'package:kanboard/src/utils/widgets_utils.dart';
import 'package:kanboard/src/utils/theme_utils.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  TaskModel task = new TaskModel();
  Map<String, ColumnModel> projectColumns = {};
  final taskProvider = new TaskProvider();
  final subtaskProvider = new SubtaskProvider();
  final columnProvider = new ColumnProvider();

  @override
  Widget build(BuildContext context) {
    final Map taskArgs = ModalRoute.of(context).settings.arguments;
    final String projectName = taskArgs['project_name'];
    if (taskArgs['task'] != null) {
      task = taskArgs['task'];
    }

    final Map<String, dynamic> appBarArguments = {
      'context': context,
      'icon': Icons.playlist_add_check_rounded,
      'route': 'subtask',
      'arguments': {'task': task}
    };

    return Scaffold(
      appBar: normalAppBar(projectName, appBarArguments),
      body: Container(
          width: double.infinity,
          child: task.id == null ? _taskForm() : _taskInfo()),
    );
  }

  _taskForm() {}

  _taskInfo() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.only(
                top: 20.0, left: 20.0, right: 20.0, bottom: 40.0),
            children: [
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: Text('Task #${task.id} - ${task.title}',
                        style: TextStyle(
                            fontSize: 22, fontStyle: FontStyle.normal)),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Icon(Icons.calendar_today_outlined,
                      color: Colors.blueGrey),
                ),
                Text(
                    'Created: ${getDateTimeFromEpoch("dd/MM/yy - HH:mm", task.dateCreation)}'),
              ]),
              SizedBox(height: 20.0),
              Row(children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Icon(Icons.calendar_today, color: Colors.blueGrey),
                ),
                Text(
                    'Modified: ${getDateTimeFromEpoch("dd/MM/yy - HH:mm", task.dateModification)}'),
              ]),
              SizedBox(height: 20.0),
              Row(children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Icon(Icons.person, color: Colors.blueGrey),
                ),
                Text('Asignee: ${task.creatorId}')
              ]),
              SizedBox(height: 20.0),
              Row(children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child:
                      Icon(Icons.watch_later_outlined, color: Colors.blueGrey),
                ),
                Text('Estimated: ${task.timeEstimated} hours')
              ]),
              SizedBox(height: 20.0),
              Row(children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child:
                      Icon(Icons.watch_later_outlined, color: Colors.blueGrey),
                ),
                Text('Spent: ${task.timeSpent} hours')
              ]),
              SizedBox(height: 20.0),
              Row(
                children: [
                  Text('Description',
                      style: TextStyle(fontSize: 20.0),
                      textAlign: TextAlign.left),
                ],
              ),
              SizedBox(height: 10.0),
              Card(
                  elevation: 3.0,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                        task.description != ""
                            ? task.description
                            : 'No Description',
                        textAlign: TextAlign.left),
                  )),
              SizedBox(height: 20.0),
              // Text('Sub-tasks', style: TextStyle(fontSize: 20.0)),
            ],
          ),
        ),
      ],
    );
  }
}
