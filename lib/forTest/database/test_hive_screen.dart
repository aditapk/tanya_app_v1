import 'dart:developer';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:tanya_app_v1/forTest/database/models/task_model.dart';
import 'package:tanya_app_v1/forTest/database/task_editor_screen.dart';
import 'package:tanya_app_v1/main.dart';

class TestHiveScreen extends StatelessWidget {
  TestHiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    log("Widget : TestHiveScreen");
    print("test command");
    var date = formatDate(DateTime.now(), [d, M, yyyy]);
    print(date);
    //var box = Hive.box('tasks');
    //print(box.values.length);

    return Scaffold(
      appBar: AppBar(
        title: Text('Hive Task DB'),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Task>('tasks').listenable(),
        builder: (context, box, _) {
          return Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Today's task",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  formatDate(DateTime.now(), [d, ", ", M, ", ", yyyy]),
                ),
                Divider(
                  height: 40,
                  color: Colors.grey,
                  thickness: 1.0,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: box.values.length,
                    itemBuilder: (context, index) {
                      Task task = box.getAt(index)!;
                      return ListTile(
                        task: task,
                        index: index,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(
            () => TaskEditorScreen(),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ListTile extends StatelessWidget {
  ListTile({super.key, required this.index, required this.task});

  int index;
  Task task;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.blue.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title!,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Get.to(() => TaskEditorScreen(task: task));
                  },
                  icon: Icon(
                    Icons.edit,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Delete Task
                    task.delete();
                  },
                  icon: Icon(
                    Icons.delete,
                  ),
                )
              ],
            ),
            Divider(
              color: Colors.black54,
              height: 10,
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),
            Text(task.note!)
          ],
        ),
      ),
    );
  }
}
