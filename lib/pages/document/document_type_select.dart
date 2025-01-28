// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:skeletonizer/skeletonizer.dart';
// import 'package:staff_view_ui/pages/lookup/lookup_controller.dart';

// class DocumentTypeSelect extends StatelessWidget {
//   DocumentTypeSelect({super.key});
//   final LookupController controller = Get.put(LookupController());

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
      
//       return Container(
//         height: 45,
//         margin: const EdgeInsets.only(top: 0, bottom: 10),
//         child: ListView.builder(
//           scrollDirection: Axis.horizontal,
//           itemCount: controller.exceptionTypes.length,
//           itemBuilder: (context, index) {
//             final exceptionType = controller.exceptionTypes[index];
//             return Padding(
//               padding: const EdgeInsets.only(right: 8),
//               child: Obx(() {
//                 final isSelected =
//                     controller.exceptionType.value == exceptionType.id;

//                 return ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     elevation: 0,
//                     backgroundColor: isSelected
//                         ? Theme.of(context).colorScheme.primary
//                         : Colors.white,
//                     foregroundColor: isSelected ? Colors.white : Colors.black,
//                     side: BorderSide(
//                       color: Theme.of(context).colorScheme.primary,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                   ),
//                   onPressed: () {
//                     controller.exceptionType.value = exceptionType.id!;
//                     controller.search();
//                   },
//                   child: Text(exceptionType.name ?? ''),
//                 );
//               }),
//             );
//           },
//         ),
//       );
//     });
//   }
// }
