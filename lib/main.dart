import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/auth/auth_repository.dart';
import 'core/auth/auth_bloc/auth_bloc.dart';
import 'core/auth/view/login_screens/login_page.dart';
import 'core/local_db.dart';
import 'home_page.dart';
import 'weight/bloc/weight_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    LocalDb.initStorage(),
    Firebase.initializeApp(),
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WeightBloc(),
        ),
        BlocProvider(
          create: (context) =>
              AuthBloc(authenticationRepository: AuthenticationRepository()),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData.dark(),
        title: 'Epic Weight Tracker',
        routes: {
          HomePage.id: (context) => const HomePage(),
          LoginPage.id: (context) => const LoginPage(),
        },
        initialRoute:
            LocalDb.currentUser() == null ? LoginPage.id : HomePage.id,
      ),
    );
  }
}
