import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedidos/widgets/main/index.dart'; // Importa el archivo index.dart

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _goToIndex(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Evento a ListTile'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://www.mimenu.pe/wp-content/uploads/2020/09/Logo-11.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: null,
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Escanea!'),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Nuestra Carta'),
              onTap: _goToIndex,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Text('Contador: $_counter'),
      ),
    );
  }
}
