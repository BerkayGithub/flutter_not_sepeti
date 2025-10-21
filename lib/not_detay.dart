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
      appBar: AppBar(title: Text(widget.baslik)),
      body: Form(
        key: formKey,
        child: kategoriListesi.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: <Widget>[
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 4,
                      ),
                      margin: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.redAccent, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(10))
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
                  ),
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
            child: Text(kategori.kategoriBaslik!, style: TextStyle(fontSize: 20),),
          ),
        )
        .toList();
  }
}
