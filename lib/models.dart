/*
{
  "weather": [
    {
      "main": "Rain",
      "description": "moderate rain",
      "icon": "10d"
    }
  ],

  "main": {
    "temp": 298.48,
  },

  "name": "Zocca"
}       

*/

// import 'dart:ffi';

import 'package:flutter/material.dart';

class WeatherInfo{
  final String description;
  final String icon;
  final String main;

  WeatherInfo(
    {
    required this.main,
    required this.description, 
    required this.icon});

  factory WeatherInfo.fromJson(Map<String, dynamic>json){
    final main = json["main"];
    final description = json["description"];
    final icon = json["icon"];
    return WeatherInfo(main:main, description: description, icon: icon);
  }
  
}

class TemperatureInfo{
  final double temperature;
  final double max_temperature;
  final double min_temperature;
  final num humidity;


  TemperatureInfo({
    required this.temperature,
    required this.max_temperature,
    required this.min_temperature,
    required this.humidity}){

  }

  factory TemperatureInfo.fromJson(Map<String, dynamic>json){
    final temperature = json['temp'];
    final temperature_max = json['temp_max'];
    final temperature_min = json['temp_min'];
    final humidity_data   = json['humidity'];
    return TemperatureInfo(temperature: temperature, max_temperature: temperature_max, min_temperature: temperature_min, humidity: humidity_data);
  }

}

class Windinformation{
  final num Wind_speed;

  Windinformation({
    required this.Wind_speed
  });

  factory Windinformation.fromJson(Map<String, dynamic>json){
    final speed_wind = json['speed'];

    return Windinformation(Wind_speed: speed_wind);
  }

}

class WeatherResponse{
  final String cityName;
  final TemperatureInfo tempInfo;
  final WeatherInfo weatherInfo;
  final Windinformation windinfo;

  WeatherResponse(
    {required this.cityName, 
    required this.tempInfo,
    required this.weatherInfo,
    required this.windinfo}
    );

  factory WeatherResponse.fromJson(Map<String, dynamic>json){
    final cityName = json['name'];

    final tempInfoJson = json['main'];
    final tempInfo = TemperatureInfo.fromJson(tempInfoJson);

    final WeatherInfoJson = json['weather'][0];
    final weatherinfo = WeatherInfo.fromJson(WeatherInfoJson);

    final WindInfoJson = json['wind'];
    final windinfo     = Windinformation.fromJson(WindInfoJson);


    return WeatherResponse(cityName: cityName, tempInfo:tempInfo, weatherInfo: weatherinfo, windinfo: windinfo);
  }
}