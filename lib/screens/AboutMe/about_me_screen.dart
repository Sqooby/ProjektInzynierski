import 'package:flutter/material.dart';

class AboutMeScreen extends StatelessWidget {
  static String routeName = '/about_me';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('O Projekcie'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Aplikacja mobilna dla Firmy trasnportowej ze strony Klienta',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Celem projektu było stworzenie aplikacji mobilnej dla frimy transportowej ze strony klienta jako projekt inżynierski \n głównymi założeniami aplikacji było:\n-wizualizacja przejazdu z punktu A do punktu B za pomocą google Maps \n-Logowanie oraz rejestracja \n-Zastosowanie pojęcia DRT \n-Możliwość zamawiania przejazdów na przyszłość',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Autor',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Michał Basznianin \nStudent 4-roku informatyki na Politechnie Rzeszowskiej',
              style: TextStyle(fontSize: 18),
            ),
            // Możesz dodać więcej sekcji lub informacji, w zależności od potrzeb
          ],
        ),
      ),
    );
  }
}
