import 'package:flutter/material.dart';
import 'package:todo_app/shared/style/colors.dart';

GlobalKey<FormState> formKey = GlobalKey<FormState>();
TextEditingController taskController = TextEditingController();

Widget addOrEditTaskScreen({
  String? tFormFieldHint,
  required BuildContext context,
  required String buttonText,
  required String sheetTitle,
  required Function buttonFunction,
}) {
  return SingleChildScrollView(
    child: Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0),
        child: Column(
          children: [
            Text(
              sheetTitle,
              style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  color: secondaryColor),
            ),
            Form(
              key: formKey,
              child: TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'task can not be empty';
                  } else {
                    return null;
                  }
                },
                autofocus: true,
                controller: taskController,
                maxLength: 60,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  hintText: tFormFieldHint,
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: secondaryColor)),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: MaterialButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    buttonFunction();
                  }
                },
                height: 40,
                color: primaryColor,
                child: Text(
                  buttonText,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
