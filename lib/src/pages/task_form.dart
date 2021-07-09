import 'package:flutter/material.dart';
import 'package:kanboard/src/models/column_model.dart';
import 'package:kanboard/src/models/project_model.dart';
import 'package:kanboard/src/models/tag_model.dart';
import 'package:kanboard/src/models/task_model.dart';
import 'package:kanboard/src/models/user_model.dart';
import 'package:kanboard/src/providers/column_provider.dart';
import 'package:kanboard/src/providers/tag_provider.dart';
import 'package:kanboard/src/providers/task_provider.dart';
import 'package:kanboard/src/providers/user_provider.dart';
import 'package:kanboard/src/utils/theme_utils.dart';
import 'package:kanboard/src/utils/utils.dart';
import 'package:kanboard/src/utils/widgets_utils.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'dart:ui';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

class TaskFormPage extends StatefulWidget {
  @override
  _TaskFormPageState createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final userProvider = new UserProvider();
  final columnProvider = new ColumnProvider();
  final tagProvider = new TagProvider();
  final taskProvider = new TaskProvider();

  ProjectModel project = new ProjectModel();
  TaskModel task = new TaskModel();
  List<UserModel> _users = [];
  List<ColumnModel> _columns = [];
  // List<TagModel> _projectTags = [];
// List<TagModel> tags = new List.from(snapshot.data[0])
//               ..addAll(snapshot.data[1]);
  String _title = '';
  String _description = '';
  ColorSwatch _tempTaskColor;
  Color _mainColor = Colors.blue;
  String _colorId = '';
  String _creatorId = '0';
  String _ownerId = '0';
  String _columnId = '0';
  String _timeEstimated = '';
  String _dateStarted = '';
  String _dateDue = '';
  String _score = ''; // COMPLEXITY
  String _priority = '0';
  List<TagModel> _availableTags = [];
  List<String> _tags = [];

  bool createTask = true;

  TextEditingController _titleFieldController = new TextEditingController();
  TextEditingController _descriptionFieldController =
      new TextEditingController();
  TextEditingController _timeEstimatedFieldController =
      new TextEditingController();
  TextEditingController _dateStartedFieldController =
      new TextEditingController();
  TextEditingController _dateDueFieldController = new TextEditingController();
  TextEditingController _scoreFieldController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    // this should not be done in build method.
    // _users = await _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    final Map taskArgs = ModalRoute.of(context).settings.arguments;
    project = taskArgs['project'];
    _users = taskArgs['usersData'];

    if (taskArgs['task'] != null) {
      task = taskArgs['task'];
      createTask = false;

      _title = task.title;
      _titleFieldController.text = _title;
      _description = task.description;
      _descriptionFieldController.text = _description;
      _creatorId = task.creatorId;
      _ownerId = task.ownerId;
      _columnId = task.columnId;
      _timeEstimated = task.timeEstimated;
      _timeEstimatedFieldController.text = _timeEstimated;
      _colorId = task.colorId;
      _mainColor = TaskModel().getTaskColor(_colorId);
      _dateDue = task.dateDue != '0' ? task.dateDue : '';
      _dateDueFieldController.text = _dateDue;
      _dateStarted = task.dateStarted != '0' ? task.dateStarted : '';
      _dateStartedFieldController.text = _dateStarted;
      _priority = task.priority;
      _score = task.score;
      _scoreFieldController.text = _score;
      if (taskArgs.containsKey('tags'))
        taskArgs['tags'].forEach((TagModel element) {
          _tags.add(element.name);
        });
      taskArgs.removeWhere((key, value) => key == 'tags');
    }

