import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/states.dart';
import 'package:todo_app/sql_database.dart/sql_database.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());

  List<Map> tasksData = [];
  SqlDatabase sqlDatabase = SqlDatabase();

  void changeCheckBoxValue(index) {
    if (tasksData[index]['status'] == 'new') {
      updatTaskStatus(newStatus: 'done', id: tasksData[index]['id']);
      getData();
    } else {
      updatTaskStatus(newStatus: 'new', id: tasksData[index]['id']);
      getData();
    }
  }

  updatTaskStatus({required String newStatus, required int id}) async {
    await sqlDatabase.updateTaskStatus(newStatus: newStatus, id: id);
  }

  getData() async {
    emit(GetDataLoadingState());
    tasksData = [];
    List<Map> response = await sqlDatabase.getData();
    tasksData.addAll(response);
    emit(GetDataSuccessState());
  }

  insertData({required String taskTitle}) async {
    emit(InsertDataLoadingState());
    int response = await sqlDatabase.insertData(taskTitle: taskTitle);
    if (response > 0) {
      emit(InsertDataSuccessState());
      getData();
    } else {
      emit(InsertDataErrorState());
    }
  }

  updateData({required String taskTitle, required int id}) async {
    emit(InsertDataLoadingState());
    int response = await sqlDatabase.updateData(newTitle: taskTitle, id: id);
    if (response > 0) {
      emit(InsertDataSuccessState());
      getData();
    } else {
      emit(InsertDataErrorState());
    }
  }

  deleteData({required int id}) async {
    emit(InsertDataLoadingState());
    int response = await sqlDatabase.deleteData(id: id);
    if (response > 0) {
      emit(InsertDataSuccessState());
      tasksData.removeWhere((e) => e['id'] == id);
    } else {
      emit(InsertDataErrorState());
    }
  }
}
