import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:khanos/src/utils/widgets_utils.dart';

class ChangelogPage extends StatelessWidget {
  final ScrollController scrollController = new ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: normalAppBar('Changelog'),
      body: _showChangelog(),
    );
  }

  _showChangelog() {
    final String changelog = """
## Version 1.1.6
### **Added** 🚀
- Swimlane Support for Tasks
- My Tasks page
- Note about 2FA on login

## Version 1.1.5
### **Added** 🚀
- Users can create personal projects.

### **Fixed**  🔧
- Users can access projects and interact depending on their permission | Thanks: @bobylapointe63.

## Version 1.1.4
### **Fixed**  🔧
- Users can login regardless of their profile type | Thanks: @bobylapointe63.

## Version 1.1.3
### **Fixed**  🔧
- Fixed the Dark Theme colors on Login Page after logging out | Thanks: @murchu27.

## Version 1.1.2
### **Changed** 🔄
- The login URL doesn't need the 'jsonrpc.php' anymore. Users can type only the Kanboard URL or specify the 'jsonrpc.php' endpoint if needed. | Thanks: @murchu27.

### **Fixed**  🔧
- Uncaught login error redirected to login screen without valid credentials | Thanks: @murchu27.

## Version 1.1.1
### **Added** 🚀
- Added Avatars to Tasks, subtasks, comments and Kanban
- Changed Logo design to comply with Google Play Policies

### **Fixed**  🔧
- Kanban now refresh elements after pop out from task page.

## Version 1.1.0
### **Added** 🚀
- Changelog Section in Side Menu showing this Changelog
- Added Tutorial Dialog image for Cards

### **Changed** 🔄
- Shimmer Animation colors for loading Activities

### **Fixed** 🔧
- Empty Overdue Tasks now shows the Empty Icon Image
- Common Framework Bugs and warnings 
  
  
## Version 1.0.9
### **Added** 🚀 
- Comments section for tasks. User can add comments and remove them
- Added Overdue Tasks page in Home
- Added Activity Page in Home
  
### **Fixed** 🔧
- Kanban Columns duplicated when moving Items
  

## Version 1.0.8
### **Added** 🚀
- Subtasks can be Reordered by long pressing and Drag.

## Version 1.0.7
### **Added** 🚀
- Close Task Functionality
- Sound Feedback when tapping Cards
- Time Spent for Subtasks

### **Fixed** 🔧
- Cards Can be re-arranged inside column on Kanban
- Bottom padding on Tasks/Subtasks lists.
- Lowered Circle decoration in AppBar to fix overlaping in dark Mode
- Fixed Project Page task List not refreshing when updating the task
  

## Version 1.0.6
### **Added** 🚀
- Kanban Functionality. Now you can drag tasks in Kanban View among columns.
- Added About Page
- Added developer's support link.

### **Changed** 🔄
- Wrapped Tasks/subtasks card's titles text to show full title of task, instead of excerpt

### **Fixed** 🔧
- Going back to login when logging in.
  

## Version 1.0.5
### **Added** 🚀
- Dark Mode
  

## Version 1.0.4
### **Added** 🚀
- Drawer Menu on Home Page with items
    - Support Link to This Github Repo
    - Logout option
- Projects can now be deleted with Slidable feature.
- Changed package Name as standars suggests. Note: You may want to uninstall the old app, as this one will use a new Package name.
  

## Version 1.0.3
### **Added** 🚀
- Redirect to Login Screen if login credentials fails, notifying the user with a notification Bar at the bottom.
- Added Spent Time Field for Tasks
- Added "In Progress" Status for Subtasks. Now Subtasks have all the 3 status (undone, progress, completed).
- Added TimeTracking start/end for subtasks when started/completed
  
### **Changed** 🔄
- Changed task Page loading animation design.

### **Fixed** 🔧 
- Fixed Validation of response data from Server and added handling
- Fixed Color Picker from Task Form
- Fixed DateTime Fields in Task Form, adding a Limit date/time depending on Start/Due date selection
- Home Screen shows projects by User
  

## Version 1.0.2
### **Added** 🚀
- Added Validation to API errors 403 Forbidden in Project Page

### **Fixed** 🔧
- Fixed Ending loading Project Page, because of 403 errors from API
  

## Version 1.0.1
### **Fixed** 🔧
- Fixed Signatures for App in AndroidManifest & build.gradle.
- Fixed Title name in Main.dart (This title affects the running application in Android Devices)
  

##Version 1.0
### **Added** 🚀
- Initial Release.

  """;

    return Markdown(
      controller: scrollController,
      selectable: true,
      data: changelog,
    );
  }
}
