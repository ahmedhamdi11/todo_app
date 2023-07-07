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
    AppCubit cubit = BlocProvider.of<AppCubit>(context);
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: primaryColor,

          //add a new task (FAB)
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            backgroundColor: secondaryColor,
            onPressed: () {
              addOrEditTask(
                context: context,
                buttonText: 'add',
                sheetTitle: 'Add Task',
                buttonFunction: () {
                  cubit.insertData(taskTitle: taskController.text);
                },
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
                  const Row(
                    children: [
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
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            fontFamily: 'jannah'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),

                  // number of tasks
                  Text(
                    '${cubit.tasksData.length} tasks',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
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
                            const Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
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
                                    checkBoxValue: cubit.tasksData[index]
                                                ['status'] ==
                                            'new'
                                        ? false
                                        : true,
                                    onChangingCheckBox: (bool? val) {
                                      cubit.changeCheckBoxValue(index);
                                    },
                                    taskContent: cubit.tasksData[index]
                                        ['title'],
                                    deleteTask: (context) {
                                      cubit.deleteData(
                                          id: cubit.tasksData[index]['id']);
                                    },
                                    editTask: (context) {
                                      addOrEditTask(
                                        context: context,
                                        buttonText: 'Update',
                                        sheetTitle: 'Update task',
                                        tFormFieldHint: cubit.tasksData[index]
                                            ['title'],
                                        buttonFunction: () {
                                          cubit.updateData(
                                            taskTitle: taskController.text,
                                            id: cubit.tasksData[index]['id'],
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
