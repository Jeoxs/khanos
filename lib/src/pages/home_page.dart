import 'dart:async';
import 'package:flutter/material.dart';
import 'package:khanos/src/pages/activity_page.dart';
import 'package:khanos/src/pages/overdue_page.dart';
import 'package:khanos/src/preferences/user_preferences.dart';
import 'package:khanos/src/providers/dark_theme_provider.dart';
import 'package:khanos/src/providers/user_provider.dart';
import 'package:khanos/src/utils/theme_utils.dart';
import 'package:khanos/src/utils/utils.dart';
import 'package:khanos/src/utils/widgets_utils.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:khanos/src/models/project_model.dart';
import 'package:khanos/src/providers/column_provider.dart';
import 'package:khanos/src/providers/project_provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final _prefs = new UserPreferences();
  final projectProvider = new ProjectProvider();
  final columnProvider = new ColumnProvider();
  final userProvider = new UserProvider();
  bool _darkTheme;
  ThemeData currentThemeData;

  @override
  void initState() {
    _darkTheme = _prefs.darkTheme;
    super.initState();
  }

  int projectsAmount;
  @override
  Widget build(BuildContext context) {
    if (_prefs.newInstall == true) {
      Future.delayed(Duration.zero, () => showChangelog(context));
      _prefs.newInstall = false;
    }
    Future.delayed(Duration.zero, () => showSlideTutorial(context));
    List<Widget> _children = [];
    _children.add(projectList(context));
    _children.add(OverdueTasksPage());
    _children.add(ActivityPage());

    currentThemeData =
        _darkTheme == true ? ThemeData.dark() : ThemeData.light();
    return Scaffold(
      appBar: normalAppBar('Khanos'),
      // body: projectList(context),
      body: _children[_currentIndex],
      drawer: _homeDrawer(),
      floatingActionButton: FloatingActionButton(
        heroTag: "addHero",
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context)
            .pushNamed('newProject')
            .then((_) => setState(() {})),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.watch_later_outlined),
            label: 'Overdue Tasks',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.list),
            label: 'Activities',
          ),
        ],
        selectedItemColor: Colors.blue,
      ),
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
    currentThemeData =
        _darkTheme == true ? ThemeData.dark() : ThemeData.light();
    return FutureBuilder(
        future: projectProvider.getProjects(),
        builder:
            (BuildContext context, AsyncSnapshot<List<ProjectModel>> snapshot) {
          if (snapshot.hasError) {
            processApiError(snapshot.error);
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
                          onTap: () {
                            Feedback.forTap(context);
                            Navigator.pushNamed(context, 'project',
                                    arguments: {'project': projects[i]})
                                .then((_) => setState(() {}));
                          },
                          child: Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            child: _projectElement(
                                projects[i].name, projects[i].description),
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
                                  _removeProject(projects[i].id);
                                },
                              ),
                            ],
                          ),
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
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
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
          colors: [Colors.blue, currentThemeData.cardColor],
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

  void _removeProject(String projectId) async {
    bool result = await projectProvider.removeProject(int.parse(projectId));
    Navigator.pop(context);
    if (result) {
      setState(() {});
    } else {
      mostrarAlerta(context, 'Something went Wront!');
    }
  }

  Widget _homeDrawer() {
    var _themeProvider = Provider.of<ThemeChanger>(context);
    return Container(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Stack(children: [
              DrawerHeader(
                child: Container(),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      CustomColors.HeaderBlueDark,
                      CustomColors.HeaderBlueLight
                    ],
                  ),
                  // color: Colors.blueAccent,
                ),
              ),
              CustomPaint(
                painter: CircleOne(),
              ),
              Positioned(
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 30.0),
                    height: 130.0,
                    width: 130.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/images/khanos_transparent.png')),
                    ),
                  ),
                ),
              ),
              Positioned(
                  child: Center(
                    child: Text('Khanos',
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.white,
                        )),
                  ),
                  top: 140.0,
                  left: 100.0),
            ]),
            SwitchListTile(
              activeColor: Colors.blue,
              value: _darkTheme,
              title: Text('Dark Mode'),
              onChanged: (value) {
                _themeProvider.setTheme(value ? darkTheme : lightTheme);
                prefs.darkTheme = value;
                _darkTheme = value;
                setState(() {});
              },
            ),
            ListTile(
              leading: Icon(Icons.support, color: Colors.blue),
              title: Text('Help & Feedback'),
              onTap: () {
                _launchGithubURL();
              },
            ),
            ListTile(
              leading: Icon(Icons.coffee, color: Colors.blue),
              title: Text('Show your support'),
              onTap: () {
                _launchBuyMeACoffee();
              },
            ),
            ListTile(
              leading: Icon(Icons.bolt, color: Colors.blue),
              title: Text('What\'s New'),
              onTap: () {
                Navigator.pushNamed(context, 'changelog');
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_support_outlined, color: Colors.blue),
              title: Text('About Khanos'),
              onTap: () {
                Navigator.pushNamed(context, 'about');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.blue),
              title: Text('Logout'),
              onTap: () {
                _prefs.authFlag = false;
                _prefs.userId = 0;
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('login', (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }

  _launchGithubURL() async {
    print('here');
    const url = 'https://github.com/Jeoxs/khanos';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchBuyMeACoffee() async {
    print('here');
    const url = 'https://buymeacoffee.com/joseaponte';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void onTabTapped(int index) {
    currentThemeData =
        _darkTheme == true ? ThemeData.dark() : ThemeData.light();
    setState(() {
      _currentIndex = index;
    });
  }
}
