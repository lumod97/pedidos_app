import 'dart:ffi';

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
  List<int> numeros = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  List<dynamic> data = [];

  // void navigateToDetails(Map<String, dynamic> item) {
  //   Navigator.push(
  //     context,
  //     // MaterialPageRoute(
  //     //   // builder: (context) => CustomBottomSheet(item: item),
  //     // ),
  //   );
  // }

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
                          _showModernBottomSheet(context,
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

  void _showModernBottomSheet(BuildContext context, Object item) {
    if (item is Map<String, dynamic>) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        builder: (BuildContext context) {
          String title = item['title'];
          String image = item['image'];
          String body = item['body'];
          String price = item['price'];
          List<String> cremas = item['cremas'].cast<String>();
          numeros = List<int>.generate(cremas.length, (index) => 1);
          // List<String> cremasList = (cremas as List).cast<String>();

          return FractionallySizedBox(
            heightFactor: 0.50,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          title,
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SanFranciscoBold'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 1, bottom: 10),
                        child: Text(
                          'S/${price}',
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontFamily: 'SanFrancisco',
                              fontSize: 20),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                            10.0), // Define el radio de las esquinas redondeadas
                        child: Image(
                          image: NetworkImage(image),
                        ),
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Descripcion',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(body),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          'Agrega cremas!',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: cremas.length,
                        itemBuilder: (context, i) {
                          return Row(
                            children: [
                              Text(
                                cremas[i]
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    if (numeros[i] < 99) {
                                      numeros[i]++;
                                    }
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(3),
                                  side:
                                      BorderSide(width: 1, color: Colors.blue),
                                ),
                                child: Icon(Icons.add,
                                    size: 15, color: Colors.blue),
                              ),
                              SizedBox(width: 10),
                              Text(numeros[i].toString()),
                              SizedBox(width: 10),
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    if (numeros[i] > 1) {
                                      numeros[i]--;
                                    }
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(3),
                                  side:
                                      BorderSide(width: 1, color: Colors.blue),
                                ),
                                child: Icon(Icons.remove,
                                    size: 15, color: Colors.blue),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }
}
