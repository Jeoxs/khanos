import 'package:flutter/material.dart';
import 'package:khanos/src/models/activity_model.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:khanos/src/preferences/user_preferences.dart';
import 'package:khanos/src/providers/user_provider.dart';
import 'package:shimmer/shimmer.dart';

class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  bool _darkTheme;
  ThemeData currentThemeData;
  List<ActivityModel> activities;
  UserProvider userProvider = new UserProvider();
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
    return _activityList();
  }

  _activityList() {
    return FutureBuilder(
      future: userProvider.getMyActivityStream(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          activities = snapshot.data;
          return Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 15, left: 20, bottom: 20),
                child: Text(
                  'Activities',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: activities.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20.0),
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  // color: Colors.blue,
                                ),
                                child: _getEventIcon(activities[i].eventName),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.70,
                                child: Text(activities[i].eventTitle,
                                    overflow: TextOverflow.clip),
                              ),
                            ],
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 35, top: 1, bottom: 1),
                            child: Dash(
                                direction: Axis.vertical,
                                length: 30,
                                dashLength: 5,
                                dashThickness: 2,
                                dashColor: Colors.grey),
                          ),
                        ],
                      );
                    }),
              ),
            ],
          );
        } else {
          return _shimmerActivity();
        }
      },
    );
  }

  Widget _shimmerActivity() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 15, left: 20, bottom: 20),
          child: Text(
            'Activities',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: 14,
              itemBuilder: (BuildContext context, int i) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // color: Colors.blue,
                          ),
                          child: Shimmer.fromColors(
                              child: Icon(Icons.event, size: 30),
                              baseColor: Colors.grey,
                              highlightColor: Colors.grey[300]),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.70,
                          child: Shimmer.fromColors(
                              child: Text(
                                  'The quick brown fox jumps over the lazy dog',
                                  overflow: TextOverflow.clip),
                              baseColor: Colors.grey,
                              highlightColor: Colors.grey[300]),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 35, top: 1, bottom: 1),
                      child: Shimmer.fromColors(
                          child: Dash(
                              direction: Axis.vertical,
                              length: 30,
                              dashLength: 5,
                              dashThickness: 2,
                              dashColor: Colors.grey),
                          baseColor: Colors.grey,
                          highlightColor: Colors.grey[300]),
                    ),
                  ],
                );
              }),
        ),
      ],
    );
  }

  _getEventIcon(String eventName) {
    IconData eventIcon = Icons.event;
    switch (eventName) {
      case "task.create":
        eventIcon = Icons.add_task;
        break;
      case "task.update":
        eventIcon = Icons.edit;
        break;
      case "task.update":
        eventIcon = Icons.edit;
        break;
      case "task.move.position":
        eventIcon = Icons.view_column_rounded;
        break;
      case "task.move.column":
        eventIcon = Icons.view_column_rounded;
        break;
      case "task_internal_link.create_update":
        eventIcon = Icons.link;
        break;
      case "task_internal_link.delete":
        eventIcon = Icons.link_off;
        break;
      case "task.assignee_change":
        eventIcon = Icons.person_add;
        break;
      case "task.close":
        eventIcon = Icons.close;
        break;
      case "subtask.create":
        eventIcon = Icons.add_task;
        break;
      case "subtask.update":
        eventIcon = Icons.playlist_add_check_rounded;
        break;
      case "subtask.delete":
        eventIcon = Icons.delete;
        break;
      case "comment.create":
        eventIcon = Icons.insert_comment;
        break;
      case "comment.update":
        eventIcon = Icons.edit;
        break;
      case "comment.delete":
        eventIcon = Icons.delete;
        break;
      default:
    }

    return Icon(
      eventIcon,
      color: Colors.grey,
      size: 30,
    );
  }
}
