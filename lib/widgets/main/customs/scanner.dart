import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:pedidos/widgets/main/views/screens/user_data.dart';
import 'package:pedidos/widgets/main/index.dart';

class AutoQrScanScreen extends StatefulWidget {
  @override
  _AutoQrScanScreenState createState() => _AutoQrScanScreenState();
}

class _AutoQrScanScreenState extends State<AutoQrScanScreen> {
  late QRViewController _controller;
  late List<dynamic> dataSedes = [];
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
    getSedes();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this._controller = controller;
    _controller.scannedDataStream.listen((scanData) async {
      if (scanData != null) {
        // Future.delayed(Duration(seconds: 2), () {
        //   _controller.resumeCamera();
        // });
        Map<String, dynamic> parsedJson = json.decode(scanData.code.toString());
        // Muestra el contenido del QR en un ZXDFGHJKLtoast
        if (dataSedes[0]['id'].toString().contains(parsedJson['sede'])) {
          _controller.stopCamera();
          final goToList = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      HomeScreen(idSede: parsedJson['sede'])));
          if (goToList != null) {
            // scanData = Barcode(null, BarcodeFormat.aztec, []);
            _controller.resumeCamera();
          }
        } else {
          _showToast('Sede no encontrada...');
        }
      }
    });
  }

  Future<void> getSedes() async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://622f-38-250-132-102.ngrok-free.app/api/pedidos/get-sedes'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({}),
      );
      // if (response.statusCode == 200) {
      // String jsonResponse = json.decode(response.body);
      // print(response.body);
      List<dynamic> newData =
          jsonDecode(response.body); // Almacena los items en la lista "data"
      setState(() {
        dataSedes = newData; // Actualiza la lista "data" con los nuevos datos
      });
      // } else {
      //   throw Exception('Failed to post data');
      // }
    } catch (e) {
      print(e.toString());
    }
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'lib/assets/background.png', // Reemplaza esto con la ruta de tu imagen
            fit: BoxFit.none,
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.05,
                bottom: MediaQuery.of(context).size.height * 0.5,
                right: MediaQuery.of(context).size.width * 0.1,
                left: MediaQuery.of(context).size.width * 0.1),
            // horizontal: MediaQuery.of(context).size.width * 0.1,
            // vertical: ,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Escanea!',
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Asiyah',
                        color: Colors.amber[900]),
                  ),
                ),
                Expanded(
                  child: QRView(
                    key: _qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                ),
              ],
            ),
          ),
          // Hero(
          // tag: 'heroTag',
          // child:
          Center(
            child: Center(
              child: GestureDetector(
                onTap: () {
                  // 
                  _controller.toggleFlash();
                },
                child: Hero(
                  tag: 'heroTag',
                  child: Tooltip(
                    message: 'Ingresa tus datos',
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person_outlined, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // )
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: AutoQrScanScreen()));
}
