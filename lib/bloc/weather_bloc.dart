import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../model/weather.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    on<WeatherEvent>((event, emit) async{

      if(event is GetWeather){
        emit.call(WeatherLoading());
        
        final weather = await _fetchTheWeatherData(event.cityName);

        emit.call(WeatherLoaded(weather));
      }
    });
  }


  Future<Weather> _fetchTheWeatherData(String cityName){
    return Future.delayed(
      const Duration(seconds: 2),(){
        return Weather(cityName: cityName,temperatureCelsius: 20 + Random().nextInt(15) + Random().nextDouble() );
      },
    );
  }
}
