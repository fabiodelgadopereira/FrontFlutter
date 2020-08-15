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
  List<Cliente> clientes;
  ScrollController _scrollController = new ScrollController();
  int count = 1;
  @override
  void initState() {
    print("initState");
    buscaClientes(count);
  }
/*  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    buscaClientes(count);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        count++;
        print(count);
          buscaClientes(count);
      }
    });

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green[300],
      ),
      body: Container(
        margin: EdgeInsets.all(0.0),
        child: Column(
          children: <Widget>[
            FutureBuilder<List<Cliente>>(
              future: buscaClientes(count),
              builder: (context, snapshot) {
                List<Cliente> users = snapshot.data ?? [];
                if (snapshot.hasData) {
                  return Expanded(
                    child: Card(
                      margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                      child: Scrollbar(
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(8),
                          itemBuilder: (context, index) {
                            Cliente cli = users[index];
                            return GestureDetector(
                              onLongPressStart:
                                  (LongPressStartDetails details) {
                                _showPopupMenu(context, details, cli);
                              },
                              child: Column(
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
                                    trailing: Icon(Icons.more_vert),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DetailScreen(cliente: cli),
                                        ),
                                      );
                                    },
                                  ),
                                  Divider(
                                    height: 5.0,
                                  ),
                                ],
                              ),
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
            ),
          ],
        ),
      ),
    );
  }

  void _showPopupMenu(
      BuildContext context, LongPressStartDetails details, Cliente cli) async {
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    int selected = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(x, y, 100, 100),
      items: [
        PopupMenuItem(
          child: Text("Detalhes"),
          value: 0,
        ),
        PopupMenuItem(
          child: Text("Editar"),
          value: 1,
        ),
        PopupMenuItem(
          child: Text("Deletar"),
          value: 2,
        ),
      ],
      elevation: 8.0,
    );
    if (selected == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailScreen(cliente: cli),
        ),
      );
    }
    if (selected == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UpdateScreen(cliente: cli),
        ),
      );
    }
    if (selected == 2) {
      _deletarCliente(context, cli);
      initState();
    }
  }

  Future<void> _deletarCliente(BuildContext context, Cliente cli) {
    Widget cancelaButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continuaButton = FlatButton(
      child: Text("Confirmar"),
      color: Colors.red,
      onPressed: () {
        deletarCliente(cli.id);
        Navigator.of(context).pop();
      },
    );

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Deletar'),
          content: Text('Deseja deletar o cliente ' + cli.nome + " ?"),
          actions: <Widget>[
            cancelaButton,
            continuaButton,
          ],
        );
      },
    );
  }
Future<List<Cliente>> buscaClientes(int entrada) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var url = "http://10.0.2.2:5003/api/Cliente?PageIndex=$entrada&PageSize=10";

  var token = sharedPreferences.getString("token");
  print("sharedPreferences : " + token);
  var headers = {
    "Content-Type": "application/json",
    "accept": "*/*",
    HttpHeaders.authorizationHeader: 'Bearer $token',
  };
  var response = await http.get(url, headers: headers);
  if (response.statusCode == 200) {
    if(clientes==null){
     clientes = (json.decode(response.body)['data'] as List)
        .map((data) => Cliente.fromJson(data))
        .toList();
    }
    else{
       clientes.addAll( (json.decode(response.body)['data'] as List)
        .map((data) => Cliente.fromJson(data))
        .toList());
    }
  }
  return clientes;
}

}

class AddScreen extends StatelessWidget {
  AddScreen({Key key}) : super(key: key);

