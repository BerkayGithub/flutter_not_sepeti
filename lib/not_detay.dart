import 'package:flutter/material.dart';
import 'package:flutter_not_sepeti/models/Kategori.dart';
import 'package:flutter_not_sepeti/utils/database_helper.dart';

class NotDetay extends StatefulWidget {
  final String baslik;

  const NotDetay({super.key, required this.baslik});

  @override
  State<NotDetay> createState() => _NotDetayState();
}

class _NotDetayState extends State<NotDetay> {
  var formKey = GlobalKey<FormState>();
  late List<Kategori> kategoriListesi;
  late DatabaseHelper databaseHelper;
  int kategoriID = 1;
  int secilenOncelik = 0;
  static final _oncelik = ["Düşük", "Orta", "Yüksek"];

  @override
  void initState() {
    super.initState();
    kategoriListesi = List<Kategori>.of([]);
    databaseHelper = DatabaseHelper();
    _kategoriListesiniDoldur();
  }

  void _kategoriListesiniDoldur() async {
    await databaseHelper.kategorileriGetir().then((kategoriIcerenMapListesi) {
      for (var kategoriMap in kategoriIcerenMapListesi) {
        kategoriListesi.add(Kategori.fromMap(kategoriMap));
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(widget.baslik)),
      body: Form(
        key: formKey,
        child: kategoriListesi.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: <Widget>[
                  Center(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "Kategori :",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 4,
                          ),
                          margin: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.redAccent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              items: _kategoriItemleriOlustur(),
                              value: kategoriID,
                              onChanged: (secilenKategoriID) {
                                setState(() {
                                  kategoriID = secilenKategoriID!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Not başlığını giriniz",
                        labelText: "Başlık",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Not içeriğini giriniz",
                        labelText: "İçerik",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Center(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "Öncelik :",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 4,
                          ),
                          margin: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.redAccent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              items: _oncelik
                                  .map(
                                    (oncelik) =>
                                        DropdownMenuItem<int>(
                                            value: _oncelik.indexOf(oncelik),
                                            child: Text(oncelik),
                                        ),
                                  )
                                  .toList(),
                              value: secilenOncelik,
                              onChanged: (secilenOncelikID) {
                                setState(() {
                                  secilenOncelik = secilenOncelikID!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  OverflowBar(
                    spacing: 20,
                    children: <Widget>[
                      ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(backgroundColor: Colors.grey), child: Text("Vazgeç", style: TextStyle(color: Colors.black),)),
                      ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.shade700), child: Text("Kaydet", style: TextStyle(color: Colors.white),)),
                    ],
                  )
                ],
              ),
      ),
    );
  }

  List<DropdownMenuItem<int>>? _kategoriItemleriOlustur() {
    return kategoriListesi
        .map(
          (kategori) => DropdownMenuItem(
            value: kategori.kategoriID!,
            child: Text(
              kategori.kategoriBaslik!,
              style: TextStyle(fontSize: 20),
            ),
          ),
        )
        .toList();
  }
}
