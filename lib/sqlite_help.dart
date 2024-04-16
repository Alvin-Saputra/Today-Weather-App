import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper{
  //fungsi membuat database
  static Future<void> createTables(sql.Database database) async{
    await database.execute("""
  CREATE TABLE tbkota_cuaca(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    nama_kota TEXT,
    Tanggal_waktu TEXT,
    Temperature REAL,
     main_weather TEXT
    
  )
  """);
  }

 
  static Future<sql.Database> db() async{
    return sql.openDatabase('cuaca.db', version: 1, onCreate: (sql.Database database, int version)async{
      await createTables(database);
    });
  }

  static Future<int> Tambahdata(String kota, String tanggal_waktu, double temperature, String mainweather) async {
  print("Menambahkan data: $kota");
  final db = await SQLHelper.db();
  final data = {'nama_kota': kota, 'Tanggal_waktu': tanggal_waktu, 'Temperature': temperature, 'main_weather': mainweather};
  final result = await db.insert('tbkota_cuaca', data);
  if(result == 1){
      print("Data berhasil ditambahkan: $result");
  }

  else{
    print("Data Gagal dimasukkan");
  }
  
  return result;
}

 static Future<int> hapusData(int id) async {
    print("Menghapus data dengan ID: $id");
    final db = await SQLHelper.db();
    final result = await db.delete('tbkota_cuaca', where: 'id = ?', whereArgs: [id]);
    
    if (result == 1) {
      print("Data berhasil dihapus: $result");
    } else {
      print("Data dengan ID $id tidak ditemukan atau gagal dihapus");
    }

    return result;
  }

  static Future<List<Map<String, dynamic>>> getdata() async {
    final db = await SQLHelper.db();
    return db.query('tbkota_cuaca');
  }

  //update data

  static Future<int> Updatedata(int id, String kota, String tanggal_waktu, double temperature, String mainweather) async{
    final db = await SQLHelper.db();

     final data = {'nama_kota': kota, 'Tanggal_waktu': tanggal_waktu, 'Temperature': temperature, 'main_weather': mainweather};

     return await db.update('tbkota_cuaca', data, where: "id = $id");
  }

}