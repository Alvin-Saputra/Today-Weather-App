import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_weather_app/data_service.dart';
import 'package:minimal_weather_app/models.dart';
import 'package:lottie/lottie.dart';
import 'package:minimal_weather_app/sqlite_help.dart';
import 'package:intl/intl.dart';


void main() {
  runApp(const home());
}

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _MyAppState();
}

class _MyAppState extends State<home> {
  
  final TextEditingController _cityTextController= TextEditingController();
  final _dataservice = DataService();
  WeatherResponse? _response;
  String? cityName;
  int index = 0;
  bool location_fetch_condition = false;
  bool weather_fetch_condition = false;
  double temper = 0.0;
  String weather_main = " ";
  
  
  String date_now(){
  DateTime now = DateTime.now();

  String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(now);

  return formattedDate;
  }


  Future<void> fetch_cityname_formlocation() async {
    String? CityNametemp;

    CityNametemp = await _dataservice.getCurrentCity();
    cityName = CityNametemp;
    print("City Name: $cityName"); 
     _cityTextController.text = cityName??"Tangerang";

    try{
    final response = await _dataservice.getWeather(CityNametemp);
    print(response.cityName);
    print(response.tempInfo.temperature);
    print(response.weatherInfo.description);

    temper = response.tempInfo.temperature;
    weather_main  =response.weatherInfo.main;

    setState(() => _response = response
    );
    // weather_fetch_condition = true;
    }

    catch(e){
      print(e);
    }

     location_fetch_condition = true;
  }

  void initState(){
      super.initState();

      if(location_fetch_condition == false){
        fetch_cityname_formlocation();
      }
        // _search();
      
  }

   Future<void> Tambahdata() async{
    await SQLHelper.Tambahdata
    (cityName??"Tangerang", date_now().toString(), temper, weather_main);

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
           decoration: BoxDecoration(
              image: _response != null
                  ? DecorationImage(
                      image: _response!.weatherInfo.main == "Clear" ||
                            _response!.weatherInfo.main == "Clouds"
                          ? AssetImage("assets/BG_Weather-02.png")

                          : _response!.weatherInfo.main == "Rain" ||
                             _response!.weatherInfo.main == "Drizzle"
                          ? AssetImage("assets/BG_Weather-03.png")

                          : _response!.weatherInfo.main == "Snow"
                          ? AssetImage("assets/BG_Weather-05.png")

                          :_response!.weatherInfo.main == "Smoke" || 
                          _response!.weatherInfo.main == "Mist" || 
                          _response!.weatherInfo.main == "Haze" ||
                          _response!.weatherInfo.main == "Fog"
                           ? AssetImage("assets/BG_Weather-03.png")

                          : _response!.weatherInfo.main == "Thunderstorm"
                          ? AssetImage("assets/BG_Weather-03.png")
                          : AssetImage("assets/BG_Weather-03.png"),
                      fit: BoxFit.cover,
                    )
                  : null, // Set the image to null if _response is null
            ),
          
          //  decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage("assets/Sunny_BG-02.png"), // Replace with your image path
          //     fit: BoxFit.cover,
          //   ),
          // ),
          child: Container(
            margin: EdgeInsets.only(bottom: 30.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Padding(
                  //   padding: EdgeInsets.symmetric(vertical: 40),
                    // child: SizedBox(
                    //   width: 250,
                    //   child: 
                    //   // TextField(
                    //   // readOnly: true,
                    //   //  controller: _cityTextController,
                    //   //  decoration: InputDecoration(labelText: 'City'),
                    //   //  textAlign: TextAlign.center
                    //   // ),
                    //   Text('${cityName}',
                    //   style: GoogleFonts.cabin(
                    //     fontSize: 30,
                    //     fontWeight: FontWeight.bold
                    //   ))
                    // ),
                  // ),
                  // ElevatedButton(onPressed: _search, child: Text('search')
                  // ),
                  if(_response != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: ElevatedButton(
                        onPressed: location_fetch_condition == true?  () async{
                       await Tambahdata() ;
                        } : null,
                        child: Icon(Icons.bookmark_outline, color: Colors.white,),
                        style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 86, 62, 224), // Ganti dengan warna yang diinginkan
                              ),),
                      ),
                    ],
                  ),
            
