class Kategori{
  int? kategoriID;
  String? kategoriBaslik;

  Kategori(this.kategoriBaslik);// Bu constructor veritabanına veri eklerken obje oluşturmak için, id'si db tarafından oluşturuluyor

  Kategori.withID(this.kategoriID, this.kategoriBaslik); // Bu constructor veritabanından veri çekerken obje oluşturmak için

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['kategoriID'] = kategoriID;
    map['kategoriBaslik'] = kategoriBaslik;
    return map;
  }

  Kategori.fromMap(Map<String, dynamic> map){
    this.kategoriID = map['kategoriID'];
    this.kategoriBaslik = map['kategoriBaslik'];
  }

  @override
  String toString() {
    return 'Kategori{kategoriID: $kategoriID, kategoriBaslik: $kategoriBaslik}';
  }


}