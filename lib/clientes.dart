import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Cliente {
  final int id;
  final String nome;
  final String cidade;
  final String email;
  final String sexo;

  Cliente({this.id, this.nome, this.cidade, this.email, this.sexo});

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      nome: json['nome'],
      cidade: json['cidade'],
      email: json['email'],
      sexo: json['sexo'],
    );
  }
}

class ClientesPage extends StatelessWidget {
  Future<Cliente> clientes;

  @override
  void initState() {
    print("initState");
    clientes = buscaClientes();
  }

  @override
  Widget build(BuildContext context) {
    clientes = buscaClientes();
    return Column(children: <Widget>[
      FutureBuilder<Cliente>(
        future: clientes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Expanded(
              child: Card(
                margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: Scrollbar(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(
                              Icons.account_circle,
                              color: Colors.blue[900],
                              size: 40.0,
                            ),
                            title: Text(
                              snapshot.data.nome,
                              style: TextStyle(
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(snapshot.data.email),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () {},
                          ),
                          Divider(
                            height: 5.0,
                          ),
                        ],
                      );
                    },
                    itemCount: 1,
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      )
    ]);
  }
}

Future<Cliente> buscaClientes() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var url = "http://10.0.2.2:5003/api/Cliente/1";

  var token = sharedPreferences.getString("token");
  print("sharedPreferences : " + token);
  var headers = {
    "Content-Type": "application/json",
    "accept": "*/*",
    HttpHeaders.authorizationHeader: 'Bearer $token',
  };
  var jsonResponse = null;
  var response = await http.get(url, headers: headers);
  if (response.statusCode == 200) {
    print("jsonResponse : " + response.body);
    return Cliente.fromJson(json.decode(response.body));
  }
}
