import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Surah Quran',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          iconTheme:
              IconThemeData(color: Colors.white), // set icon color to white
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  void _navigateToSurah(
      BuildContext context, String surahID, String namaSurah) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SurahPage(surahID: surahID, namaSurah: namaSurah),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Surah Quran', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _navigateToSurah(context, '36', 'Surat Yasin'),
              child: Row(
                children: [
                  Icon(Icons.book, size: 50, color: Colors.yellowAccent),
                  const SizedBox(width: 10),
                  Text(
                    'Surat Yasin',
                    style: TextStyle(fontSize: 20, color: Colors.yellowAccent),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _navigateToSurah(context, '56', 'Surat Al-Waqiah'),
              child: Row(
                children: [
                  Icon(Icons.book, size: 50, color: Colors.yellowAccent),
                  const SizedBox(width: 10),
                  Text(
                    'Surat Al-Waqiah',
                    style: TextStyle(fontSize: 20, color: Colors.yellowAccent),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _navigateToSurah(context, '67', 'Surat Al-Mulk'),
              child: Row(
                children: [
                  Icon(Icons.book, size: 50, color: Colors.yellowAccent),
                  const SizedBox(width: 10),
                  Text(
                    'Surat Al-Mulk',
                    style: TextStyle(fontSize: 20, color: Colors.yellowAccent),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SurahPage extends StatelessWidget {
  final String surahID;
  final String namaSurah;

  const SurahPage({Key? key, required this.surahID, required this.namaSurah});

  Future<List> fetchSurahData() async {
    final response =
        await http.get(Uri.parse('https://equran.id/api/surat/$surahID'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['ayat'];
    } else {
      throw Exception('Gagal mengambil data dari API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          namaSurah,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<List>(
        future: fetchSurahData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final verses = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: verses.length,
              itemBuilder: (context, index) {
                final verse = verses[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    '${verse['ar']}\n${verse['tr']}\n',
                    style: TextStyle(fontSize: 18, color: Colors.yellowAccent),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
