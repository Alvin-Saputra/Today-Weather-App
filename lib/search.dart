import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:minimal_weather_app/data_service.dart';
import 'package:minimal_weather_app/models.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_weather_app/sqlite_help.dart';

void main() {
  runApp(const search_page());
}

class search_page extends StatefulWidget {
  const search_page({super.key});

  @override
  State<search_page> createState() => _MyAppState();
}

class _MyAppState extends State<search_page> {
  final TextEditingController _cityTextController= TextEditingController();
  final _dataservice = DataService();
  WeatherResponse? _response;
  String? cityName;
  int index = 0;
  bool location_fetch_condition = false;
  double temper = 0.0;
  String weather_main = " ";


  String date_now(){
  DateTime now = DateTime.now();

  String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(now);

  return formattedDate;
  }


  void _search() async{
    final response = await _dataservice.getWeather(_cityTextController.text);
    print(response.cityName);
    print(response.tempInfo.temperature);
    print(response.weatherInfo.description);


    setState(() => _response = response
    );

    temper = response.tempInfo.temperature;
    weather_main = response.weatherInfo.main;

    
  }

  void initState(){
      super.initState();

      // if(location_fetch_condition == false){
      //   fetch_cityname_formlocation();
      // } 
  }

  
   Future<void> Tambahdata() async{
    await SQLHelper.Tambahdata
    (_cityTextController.text, date_now().toString(), temper, weather_main);

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
            
            child: Container(
              margin: EdgeInsets.only(bottom:40.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left:40.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 50),
                              child: SizedBox(
                                width: 200,
                                child: TextField(
                                // hintText: 'Enter A City Name',
                                 controller: _cityTextController,
                                 decoration: InputDecoration(
                                  labelText: 'City',  
                                  prefixIcon: Icon
                                 (Icons.search,
                                   color:Colors.black,
                                   size: 20,),
                                   ), 
                                  textAlign: TextAlign.center
                            
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 25.0, left: 25.0),
                              child: ElevatedButton(onPressed: _search, child: Text('Search', style: TextStyle(color: Colors.white),), 
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 86, 62, 224), // Ganti dengan warna yang diinginkan
                              ),),
                            ),
                          ],
                              ),
                      ),
                      
                       
                                
                      if(_response != null)
                      Column(
                        children: [
                          //animation
                          if(_response!.weatherInfo.main == "Clear")
                          Lottie.asset('assets/Sunny.json', width: 180, height: 180,),
                                
                          if(_response!.weatherInfo.main == "Clouds")
                          Lottie.asset('assets/Cloudy_2.json', width: 180, height: 180,),
                                
                          if(_response!.weatherInfo.main == "Rain" || 
                          _response!.weatherInfo.main == "Drizzle")
                          Lottie.asset('assets/Rain.json', width: 180, height: 180,),
                                
                          if(_response!.weatherInfo.main == "Thunderstorm")
                          Lottie.asset('assets/Thunderstorm.json', width: 180, height: 180,),
                                
                          if(_response!.weatherInfo.main == "Snow")
                          Lottie.asset('assets/Snow.json', width: 180, height: 180,),
                                
                          if(_response!.weatherInfo.main == "Smoke" || 
                          _response!.weatherInfo.main == "Mist" || 
                          _response!.weatherInfo.main == "Haze" ||
                          _response!.weatherInfo.main == "Fog")
                          Lottie.asset('assets/Fog.json', width: 180, height: 180,),
                                
                          //text
                          Text('${_response!.tempInfo.temperature}°',
                          style: TextStyle(fontSize: 40),),
                          Text('${_response!.weatherInfo.description}'),

                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: ElevatedButton(onPressed: Tambahdata, 
                             child: Icon(Icons.bookmark_outline, color:Colors.white),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 86, 62, 224), // Ganti dengan warna yang diinginkan
                              ),),
                             
                          )
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
                                
                        if(_response != null)
                        Container(
                           margin: EdgeInsets.only(top: 30.0, left:65.0),
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        
      //  bottomNavigationBar: NavigationBarTheme(
      //     data:NavigationBarThemeData(
      //       indicatorColor: Colors.blue.shade100,
      //       labelTextStyle: MaterialStateProperty.all(
      //         TextStyle(fontSize: 14, fontWeight: FontWeight.w500)
      //       )
      //     ),
      //     child: NavigationBar(
      //       height: 60,
      //       selectedIndex: index,
      //       onDestinationSelected: (index) =>
      //       setState(() => this.index = index),

      //       destinations: [
      //        NavigationDestination(
      //         icon: Icon(Icons.home_outlined), label: 'search_page'),
         
      //        NavigationDestination(
      //         icon: Icon(Icons.search_outlined), label: 'search_page')
         
      //     ]),
      //  ),
      ),
    );
  }
}