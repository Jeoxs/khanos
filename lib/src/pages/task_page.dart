import 'package:flutter/material.dart';
import 'package:kanboard/src/models/column_model.dart';
import 'package:kanboard/src/models/project_model.dart';
import 'package:kanboard/src/models/tag_model.dart';
import 'package:kanboard/src/models/task_model.dart';
import 'package:kanboard/src/models/user_model.dart';
import 'package:kanboard/src/providers/column_provider.dart';
import 'package:kanboard/src/providers/subtask_provider.dart';
import 'package:kanboard/src/providers/tag_provider.dart';
import 'package:kanboard/src/providers/task_provider.dart';
import 'package:kanboard/src/providers/user_provider.dart';
import 'package:kanboard/src/utils/datetime_utils.dart';
import 'package:kanboard/src/utils/utils.dart';
import 'package:kanboard/src/utils/widgets_utils.dart';
import 'package:kanboard/src/utils/theme_utils.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  TaskModel task = new TaskModel();
  List<ColumnModel> projectColumns = [];
  List<TagModel> _tags = [];
  ProjectModel project;
  final taskProvider = new TaskProvider();
  final tagProvider = new TagProvider();
  final subtaskProvider = new SubtaskProvider();
  final userProvider = new UserProvider();
  final columnProvider = new ColumnProvider();

  @override
  Widget build(BuildContext context) {
    final Map taskArgs = ModalRoute.of(context).settings.arguments;
    // final String projectName = taskArgs['project_name'];
    project = taskArgs['project'];
    if (taskArgs['task'] != null) {
      task = taskArgs['task'];
    }

    return Scaffold(
      appBar: normalAppBar(project.name),
      body: Container(
          width: double.infinity,
          child: task.id == null ? _taskForm() : _taskInfo()),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "subtaskListHero",
            onPressed: () {
              Navigator.pushNamed(context, 'subtask',
                  arguments: {'task': task});
            },
            child: Icon(Icons.playlist_add_check_rounded),
          ),
          SizedBox(height: 10.0),
          FloatingActionButton(
            heroTag: "editTaskHero",
            onPressed: () async {
              Navigator.pushNamed(context, 'taskForm', arguments: {
                'task': task,
                'project': project,
                'tags': _tags,
              }).then((_) => setState(() {}));
            },
            child: Icon(Icons.edit),
          ),
        ],
      ),
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
                _getUserFullName(task.creatorId),
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
                  Text('Tags',
                      style: TextStyle(fontSize: 20.0),
                      textAlign: TextAlign.left),
                ],
              ),
              SizedBox(height: 10.0),
              _taskTags(task.id),
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

  Widget _getUserFullName(String creatorId) {
    return FutureBuilder(
        future: UserProvider().getUser(int.parse(creatorId)),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final UserModel user = snapshot.data;
            return _userButton(user);
          } else {
            return Text('Loading..');
          }
        });
  }

  Widget _userButton(UserModel user) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(right: 10),
        child: Text(
          user.name,
          style: TextStyle(color: Colors.white),
        ),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          color: CustomColors.BlueShadow,
          boxShadow: [
            BoxShadow(
              color: CustomColors.GreenShadow,
              blurRadius: 5.0,
              spreadRadius: 3.0,
              offset: Offset(0.0, 0.0),
            ),
          ],
        ),
      ),
    );
  }

  _taskTags(String taskId) {
    return FutureBuilder(
        future: TagProvider().getTagsByTask(int.parse(taskId)),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            _tags = snapshot.data;
            if (_tags.length > 0) {
              List<Widget> chips = [];
              _tags.forEach((tag) {
                chips.add(Chip(
                  backgroundColor: CustomColors.HeaderBlueLight,
                  elevation: 4.0,
                  label: Text(tag.name),
                ));
              });
              return Wrap(spacing: 5.0, children: chips);
            } else {
              return Text('No Tags');
            }
          } else {
            return Text('Loading...');
          }
        });
  }
}
