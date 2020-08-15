import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ContactPage extends StatelessWidget {
  static TextEditingController nameController = new TextEditingController();
  static TextEditingController emailController = new TextEditingController();
  static TextEditingController mensagemController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(children: <Widget>[
      SizedBox(height: 30.0),
      TextFormField(
        controller: nameController,
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: 'Nome',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      ),
      SizedBox(height: 30.0),
      TextFormField(
        controller: emailController,
        cursorColor: Colors.white,
        obscureText: true,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: 'Email',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      ),
      Text('Não compartilharemos seu email com mais ninguém.',
          style: TextStyle(color: Colors.grey, fontSize: 12.0)),
      SizedBox(height: 30.0),
         Expanded(
        child: LayoutBuilder(
          builder: (_, __) {
            return Container(
              color: Colors.white,
              margin: EdgeInsets.only(top: 8),
              child: TextField(
                controller: mensagemController,
                maxLines: 10,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
          hintText: 'Escreva sua mensagem aqui',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        )
              ),
            );
          },
        ),
      ),
      RaisedButton(
        onPressed: () {
                final String nome = nameController.text;
                final String email = emailController.text;
                final String mensagem = mensagemController.text;

                if(nome =="" || email =="" || mensagem ==""){
                  __popup(context, "Preencha todos os campos");
                }else{
                enviarMensagem(nome, email, mensagem);

                emailController.text ="";
                nameController.text = "";
                mensagemController.text = "";
                __popup(context, "Mensagem enviada com sucesso!");
                }
              },
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Colors.green,
        disabledColor: Colors.green[100],
        child: Text('Enviar',
            style: TextStyle(color: Colors.white70, fontSize: 16.0)),
      ),
    ]));
  }
}

void enviarMensagem(String nome, String email, String mensagem) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var url = "http://10.0.2.2:5003/api/Contato";

  var token = sharedPreferences.getString("token");
  print("sharedPreferences : " + token);
  var headers = {
    "Content-Type": "application/json",
    "accept": "*/*",
    HttpHeaders.authorizationHeader: 'Bearer $token',
  };
  var bodies = json
      .encode({"Nome": "$nome", "Email": "$email", "Mensagem": "$mensagem"});
  var response = await http.post(url, headers: headers, body: bodies);
  print(response.body);
}

 Future<void> __popup(BuildContext context, String mensagem) {

    Widget continuaButton = FlatButton(
      child: Text("Ok!"),
      color: Colors.green,
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

 return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mensagem'),
          content: Text(mensagem),
          actions: <Widget>[
            continuaButton,
          ],
        );
      },
    );
  }
