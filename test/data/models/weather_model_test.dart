import 'dart:convert';

import 'package:clean_tdd/data/models/weather_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/json_reader.dart';

void main() {
  const testWeatherModel = WeatherModel(
    cityName: 'Porto',
    main: 'Clouds',
    description: 'few clouds',
    iconCode: '02d',
    temperature: 12.0,
    pressure: 1009,
    humidity: 75,
  );

  test('should be a subclass of weather entity', () async {
    // ASSERT
    expect(testWeatherModel, isA<WeatherModel>());
  });

  test('should return a valid model from json', () async {
    // ARRANGE
    final Map<String, dynamic> jsonMap = json.decode(
      readJson('helpers/dummy_data/dummy_weather_response.json'),
    );

    // ACT
    final result = WeatherModel.fromJson(jsonMap);

    // ASSERT
    expect(result, equals(testWeatherModel));
  });

  test('should return a json map containing proper data', () async {
    // ACT
    final result = testWeatherModel.toJson();

    // ASSERT
    final expectedJsonMap = {
      'weather': [
        {
          'main': 'Clouds',
          'description': 'few clouds',
          'icon': '02d',
        }
      ],
      'main': {
        'temp': 12.0,
        'pressure': 1009,
        'humidity': 75,
      },
      'name': 'Porto',
    };

    expect(result, equals(expectedJsonMap));
  });
}
