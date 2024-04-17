import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqfliteflutter/database/db_helper.dart';
import 'package:sqfliteflutter/screens/homepage.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await LocalDatabase.instance.databse;
//   runApp(const ProviderScope(child: MyApp()));
// }
void main() {
  runZonedGuarded(() async {
    await init();
    runApp(const ProviderScope(child: MyApp()));
  }, (error, stackTrace) {
    print('Error occurred: $error');
  });
}

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    DatabaseHelper;
  } catch (error) {
    print('Error initializing Hive: $error');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Homepage());
  }
}

class TextPage extends ConsumerWidget {
  const TextPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Center(
        child: Text("data"),
      ),
    );
  }
}
