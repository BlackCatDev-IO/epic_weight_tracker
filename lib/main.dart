import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/local_db.dart';
import 'home_page.dart';
import 'weight/bloc/weight_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDb.initStorage();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      title: 'Epic Weight Tracker',
      home: BlocProvider(
        create: (context) => WeightBloc(),
        child: const HomePage(),
      ),
    );
  }
}
