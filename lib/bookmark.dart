import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_weather_app/sqlite_help.dart';

class bookmark extends StatefulWidget {
  const bookmark({super.key});

  

  @override
  State<bookmark> createState() => _bookmarkState();
}

class _bookmarkState extends State<bookmark> {

  TextEditingController nama_kota_controller = TextEditingController();
  TextEditingController tanggal_Waktu_controller = TextEditingController();
  TextEditingController temperature_controller = TextEditingController();
  TextEditingController weather_main_controller = TextEditingController();


   List<Map<String, dynamic>> cuaca = [];
  void refreshCatatan() async {
  final data = await SQLHelper.getdata();
  print("Data dari database: $data");
  setState(() {
    cuaca = data;
  });
}

Future<void> hapusData(id) async{
    await SQLHelper.hapusData
    (id);
     refreshCatatan();
  }

Future<void> updatedata(int id) async{
  var myDouble = double.parse(temperature_controller.text);
  assert(myDouble is double);

  await SQLHelper.Updatedata(id, nama_kota_controller.text, tanggal_Waktu_controller.text, myDouble, weather_main_controller.text);
  refreshCatatan();
  
}

  void initState(){
    refreshCatatan();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    print(cuaca);
    return Scaffold(
      
      body: Container(
        decoration: BoxDecoration(
            // image: DecorationImage(
            //   image: AssetImage("assets/BG_Bookmarks-04.png"), // Replace with your image path
            //   fit: BoxFit.cover,
            // ),
          ),
        child: Column(
          children: [
             Padding(
               padding: const EdgeInsets.only(top: 40.0),
               child: Text('Bookmarks', style:GoogleFonts.cabin(
                            fontSize: 30,
                            fontWeight: FontWeight.bold)),
             ),
            Expanded(
              child: ListView.builder(
                itemCount: cuaca.length,
                itemBuilder: (context, index) => Card(
                   
                  
                  margin: const EdgeInsets.symmetric( horizontal: 20.0, vertical: 10.0),
                  child: ListTile(
                    tileColor: Color.fromARGB(255, 224, 221, 255),
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_city), // Icon for Nama Kota
                            SizedBox(width: 5),
                            Text(
                              cuaca[index]['nama_kota'],
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.calendar_today), // Icon for Tanggal/Waktu
                            SizedBox(width: 5),
                            Text('Waktu: ' + cuaca[index]['Tanggal_waktu'], style: TextStyle(
                              fontSize: 15
                            ),),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.cloud), // Icon for Cuaca
                            SizedBox(width: 5),
                            Text('Cuaca: ' + cuaca[index]['main_weather']),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.thermostat), // Icon for Temperature
                            SizedBox(width: 5),
                            Text('Temp: ' + cuaca[index]['Temperature'].toString() + '°C'),
                          ],
                        ),
                      ],
                    ),
                    trailing: SizedBox(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              modalForm(cuaca[index]['id']);
                            },
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              hapusData(cuaca[index]['id']);
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
       floatingActionButton: Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          refreshCatatan();
        },
        child: Text('Refresh', style: TextStyle(color: Colors.white),),
        style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 86, 62, 224), // Ganti dengan warna yang diinginkan
                              ),
      ),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }


  //mode sheet
  void modalForm(int id)async{
    if(id != null){
      final datacuaca = cuaca.firstWhere((element) => element['id'] == id);
      nama_kota_controller.text = datacuaca['nama_kota'];
      tanggal_Waktu_controller.text = datacuaca['Tanggal_waktu'];
      weather_main_controller.text = datacuaca['main_weather'];
      temperature_controller.text = datacuaca['Temperature'].toString();
    }
    showModalBottomSheet(
      context: context, 
      builder: (_)=> Container(
        padding: const EdgeInsets.all(15.0),
        width: double.infinity,
        height: 1000,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
            TextField(
              controller: nama_kota_controller,
              decoration: const InputDecoration(
                hintText: 'Nama Kota'
              ),
            ),
            const SizedBox(
              height: 10),

             TextField(
              controller: tanggal_Waktu_controller,
              decoration: const InputDecoration(
                hintText: 'Tanggal/Waktu'
              ),
            ),

            const SizedBox(
              height: 10),

            TextField(
              controller: weather_main_controller,
              decoration: const InputDecoration(
                hintText: 'Cuaca'
              ),
            ),

            const SizedBox(
              height: 10),

              TextField(
              controller: temperature_controller,
              decoration: const InputDecoration(
                hintText: 'Temperature'
              ),
            ),

            const SizedBox(height: 20),
            ElevatedButton(onPressed: () async{
              await updatedata(id);
              Navigator.of(context).pop();
            }, child: Text('Update', style: TextStyle(color: Colors.white),),
            style: ElevatedButton.styleFrom(
           backgroundColor: Color.fromARGB(255, 86, 62, 224), // Ganti dengan warna yang diinginkan
                              ),
            )
          ]),
        ),
      ));
  }
}