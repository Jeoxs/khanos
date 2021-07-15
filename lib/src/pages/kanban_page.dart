import 'package:boardview/board_item.dart';
import 'package:boardview/board_list.dart';
import 'package:boardview/boardview.dart';
import 'package:boardview/boardview_controller.dart';
import 'package:flutter/material.dart';
import 'package:khanos/src/models/column_model.dart';
import 'package:khanos/src/models/project_model.dart';
import 'package:khanos/src/models/task_model.dart';
import 'package:khanos/src/preferences/user_preferences.dart';
import 'package:khanos/src/providers/task_provider.dart';
import 'package:khanos/src/utils/board_item_object.dart';
import 'package:khanos/src/utils/board_list_object.dart';
import 'package:khanos/src/utils/widgets_utils.dart';

class KanbanPage extends StatefulWidget {
  List<TaskModel> tasks;

  KanbanPage({this.tasks});

  @override
  _KanbanPageState createState() => _KanbanPageState();
}

class _KanbanPageState extends State<KanbanPage> {
  bool _darkTheme;
  ThemeData currentThemeData;
  final taskProvider = new TaskProvider();
  final _prefs = new UserPreferences();
  ProjectModel _project;

  //Can be used to animate to different sections of the BoardView
  BoardViewController boardViewController = new BoardViewController();
  List<BoardListObject> _listData = [];
  List<BoardItemObject> column1Items = [];

  @override
  void initState() {
    _darkTheme = _prefs.darkTheme;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentThemeData =
        _darkTheme == true ? ThemeData.dark() : ThemeData.light();
    final Map kanbanArgs = ModalRoute.of(context).settings.arguments;

    List<TaskModel> tasks = kanbanArgs['tasks'];
    tasks.sort((a, b) => a.position.compareTo(b.position));
    List<ColumnModel> columns = kanbanArgs['columns'];
    _project = kanbanArgs['project'];

    columns.forEach((col) {
      List<TaskModel> columnTasks =
          tasks.where((task) => task.columnId == col.id).toList();

      List<BoardItemObject> columnObjects = [];
      if (columnTasks.isNotEmpty) {
        columnTasks.forEach((element) {
          print(element.title);
          columnObjects
              .add(BoardItemObject(title: element.title, taskContent: element));
        });
      }
      _listData.add(BoardListObject(
          title: col.title, items: columnObjects, columnContent: col));
    });

    ProjectModel project = kanbanArgs['project'];

    List<BoardList> _lists = [];
    for (int i = 0; i < _listData.length; i++) {
      _lists.add(_createBoardList(_listData[i]) as BoardList);
    }

    return Scaffold(
      appBar: normalAppBar(project.name),
      body: _getKanban(_lists),
    );
  }

  _getKanban(List<BoardList> lists) {
    return BoardView(
      lists: lists,
      boardViewController: boardViewController,
    );
  }

  Widget _createBoardList(BoardListObject list) {
    List<BoardItem> items = [];

    for (int i = 0; i < list.items.length; i++) {
      items.insert(i, buildBoardItem(list.items[i]) as BoardItem);
    }

    return BoardList(
      onStartDragList: (int listIndex) {},
      onTapList: (int listIndex) async {},
      onDropList: (int listIndex, int oldListIndex) {
        print('OLD: $oldListIndex - NEW: $listIndex');
        //Update our local list data
        var list = _listData[oldListIndex];
        _listData.removeAt(oldListIndex);
        _listData.insert(listIndex, list);
      },
      headerBackgroundColor:
          _prefs.darkTheme ? currentThemeData.cardColor : Colors.grey[300],
      backgroundColor:
          _prefs.darkTheme ? currentThemeData.cardColor : Colors.grey[300],
      header: [
        Expanded(
            child: Padding(
                padding: EdgeInsets.all(5),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    list.title,
                    style: TextStyle(fontSize: 20),
                  ),
                ))),
      ],
      items: items,
    );
  }

  Widget buildBoardItem(BoardItemObject itemObject) {
    return BoardItem(
      onStartDragItem: (int listIndex, int itemIndex, BoardItemState state) {},
      onDropItem: (int listIndex, int itemIndex, int oldListIndex,
          int oldItemIndex, BoardItemState state) async {
        //Used to update our local item data
        var item = _listData[oldListIndex].items[oldItemIndex];
        print('Position -> oldItemIndex: $oldItemIndex, itemIndex: $itemIndex');
        print(
            'Position -> ${itemObject.taskContent.title} - ${itemObject.taskContent.position}');
        bool updateResult = await taskProvider.moveTaskPosition({
          'task_id': itemObject.taskContent.id,
          'project_id': itemObject.taskContent.projectId,
          'column_id': _listData[listIndex].columnContent.id,
          'position': itemIndex + 1,
          'swimlane_id': itemObject.taskContent.swimlaneId,
        });

        if (updateResult) {
          _listData[oldListIndex].items.removeAt(oldItemIndex);
          _listData[listIndex].items.insert(itemIndex, item);
        }
        setState(() {});
      },
      onTapItem: (int listIndex, int itemIndex, BoardItemState state) async {
        Feedback.forTap(context);
        Navigator.pushNamed(context, 'task', arguments: {
          'task_id': itemObject.taskContent.id,
          'project': _project
        }).then((_) => setState(() {}));
      },
      item: _taskElement(
          itemObject.taskContent.title, itemObject.taskContent.colorId),
    );
  }

  Widget _taskElement(String title, String color) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 15),
      padding: EdgeInsets.fromLTRB(25, 13, 5, 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 150,
            child: Text(title,
                style: TextStyle(fontSize: 15), overflow: TextOverflow.clip),
          ),
        ],
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          stops: [0.015, 0.015],
          colors: [TaskModel().getTaskColor(color), currentThemeData.cardColor],
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
}
