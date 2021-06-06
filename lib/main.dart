import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

var request = Uri.parse("https://controle-finaceiro-back.herokuapp.com/flu");
void main() async {
  print(await getDataFuture());
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        )),
  ));
}

Future<Map> getDataFuture() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar = 10;
  double euro = 5;

  void _realChangedd(String text) {
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChangedd(String text) {
   double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = ( dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChangedd(String text) {
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

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
            builder: ((context, snapshot) {
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
                    dolar = snapshot.data!["dolar"];
                    euro = snapshot.data!["euro"];

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(
                            Icons.monetization_on,
                            size: 150,
                            color: Colors.amber,
                          ),
                          bildTextField(
                              'real', 'R\$', realController, _realChangedd),
                          Divider(),
                          bildTextField(
                              'Dolar', 'US\$', dolarController, _dolarChangedd),
                          Divider(),
                          bildTextField(
                              'Euro', 'R\$', euroController, _euroChangedd)
                        ],
                      ),
                    );
                  }
              }
            })));
  }
}

Widget bildTextField(String label, String prefix,
    TextEditingController controller, Function functionController) {
  return TextField(
      controller: controller,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.amber),
          border: OutlineInputBorder(),
          prefixText: prefix),
      style: TextStyle(color: Colors.amber, fontSize: 25),
      onChanged: (String ok) => {functionController(ok)},
      keyboardType: TextInputType.number);
}
