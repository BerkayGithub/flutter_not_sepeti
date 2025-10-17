import 'package:flutter/material.dart';

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
      home: const NotListesi(),
    );
  }
}

class NotListesi extends StatelessWidget {
  const NotListesi({super.key});

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
            showDialog(barrierDismissible:false ,context: context, builder: (context){
              return SimpleDialog(
                title: Text("Kategori Ekle", style: TextStyle(color: Theme.of(context).primaryColor)),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Kategori ekle",
                        border: OutlineInputBorder()
                      ),
                      validator: (girilenKategoriAdi){
                        if(girilenKategoriAdi!.length < 3){
                          return "En az 3 karakter giriniz";
                        }
                      },
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: OverflowBar(
                      alignment: MainAxisAlignment.end,
                      spacing: 8.0,
                      children: [
                        ElevatedButton(onPressed: (){Navigator.pop(context);},style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent), child: Text("Vazgeç", style: TextStyle(color: Colors.white))),
                        ElevatedButton(onPressed: (){},style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent), child: Text("Kaydet", style: TextStyle(color: Colors.white))),
                      ],
                    ),
                  )
                ],
              );
            });
          },
          tooltip: "Kategori Ekle",
          mini: true,
          child: Icon(Icons.add_circle),
        ),
        FloatingActionButton(
          onPressed: () {},
          tooltip: "Not Ekle",
          child: Icon(Icons.add),
        )
      ],
      ),
    );
  }
}
