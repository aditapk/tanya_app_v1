// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// import 'models/test_medicine_info_model.dart';
// import 'dart:math';

// class TestMedicineInfoScreen extends StatelessWidget {
//   const TestMedicineInfoScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Test Medicine Database"),
//       ),
//       body: ValueListenableBuilder(
//         valueListenable:
//             Hive.box<TestMedicineInfo>('medicine_info').listenable(),
//         builder: (BuildContext context, box, _) {
//           // re-build when box<medicineInf> is changed
//           var boxdata = box.values;
//           return Text("boxdata = ${boxdata.length}");
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           var box = Hive.box<TestMedicineInfo>('medicine_info');
//           print(box);
//           var rng = Random();
//           var data = TestMedicineInfo(
//             name: "test_put_${rng.nextInt(100)}",
//             description: "description_test",
//             nTake: 5,
//             order: "before",
//             period_time: ["morning", "launch"],
//             type: "pills",
//           );
//           //await box.put("test", data);
//           int index = await box.add(data);
//           print("index = $index");
//           var gdata = box.get(index);
//           print("${gdata?.name}");
//         },
//         child: const Icon(
//           Icons.add,
//         ),
//       ),
//     );
//   }
// }
