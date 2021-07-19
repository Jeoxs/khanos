import 'package:flutter/material.dart';
import 'package:khanos/src/models/task_model.dart';
import 'package:khanos/src/models/user_model.dart';
import 'package:khanos/src/providers/subtask_provider.dart';
import 'package:khanos/src/providers/user_provider.dart';
import 'package:khanos/src/utils/utils.dart';
import 'package:khanos/src/utils/widgets_utils.dart';

class NewSubtaskPage extends StatefulWidget {
  @override
  _NewSubtaskPageState createState() => _NewSubtaskPageState();
}

class _NewSubtaskPageState extends State<NewSubtaskPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final userProvider = new UserProvider();
  final subtaskProvider = new SubtaskProvider();
  TaskModel task = new TaskModel();
  List<UserModel> _users = [];

  String title = '';
  String _userId = '0';

  TextEditingController _titleFieldController = new TextEditingController();
  TextEditingController _timeEstimatedFieldController =
      new TextEditingController();

  @override
  void initState() {
    super.initState();
    // this should not be done in build method.
    // _users = await _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    final Map taskArgs = ModalRoute.of(context).settings.arguments;
    task = taskArgs['task'];
    return Scaffold(
      appBar: normalAppBar('New Subtask'),
      body: _newSubtaskForm(),
    );
  }

  Widget _newSubtaskForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 15, left: 20),
            child: Text(
              'For Task #${task.id}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _titleField(),
          SizedBox(height: 15.0),
          _userSelect(),
          SizedBox(height: 10.0),
          _timeEstimatedField(),
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

  Widget _userSelect() {
    return FutureBuilder(
      future: userProvider.getUsers(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        List<DropdownMenuItem<String>> usernameList = [];
        if (snapshot.hasData) {
          usernameList.add(DropdownMenuItem<String>(
              child: Text('Select user'), value: 0.toString()));
          _users = snapshot.data;
        } else {
          usernameList.add(DropdownMenuItem<String>(
              child: Text('Loading..'), value: 0.toString()));
        }
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
            onTap: () {FocusScope.of(context).requestFocus(new FocusNode());},
            icon: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(Icons.person, color: Colors.blue),
            ),
            items: usernameList,
            value: _userId,
            decoration: InputDecoration(helperText: 'Optional'),
            onChanged: (newValue) {
              _userId = newValue;
            },
          ),
        );
      },
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
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(5.0),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
        child: Text('Create'),
      ),
      onPressed: () {
        if (_formKey.currentState.validate()) {
          _createSubtask(context);
        } else {
          mostrarAlerta(context, 'Please fill required Fields');
        }
      },
    );
  }

  _createSubtask(BuildContext context) async {
    final String _subtaskTitle = _titleFieldController.text;
    final String _subtaskUserId = _userId;
    final String _subtaskTimeEstimated = _timeEstimatedFieldController.text;

    int newSubtaskId = await subtaskProvider.createSubtask(int.parse(task.id),
        _subtaskTitle, int.parse(_subtaskUserId), _subtaskTimeEstimated);

    if (newSubtaskId > 0) {
      setState(() {
        Navigator.pop(context);
      });
    } else {
      mostrarAlerta(context, 'Something went Wront!');
    }
  }
}
