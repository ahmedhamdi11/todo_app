import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TasksTile extends StatelessWidget {
  final String taskContent;
  final Function(BuildContext) deleteTask;
  final Function(BuildContext) editTask;
  final Function(bool? val)? onChangingCheckBox;
  final bool checkBoxValue;
  const TasksTile({
    super.key,
    required this.taskContent,
    required this.deleteTask,
    required this.editTask,
    required this.onChangingCheckBox,
    required this.checkBoxValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Slidable(
        closeOnScroll: false,
        endActionPane: ActionPane(motion: const StretchMotion(), children: [
          SlidableAction(
            onPressed: deleteTask,
            backgroundColor: Colors.grey[100]!,
            foregroundColor: Colors.red,
            icon: Icons.delete,
            borderRadius: BorderRadius.circular(15.0),
          ),
          SlidableAction(
            onPressed: editTask,
            backgroundColor: Colors.grey[100]!,
            foregroundColor: const Color(0xFF21B7CA),
            icon: Icons.edit,
            borderRadius: BorderRadius.circular(15.0),
          ),
        ]),
        child: Container(
          height: 60,
          padding: const EdgeInsets.only(right: 8.0),
          decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(15.0)),
          child: Row(children: [
            Checkbox(
              activeColor: Colors.teal[400],
              value: checkBoxValue,
              onChanged: onChangingCheckBox,
            ),
            Expanded(
              child: Text(
                taskContent,
                maxLines: 2,
              ),
            ),
            const Icon(
              Icons.arrow_back,
              size: 20,
              color: Colors.grey,
            )
          ]),
        ),
      ),
    );
  }
}