  final TextEditingController _controladorNome = TextEditingController();
  final TextEditingController _controladorCidade = TextEditingController();
  final TextEditingController _controladorEmail = TextEditingController();
  final TextEditingController _controladorSexo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controladorNome,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TextField(
                controller: _controladorEmail,
                decoration: InputDecoration(labelText: 'E-mail'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TextField(
                controller: _controladorCidade,
                decoration: InputDecoration(labelText: 'Cidade'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TextField(
                controller: _controladorSexo,
                decoration: InputDecoration(labelText: 'Sexo'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final String nome = _controladorNome.text;
          final String email = _controladorEmail.text;
          final String cidade = _controladorCidade.text;
          final String sexo = _controladorSexo.text;

          inserirCliente(nome, cidade, email, sexo);
          Navigator.of(context).pop();
        },
        label: Text('Salvar'),
        icon: Icon(Icons.check),
        backgroundColor: Colors.green[300],
      ),
    );
  }

  void inserirCliente(String nome, String cidade, String email, String sexo) {}
}

class UpdateScreen extends StatelessWidget {
  final Cliente cliente;

  // In the constructor, require a Todo.
  UpdateScreen({Key key, @required this.cliente}) : super(key: key);

  TextEditingController _controladorNome;
  TextEditingController _controladorCidade;
  TextEditingController _controladorEmail;
  TextEditingController _controladorSexo;

  @override
  Widget build(BuildContext context) {
    _controladorNome = new TextEditingController(text: cliente.nome);
    _controladorCidade = TextEditingController(text: cliente.cidade);
    _controladorEmail = TextEditingController(text: cliente.email);
    _controladorSexo = TextEditingController(text: cliente.sexo);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controladorNome,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TextField(
                controller: _controladorEmail,
                decoration: InputDecoration(labelText: 'E-mail'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TextField(
                controller: _controladorCidade,
                decoration: InputDecoration(labelText: 'Cidade'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TextField(
                controller: _controladorSexo,
                decoration: InputDecoration(labelText: 'Sexo'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final String nome = _controladorNome.text;
          final String email = _controladorEmail.text;
          final String cidade = _controladorCidade.text;
          final String sexo = _controladorSexo.text;
          updateCliente(cliente.id, nome, cidade, email, sexo);
          Navigator.of(context).pop();
        },
        label: Text('Salvar'),
        icon: Icon(Icons.check),
        backgroundColor: Colors.green[300],
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  // Declare a field that holds the Todo.
  final Cliente cliente;

  // In the constructor, require a Todo.
  DetailScreen({Key key, @required this.cliente}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes Cliente'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text(cliente.nome,
                  style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text('ID: ' + cliente.id.toString()),
              leading: Icon(
                Icons.account_circle,
                color: Colors.blue[900],
              ),
            ),
            Divider(),
            ListTile(
              title: Text(cliente.cidade,
                  style: TextStyle(fontWeight: FontWeight.w500)),
              leading: Icon(
                Icons.location_city,
                color: Colors.blue[900],
              ),
            ),
            ListTile(
              title: Text(cliente.email),
              leading: Icon(
                Icons.contact_mail,
                color: Colors.blue[900],
              ),
            ),
            ListTile(
              title: Text(cliente.sexo),
              leading: Icon(
                Icons.info,
                color: Colors.blue[900],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void inserirCliente(
    String nome, String endereco, String email, String sexo) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var url = "http://10.0.2.2:5003/api/Cliente";

  var token = sharedPreferences.getString("token");
  print("sharedPreferences : " + token);
  var headers = {
    "Content-Type": "application/json",
    "accept": "*/*",
    HttpHeaders.authorizationHeader: 'Bearer $token',
  };
  var bodies = json.encode({
    "Nome": "$nome",
    "Cidade": "$endereco",
    "Email": "$email",
    "Sexo": "$sexo",
  });
  var response = await http.post(url, headers: headers, body: bodies);
  print(response.body);
}

void deletarCliente(int id) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var url = "http://10.0.2.2:5003/api/Cliente/$id";

  var token = sharedPreferences.getString("token");
  print("sharedPreferences : " + token);
  var headers = {
    "Content-Type": "application/json",
    "accept": "*/*",
    HttpHeaders.authorizationHeader: 'Bearer $token',
  };
  var response = await http.delete(url, headers: headers);
  print(response.body);
}

void updateCliente(
    int id, String nome, String endereco, String email, String sexo) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var url = "http://10.0.2.2:5003/api/Cliente";

  var token = sharedPreferences.getString("token");
  print("sharedPreferences : " + token);
  var headers = {
    "Content-Type": "application/json",
    "accept": "*/*",
    HttpHeaders.authorizationHeader: 'Bearer $token',
  };
  var bodies = json.encode({
    "Id": "$id",
    "Nome": "$nome",
    "Cidade": "$endereco",
    "Email": "$email",
    "Sexo": "$sexo",
  });
  var response = await http.put(url, headers: headers, body: bodies);
  print(response.body);
}


