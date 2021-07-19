import 'package:khanos/src/models/column_model.dart';
import 'package:khanos/src/utils/board_item_object.dart';

class BoardListObject {
  String title;
  List<BoardItemObject> items;
  ColumnModel columnContent;

  BoardListObject({this.title, this.items, this.columnContent}) {
    if (this.title == null) {
      this.title = "";
    }
    if (this.items == null) {
      this.items = [];
    }
    if (this.columnContent == null) {
      this.columnContent = null;
    }
  }
}
