import 'package:flutter/material.dart';

class MyAppFunctions {
  static Future<void> showErrorOrWarningDialog({
    required BuildContext context,
    required String text,
    bool isError = true,
    required Function fct,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: fct(),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(text),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: fct(),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.cancel,
                        color: Colors.green,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(text),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

// static Future<void> imagePickerDialog({
//   required BuildContext context,
//   required Function cameraFct,
//   required Function galleryFct,
//   required Function removeFct,
// }) async {
//   await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           title: const Center(
//             child: TitlesTextWidget(label: 'Choose Option'),
//           ),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: [
//                 TextButton.icon(
//                   onPressed: () {
//                     cameraFct();
//                     if (Navigator.canPop(context)) {
//                       Navigator.pop(context);
//                     }
//                   },
//                   label: const Text(
//                     'Camera',
//                     style: TextStyle(color: Colors.black),
//                   ),
//                   icon: const Icon(Icons.camera,color: Colors.purple,),
//                 ),
//                 TextButton.icon(
//                   onPressed: () {
//                     galleryFct();
//                     if (Navigator.canPop(context)) {
//                       Navigator.pop(context);
//                     }
//                   },
//                   label: const Text(
//                     'Gallery',
//                     style: TextStyle(color: Colors.black),
//                   ),
//                   icon: const Icon(Icons.image,color: Colors.pinkAccent,),
//                 ),
//                 TextButton.icon(
//                   onPressed: () {
//                     removeFct();
//                     if (Navigator.canPop(context)) {
//                       Navigator.pop(context);
//                     }
//                   },
//                   label: const Text(
//                     'Remove',
//                     style: TextStyle(color: Colors.black),
//                   ),
//                   icon: const Icon(Icons.remove_circle_outline,color: Colors.red,),
//                 ),
//               ],
//             ),
//           ),
//         );
//       });
// }
}
