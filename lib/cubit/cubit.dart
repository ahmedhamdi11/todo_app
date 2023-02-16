import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/states.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/component/bottom_sheet.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  late Database tasksDatabase;
  List<Map> tasksData = [];
////////////////
  void changeCheckBoxValue(index) {
    if (tasksData[index]['status'] == 'new') {
      updateTaskStatusInDatabase(
          newTaskStatus: 'done', id: tasksData[index]['id']);
      emit(CheckBoxChangedState());
    } else {
      updateTaskStatusInDatabase(
          newTaskStatus: 'new', id: tasksData[index]['id']);
      emit(CheckBoxChangedState());
    }
  }

///////////////
  void createDatabase() {
    openDatabase(
      'what_todo.db',
      version: 1,
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE TASKS (id INTEGER PRIMARY KEY,task TEXT,status TEXT)');
      },
      onOpen: (db) async {
        await getDataFromDatabase(db);
      },
    ).then((value) {
      tasksDatabase = value;
      emit(CreateDatabaseSuccessState());
    });
  }

/////////////////
  Future getDataFromDatabase(database) async {
    tasksData = [];
    return await database.rawQuery('SELECT * FROM TASKS').then((value) {
      value.forEach((e) {
        tasksData.add(e);
      });
      emit(GetDataSuccessState());
    }).catchError((error) {
      emit(GetDataErrorState());
    });
  }

////////////////////
  void insertToDatabase({
    required String taskContent,
  }) {
    tasksDatabase.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO TASKS (task,status) VALUES("$taskContent", "new")')
          .then((value) {
        getDataFromDatabase(tasksDatabase);
      });
    });
  }

///////////////
  void deleteFromDatabase(id) async {
    await tasksDatabase
        .rawDelete('DELETE FROM TASKS WHERE id=?', [id]).then((value) {
      getDataFromDatabase(tasksDatabase);
    });
  }

  void deleteAllFromDatabase() async {
    await tasksDatabase.rawDelete('DELETE FROM TASKS').then((value) {
      getDataFromDatabase(tasksDatabase);
    });
  }

///////////////////
  void updateTaskContentInDatabase({
    required String newTaskContent,
    required int id,
  }) async {
    await tasksDatabase.rawUpdate('UPDATE TASKS SET task = ? WHERE id = ?',
        [newTaskContent, id]).then((value) {
      getDataFromDatabase(tasksDatabase);
    });
  }

/////////////////
  void updateTaskStatusInDatabase({
    required String newTaskStatus,
    required int id,
  }) async {
    await tasksDatabase.rawUpdate('UPDATE TASKS SET status = ? WHERE id = ?',
        [newTaskStatus, id]).then((value) {
      getDataFromDatabase(tasksDatabase);
    });
  }

  //////////////
  void editTask({
    String? tFormFieldHint,
    required BuildContext context,
    required TextEditingController controller,
    required int taskId,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) => addOrEditTaskScreen(
          tFormFieldHint: tFormFieldHint,
          buttonText: 'update',
          sheetTitle: 'Update Task',
          buttonFunction: () {
            updateTaskContentInDatabase(
              id: taskId,
              newTaskContent: controller.text,
            );
            controller.clear();
            Navigator.pop(context);
          },
          context: context),
    );
  }
}
