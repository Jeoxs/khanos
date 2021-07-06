import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kanboard/src/models/column_model.dart';
import 'package:kanboard/src/models/project_model.dart';
import 'package:kanboard/src/models/task_model.dart';
import 'package:kanboard/src/providers/column_provider.dart';
import 'package:kanboard/src/providers/project_provider.dart';
import 'package:kanboard/src/providers/task_provider.dart';
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
      appBar: AppBar(
          title:
              project.name != null ? Text(project.name) : Text('New Project')),
      body: Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 20.0),
          child: project.id == null ? _projectForm() : _projectInfo()),
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
        _taskList(int.parse(project.id)),
      ],
    );
  }

  Widget _taskList(int projectId) {
    return FutureBuilder(
        future: Future.wait([
          taskProvider.getTasks(projectId, 1),
          columnProvider.getColumns(projectId)
        ]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            final List<TaskModel> tasks = snapshot.data[0];
            final Map<String, ColumnModel> columns = snapshot.data[1];
            return Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (BuildContext context, int i) {
                  return new Column(children: [
                    ListTile(
                      leading: Icon(Icons.circle,
                          color: TaskModel().getTaskColor(tasks[i].colorId)),
                      title:
                          Text(tasks[i].title, overflow: TextOverflow.ellipsis),
                      subtitle: Text(
                        'Column: ${columns[tasks[i].columnId].title} - ${'Updated: ' + DateFormat("dd/MM/yy").format(DateTime.fromMillisecondsSinceEpoch(int.parse(tasks[i].dateModification) * 1000))}',
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, 'task', arguments: {
                          'task': tasks[i],
                          'project_name': project.name
                        });
                      },
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
                            leading: Icon(Icons.circle),
                            title: Text('Task #$index ...'),
                          ),
                          Divider(height: 2.0),
                        ],
                      );
                    }),
                baseColor: Colors.grey[400],
                highlightColor: Colors.grey[600],
              ),
            );
          }
        });
  }
}
