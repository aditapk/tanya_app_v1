// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hive/hive.dart';
// import 'package:tanya_app_v1/forTest/database/test_hive_screen.dart';

// import 'models/task_model.dart';

// class TaskEditorScreen extends StatelessWidget {
//   TaskEditorScreen({this.task, super.key});
//   Task? task;

//   @override
//   Widget build(BuildContext context) {
//     TextEditingController _taskTitle = TextEditingController(
//       text: task?.title,
//     );
//     TextEditingController _taskNote = TextEditingController(
//       text: task?.note,
//     );
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(task == null ? "Add new Task" : "Update Task"),
//         elevation: 0.0,
//         backgroundColor: Colors.transparent,
//         foregroundColor: Colors.black,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Title"),
//             TextFormField(
//               controller: _taskTitle,
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Text("Note"),
//             TextFormField(
//               controller: _taskNote,
//             ),
//             Expanded(
//               child: Align(
//                 alignment: FractionalOffset.bottomCenter,
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     var newTask = Task(
//                       title: _taskTitle.text,
//                       note: _taskNote.text,
//                     );
//                     if (task != null) {
//                       // update
//                       task!.title = newTask.title;
//                       task!.note = newTask.note;
//                       task!.save();
//                     } else {
//                       // Add new task
//                       // ref box
//                       Box<Task> taskBox = Hive.box<Task>('tasks');
//                       await taskBox.add(newTask);
//                     }
//                     Get.to(() => TestHiveScreen());
//                   },
//                   child: Text(task == null ? "Add new Task" : "Update Task"),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
