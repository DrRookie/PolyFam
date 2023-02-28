import 'dart:convert';

import 'package:http/http.dart';


class WeatherAPIService{
  Future<List> fetchWeather() {

    List values = [];

    Uri url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=Singapore&appid=f119a010e2c9442001cb5224e38b450d&units=metric');
    return get(url).then((value) {
      var extractedData = json.decode(value.body) as dynamic;
      values.add(extractedData['main']['temp']);
      values.add(extractedData['weather'][0]['main']);
      values.add(extractedData['name']);
      return values;

    },).catchError((error) {
      throw error;
    });
  }
}