import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedidos/widgets/main/index.dart'; // Importa el archivo index.dart
import 'package:pedidos/widgets/main/customs/scanner.dart';
import 'package:camera/camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<CameraDescription> cameras = await availableCameras();
  runApp(MyApp(cameras));
}


class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  MyApp(this.cameras);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(cameras),
    );
  }
}

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  HomePage(this.cameras);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    if(widget.cameras.isNotEmpty){

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'lib/assets/logo.png',
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
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: AutoQrScanScreen(),
      ),
    );
    }else{
      return Text('asd');
    }
  }
}
