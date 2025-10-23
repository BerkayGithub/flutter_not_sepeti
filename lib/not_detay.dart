import 'package:flutter/material.dart';
import 'package:flutter_not_sepeti/models/Kategori.dart';
import 'package:flutter_not_sepeti/models/not.dart';
import 'package:flutter_not_sepeti/utils/database_helper.dart';

class NotDetay extends StatefulWidget {
  final String baslik;
  final Not? duzenlenecekNot;

  const NotDetay({super.key, required this.baslik, this.duzenlenecekNot});

  @override
  State<NotDetay> createState() => _NotDetayState();
}

class _NotDetayState extends State<NotDetay> {
  var formKey = GlobalKey<FormState>();
  late List<Kategori> kategoriListesi;
  late DatabaseHelper databaseHelper;
  late int kategoriID;
  late int secilenOncelik;
  static final _oncelik = ["Düşük", "Orta", "Yüksek"];
  late String notBaslik, notIcerik;

  @override
  void initState() {
    super.initState();
    kategoriListesi = List<Kategori>.of([]);
    databaseHelper = DatabaseHelper();
    _kategoriListesiniDoldur();
    if(widget.duzenlenecekNot != null){
      notBaslik = widget.duzenlenecekNot!.notBaslik!;
      notIcerik = widget.duzenlenecekNot!.notIcerik!;
      kategoriID = widget.duzenlenecekNot!.kategoriID!;
      secilenOncelik = widget.duzenlenecekNot!.notOncelik!;
    }else {
      kategoriID = 1;
      secilenOncelik = 0;
    }
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
                      initialValue: notBaslik,
                      validator: (textBasligi){
                        if(textBasligi!.length < 3){
                          return "En az 3 karakter olmalı";
                        }
                        return null;
                      },
                      onSaved: (textBasligi){
                        notBaslik = textBasligi!;
                      },
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
                      initialValue: notIcerik,
                      onSaved: (textIcerik){
                        notIcerik = textIcerik!;
                      },
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
                      ElevatedButton(onPressed: (){
                        Navigator.of(context).pop();
                      }, style: ElevatedButton.styleFrom(backgroundColor: Colors.grey), child: Text("Vazgeç", style: TextStyle(color: Colors.black),)),
                      ElevatedButton(onPressed: () async {
                        if(formKey.currentState!.validate()){
                          formKey.currentState!.save();
                          var notTarih = DateTime.now();
                          if(widget.duzenlenecekNot == null) {
                            var eklenecekNot = Not(
                                kategoriID, notBaslik, notIcerik,
                                notTarih.toString(), secilenOncelik);
                            await databaseHelper.notEkle(eklenecekNot).then((kaydedilenNotID){
                              if(kaydedilenNotID > 0){
                                Navigator.pop(context);
                              }
                            });
                          }else{
                            var guncellenecekNot = Not.withId(
                              widget.duzenlenecekNot!.notID!,
                                kategoriID, notBaslik, notIcerik,
                                notTarih.toString(), secilenOncelik);
                            await databaseHelper.notGuncelle(guncellenecekNot).then((guncellenenID){
                              if(guncellenenID > 0){
                                Navigator.pop(context);
                              }
                            });
                          }
                        }
                      }, style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.shade700), child: Text("Kaydet", style: TextStyle(color: Colors.white),)),
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
