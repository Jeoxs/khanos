import 'package:flutter/material.dart';
import 'package:khanos/src/models/column_model.dart';
import 'package:khanos/src/models/project_model.dart';
import 'package:khanos/src/models/task_model.dart';
import 'package:khanos/src/providers/column_provider.dart';
import 'package:khanos/src/providers/project_provider.dart';
import 'package:khanos/src/providers/task_provider.dart';
import 'package:khanos/src/utils/datetime_utils.dart';
import 'package:khanos/src/utils/widgets_utils.dart';
import 'package:khanos/src/utils/theme_utils.dart';
import 'package:shimmer/shimmer.dart';

class ProjectPage extends StatefulWidget {
  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  ProjectModel project = new ProjectModel();
  Map<String, ColumnModel> projectColumns = {};
  final projectProvider = new ProjectProvider();
  final taskProvider = new TaskProvider();
  final columnProvider = new ColumnProvider();

  @override
  Widget build(BuildContext context) {
    final Map projectArgs = ModalRoute.of(context).settings.arguments;

    if (projectArgs['project'] != null) {
      project = projectArgs['project'];
      // projectColumns = projectArgs['columns'];
    }

    return Scaffold(
      appBar: normalAppBar(project.name != null ? project.name : 'New Project'),
      body: Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 20.0),
          child: project.id == null ? _projectForm() : _projectInfo()),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, 'taskForm',
              arguments: {'project': project}).then((_) => setState(() {}));
        },
      ),
    );
  }

  Widget _projectForm() {
    return Text('New Project Form');
  }

  Widget _projectInfo() {
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
        // _testWidget('07:00 AM', 'Title', Colors.blue),
        SizedBox(height: 20.0),
        _taskList(int.parse(project.id)),
      ],
    );
  }

  Widget _taskList(int projectId) {
    return FutureBuilder(
        future: Future.wait([taskProvider.getTasks(projectId, 1)]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            final List<TaskModel> tasks = snapshot.data[0];
            if (tasks.length > 0) {
              return Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (BuildContext context, int i) {
                    return new Column(children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, 'task', arguments: {
                            'task': tasks[i],
                            'project': project
                          });
                        },
                        child: _taskElement(
                            getDateTimeFromEpoch(
                                "dd/MM/yy", tasks[i].dateModification),
                            tasks[i].title,
                            TaskModel().getTaskColor(tasks[i].colorId)),
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
          } else {
            return Expanded(
              child: Shimmer.fromColors(
                child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          _taskElement(
                              '01/01/1970', 'Task #$index', Colors.grey),
                          Divider(height: 2.0),
                        ],
                      );
                    }),
                baseColor: CustomColors.BlueDark,
                highlightColor: Colors.lightBlue[200],
              ),
            );
          }
        });
  }

  Widget _taskElement(String timeUpdated, String title, Color color) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 15),
      padding: EdgeInsets.fromLTRB(5, 13, 5, 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            timeUpdated,
          ),
          Container(
            width: 180,
            child: Text(title,
                style: TextStyle(fontSize: 15),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          stops: [0.015, 0.015],
          colors: [color, Colors.white],
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
