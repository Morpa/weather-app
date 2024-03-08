import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../data/data_sources/weather_remote_data_source.dart';
import '../data/repositories/weather_repository_impl.dart';
import '../domain/repositories/weather_repository.dart';
import '../domain/usecases/get_current_weather.dart';
import 'bloc/weather_bloc.dart';

final locator = GetIt.instance;

void setupLocator() {
  // BLOC
  locator.registerFactory(() => WeatherBloc(locator()));

  // USECASE
  locator.registerLazySingleton(() => GetCurrentWeather(locator()));

  // REPOSITORY
  locator.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(weatherRemoteDataSource: locator()),
  );

  // DATA SOURCE
  locator.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(
      client: locator(),
    ),
  );

  // EXTERNAL
  locator.registerLazySingleton(() => http.Client());
}
