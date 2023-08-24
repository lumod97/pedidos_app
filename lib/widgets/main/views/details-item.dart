import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final Map<String, dynamic> item;

  DetailsScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 16.0), // Margen a la derecha
                  child: Image(
                    image: NetworkImage(
                        'https://cdn-icons-png.flaticon.com/512/857/857681.png'),
                    width: 100, // Ancho deseado
                    height: 100, // Alto deseado
                  ),
                ),
              ],
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Title: ${item['title']}'),
                  SizedBox(height: 8),
                  Text('Body: ${item['body']}'),
                  // Puedes mostrar más detalles aquí si los tienes en tu estructura de datos
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
