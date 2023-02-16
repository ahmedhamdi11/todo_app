import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/cubit.dart';
import 'package:todo_app/cubit/states.dart';
import 'package:todo_app/shared/component/bottom_sheet.dart';
import 'package:todo_app/shared/component/task_tile.dart';
import 'package:todo_app/shared/style/colors.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          backgroundColor: primaryColor,

          //add a new task (FAB)
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            backgroundColor: secondaryColor,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => addOrEditTaskScreen(
                  context: context,
                  buttonText: 'add',
                  sheetTitle: 'Add Task',
                  buttonFunction: () {
                    cubit.insertToDatabase(taskContent: taskController.text);
                    taskController.clear();
                    Navigator.pop(context);
                  },
                ),
              );
            },
            child: const Icon(Icons.add),
          ),

          //HOME SCREEN
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            //main column
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //App Title (What ToDo)
                Row(
                  children: const [
                    Icon(
                      Icons.done_all_outlined,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'What ToDo',
                      style:
                          TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              fontFamily: 'jannah'
                          ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),

                // number of tasks
                Row(
                  children: [
                    Text(
                      '${cubit.tasksData.length} tasks',
                      style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 25,
                      child: MaterialButton(
                           color: secondaryColor,
                          onPressed: () {
                            showDialog(

                                context: context,
                                builder: (context) => AlertDialog(
                                      content: const Text(
                                          'are you sure you want to delete all todos?'),
                                      actions: [
                                        MaterialButton(
                                          height: 30,
                                          color:Colors.red,
                                            onPressed: () {
                                              cubit.deleteAllFromDatabase();
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'delete',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        MaterialButton(
                                          height: 30,
                                            color:secondaryColor,
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ))
                                      ],
                                    ));
                          },
                          child:const Text(
                            'delete',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                    const SizedBox(
                      width: 5.0,
                    )
                  ],
                ),

                //tasks list
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 35.0, top: 10),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: cubit.tasksData.isEmpty
                          ?
                          //if there is no tasks
                          Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.checklist_rounded,
                                    color: Colors.grey,
                                    size: 70,
                                  ),
                                  Text(
                                    'no tasks yet',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 16),
                                  ),
                                ],
                              ),
                            )
                          //if the user have tasks
                          : ListView.builder(
                              itemCount: cubit.tasksData.length,
                              itemBuilder: (context, index) {
                                return TasksTile(
                                  checkBoxValue:
                                      cubit.tasksData[index]['status'] == 'new'
                                          ? false
                                          : true,
                                  onChangingCheckBox: (bool? val) {
                                    cubit.changeCheckBoxValue(index);
                                  },
                                  taskContent: cubit.tasksData[index]['task'],
                                  deleteTask: (context) =>
                                      cubit.deleteFromDatabase(
                                          cubit.tasksData[index]['id']),
                                  editTask: (context) {
                                    cubit.editTask(
                                        tFormFieldHint: cubit.tasksData[index]
                                                ['task']
                                            .toString(),
                                        taskId: cubit.tasksData[index]['id'],
                                        context: context,
                                        controller: taskController);
                                  },
                                );
                              }),
                    ),
                  ),
                ),
              ],
            ),
          )),
        );
      },
    );
  }
}
