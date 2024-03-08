import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:clean_tdd/domain/entities/weather.dart';
import 'package:clean_tdd/presentation/bloc/weather_bloc.dart';
import 'package:clean_tdd/presentation/bloc/weather_event.dart';
import 'package:clean_tdd/presentation/bloc/weather_state.dart';
import 'package:clean_tdd/presentation/pages/weather_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWeatherBloc extends MockBloc<WeatherEvent, WeatherState>
    implements WeatherBloc {}

void main() {
  late MockWeatherBloc mockWeatherBloc;

  setUp(() {
    mockWeatherBloc = MockWeatherBloc();
    HttpOverrides.global = null;
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WeatherBloc>(
      create: (context) => mockWeatherBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  const testWeather = WeatherEntity(
    cityName: 'Porto',
    main: 'Clouds',
    description: 'few clouds',
    iconCode: '02d',
    temperature: 12.0,
    pressure: 1009,
    humidity: 75,
  );

  testWidgets(
    'text field should trigger state to change from empty to loading',
    (widgetTester) async {
      // ARRANGE
      when(() => mockWeatherBloc.state).thenReturn(WeatherEmpty());

      // ACT
      await widgetTester.pumpWidget(makeTestableWidget(const WeatherPage()));
      var textField = find.byType(TextField);
      expect(textField, findsOneWidget);
      await widgetTester.enterText(textField, 'Porto');
      await widgetTester.pump();
      expect(find.text('Porto'), findsOneWidget);
    },
  );

  testWidgets(
    'should show progress indicator when state is loading',
    (widgetTester) async {
      // ARRANGE
      when(() => mockWeatherBloc.state).thenReturn(WeatherLoading());

      // ACT
      await widgetTester.pumpWidget(makeTestableWidget(const WeatherPage()));

      // ASSERT
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'should show widget contain weather data when state is weather loaded',
    (widgetTester) async {
      // ARRANGE
      when(() => mockWeatherBloc.state)
          .thenReturn(const WeatherLoaded(testWeather));

      // ACT
      await widgetTester.pumpWidget(makeTestableWidget(const WeatherPage()));
      await widgetTester.pumpAndSettle();

      // ASSERT
      expect(find.byKey(const Key('weather_data')), findsOneWidget);
    },
  );
}
