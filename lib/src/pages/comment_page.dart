import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:khanos/src/models/task_model.dart';
import 'package:khanos/src/models/comment_model.dart';
import 'package:khanos/src/preferences/user_preferences.dart';
import 'package:khanos/src/providers/task_provider.dart';
import 'package:khanos/src/providers/comment_provider.dart';
import 'package:khanos/src/providers/user_provider.dart';
import 'package:khanos/src/utils/datetime_utils.dart';
import 'package:khanos/src/utils/theme_utils.dart';
import 'package:khanos/src/utils/utils.dart';
import 'package:khanos/src/utils/widgets_utils.dart';
import 'package:shimmer/shimmer.dart';

class CommentPage extends StatefulWidget {
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  TextEditingController _commentFieldController = new TextEditingController();
  ScrollController _scrollController = ScrollController();
  String newComment = '';
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
              controller: _scrollController,
              itemCount: comments.length,
              itemBuilder: (BuildContext context, int i) {
                return _commentCard(
                    comments[i].username,
                    comments[i].comment,
                    comments[i].dateCreation,
                    comments[i].id,
                    comments[i].userId);
              }),
        ),
        Container(
            margin: EdgeInsets.symmetric(vertical: 2.0),
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              // First child is enter comment text input
              Expanded(
                child: TextFormField(
                  controller: _commentFieldController,
                  autocorrect: false,
                  decoration: new InputDecoration(
                    labelText: "Add Comment",
                    labelStyle: TextStyle(fontSize: 15.0),
                    fillColor: Colors.blue,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        // borderRadius:
                        //     BorderRadius.all(Radius.zero(5.0)),
                        borderSide: BorderSide(color: Colors.purpleAccent)),
                  ),
                  onChanged: (value) {
                    newComment = value;
                  },
                ),
              ),
              // Second child is button
              IconButton(
                icon: Icon(Icons.send, color: Colors.blue),
                iconSize: 20.0,
                onPressed: () {
                  showLoaderDialog(context);
                  _addComment(context);
                },
              )
            ])),
      ],
    );
  }

  _shimmerList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              controller: _scrollController,
              itemCount: 8,
              itemBuilder: (BuildContext context, int i) {
                return _shimmerCard();
              }),
        ),
        Shimmer.fromColors(
          child: Container(
              margin: EdgeInsets.symmetric(vertical: 2.0),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                // First child is enter comment text input
                Expanded(
                  child: TextFormField(
                    autocorrect: false,
                    decoration: new InputDecoration(
                      labelText: "Add Comment",
                      labelStyle: TextStyle(fontSize: 15.0),
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
                Icon(Icons.send, color: Colors.blue),
              ])),
          baseColor: Colors.grey[600],
          highlightColor: Colors.grey[200],
        )
      ],
    );
  }

  _shimmerCard() {
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: [
            Row(
              children: [
                Shimmer.fromColors(
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text('J',
                        style: TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                    decoration: BoxDecoration(
                      color: currentThemeData.backgroundColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  baseColor: Colors.grey[600],
                  highlightColor: Colors.grey[500],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      child: Text(
                        'JohnDoe',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15.0),
                      ),
                      baseColor: Colors.grey[600],
                      highlightColor: Colors.grey[500],
                    ),
                    Shimmer.fromColors(
                      child: Text(
                        getTimeAgo('123423335'),
                        style: currentThemeData.textTheme.caption,
                      ),
                      baseColor: Colors.grey[600],
                      highlightColor: Colors.grey[500],
                    ),
                  ],
                ),
                Spacer(),
                Shimmer.fromColors(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.more_vert),
                  ),
                  baseColor: Colors.grey[600],
                  highlightColor: Colors.grey[500],
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: Shimmer.fromColors(
                  child: Text(
                    'A quick brown fox jumps over...',
                    textAlign: TextAlign.start,
                    style: currentThemeData.textTheme.bodyText1,
                  ),
                  baseColor: Colors.grey[600],
                  highlightColor: Colors.grey[500],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _commentCard(String username, String comment, String dateCreated,
      String commentId, String userId) {
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
                (int.parse(userId) == _prefs.userId)
                    ? PopupMenuButton(
                        onSelected: (value) {
                          switch (value) {
                            case "edit":
                              _editCommentDialog(context, commentId, comment);
                              break;
                            case "remove":
                              _removeComment(commentId);
                              break;
                            default:
                          }
                        },
                        elevation: 5.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.more_vert),
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Text("Edit"),
                            value: "edit",
                          ),
                          PopupMenuItem(
                            child: Text("Remove"),
                            value: "remove",
                          ),
                        ],
                      )
                    : Container(),
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

  void _addComment(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (newComment.isNotEmpty) {
      int newCommentId = 0;

      try {
        newCommentId = await commentProvider.createComment({
          "task_id": task.id,
          "user_id": _prefs.userId,
          "content": newComment
        });
      } catch (e) {
        processApiError(e);
        error = e;
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
                  arguments: {'error': e});
            });
          }

          run();
        }
      }

      Navigator.pop(context);
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 200,
          duration: Duration(seconds: 2),
          curve: Curves.fastOutSlowIn);
      if (newCommentId != null && newCommentId > 0) {
        newComment = '';
        _commentFieldController.clear();

        setState(() {});
      } else {
        mostrarAlerta(context, 'There was some error! Please, try again!');
      }
    } else {
      mostrarAlerta(context, 'Please, Fill something before send!');
    }
  }

  _removeComment(String commentId) async {
    showLoaderDialog(context);
    bool result = false;
    try {
      result = await commentProvider.removeComment(int.parse(commentId));
    } catch (e) {
      processApiError(e);
      error = e;
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
                arguments: {'error': e});
          });
        }

        run();
      }
    }

    if (result) {
      setState(() {
        Navigator.pop(context);
      });
    } else {
      mostrarAlerta(context, 'There was some error! Please, try again!');
    }
  }

  void _editCommentDialog(
      BuildContext context, String commentId, String comment) {
    String newEditedComment = comment;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text('Edit Comment'),
            content: TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              initialValue: newEditedComment,
              onChanged: (value) {
                newEditedComment = value;
              },
              decoration: new InputDecoration(
                labelText: "Edit Comment",
                labelStyle: TextStyle(fontSize: 15.0),
                fillColor: Colors.blue,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    // borderRadius:
                    //     BorderRadius.all(Radius.zero(5.0)),
                    borderSide: BorderSide(color: Colors.purpleAccent)),
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel')),
              TextButton(
                  child: Text('Ok'),
                  onPressed: () async {
                    showLoaderDialog(context);
                    if (newEditedComment.isNotEmpty) {
                      bool result = await commentProvider.updateComment(
                          {'id': commentId, 'content': newEditedComment});
                      Navigator.of(context).pop(); // Pop out loader dialog
                      if (result) {
                        setState(() {});
                        Navigator.of(context).pop(); // Pop out Editing message
                      } else {
                        mostrarAlerta(context, 'Something went Wrong');
                      }
                    } else {
                      mostrarAlerta(context, 'Comment Message cannot be Empty');
                    }
                  }),
            ]);
      },
    );
  }
}
