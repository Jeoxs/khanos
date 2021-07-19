import 'package:flutter/material.dart';
import 'package:khanos/src/models/project_model.dart';
import 'package:khanos/src/models/task_model.dart';
import 'package:khanos/src/preferences/user_preferences.dart';
import 'package:khanos/src/providers/project_provider.dart';
import 'package:khanos/src/providers/task_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:khanos/src/utils/datetime_utils.dart';
import 'package:khanos/src/utils/theme_utils.dart';
import 'package:shimmer/shimmer.dart';

class OverdueTasksPage extends StatefulWidget {
  @override
  _OverdueTasksPageState createState() => _OverdueTasksPageState();
}

class _OverdueTasksPageState extends State<OverdueTasksPage> {
  bool _darkTheme;
  ThemeData currentThemeData;
  List<TaskModel> tasks;
  List<ProjectModel> projects;
  TaskProvider taskProvider = new TaskProvider();
  ProjectProvider projectProvider = new ProjectProvider();
  final _prefs = new UserPreferences();
  Map<String, dynamic> error;

  @override
  void initState() {
    _darkTheme = _prefs.darkTheme;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentThemeData =
        _darkTheme == true ? ThemeData.dark() : ThemeData.light();
    return FutureBuilder(
      future: Future.wait(
          [taskProvider.getOverdueTasks(), projectProvider.getProjects()]),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          tasks = snapshot.data[0];
          projects = snapshot.data[1];
          if (tasks.length > 0) {
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 15, bottom: 20),
                  child: Text(
                    'Overdue Tasks',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (BuildContext context, int i) {
                        return GestureDetector(
                          onTap: () {
                            Feedback.forTap(context);
                            Navigator.pushNamed(context, 'task', arguments: {
                              'task_id': tasks[i].id,
                              'project': projects.firstWhere((element) =>
                                  element.id == tasks[i].projectId),
                            }).then((_) => setState(() {}));
                          },
                          child: _taskElement(
                              tasks[i].dateDue,
                              tasks[i].title,
                              tasks[i].colorId,
                              projects
                                  .firstWhere((element) =>
                                      element.id == tasks[i].projectId)
                                  .name),
                        );
                      }),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 15, bottom: 20),
                  child: Text(
                    'Overdue Tasks',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Center(
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
                            child: Image.asset(
                                'assets/images/Clipboard-empty.png'),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'No Overdue Tasks',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: CustomColors.TextSubHeader),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        } else {
          return Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 15, left: 20, bottom: 20),
                child: Text(
                  'Overdue Tasks',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Shimmer.fromColors(
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
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
          );
        }
      },
    );
  }

  Widget _taskElement(
      String timeDue, String title, String colorId, String projectName) {
    Color color =
        (colorId != null) ? TaskModel().getTaskColor(colorId) : Colors.blue;
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 15),
      padding: EdgeInsets.fromLTRB(25, 13, 5, 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(projectName, overflow: TextOverflow.clip),
                Text('Due: ' + getStringDateTimeFromEpoch("dd/MM/yy", timeDue),
                    style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.red,
                        fontWeight: FontWeight.w500)),
              ],
            ),
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
          colors: [color, Theme.of(context).cardColor],
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 4,
            offset: Offset(1.5, 1.5),
          ),
        ],
      ),
    );
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
            color: Theme.of(context).shadowColor,
            blurRadius: 4,
            offset: Offset(1.5, 1.5),
          ),
        ],
      ),
    );
  }
}
