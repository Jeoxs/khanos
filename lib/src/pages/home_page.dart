import 'package:flutter/material.dart';
import 'package:kanboard/src/providers/user_provider.dart';
import 'package:kanboard/src/utils/theme_utils.dart';
import 'package:kanboard/src/utils/widgets_utils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:kanboard/src/models/project_model.dart';
import 'package:kanboard/src/providers/column_provider.dart';
import 'package:kanboard/src/providers/project_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final projectProvider = new ProjectProvider();
  final columnProvider = new ColumnProvider();
  final userProvider = new UserProvider();
  int projectsAmount;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: normalAppBar('GoJaponte Kanboard'),
      body: projectList(context),
    );
  }

  Widget homeContent(BuildContext context) {
    return Column(
      children: [
        projectsOverview(context),
        Container(
          padding: EdgeInsets.only(bottom: 5.0, left: 25.0),
          width: double.infinity,
          child: Text(
            'All Projects',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
            textAlign: TextAlign.left,
          ),
        ),
        Container(child: projectList(context)),
      ],
    );
  }

  Widget projectsOverview(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Text(
              '${projectsAmount.toString()} Projects',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget projectList(BuildContext context) {
    return FutureBuilder(
        future: projectProvider.getProjects(context),
        builder:
            (BuildContext context, AsyncSnapshot<List<ProjectModel>> snapshot) {
          if (snapshot.hasData) {
            final projects = snapshot.data;
            projectsAmount = projects.length;
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 15, left: 20, bottom: 10),
                  child: Text(
                    'Projects',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 80.0),
                      itemCount: projects.length,
                      itemBuilder: (BuildContext context, int i) {
                        return GestureDetector(
                          onTap: () => Navigator.pushNamed(context, 'project',
                              arguments: {'project': projects[i]}),
                          child: _projectElement(
                              projects[i].name, projects[i].description),
                        );
                      }),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                Expanded(
                  child: Shimmer.fromColors(
                    child: ListView.builder(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          return _projectElement('someTitle', 'description..');
                        }),
                    baseColor: CustomColors.BlueDark,
                    highlightColor: Colors.lightBlue[200],
                  ),
                ),
              ],
            );
          }
        });
  }

  Widget _projectElement(String title, String description) {
    description = description != null ? description : 'No description';
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: 20.0),
          ),
          Container(
            child: Text(description,
                style: TextStyle(fontSize: 15),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          stops: [0.015, 0.015],
          colors: [Colors.green, Colors.white],
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
