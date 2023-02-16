import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc_observer.dart';
import 'package:todo_app/cubit/cubit.dart';
import 'package:todo_app/layout/home_layout.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: MaterialApp(
        title: 'todo_app',
        home: HomeLayout(),
      ),
    );
  }
}
