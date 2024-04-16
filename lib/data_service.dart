import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:minimal_weather_app/models.dart';

import 'package:geolocator/geolocator.dart';

class DataService{
  Future <WeatherResponse>getWeather(String city)async{
    //api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}

    final queryParameters = {
      'q' : city,
      'appid' : '601bcd235ff4e9883322abb767bffb67',
      'units': 'metric'
    };

    final uri = Uri.https('api.openweathermap.org', '/data/2.5/weather', queryParameters);

    final response = await http.get(uri);

    print(response.body);
    final json = jsonDecode(response.body);
    return WeatherResponse.fromJson(json);
  }

  Future<String> getCurrentCity() async{

    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }
  
    Position position = await Geolocator.getCurrentPosition(
      forceAndroidLocationManager: true,
      desiredAccuracy: LocationAccuracy.best
    );

    List<Placemark> placemark = await placemarkFromCoordinates(position.latitude, position.longitude);
    print("Placemark: ${placemark.toString()}");

    String? city = placemark[0].administrativeArea;

    return city ?? "";
  }
}