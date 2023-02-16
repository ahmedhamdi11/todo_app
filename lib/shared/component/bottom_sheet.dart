import 'package:flutter/material.dart';

var taskController = TextEditingController();
Widget addOrEditTaskScreen({
  String? tFormFieldHint,
  required BuildContext context,
  required String buttonText,
  required String sheetTitle,
  required Function() buttonFunction,
}) {
  return SingleChildScrollView(
    child: Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              sheetTitle,
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[400]),
            ),
            TextFormField(
              autofocus: true,
              controller: taskController,
              maxLength: 60,
              textAlign: TextAlign.center,
              decoration: InputDecoration(hintText: tFormFieldHint),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: MaterialButton(
                onPressed: buttonFunction,
                height: 40,
                color: Colors.teal[400],
                child: Text(buttonText),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
