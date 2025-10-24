import 'package:flutter/material.dart';
import 'package:flutter_not_sepeti/models/Kategori.dart';
import 'package:flutter_not_sepeti/utils/database_helper.dart';

class Kategoriler extends StatefulWidget {
  const Kategoriler({super.key});

  @override
  State<Kategoriler> createState() => _KategorilerState();
}

class _KategorilerState extends State<Kategoriler> {
  List<Kategori>? _tumKategoriler;
  late DatabaseHelper _databaseHelper;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    if (_tumKategoriler == null) {
      _tumKategoriler = List<Kategori>.empty();
      _kategorileriGuncelle();
    }

    return Scaffold(
      appBar: AppBar(title: Text("Kategoriler")),
      body: Center(
        child: ListView.builder(
          itemCount: _tumKategoriler!.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_tumKategoriler![index].kategoriBaslik!),
              leading: Icon(Icons.category),
              trailing: InkWell(child: Icon(Icons.delete), onTap: (){
                _kategoriSil(_tumKategoriler![index].kategoriID!);
              },),
              onTap: () {
                _kategoriGuncelleDialog(context,_tumKategoriler![index]);
              },
            );
          },
        ),
      ),
    );
  }

  void _kategorileriGuncelle() async {
    _databaseHelper.kategoriListesiniGetir().then((kategorileriIcerenListe) {
      setState(() {
        _tumKategoriler = kategorileriIcerenListe;
      });
    });
  }

  void _kategoriSil(int kategoriID) {
    showDialog(context: context, barrierDismissible: false, builder: (context) {
      return AlertDialog(
        title: Text("Kategori Sil"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Kategoriyi sildiğinizde bununla ilgili tüm notlar da silinecektir. Emin misiniz?"),
            OverflowBar(
              alignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: (){
                  Navigator.of(context).pop();
                }, child: Text("Vazgeç")),
                TextButton(onPressed: (){
                  _databaseHelper.kategoriSil(kategoriID).then((silinenKategoriID){
                    if(silinenKategoriID != 0){
                      Navigator.of(context).pop();
                      setState(() {
                        _kategorileriGuncelle();
                      });
                    }
                  });
                }, child: Text("Kategoriyi Sil", style: TextStyle(color: Colors.redAccent),)),
              ],
            )
          ],
        ),
      );
    });
  }

  _kategoriGuncelleDialog(BuildContext context, Kategori kategori) {
    var formKey = GlobalKey<FormState>();
    String guncellenecekKategoriAdi = kategori.kategoriBaslik!;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "Kategori Guncelle",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: TextFormField(
                  initialValue: guncellenecekKategoriAdi,
                  onSaved: (yeniDeger) {
                    guncellenecekKategoriAdi = yeniDeger!;
                  },
                  decoration: InputDecoration(
                    labelText: "Kategori güncelle",
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
                        _databaseHelper
                            .kategoriGuncelle(Kategori.withID(kategori.kategoriID, guncellenecekKategoriAdi))
                            .then((kategoriID) {
                          if (kategoriID > 0) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text("Kategori Güncellendi"),
                                    duration: Duration(seconds: 1)
                                )
                            );
                            _kategorileriGuncelle();
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


}
