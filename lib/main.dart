// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GetApiData(title: 'Flutter Demo Home Page'),
    );
  }
}

class GetApiData extends StatefulWidget {
  const GetApiData({Key? key, required String title}) : super(key: key);

  @override
  _GetApiDataState createState() => _GetApiDataState();
}

class _GetApiDataState extends State<GetApiData> {
  getUserData() async {
    var response =
        await http.get(Uri.https('jsonplaceholder.typicode.com', 'users'));
    var jsonData = jsonDecode(response.body);
    List<User>? users = [];

    for (var u in jsonData) {
      User user = User(u["name"], u["email"], u["username"], u["id"]);
      users.add(user);
    }
    // ignore: avoid_print
    print(users.length);
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('User Data'),
        ),
        body: Card(
          child: FutureBuilder(
              future: getUserData(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  // ignore: avoid_unnecessary_containers
                  return Container(
                    child: Center(
                      child: Text('Loading...'),
                    ),
                  );
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, i) {
                        return ListTile(
                          title: Text(snapshot.data![i].name),
                          subtitle: Text(snapshot.data![i].email),
                          trailing: Text(snapshot.data![i].id.toString()),
                        );
                      });
                }
              }),
        ));
  }
}

class User {
  final String name, email, username;
  final int id;
  User(this.name, this.email, this.username, this.id);
}
