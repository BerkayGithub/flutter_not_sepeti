import 'package:flutter/material.dart';
import 'package:flutter_not_sepeti/models/Kategori.dart';
import 'package:flutter_not_sepeti/utils/database_helper.dart';

import 'not_detay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: NotListesi(),
    );
  }
}

class NotListesi extends StatelessWidget {
  NotListesi({super.key});

  final DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Not Listesi"))),
      body: Container(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _kategoriEkleDialog(context);
            },
            heroTag: "KategoriEkle",
            tooltip: "Kategori Ekle",
            mini: true,
            child: Icon(Icons.add_circle),
          ),
          FloatingActionButton(
            onPressed: () => _detaySayfasinaGit(context),
            heroTag: "NotEkle",
            tooltip: "Not Ekle",
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  _kategoriEkleDialog(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    String yeniKategoriAdi = "";
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "Kategori Ekle",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: TextFormField(
                  onSaved: (yeniDeger) {
                    yeniKategoriAdi = yeniDeger!;
                  },
                  decoration: InputDecoration(
                    labelText: "Kategori ekle",
                    border: OutlineInputBorder(),
                  ),
                  validator: (girilenKategoriAdi) {
                    if (girilenKategoriAdi!.length < 3) {
                      return "En az 3 karakter giriniz";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: OverflowBar(
                alignment: MainAxisAlignment.end,
                spacing: 8.0,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                    ),
                    child: Text(
                      "Vazgeç",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        databaseHelper
                            .kategoriEkle(Kategori(yeniKategoriAdi))
                            .then((kategoriID) {
                              if (kategoriID > 0) {
                                debugPrint(kategoriID.toString());
                              }
                            });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    child: Text(
                      "Kaydet",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _detaySayfasinaGit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotDetay(baslik: 'Yeni Not')),
    );
  }
}
