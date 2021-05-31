import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

var request = Uri.parse("https://controle-finaceiro-back.herokuapp.com/flu");
void main() async {
  print(await getDataFuture());
  runApp(MaterialApp(home: Home()));
}

Future<Map> getDataFuture() async {
  http.Response response = await http.get(request);
  return jsonDecode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.amber,
          centerTitle: true,
          title: Text(
            "\$ Conversor \$",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: FutureBuilder<Map>(
          future: getDataFuture(),
          builder: ((context, snapshot)  {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                    child: Text(
                  "Carregando dados!",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ));
                default:
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    "Erro de dados",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ));
                } else {
                  return Container(
                    color: Colors.green,
                  );
                }
            }
          })
        ));
  }
}
