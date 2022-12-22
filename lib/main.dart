import 'package:flutter/material.dart';
import 'package:user_list/userList.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User List',
      home: UserList(
        title: 'User List',
      ),
    );
  }
}