                  if(_response != null)
                  Column(
                    children: [
                      //animation
                            
                      if(_response!.weatherInfo.main == "Clear")
                      Lottie.asset('assets/Sunny.json', width: 220, height: 220,),
            
                      if(_response!.weatherInfo.main == "Clouds")
                      Lottie.asset('assets/Cloudy_2.json', width: 220, height: 220,),
            
                      if(_response!.weatherInfo.main == "Rain" || 
                      _response!.weatherInfo.main == "Drizzle")
                      Lottie.asset('assets/Rain.json', width: 220, height: 220,),
            
                      if(_response!.weatherInfo.main == "Thunderstorm")
                      Lottie.asset('assets/Thunderstorm.json', width: 220, height: 220,),
            
                      if(_response!.weatherInfo.main == "Snow")
                      Lottie.asset('assets/Snow.json', width: 220, height: 220,),
            
                      if(_response!.weatherInfo.main == "Smoke" || 
                      _response!.weatherInfo.main == "Mist" || 
                      _response!.weatherInfo.main == "Haze" ||
                      _response!.weatherInfo.main == "Fog")
                      Lottie.asset('assets/Fog.json', width: 220, height: 220,),
                      
                      Text('${cityName}',
                      style: GoogleFonts.cabin(
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                      )),
                      
                      Text('${_response!.tempInfo.temperature}°C',
                      style: GoogleFonts.cabin(
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
                      Text('${_response?.weatherInfo.description??'N/A'}'),
                      // Text('Max Temperature: ${_response!.tempInfo.max_temperature}'),
                      // Text('Min Temperature:${_response!.tempInfo.min_temperature}'),
                    ],
                  ),
                  if(_response == null)
                  Column(
                    children:[
                      Lottie.asset('assets/Loading.json', width: 400, height: 400,),
                    ]
                  ),
                  
                  // Expanded(
                  //   child: Card(
                  //           margin: EdgeInsets.all(16),
                  //           child: Padding(
                  //             padding: const EdgeInsets.all(16.0),
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.stretch,
                  //               children: [
                  //                 Text('Additional Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  //                 SizedBox(height: 8),
                  //                 // Add any additional information here
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  // ),
                  if(_response != null)
                  Container(
                     margin: EdgeInsets.only(top: 70.0, left:65.0),
                    child: Row(
                      children: [
                        Column(
                          children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Icon(Icons.thermostat_outlined,
                                  size: 30,),
                          ),
                          Text('Max Temp:', style: GoogleFonts.cabin(
                                                         fontSize: 12,
                                                         fontWeight: FontWeight.bold
                                                       )),
                          Text('${_response?.tempInfo.max_temperature ?? 'N/A'} °C', style: GoogleFonts.cabin(
                                                         fontSize: 15,
                                                         fontWeight: FontWeight.bold
                                                       )),
                          
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 50.0),
                          child: Column(
                            children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom:15.0),
                              child: Icon(Icons.water_drop_rounded,
                                    size: 30,),
                            ),
                            Text('Humidity:', style: GoogleFonts.cabin(
                                                           fontSize: 12,
                                                           fontWeight: FontWeight.bold
                                                         )),
                            Text('${_response?.tempInfo.humidity ?? 'N/A'} %', style: GoogleFonts.cabin(
                                                           fontSize: 15,
                                                           fontWeight: FontWeight.bold
                                                         )),
                            
                            ],
                          ),
                        ),
            
