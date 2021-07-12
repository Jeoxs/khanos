import 'package:flutter/material.dart';
import 'package:khanos/src/utils/widgets_utils.dart';

class KanbanPage extends StatefulWidget {
  @override
  _KanbanPageState createState() => _KanbanPageState();
}

class _KanbanPageState extends State<KanbanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: normalAppBar('project'),
      body: _getKanban(),
    );
  }

  _getKanban() {
    return Container();
  }
}
