import 'package:get_it/get_it.dart';
import 'package:moolaxv2/business_logic/view_models/calculate_screen_viewmodel.dart';
import 'package:moolaxv2/business_logic/view_models/choose_favorites_viewmodel.dart';
import 'package:moolaxv2/services/currency/currency_service.dart';
import 'package:moolaxv2/services/currency/currency_service_implementation.dart';
import 'package:moolaxv2/services/storage/storage_service.dart';
import 'package:moolaxv2/services/storage/storage_service_implementation.dart';
import 'package:moolaxv2/services/web_api/web_api.dart';
import 'package:moolaxv2/services/web_api/web_api_implementation.dart';

// 1
GetIt serviceLocator = GetIt.instance;

// 2
void setupServiceLocator() {
  // 3
  //RegisterLazySingleton
  serviceLocator
      .registerLazySingleton<StorageService>(() => StorageServiceImpl());
  serviceLocator
      .registerLazySingleton<CurrencyService>(() => CurrencyServiceImpl());
  serviceLocator.registerLazySingleton<WebApi>(() => WebApiImpl());

  // 4
  //RegisterFactory ViewModel
  serviceLocator.registerFactory<CalculateScreenViewModel>(
      () => CalculateScreenViewModel());
  serviceLocator.registerFactory<ChooseFavoritesViewModel>(
      () => ChooseFavoritesViewModel());
}
