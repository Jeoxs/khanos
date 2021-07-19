import 'package:flutter/material.dart';
import 'package:khanos/src/providers/project_provider.dart';
import 'package:khanos/src/utils/utils.dart';
import 'package:khanos/src/utils/widgets_utils.dart';

class NewProjectPage extends StatefulWidget {
  // NewProjectPage({Key? key}) : super(key: key);

  @override
  _NewProjectPageState createState() => _NewProjectPageState();
}

class _NewProjectPageState extends State<NewProjectPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ProjectProvider projectProvider = new ProjectProvider();

  String _name = '';
  String _description = '';
  String _identifier = '';

  TextEditingController _nameFieldController = new TextEditingController();
  TextEditingController _descriptionFieldController =
      new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: normalAppBar('New Project'),
      body: _newProjectForm(),
    );
  }

  _newProjectForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _nameField(),
          SizedBox(height: 20.0),
          _descriptionField(),
          // SizedBox(height: 20.0),
          // _identifierField(),
          SizedBox(height: 40.0),
          _submitButton(),
        ],
      ),
    );
  }

  Widget _nameField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
          controller: _nameFieldController,
          decoration: InputDecoration(
            hintText: 'My super Project',
            labelText: 'Name',
            suffixIcon: Icon(Icons.star, color: Colors.blue),
          ),
          onChanged: (value) {
            _name = value;
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please type a Project name';
            }
            return null;
          }),
    );
  }

  _submitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState.validate()) {
          showLoaderDialog(context);
          _createProject(context);
        } else {
          mostrarAlerta(context, 'Please fill required fields');
        }
      },
      child: Text('Create Project'),
      style: ElevatedButton.styleFrom(elevation: 5.0),
    );
  }

  _createProject(BuildContext context) async {
    int newProjectId =
        await ProjectProvider().createProject(_name, _identifier, _description);

    Navigator.pop(context);
    if (newProjectId > 0) {
      setState(() {
        Navigator.pop(context);
      });
    } else {
      mostrarAlerta(context, 'Something went Wront!');
    }
    return true;
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
        onChanged: (value) {
          _description = value;
        },
      ),
    );
  }
}
