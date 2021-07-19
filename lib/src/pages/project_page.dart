import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:khanos/src/models/column_model.dart';
import 'package:khanos/src/models/project_model.dart';
import 'package:khanos/src/models/task_model.dart';
import 'package:khanos/src/preferences/user_preferences.dart';
import 'package:khanos/src/providers/column_provider.dart';
import 'package:khanos/src/providers/project_provider.dart';
import 'package:khanos/src/providers/task_provider.dart';
import 'package:khanos/src/utils/datetime_utils.dart';
import 'package:khanos/src/utils/utils.dart';
import 'package:khanos/src/utils/widgets_utils.dart';
import 'package:khanos/src/utils/theme_utils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ProjectPage extends StatefulWidget {
  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  LongPressStartDetails details;
  bool _darkTheme;
  ThemeData currentThemeData;
  final _prefs = new UserPreferences();
  Map<String, dynamic> error;
  ProjectModel project = new ProjectModel();
  Map<String, ColumnModel> projectColumns = {};
  final projectProvider = new ProjectProvider();
  final taskProvider = new TaskProvider();
  final columnProvider = new ColumnProvider();
  Widget floatingAction;

  @override
  void initState() {
    _darkTheme = _prefs.darkTheme;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentThemeData =
        _darkTheme == true ? ThemeData.dark() : ThemeData.light();
    final Map projectArgs = ModalRoute.of(context).settings.arguments;

    if (projectArgs['project'] != null) {
      project = projectArgs['project'];
      // projectColumns = projectArgs['columns'];
    }
    return FutureBuilder(
        future: Future.wait([
          taskProvider.getTasks(int.parse(project.id), 1),
          columnProvider.getColumns(project.id),
        ]),
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
              return Scaffold(
                  appBar: normalAppBar(project.name),
                  body: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 20.0),
                      child: errorPage(snapshot.error)));
            }
          }
          if (snapshot.hasData) {
            final List<TaskModel> tasks = snapshot.data[0];
            final List<ColumnModel> columns = snapshot.data[1];
            tasks.sort((a, b) => a.id.compareTo(b.id));
            return Scaffold(
              appBar: normalAppBar(project.name),
              body: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 20.0),
                  child: _projectInfo(tasks, columns)),
              floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.view_column),
                    heroTag: "kanbanHero",
                    onPressed: () {
                      Navigator.pushNamed(context, 'kanban', arguments: {
                        'project': project,
                        'tasks': tasks,
                        'columns': columns
                      }).then((_) => setState(() {}));
                    },
                  ),
                  SizedBox(height: 10.0),
                  FloatingActionButton(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.add),
                    heroTag: "addHero",
                    onPressed: () {
                      Navigator.pushNamed(context, 'taskForm',
                              arguments: {'project': project})
                          .then((_) => setState(() {}));
                    },
                  ),
                ],
              ),
            );
          } else {
            return Scaffold(
              appBar: normalAppBar(project.name),
              body: Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Expanded(
                        child: Shimmer.fromColors(
                          child: ListView.builder(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 40.0),
                              itemCount: 8,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    _shimmerTaskElement(),
                                  ],
                                );
                              }),
                          baseColor: CustomColors.BlueDark,
                          highlightColor: Colors.lightBlue[200],
                        ),
                      )
                    ],
                  )),
            );
          }
        });
  }

  Widget _projectInfo(List<TaskModel> tasks, List<ColumnModel> columns) {
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
              project.description != null
                  ? Text(project.description, textAlign: TextAlign.left)
                  : Text('No Description', textAlign: TextAlign.left),
              SizedBox(height: 20.0),
              Text('Tasks', style: TextStyle(fontSize: 20.0)),
            ],
          ),
        ),
        SizedBox(height: 20.0),
        _taskList(tasks, columns),
      ],
    );
  }

  Widget _taskList(List<TaskModel> tasks, List<ColumnModel> columns) {
    if (tasks.length > 0) {
      return Expanded(
        child: ListView.builder(
          padding: EdgeInsets.only(top: 10.0, bottom: 140.0),
          itemCount: tasks.length,
          itemBuilder: (BuildContext context, int i) {
            return new Column(children: [
              GestureDetector(
                onTap: () {
                  Feedback.forTap(context);
                  Navigator.pushNamed(context, 'task', arguments: {
                    'task_id': tasks[i].id,
                    'project': project
                  }).then((_) => setState(() {}));
                },
                onLongPressStart: (LongPressStartDetails tempDetails) {
                  details = tempDetails;
                },
                child: Slidable(
                  actionExtentRatio: 0.2,
                  actionPane: SlidableDrawerActionPane(),
                  child: _taskElement(
                      getStringDateTimeFromEpoch(
                          "dd/MM/yy", tasks[i].dateModification),
                      tasks[i].title,
                      TaskModel().getTaskColor(tasks[i].colorId),
                      columns
                          .firstWhere(
                              (element) => element.id == tasks[i].columnId)
                          .title),
                  secondaryActions: <Widget>[
                    SlideAction(
                      child: Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.blue),
                          child: Icon(Icons.lock, color: Colors.white),
                        ),
                      ),
                      onTap: () {
                        showLoaderDialog(context);
                        _closeTask(tasks[i].id);
                      },
                    ),
                    SlideAction(
                      child: Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: CustomColors.TrashRedBackground),
                          child: Image.asset('assets/images/trash.png'),
                        ),
                      ),
                      onTap: () {
                        showLoaderDialog(context);
                        _removeTask(tasks[i].id);
                      },
                    ),
                  ],
                ),
              ),
            ]);
          },
        ),
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
              'No tasks',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: CustomColors.TextHeader),
            ),
          ],
        ),
      ));
    }
  }

  Widget _taskElement(
      String timeUpdated, String title, Color color, String columnTitle) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 15),
      padding: EdgeInsets.fromLTRB(25, 13, 5, 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: 100.0,
                  child: Text(columnTitle, overflow: TextOverflow.clip)),
              Text('Mod: ' + timeUpdated, style: TextStyle(fontSize: 12.0)),
            ],
          ),
          Container(
            width: 200,
            child: Text(title,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                overflow: TextOverflow.clip),
          ),
        ],
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          stops: [0.015, 0.015],
          colors: [color, currentThemeData.cardColor],
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

  void _removeTask(String taskId) async {
    bool result = await taskProvider.removeTask(int.parse(taskId));
    Navigator.pop(context);
    if (result) {
      setState(() {});
    } else {
      mostrarAlerta(context, 'Something went Wront!');
    }
  }

  Widget _shimmerTaskElement() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 15),
      padding: EdgeInsets.fromLTRB(25, 13, 5, 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(''),
            ],
          ),
          Container(
            width: 200,
          ),
        ],
      ),
      decoration: BoxDecoration(
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

  void _closeTask(String taskId) async {
    bool result = await taskProvider.closeTask(int.parse(taskId));
    Navigator.pop(context);
    if (result) {
      setState(() {});
    } else {
      mostrarAlerta(context, 'Something went Wront!');
    }
  }
}
