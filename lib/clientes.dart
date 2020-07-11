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
      id: json['Id'],
      nome: json['Nome'],
      cidade: json['Cidade'],
      email: json['Email'],
      sexo: json['Sexo'],
    );
  }
}

class ClientesPage extends StatelessWidget {
  Future<List<Cliente>> clientes;

  @override
  void initState() {
    print("initState");
    clientes = buscaClientes();
  }

  @override
  Widget build(BuildContext context) {
    clientes = buscaClientes();
    return Column(children: <Widget>[
      FutureBuilder<List<Cliente>>(
        future: clientes,
        builder: (context, snapshot) {
          List<Cliente> users = snapshot.data ?? [];
          if (snapshot.hasData) {
            return Expanded(
              child: Card(
                margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: Scrollbar(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      Cliente cli = users[index];
                      return Column(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(
                              Icons.account_circle,
                              color: Colors.blue[900],
                              size: 40.0,
                            ),
                            title: Text(
                              cli.nome,
                              style: TextStyle(
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(cli.email),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () {},
                          ),
                          Divider(
                            height: 5.0,
                          ),
                        ],
                      );
                    },
                    itemCount: users.length,
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

Future<List<Cliente>> buscaClientes() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var url = "http://10.0.2.2:5003/api/Cliente?PageIndex=1&PageSize=10";

  var token = sharedPreferences.getString("token");
  print("sharedPreferences : " + token);
  var headers = {
    "Content-Type": "application/json",
    "accept": "*/*",
    HttpHeaders.authorizationHeader: 'Bearer $token',
  };
  var response = await http.get(url, headers: headers);
  if (response.statusCode == 200) {
    return (json.decode(response.body)['data'] as List)
        .map((data) => Cliente.fromJson(data))
        .toList();
  }
}
