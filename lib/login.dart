  
import 'package:flutter/material.dart';

class Login extends StatelessWidget {

  Widget _buildPageContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      color: Colors.white,
      child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
             
              SizedBox(height: 50,),
              Container(width: 200, child: Icon(Icons.account_circle,size: 100.0,color: Colors.deepOrangeAccent,),),
              SizedBox(height: 50,),
              ListTile(
                title: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
        hintText: 'Username',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
                )
              ),
              Divider(color: Colors.greenAccent,),
              ListTile(
                title: TextField(
                  obscureText: true,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
                )
              ),
              Divider(color: Colors.greenAccent,),
              SizedBox(height: 20,),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      onPressed: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => Login()
                        ));
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius:BorderRadius.circular(30.0)
                      ),
                      color: Colors.green,
                      child: Text('Login', style: TextStyle(color: Colors.white70, fontSize: 16.0),),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40,),
              Text('Click aqui para se registrar!', style: TextStyle(color: Colors.grey.shade500),)
            ],
          ),
        ],
      ),
    );
  }

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: _buildPageContent(context),
      );
    }
}