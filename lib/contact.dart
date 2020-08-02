import 'package:flutter/material.dart';


class ContactPage extends StatelessWidget{

   static TextEditingController nameController = new TextEditingController();
   static TextEditingController emailController = new TextEditingController();
   static TextEditingController mensagemController = new TextEditingController();
  
  @override
  Widget build(BuildContext context){
      return  Column(
      children: <Widget>[
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
           Text('Não compartilharemos seu email com mais ninguém.', style: TextStyle(color: Colors.grey, fontSize: 12.0)),
           SizedBox(height: 30.0),
          Card(
              child: TextField(
                maxLines: 8,
                 controller: mensagemController,
               decoration: InputDecoration(
              hintText: 'Escreva sua mensagem aqui',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            ),
              ),
          ),
          SizedBox(height: 30.0),
         RaisedButton(
        onPressed: emailController.text == "" || nameController.text == "" || mensagemController.text == "" ? null : () {
        //todo
        },
        shape: RoundedRectangleBorder(
                        borderRadius:BorderRadius.circular(30.0)
                      ),
        color: Colors.green,
        disabledColor: Colors.green[100],
        child: Text('Enviar', style: TextStyle(color: Colors.white70, fontSize: 16.0)),
      ),
      ]
    
  );
}
}