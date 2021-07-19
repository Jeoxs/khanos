import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:khanos/src/models/subtask_model.dart';
import 'package:khanos/src/models/task_model.dart';
import 'package:khanos/src/preferences/user_preferences.dart';
import 'package:khanos/src/providers/subtask_provider.dart';
import 'package:khanos/src/providers/task_provider.dart';
import 'package:khanos/src/utils/utils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:khanos/src/utils/widgets_utils.dart';
import 'package:khanos/src/utils/theme_utils.dart';

class SubtaskPage extends StatefulWidget {
  @override
  _SubtaskPageState createState() => _SubtaskPageState();
}

class _SubtaskPageState extends State<SubtaskPage> {
  final _prefs = new UserPreferences();
  Map<String, dynamic> error;
  TaskModel task = new TaskModel();
  final taskProvider = new TaskProvider();
  final subtaskProvider = new SubtaskProvider();
  bool _darkTheme;
  ThemeData currentThemeData;

  @override
  void initState() {
    _darkTheme = _prefs.darkTheme;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentThemeData =
        _darkTheme == true ? ThemeData.dark() : ThemeData.light();
    final Map taskArgs = ModalRoute.of(context).settings.arguments;
    task = taskArgs['task'];
    return Scaffold(
      appBar: normalAppBar(task.title),
      body: Container(
        width: double.infinity,
        child: _subtaskList(int.parse(task.id)),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, 'newSubtask', arguments: {'task': task})
              .then((_) => setState(() {}));
        },
      ),
    );
  }

  _subtaskList(int taskId) {
    return FutureBuilder(
        future: subtaskProvider.getSubtasks(taskId),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
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
            final List<SubtaskModel> subtasks = snapshot.data;
            if (subtasks.length > 0) {
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
                    child: ReorderableListView.builder(
                      onReorder: (oldIndex, newIndex) async {
                        Feedback.forTap(context);
                        showLoaderDialog(context);

                        await subtaskProvider.updateSubtaskPosition(
                            subtasks[oldIndex], subtasks[newIndex]);
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                      padding: EdgeInsets.only(top: 20, bottom: 140),
                      itemCount: subtasks.length,
                      itemBuilder: (BuildContext context, int i) {
                        return GestureDetector(
                          key: ValueKey(subtasks[i].id),
                          onTap: () async {
                            Feedback.forTap(context);
                            showLoaderDialog(context);

                            await subtaskProvider.processSubtask(subtasks[i]);
                            setState(() {
                              Navigator.pop(context);
                            });
                          },
                          child: Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            child: _subtaskElement(
                                subtasks[i].title,
                                subtasks[i].status,
                                subtasks[i].timeSpent,
                                subtasks[i].id),
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
                                    child:
                                        Image.asset('assets/images/trash.png'),
                                  ),
                                ),
                                onTap: () {
                                  showLoaderDialog(context);
                                  _removeSubtask(subtasks[i].id);
                                },
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
              return Center(
                  child: Container(
                width: MediaQuery.of(context).size.width / 1.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(
                      fit: FlexFit.loose,
                      child: Hero(
                        tag: 'Clipboard',
                        child: Image.asset('assets/images/Clipboard-empty.png'),
                      ),
                    ),
                    Text(
                      'No subtasks',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: CustomColors.TextHeader),
                    ),
                  ],
                ),
              ));
            }
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

  Widget _subtaskElement(
      String title, String status, String timeSpent, String id) {
    Icon _subtaskIcon;

    switch (status) {
      case "0":
        _subtaskIcon = Icon(Icons.check_box_outline_blank);
        break;
      case "1":
        _subtaskIcon = Icon(Icons.access_time_rounded);
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
          Text('${timeSpent}h'),
          Container(
            width: 250,
            child: Text(title,
                style: TextStyle(
                  fontSize: 15,
                  decoration:
                      (status == "2" ? TextDecoration.lineThrough : null),
                ),
                overflow: TextOverflow.clip),
          ),
          // _getTaskTimeSpent(int.parse(subtaskId)),
        ],
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          stops: [0.015, 0.015],
          colors: [
            (status == "2" ? Colors.grey : Colors.blue),
            currentThemeData.cardColor
          ],
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
        boxShadow: [
          BoxShadow(
            color: currentThemeData.shadowColor,
            blurRadius: 4,
            offset: Offset(1.5, 1.5),
          ),
        ],
      ),
    );
  }

  _removeSubtask(String subtaskId) async {
    bool result = await subtaskProvider.removeSubtask(int.parse(subtaskId));
    Navigator.pop(context);
    if (result) {
      setState(() {});
    } else {
      mostrarAlerta(context, 'Something went Wront!');
    }
  }
}
