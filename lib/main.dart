
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/weather_bloc.dart';
import 'model/weather.dart';

void main() => runApp(const MyApp());


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen()
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final WeatherBloc weatherBloc = WeatherBloc();

  @override
  void dispose() {
    super.dispose();
    weatherBloc.close();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather App')),
      body: BlocProvider(
        create: (context) => weatherBloc,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          child: BlocBuilder(
            bloc: weatherBloc,
            builder: (BuildContext context, WeatherState state){
              if(state is WeatherInitial){
                return buildInitialInput();
              }
              else if(state is WeatherLoading){
                return buildLoading();
              }
              else if(state is WeatherLoaded){
                final weather = state.weather;
                return buildColumnWithData(weather);
              }
              else {
                return const Center(child: Text('Something went wrong!'));
              }
            },
          )
        ),
      ),
    );
  }

  Widget buildInitialInput(){
    return const Center(
      child: CityInputField(),
    );
  }

  Widget buildLoading(){
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
  Column buildColumnWithData(Weather weather){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          weather.cityName,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700
          ),
        ),
        Text(
          "${weather.temperatureCelsius.toStringAsFixed(1)} °C",
          style: const TextStyle(
            fontSize: 80
          ),
        ),
        const CityInputField()
      ],
    );
  }
}


class CityInputField extends StatefulWidget {
  const CityInputField({Key? key}) : super(key: key);

  @override
  State<CityInputField> createState() => _CityInputFieldState();
}

class _CityInputFieldState extends State<CityInputField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        onSubmitted: submitCityName,
        textInputAction: TextInputAction.search,
        decoration: const InputDecoration(
          hintText: 'Enter a city',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          suffixIcon: Icon(Icons.search)
        ),
      ),
    );
  }

  void submitCityName(String cityName){
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    weatherBloc.add(GetWeather(cityName));
  }
}
