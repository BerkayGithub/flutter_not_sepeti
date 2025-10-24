import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_not_sepeti/kategori_islemleri.dart';
import 'package:flutter_not_sepeti/models/Kategori.dart';
import 'package:flutter_not_sepeti/models/not.dart';
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: NotListesi(),
    );
  }
}

class NotListesi extends StatefulWidget {
  const NotListesi({super.key});

  @override
  State<NotListesi> createState() => _NotListesiState();
}

class _NotListesiState extends State<NotListesi> {
  final DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Not Listesi")),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.category),
                    title: Text("Kategoriler"),
                    onTap: () {
                      Navigator.pop(context);
                      _kategorilerSayfasinaGit();
                    },
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Notlar(),
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
                                Navigator.pop(context);
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

  void _detaySayfasinaGit(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotDetay(baslik: 'Yeni Not')),
    );
    setState(() {});
  }

  void _kategorilerSayfasinaGit() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => Kategoriler()));
    setState(() {});
  }
}

class Notlar extends StatefulWidget {
  const Notlar({super.key});

  @override
  State<Notlar> createState() => _NotlarState();
}

class _NotlarState extends State<Notlar> {
  List<Not> tumNotlar = [];
  late DatabaseHelper _databaseHelper;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _databaseHelper.notListesiniGetir(),
      builder: (context, AsyncSnapshot<List<Not>> snapShot) {
        if (snapShot.connectionState == ConnectionState.done) {
          tumNotlar = snapShot.data!;
          sleep(Duration(milliseconds: 500));
          return ListView.builder(
            itemBuilder: (context, index) => ExpansionTile(
              leading: _oncelikIconuAta(tumNotlar[index].notOncelik!),
              title: Text(tumNotlar[index].notBaslik!),
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Kategori",
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              tumNotlar[index].kategoriBaslik!,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Tarih",
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _databaseHelper.dateFormat(
                                DateTime.parse(tumNotlar[index].notTarih!),
                              ),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("İçerik"),
                            Text(tumNotlar[index].notIcerik!),
                          ],
                        ),
                      ),
                      OverflowBar(
                        alignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              _notSil(tumNotlar[index].notID!);
                            },
                            child: Text(
                              "SİL",
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _detaySayfasinaGit(context, tumNotlar[index]);
                            },
                            child: Text(
                              "GÜNCELLE",
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            itemCount: tumNotlar.length,
          );
        } else {
          return Center(child: Text("Yükleniyor..."));
        }
      },
    );
  }

  _oncelikIconuAta(int notOncelik) {
    switch (notOncelik) {
      case 0:
        return CircleAvatar(
          backgroundColor: Colors.redAccent.shade100,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text("AZ", maxLines: 1),
          ),
        );
      case 1:
        return CircleAvatar(
          backgroundColor: Colors.redAccent.shade400,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text("ORTA", maxLines: 1),
          ),
        );
      case 2:
        return CircleAvatar(
          backgroundColor: Colors.redAccent.shade700,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text("ACİL", maxLines: 1),
          ),
        );
    }
  }

  void _notSil(int notID) {
    _databaseHelper.notSil(notID).then((silinenNotID) {
      if (silinenNotID != 0) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Not silindi')));
        setState(() {});
      }
    });
  }

  void _detaySayfasinaGit(BuildContext context, Not not) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            NotDetay(baslik: 'Notu Düzenle', duzenlenecekNot: not),
      ),
    );
    setState(() {});
  }
}
