### Autor: Fábio Delgado

Olá! Seja bem vindo ;)

## Índice

## FrontFlutter

Essa aplicação tem como objetivo disponibillizar um front end para as APIs desenvolvidas em .Net core, Python e Java disponibilizadas nessa conta do github.
Ela possui uma interfase para login e gerenciamento de uma base de dados exemplo de clientes.

#### Tela de login utilizando autenticação com backend
![Login](/img/login.png)![home](/img/home.png)

#### Consulta de clientes com detalhemento
![clientes](/img/crud_v4.gif)![detalhes](/img/detalhes.png)

### adcionar e remover clientes
![add](/img/add.png)

#### Upload de arquivos e Tela de contato
![fileupload](/img/fileupload.gif)![contato](/img/contato.png)

## Executando o projeto 

- Depois de clonar este repositório, navegue até a raiz dele.
- Em seguida, execute no prompt `. / Get_packages.sh`
  > Verifique se o script é executável. Caso contrário, execute `chmod + x get_packages.sh` primeiro para torná-lo executável.

### Extensões recomendadas para desenvolvimento no VSCODE

 - Flutter from Dart Code

### Instalando uma biblioteca

> Adicione a referência no arquivo pubspec.yaml do seu pacote, exemplo:

```dart
dependencies:
  image_picker: ^0.6.7+4
```

> Você pode instalar pacotes a partir da linha de comando:

```sh
$ flutter pub get
```

Agora, no seu código Dart, você importa a referência:

```dart
import 'package:image_picker/image_picker.dart';
```

## Suporte

Por favor entre em contato conosco via [Email]