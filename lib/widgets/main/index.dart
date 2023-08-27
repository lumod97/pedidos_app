import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pedidos/widgets/main/views/details-item.dart'; // Importa el archivo index.dart

class HomeScreen extends StatefulWidget {
  final String idSede;
  HomeScreen({required this.idSede});

  @override
  _HomeScreenState createState() => _HomeScreenState();
  
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  List<dynamic> dataLetters = [];
  List<dynamic> dataCremas = [];

  @override
  void initState() {
    super.initState();
    getPedidos();
  }

  // void navigateToDetails(Map<String, dynamic> item) {
  //   Navigator.push(
  //     context,
  //     // MaterialPageRoute(
  //     //   // builder: (context) => CustomBottomSheet(item: item),
  //     // ),
  //   );
  // }

  Future<void> getPedidos() async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://622f-38-250-132-102.ngrok-free.app/api/pedidos/get-letters'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'idSede': widget.idSede,
        }),
      );
      if (response.statusCode == 200) {
        //   Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> newData =
            jsonDecode(response.body); // Almacena los items en la lista "data"

        setState(() {
          dataLetters =
              newData; // Actualiza la lista "data" con los nuevos datos
        });

        print('Data posted successfully');
        // } else {
        //   throw Exception('Failed to post data');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Carta'),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: dataLetters.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(dataLetters[index]['title']),
                            subtitle: Text(dataLetters[index]['body']),
                            onTap: () {
                              _showModernBottomSheet(
                                  context,
                                  dataLetters[
                                      index]); // Navegar a la pantalla de detalles
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async {
          Navigator.pop(context, 'returned');
          return false;
        });
  }

  void _showModernBottomSheet(BuildContext context, Object item) {
    if (item is Map<String, dynamic>) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        builder: (BuildContext context) {
          // List<String> cremasList = (cremas as List).cast<String>();
          return DetailsScreen(item: item);
        },
      );
    }
  }
}
