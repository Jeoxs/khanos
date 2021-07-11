import 'dart:async';

import 'package:flutter/material.dart';
import 'package:khanos/src/models/column_model.dart';
import 'package:khanos/src/models/project_model.dart';
import 'package:khanos/src/models/tag_model.dart';
import 'package:khanos/src/models/task_model.dart';
import 'package:khanos/src/models/user_model.dart';
import 'package:khanos/src/preferences/user_preferences.dart';
import 'package:khanos/src/providers/column_provider.dart';
import 'package:khanos/src/providers/subtask_provider.dart';
import 'package:khanos/src/providers/tag_provider.dart';
import 'package:khanos/src/providers/task_provider.dart';
import 'package:khanos/src/providers/user_provider.dart';
import 'package:khanos/src/utils/datetime_utils.dart';
import 'package:khanos/src/utils/utils.dart';
import 'package:khanos/src/utils/widgets_utils.dart';
import 'package:khanos/src/utils/theme_utils.dart';
import 'package:shimmer/shimmer.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final _prefs = new UserPreferences();
  Map<String, dynamic> error;
  TaskModel task = new TaskModel();
  int taskId;
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
    taskId = int.parse(taskArgs['task_id']);

    return Scaffold(
      appBar: normalAppBar(project.name),
      body: Container(width: double.infinity, child: _taskInfo()),
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

  _taskInfo() {
    return FutureBuilder(
      future: TaskProvider().getTask(taskId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          processApiError(snapshot.error);
          error = snapshot.error;
          if (_prefs.authFlag != true) {
            final SnackBar _snackBar = SnackBar(
              content: const Text('Login Failed!'),
              duration: const Duration(seconds: 5),
            );
            @override
            void run() {
              scheduleMicrotask(() {
                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                Navigator.pushReplacementNamed(context, 'login',
                    arguments: {'error': snapshot.error});
              });
            }

            run();
          } else {
            return Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: 20.0),
                child: errorPage(snapshot.error));
          }
        }

        if (snapshot.hasData) {
          task = snapshot.data;
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
                          'Created: ${getStringDateTimeFromEpoch("dd/MM/yy - HH:mm", task.dateCreation)}'),
                    ]),
                    SizedBox(height: 20.0),
                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child:
                            Icon(Icons.calendar_today, color: Colors.blueGrey),
                      ),
                      Text(
                          'Modified: ${getStringDateTimeFromEpoch("dd/MM/yy - HH:mm", task.dateModification)}'),
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
                        child: Icon(Icons.watch_later_outlined,
                            color: Colors.blueGrey),
                      ),
                      Text('Estimated: ${task.timeEstimated} hours')
                    ]),
                    SizedBox(height: 20.0),
                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Icon(Icons.watch_later_outlined,
                            color: Colors.blueGrey),
                      ),
                      Text('Spent: ${task.timeSpent} hours')
                    ]),
                    SizedBox(height: 20.0),
                    task.dateStarted != '0'
                        ? Row(children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Icon(Icons.calendar_today,
                                  color: Colors.blueGrey),
                            ),
                            Text(
                                'Created: ${getStringDateTimeFromEpoch("dd/MM/yy - HH:mm", task.dateStarted)}'),
                          ])
                        : Container(),
                    SizedBox(height: 20.0),
                    task.dateDue != '0'
                        ? Row(children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Icon(Icons.calendar_today,
                                  color: Colors.blueGrey),
                            ),
                            Text(
                                'Modified: ${getStringDateTimeFromEpoch("dd/MM/yy - HH:mm", task.dateDue)}'),
                          ])
                        : Container(),
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
        } else {
          return _shimmerPage();
        }
      },
    );
  }

  Widget _getUserFullName(String creatorId) {
    return FutureBuilder(
        future: UserProvider().getUser(int.parse(creatorId)),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            processApiError(snapshot.error);
            error = snapshot.error;
            if (_prefs.authFlag != true) {
              final SnackBar _snackBar = SnackBar(
                content: const Text('Login Failed!'),
                duration: const Duration(seconds: 5),
              );
              @override
              void run() {
                scheduleMicrotask(() {
                  ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                  Navigator.pushReplacementNamed(context, 'login',
                      arguments: {'error': snapshot.error});
                });
              }

              run();
            }
          }
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
          if (snapshot.hasError) {
            processApiError(snapshot.error);
            error = snapshot.error;
            if (_prefs.authFlag != true) {
              final SnackBar _snackBar = SnackBar(
                content: const Text('Login Failed!'),
                duration: const Duration(seconds: 5),
              );
              @override
              void run() {
                scheduleMicrotask(() {
                  ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                  Navigator.pushReplacementNamed(context, 'login',
                      arguments: {'error': snapshot.error});
                });
              }

              run();
            }
          }
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

  _shimmerPage() {
    return Shimmer.fromColors(
      child: Column(
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
                      child: Text('Task #...',
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
                  Text('Created: dd/MM/yy - HH:mm'),
                ]),
                SizedBox(height: 20.0),
                Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Icon(Icons.calendar_today, color: Colors.blueGrey),
                  ),
                  Text('Modified: dd/MM/yy - HH:mm'),
                ]),
                SizedBox(height: 20.0),
                Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Icon(Icons.person, color: Colors.blueGrey),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Text(
                      'John Doe...',
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
                ]),
                SizedBox(height: 20.0),
                Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Icon(Icons.watch_later_outlined,
                        color: Colors.blueGrey),
                  ),
                  Text('Estimated: some hours')
                ]),
                SizedBox(height: 20.0),
                Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Icon(Icons.watch_later_outlined,
                        color: Colors.blueGrey),
                  ),
                  Text('Spent: some hours')
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
                // _taskTags(task.id),
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
                      child: Text('A quick brown fox jumped over...',
                          textAlign: TextAlign.left),
                    )),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ],
      ),
      baseColor: CustomColors.BlueDark,
      highlightColor: Colors.lightBlue[200],
    );
  }
}