    return Scaffold(
      appBar: normalAppBar(createTask ? 'New Task' : task.title),
      body: FutureBuilder(
        future: Future.wait([
          tagProvider.getTagsByProject(int.parse(project.id)),
          tagProvider.getDefaultTags(),
          userProvider.getUsers(),
          columnProvider.getColumns(int.parse(project.id)),
        ]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            _availableTags = new List.from(snapshot.data[0])
              ..addAll(snapshot.data[1]);
            _users = snapshot.data[2];
            _columns = snapshot.data[3];
            return ListView(
              padding: EdgeInsets.only(top: 10.0, bottom: 80.0),
              children: [_taskForm()],
            );
          } else {
            return Shimmer.fromColors(
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 10.0, bottom: 80.0),
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        _loadingTextField(),
                        SizedBox(height: 15.0),
                        _loadingTextField(),
                        SizedBox(height: 15.0),
                        _loadingTextField(),
                        SizedBox(height: 10.0),
                        _loadingTextField(),
                        SizedBox(height: 10.0),
                        _loadingTextField(),
                        SizedBox(height: 10.0),
                        _loadingTextField(),
                        SizedBox(height: 30.0),
                        _loadingColorPicker(),
                        SizedBox(height: 15.0),
                        Row(
                          children: [
                            new Flexible(
                              child: _loadingDateField(),
                            ),
                            new Flexible(
                              child: _loadingDateField(),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.0),
                        Row(
                          children: [
                            new Flexible(
                              child: _loadingPriorityField(),
                            ),
                            new Flexible(
                              child: _loadingScoreField(),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.0),
                      ],
                    );
                  }),
              baseColor: CustomColors.BlueDark,
              highlightColor: Colors.lightBlue[200],
            );
          }
        },
      ),
    );
  }

  Widget _taskForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _titleField(),
          SizedBox(height: 15.0),
          _descriptionField(),
          SizedBox(height: 15.0),
          _creatorSelect(),
          SizedBox(height: 10.0),
          _ownerSelect(),
          SizedBox(height: 10.0),
          _columnSelect(),
          SizedBox(height: 10.0),
          _timeEstimatedField(),
          SizedBox(height: 30.0),
          _taskColorPicker(),
          SizedBox(height: 15.0),
          Row(
            children: [
              new Flexible(
                child: _dateDueSelect(context),
              ),
              new Flexible(
                child: _datestartSelect(context),
              ),
            ],
          ),
          SizedBox(height: 15.0),
          Row(
            children: [
              new Flexible(
                child: _prioritySelect(),
              ),
              new Flexible(
                child: _scoreField(),
              ),
            ],
          ),
          SizedBox(height: 15.0),
          Container(
            margin: EdgeInsets.only(top: 15, left: 20),
            child: Text(
              'Choose Tags',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _projectTagsChips(),
          SizedBox(height: 40.0),
          _submitButton()
        ],
      ),
    );
  }

  Widget _titleField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
          controller: _titleFieldController,
          decoration: InputDecoration(
            hintText: 'Super Title',
            labelText: 'Title',
            suffixIcon:
                Icon(Icons.swap_horizontal_circle_outlined, color: Colors.blue),
          ),
          onChanged: (value) {},
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please type a title';
            }
            return null;
          }),
    );
  }

  Widget _loadingTextField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Loading',
          suffixIcon: Icon(Icons.support_sharp, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _loadingColorPicker() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Text('Task Color'),
          SizedBox(width: 20.0),
          Container(
            height: 40.0,
            width: 40.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0), color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _loadingDateField() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 10.0),
      child: TextFormField(
        enableInteractiveSelection: false,
        decoration: InputDecoration(
          hintText: 'Due Date',
          labelText: 'Due Date',
          suffixIcon: Icon(Icons.calendar_today_outlined, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _loadingPriorityField() {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 20.0, top: 5.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Complexity',
          suffixIcon: Icon(Icons.handyman_rounded, color: Colors.grey),
        ),
        onChanged: (value) {},
      ),
    );
  }

  Widget _loadingScoreField() {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 20.0, top: 5.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Complexity',
          suffixIcon: Icon(Icons.handyman_rounded, color: Colors.grey),
        ),
        onChanged: (value) {},
      ),
    );
  }

  Widget _descriptionField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        controller: _descriptionFieldController,
        decoration: InputDecoration(
          hintText: 'The quick brown fox jumped over...',
          labelText: 'Description',
          suffixIcon: Icon(Icons.library_books_outlined, color: Colors.blue),
        ),
        onChanged: (value) {},
      ),
    );
  }

  Widget _creatorSelect() {
    List<DropdownMenuItem<String>> usernameList = [];
    usernameList.add(DropdownMenuItem<String>(
        child: Text('Select Creator'), value: 0.toString()));

    _users.forEach((user) {
      usernameList.add(DropdownMenuItem<String>(
          child: Container(
            child: Text(
              user.name,
            ),
          ),
          value: user.id.toString()));
    });

    return Container(
      // margin: EdgeInsets.only(left: 40.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: DropdownButtonFormField(
        icon: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Icon(Icons.person_pin_circle_outlined, color: Colors.blue),
        ),
        items: usernameList,
        value: _creatorId,
        decoration: InputDecoration(helperText: 'Optional'),
        onChanged: (newValue) {
          _creatorId = newValue;
        },
      ),
    );
  }

  Widget _ownerSelect() {
    List<DropdownMenuItem<String>> usernameList = [];
    usernameList.add(DropdownMenuItem<String>(
        child: Text('Select Owner'), value: 0.toString()));
    _users.forEach((user) {
      usernameList.add(DropdownMenuItem<String>(
          child: Container(
            child: Text(
              user.name,
            ),
          ),
          value: user.id.toString()));
    });

    return Container(
      // margin: EdgeInsets.only(left: 40.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: DropdownButtonFormField(
        icon: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Icon(Icons.person, color: Colors.blue),
        ),
        items: usernameList,
        value: _ownerId,
        decoration: InputDecoration(helperText: 'Required'),
        onChanged: (newValue) {
          _ownerId = newValue;
        },
      ),
    );
  }

  Widget _columnSelect() {
    List<DropdownMenuItem<String>> columnList = [];
    columnList.add(DropdownMenuItem<String>(
        child: Text('Select Column'), value: 0.toString()));
    _columns.forEach((column) {
      columnList.add(DropdownMenuItem<String>(
          child: Container(
            child: Text(
              column.title,
            ),
          ),
          value: column.id.toString()));
    });
    return Container(
      // margin: EdgeInsets.only(left: 40.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: DropdownButtonFormField(
        icon: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Icon(Icons.view_column, color: Colors.blue),
        ),
        items: columnList,
        value: _columnId,
        decoration: InputDecoration(helperText: 'Optional'),
        onChanged: (newValue) {
          _columnId = newValue;
        },
      ),
    );
  }

  Widget _timeEstimatedField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: _timeEstimatedFieldController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Hours (Integer)',
          labelText: 'Original Estimate',
          suffixIcon: Icon(Icons.watch_later_outlined, color: Colors.blue),
        ),
        onChanged: (value) {},
      ),
    );
  }

  Widget _submitButton() {
    return RaisedButton(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
          child: Text(createTask ? 'Create' : 'Update'),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        elevation: 0.0,
        color: Colors.blue,
        textColor: Colors.white,
        onPressed: () {
          if (_formKey.currentState.validate() && _ownerId != '0') {
            _submitForm(context);
          } else {
            mostrarAlerta(context, 'Please, fill the Title and Owner fields!');
          }
        });
  }

  _submitForm(BuildContext context) async {
    _title = _titleFieldController.text;
    _description = _descriptionFieldController.text;
    _timeEstimated = _timeEstimatedFieldController.text;
    _dateDue = _dateDueFieldController.text;
    _dateStarted = _dateStartedFieldController.text;
    _score = _scoreFieldController.text;

    if (createTask) {
      Map<String, dynamic> formData = {
        "title": _title,
        "project_id": project.id,
        "description": _description,
        "creator_id": _creatorId,
        "owner_id": _ownerId,
        "column_id": _columnId,
        "time_estimated": _timeEstimated,
        "color_id": _colorId,
        "date_due": _dateDue,
        "date_started": _dateStarted,
        "priority": _priority,
        "score": _score,
        "tags": _tags,
      };
      int newTaskId = await taskProvider.createTask(formData);

      if (newTaskId > 0) {
        setState(() {
          Navigator.pop(context);
        });
      } else {
        mostrarAlerta(context, 'Something went Wront!');
      }
    } else {
      Map<String, dynamic> formData = {
        "id": task.id,
        "title": _title,
        "description": _description,
        "creator_id": _creatorId,
        "owner_id": _ownerId,
        "column_id": _columnId,
        "time_estimated": _timeEstimated,
        "color_id": _colorId,
        "date_due": _dateDue,
        "date_started": _dateStarted,
        "priority": _priority,
        "score": _score,
        "tags": _tags,
      };
      bool result = await taskProvider.updateTask(formData);
      if (result) {
        setState(() {
          Navigator.pop(context);
        });
      } else {
        mostrarAlerta(context, 'Something went Wront!');
      }
    }
  }

  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            TextButton(
              child: Text('CANCEL'),
              onPressed: Navigator.of(context).pop,
            ),
          ],
        );
      },
    );
  }

  void _openMainColorPicker() async {
    _openDialog(
      "Tag Color",
      Container(
        height: 200.0,
        child: MaterialColorPicker(
            selectedColor: _mainColor,
            colors: TaskModel().getTaskColorsList(),
            allowShades: false,
            onMainColorChange: (color) {
              _tempTaskColor = color;
              _colorId = TaskModel().getTaskColorName(color);
              Navigator.of(context).pop();
              setState(() => _mainColor = _tempTaskColor);
            }),
      ),
    );
  }

  _taskColorPicker() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Text('Task Color'),
          SizedBox(width: 20.0),
          GestureDetector(
            child: Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0), color: _mainColor),
            ),
            onTap: _openMainColorPicker,
          ),
        ],
      ),
    );
  }

  Widget _dateDueSelect(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 10.0),
      child: TextFormField(
        enableInteractiveSelection: false,
        controller: _dateDueFieldController,
        decoration: InputDecoration(
          hintText: 'Due Date',
          labelText: 'Due Date',
          suffixIcon: Icon(Icons.calendar_today_outlined, color: Colors.blue),
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _dateDueDateTime(context);
        },
      ),
    );
  }

  Widget _datestartSelect(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 20.0),
      child: TextFormField(
        enableInteractiveSelection: false,
        controller: _dateStartedFieldController,
        decoration: InputDecoration(
          hintText: 'Start Date',
          labelText: 'Start Date',
          suffixIcon: Icon(Icons.calendar_today, color: Colors.blue),
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _datestartDateTime(context);
        },
      ),
    );
  }

  _datestartDateTime(BuildContext context) async {
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: new DateTime(2018),
      maxTime: new DateTime(2025),
      onConfirm: (date) {
        _dateStarted = _dateStartedFieldController.text =
            DateFormat('dd/MM/yy HH:mm', 'en_US').format(date);
        _dateStartedFieldController.text =
            DateFormat('dd/MM/yy HH:mm', 'en_US').format(date);
        print(_dateStarted);
      },
      currentTime: DateTime.now(),
      locale: LocaleType.en,
    );
  }

  _dateDueDateTime(BuildContext context) async {
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: new DateTime(2018),
      maxTime: new DateTime(2025),
      onConfirm: (date) {
        _dateDue = _dateDueFieldController.text =
            DateFormat('dd/MM/yy HH:mm', 'en_US').format(date);
        _dateDueFieldController.text =
            DateFormat('dd/MM/yy HH:mm', 'en_US').format(date);
        print(_dateDue);
      },
      currentTime: DateTime.now(),
      locale: LocaleType.en,
    );
  }

  Widget _prioritySelect() {
    return Container(
      // margin: EdgeInsets.only(left: 40.0),
      padding: EdgeInsets.only(left: 20.0, right: 10.0),
      child: DropdownButtonFormField(
        icon: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Icon(Icons.star_border, color: Colors.blue),
        ),
        items: [
          DropdownMenuItem<String>(child: Text('0'), value: 0.toString()),
          DropdownMenuItem<String>(child: Text('1'), value: 1.toString()),
          DropdownMenuItem<String>(child: Text('2'), value: 2.toString()),
          DropdownMenuItem<String>(child: Text('3'), value: 3.toString()),
        ],
        value: _priority,
        decoration: InputDecoration(labelText: 'Priority'),
        onChanged: (newValue) {
          _priority = newValue;
        },
      ),
    );
  }

  // COMPLEXITY
  Widget _scoreField() {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 20.0, top: 5.0),
      child: TextFormField(
        controller: _scoreFieldController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Complexity',
          suffixIcon: Icon(Icons.handyman_rounded, color: Colors.blue),
        ),
        onChanged: (value) {},
      ),
    );
  }

  _projectTagsChips() {
    if (_availableTags.length > 0) {
      List<Widget> chips = [];
      _availableTags.forEach((tag) {
        chips.add(InputChip(
          backgroundColor: CustomColors.HeaderBlueLight,
          elevation: 4.0,
          label: Text(tag.name),
          selected: _tags.contains(tag.name) ? true : false,
          onSelected: (bool selected) {
            setState(() {
              selected == true
                  ? _tags.add(tag.name)
                  : _tags.removeWhere((element) => element == tag.name);
            });
          },
        ));
      });
      return Wrap(spacing: 5.0, children: chips);
    } else {
      return Text('No Tags');
    }
  }
}
