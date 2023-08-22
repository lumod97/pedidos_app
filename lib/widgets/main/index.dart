import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pedidos/widgets/main/views/details-item.dart'; // Importa el archivo index.dart

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  List<dynamic> data = [];

  void navigateToDetails(Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(item: item),
      ),
    );
  }

  Future<void> postData() async {
    var respuesta = '';
    try {
      final response = await http.post(
        Uri.parse('http://192.168.18.252:8000/api/pedidos/get-carta'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'title': titleController.text,
          'body': bodyController.text,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> newData =
            jsonResponse['data']; // Almacena los items en la lista "data"

        setState(() {
          data = newData; // Actualiza la lista "data" con los nuevos datos
        });

        print('Data posted successfully');
      } else {
        throw Exception('Failed to post data');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('POST Data Example'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: bodyController,
                decoration: InputDecoration(labelText: 'Body'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  postData();
                },
                child: Text('Post Data'),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(data[index]['title']),
                        subtitle: Text(data[index]['body']),
                        onTap: () {
                          navigateToDetails(
                              data[index]); // Navegar a la pantalla de detalles
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
    );
  }
}