import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polyfam/services/weather_api_service.dart';
import 'package:polyfam/widgets/BackgroundImage_widget.dart';

class TheWeatherScreen extends StatelessWidget {
  static String routeName = '/weatherscreen';


  @override
  Widget build(BuildContext context) {
    WeatherAPIService weatherService = WeatherAPIService();
    return FutureBuilder(
      future: weatherService.fetchWeather(),
      builder:(context, snapshot) => snapshot.connectionState == ConnectionState.waiting ? Center(child: CircularProgressIndicator()) :Scaffold(
        body: Stack(
          children: [
            BackgroundImageWidget(),

            Container(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 50,),
                    Image.asset("images/weather.png"),
                    Text( (snapshot.data! as List)[0].toString() + "°C", style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),

                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Text('Current Weather Condition: ' + (snapshot.data! as List)[1].toString() + "",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                    ),







                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Country: ' + (snapshot.data! as List)[2].toString() + "",style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color:Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}





