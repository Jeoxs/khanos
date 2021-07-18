import 'dart:async';

import 'package:flutter/material.dart';
import 'package:khanos/src/models/task_model.dart';
import 'package:khanos/src/models/comment_model.dart';
import 'package:khanos/src/preferences/user_preferences.dart';
import 'package:khanos/src/providers/task_provider.dart';
import 'package:khanos/src/providers/comment_provider.dart';
import 'package:khanos/src/providers/user_provider.dart';
import 'package:khanos/src/utils/datetime_utils.dart';
import 'package:khanos/src/utils/utils.dart';
import 'package:khanos/src/utils/widgets_utils.dart';

class CommentPage extends StatefulWidget {
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final _prefs = new UserPreferences();
  TaskModel task = new TaskModel();
  Map<String, dynamic> error;
  final taskProvider = new TaskProvider();
  final commentProvider = new CommentProvider();
  final userProvider = new UserProvider();
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
    final Map commentArgs = ModalRoute.of(context).settings.arguments;

    task = commentArgs['task'];

    return Scaffold(
      appBar: normalAppBar(task.title),
      body: _commentBodyPage(),
    );
  }

  Widget _commentBodyPage() {
    return FutureBuilder(
      future: Future.wait([
        commentProvider.getAllComments(int.parse(task.id)),
        userProvider.getUsers(),
      ]),
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
            return Scaffold(
                appBar: normalAppBar(task.title),
                body: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 20.0),
                    child: errorPage(snapshot.error)));
          }
        }
        if (snapshot.hasData) {
          List<CommentModel> comments = snapshot.data[0];
          return _commentList(comments);
        } else {
          return _shimmerList();
        }
      },
    );
  }

  _commentList(List<CommentModel> comments) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (BuildContext context, int i) {
                return _commentCard(comments[i].username, comments[i].comment,
                    comments[i].dateCreation);
              }),
        ),
        Container(
            margin: EdgeInsets.symmetric(vertical: 2.0),
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              // First child is enter comment text input
              Expanded(
                child: TextFormField(
                  autocorrect: false,
                  decoration: new InputDecoration(
                    labelText: "Add Comment",
                    labelStyle: TextStyle(fontSize: 20.0),
                    fillColor: Colors.blue,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        // borderRadius:
                        //     BorderRadius.all(Radius.zero(5.0)),
                        borderSide: BorderSide(color: Colors.purpleAccent)),
                  ),
                ),
              ),
              // Second child is button
              IconButton(
                icon: Icon(Icons.send, color: Colors.blue),
                iconSize: 20.0,
                onPressed: () {},
              )
            ])),
      ],
    );
  }

  _shimmerList() {
    return Container();
  }

  _commentCard(String username, String comment, String dateCreated) {
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40.0,
                  height: 40.0,
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(username[0],
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                  decoration: BoxDecoration(
                    color: currentThemeData.backgroundColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15.0),
                    ),
                    Text(
                      getTimeAgo(dateCreated),
                      style: currentThemeData.textTheme.caption,
                    ),
                  ],
                ),
                Spacer(),
                IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: Text(
                  comment,
                  textAlign: TextAlign.start,
                  style: currentThemeData.textTheme.bodyText1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
