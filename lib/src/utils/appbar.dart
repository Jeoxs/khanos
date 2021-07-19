import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:khanos/src/utils/theme_utils.dart';
import 'package:khanos/src/utils/widgets_utils.dart';

class KhanosAppBar extends StatefulWidget {
  final String title;

  final Map<String, dynamic> arguments;

  KhanosAppBar({this.title, this.arguments});

  @override
  _KhanosAppBarState createState() => _KhanosAppBarState();
}

class _KhanosAppBarState extends State<KhanosAppBar> {
  @override
  Widget build(BuildContext context) {
    Widget appBarButton;
    if (widget.arguments != null) {
      appBarButton = IconButton(
        icon: Icon(widget.arguments['icon']),
        onPressed: () {
          Navigator.pushNamed(
                  widget.arguments['context'], widget.arguments['route'],
                  arguments: widget.arguments['arguments'])
              .then((_) => setState(() {}));
        },
      );
    } else {
      appBarButton = Container();
    }
    return PreferredSize(
      preferredSize: Size.fromHeight(60.0),
      child: GradientAppBar(
        flexibleSpace: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CustomPaint(
              painter: CircleOne(),
            ),
            CustomPaint(
              painter: CircleTwo(),
            ),
          ],
        ),
        title: Container(
          // margin: EdgeInsets.only(top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          appBarButton
          // Container(
          //   margin: EdgeInsets.fromLTRB(0, 20, 20, 0),
          //   child: Image.asset('assets/images/photo.png'),
          // ),
        ],
        elevation: 0,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [CustomColors.HeaderBlueDark, CustomColors.HeaderBlueLight],
        ),
      ),
    );
  }
}
