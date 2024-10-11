import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;

  Future<Map<String,dynamic>> getCurrentWeather() async {
    try{
      String cityName = 'London';
      final res = await http.get(
        Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey')
      );

      final data = jsonDecode(res.body);

      if(data['cod']!= '200'){
        throw 'An unexpected error occured';
      }

      return data;
    } catch (e){
      throw e.toString();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            setState(() {
              weather = getCurrentWeather();
            });
          }, 
          icon: const Icon(Icons.refresh),)
        ],
      ),
      body: FutureBuilder(future: weather, 
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        if(snapshot.hasError){
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        final data = snapshot.data;

        final currentWeatherData = data['list'][0];

        final currentTemp = currentWeatherData['main']['temp'];
        final currentSky = currentWeatherData['weather'][0]['main'];
      }),
    );
  }
}