                        Padding(
                          padding: const EdgeInsets.only(left: 50.0),
                          child: Column(
                            children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Icon(Icons.wind_power_outlined,
                                    size: 30,),
                            ),
                            Text('Wind Speed:', style: GoogleFonts.cabin(
                                                           fontSize: 12,
                                                           fontWeight: FontWeight.bold
                                                         )),
                            Text('${_response?.windinfo.Wind_speed ?? 'N/A'} m/s', style: GoogleFonts.cabin(
                                                           fontSize: 15,
                                                           fontWeight: FontWeight.bold
                                                         )),
                            
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                //   Column(
                //     children: [
                //       Row(
                //       children: [
                        
                //         Container(
                //           margin: EdgeInsets.only(top: 30.0, left:40.0),
                //           child: Row(
                //             children: [
                //              Icon(Icons.thermostat_auto_outlined,
                //              size: 30,),
                          
                //              Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                Padding(
                //                  padding: const EdgeInsets.only(left: 5.0),
                //                  child: Text('Max Temp:', style: GoogleFonts.cabin(
                //                                        fontSize: 15,
                //                                        fontWeight: FontWeight.bold
                //                                      )),
                //                ),
                //                 Padding(
                //                   padding: const EdgeInsets.only(left: 5.0),
                //                   child: Text('${_response?.tempInfo.max_temperature ?? 'N/A'}', style: GoogleFonts.cabin(
                //                                        fontSize: 15,
                //                                        fontWeight: FontWeight.bold
                //                                      )),
                //                 ),
                //               ],
                //              )
                //              ]
                //           ),
                //         ),
                      
                //         Container(
                //           margin: EdgeInsets.only(top: 30.0, left:100.0),
                //           child: Row(
                //             children: [
                //              Icon(Icons.wb_sunny_outlined,
                //              size: 30,),
                          
                //              Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                Padding(
                //                  padding: const EdgeInsets.only(left: 5.0),
                //                  child: Text('Max Temp:', style: GoogleFonts.cabin(
                //                                        fontSize: 15,
                //                                        fontWeight: FontWeight.bold
                //                                      )),
                //                ),
                //                 Padding(
                //                   padding: const EdgeInsets.only(left: 5.0),
                //                   child: Text('${_response?.tempInfo.max_temperature ?? 'N/A'}', style: GoogleFonts.cabin(
                //                                        fontSize: 15,
                //                                        fontWeight: FontWeight.bold
                //                                      )),
                //                 ),
                //               ],
                //              )
                //              ]
                //           ),
                //         ),
                //       ],
                //     ),
                //     Row(
                //       children: [
                        
                //         Container(
                //           margin: EdgeInsets.only(top: 30.0, left:40.0),
                //           child: Row(
                //             children: [
                //              Icon(Icons.thermostat_auto_outlined,
                //              size: 30,),
                          
                //              Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                Padding(
                //                  padding: const EdgeInsets.only(left: 5.0),
                //                  child: Text('Max Temp:', style: GoogleFonts.cabin(
                //                                        fontSize: 15,
                //                                        fontWeight: FontWeight.bold
                //                                      )),
                //                ),
                //                 Padding(
                //                   padding: const EdgeInsets.only(left: 5.0),
                //                   child: Text('${_response?.tempInfo.max_temperature ?? 'N/A'}', style: GoogleFonts.cabin(
                //                                        fontSize: 15,
                //                                        fontWeight: FontWeight.bold
                //                                      )),
                //                 ),
                //               ],
                //              )
                //              ]
                //           ),
                //         ),
                      
                //         Container(
                //           margin: EdgeInsets.only(top: 40.0, left:100.0),
                //           child: Row(
                //             children: [
                //              Icon(Icons.wb_sunny_outlined,
                //              size: 30,),
                          
                //              Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                Padding(
                //                  padding: const EdgeInsets.only(left: 5.0),
                //                  child: Text('Max Temp:', style: GoogleFonts.cabin(
                //                                        fontSize: 15,
                //                                        fontWeight: FontWeight.bold
                //                                      )),
                //                ),
                //                 Padding(
                //                   padding: const EdgeInsets.only(left: 5.0),
                //                   child: Text('${_response?.tempInfo.max_temperature ?? 'N/A'}', style: GoogleFonts.cabin(
                //                                        fontSize: 15,
                //                                        fontWeight: FontWeight.bold
                //                                      )),
                //                 ),
                //               ],
                //              )
                //              ]
                //           ),
                //         ),
                      
                //       ],
                //                     )
            
                //   ],
                //  ),
              ],
                
                     ),
              
              
            ),
          ),
        ),
      
      ),
    );
  }
}