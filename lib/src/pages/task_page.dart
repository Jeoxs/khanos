import 'package:flutter/material.dart';
import 'package:kanboard/src/models/column_model.dart';
import 'package:kanboard/src/models/subtask_model.dart';
import 'package:kanboard/src/models/task_model.dart';
import 'package:kanboard/src/providers/column_provider.dart';
import 'package:kanboard/src/providers/subtask_provider.dart';
import 'package:kanboard/src/providers/task_provider.dart';
import 'package:shimmer/shimmer.dart';

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

    return Scaffold(
      appBar: AppBar(
          title: Text(
              'Task: ${taskArgs['task'] != null ? task.title : "New Task"}')),
      body: Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 20.0),
          child: task.id == null ? _taskForm() : _taskInfo()),
    );
  }

  _taskForm() {}

  _taskInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Text('Description',
                  style: TextStyle(fontSize: 20.0), textAlign: TextAlign.left),
              SizedBox(height: 10.0),
              task.description != ""
                  ? Text(task.description, textAlign: TextAlign.left)
                  : Text('No Description', textAlign: TextAlign.left),
              SizedBox(height: 20.0),
              Text('Sub-tasks', style: TextStyle(fontSize: 20.0)),
            ],
          ),
        ),
        _subtaskList(int.parse(task.id)),
      ],
    );
  }

  _subtaskList(int taskId) {
    return FutureBuilder(
        future: subtaskProvider.getSubtasks(taskId),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            final List<SubtaskModel> subtasks = snapshot.data;
            return Expanded(
              child: ListView.builder(
                itemCount: subtasks.length,
                itemBuilder: (BuildContext context, int i) {
                  Icon subtaskStatusIcon;
                  switch (subtasks[i].status) {
                    case "0":
                      subtaskStatusIcon = Icon(Icons.check_box_outline_blank);
                      break;
                    case "1":
                      subtaskStatusIcon = Icon(Icons.watch_later_outlined);
                      break;
                    case "2":
                      subtaskStatusIcon = Icon(Icons.check_box_outlined);
                      break;
                  }
                  return new Column(children: [
                    ListTile(
                      leading: subtaskStatusIcon,
                      title: Text(subtasks[i].title,
                          overflow: TextOverflow.ellipsis),
                      onTap: () {},
                    ),
                    Divider(height: 2.0),
                  ]);
                },
              ),
            );
          } else {
            return Expanded(
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
            );
          }
        });
  }
}
