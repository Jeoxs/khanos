import 'package:flutter/material.dart';
import 'package:khanos/src/pages/about_page.dart';
import 'package:khanos/src/pages/home_page.dart';
import 'package:khanos/src/pages/kanban_page.dart';
import 'package:khanos/src/pages/login_page.dart';
import 'package:khanos/src/pages/new_project_page.dart';
import 'package:khanos/src/pages/new_subtask_page.dart';
import 'package:khanos/src/pages/project_page.dart';
import 'package:khanos/src/pages/subtask_page.dart';
import 'package:khanos/src/pages/task_form.dart';
import 'package:khanos/src/pages/task_page.dart';
import 'package:khanos/src/pages/welcome_page.dart';
import 'package:khanos/src/preferences/user_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:khanos/src/providers/dark_theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new UserPreferences();
  await prefs.initPrefs();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeChanger(lightTheme)),
      ],
      child: MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  final Map<String, dynamic> preferences = {
    'endpoint': prefs.endpoint,
    'username': prefs.username,
    'password': prefs.password,
    'authFlag': prefs.authFlag
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    String _initialRoute = '';

    if (preferences['endpoint'] == '' ||
        preferences['username'] == '' ||
        preferences['password'] == '') {
      _initialRoute = 'welcome';
    } else if (preferences['authFlag'] != true) {
      _initialRoute = 'login';
    } else {
      _initialRoute = 'home';
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('es', 'ES'),
      ],
      title: 'Khanos - Kanboard Client',
      initialRoute: _initialRoute,
      routes: {
        'home': (BuildContext context) => HomePage(),
        'project': (BuildContext context) => ProjectPage(),
        'task': (BuildContext context) => TaskPage(),
        'taskForm': (BuildContext context) => TaskFormPage(),
        'subtask': (BuildContext context) => SubtaskPage(),
        'newSubtask': (BuildContext context) => NewSubtaskPage(),
        'welcome': (BuildContext context) => WelcomePage(),
        'login': (BuildContext context) => LoginPage(),
        'newProject': (BuildContext context) => NewProjectPage(),
        'kanban': (BuildContext context) => KanbanPage(),
        'about': (BuildContext context) => AboutPage(),
      },
      theme: theme.getTheme,
    );
  }
}
