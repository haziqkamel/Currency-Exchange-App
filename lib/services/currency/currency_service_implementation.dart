import 'package:moolaxv2/business_logic/models/currency.dart';
import 'package:moolaxv2/business_logic/models/rate.dart';
import 'package:moolaxv2/services/currency/currency_service.dart';
import 'package:moolaxv2/services/service_locator.dart';
import 'package:moolaxv2/services/storage/storage_service.dart';
import 'package:moolaxv2/services/web_api/web_api.dart';

/// This class is the concrete implementation of [CurrencyService]. It is a
/// wrapper around the WebApi and StorageService services. This way the view models
/// don't actually have to know anything about the web or storage details.

class CurrencyServiceImpl implements CurrencyService {
  final WebApi _webApi = serviceLocator<WebApi>();
  final StorageService _storageService = serviceLocator<StorageService>();

  static final defaultFavorites = [Currency('EUR'), Currency('USD')];

  @override
  Future<List<Rate>> getAllExchangeRates({String? base}) async {
    List<Rate>? webData = await _webApi.fetchExchangeRates();
    if (base != null) {
      return _convertBaseCurrency(base, webData ?? []);
    }
    return webData ?? [];
  }

  @override
  Future<List<Currency>> getFavoriteCurrencies() async {
    final favorites = await _storageService.getFavoriteCurrencies();
    if (favorites.isEmpty) {
      return defaultFavorites;
    }
    return favorites;
  }

  @override
  Future<void> saveFavoriteCurrencies(List<Currency> data) async {
    if (data.isEmpty) return;
    await _storageService.saveFavoriteCurrencies(data);
  }

  List<Rate> _convertBaseCurrency(String base, List<Rate> webData) {
    if (webData[0].baseCurrency == base) {
      return webData;
    }
    double divisor =
        webData.firstWhere((rate) => rate.quoteCurrency == base).exchangeRate;
    return webData
        .map(
          (rate) => Rate(
            baseCurrency: base,
            quoteCurrency: rate.quoteCurrency,
            exchangeRate: rate.exchangeRate / divisor,
          ),
        )
        .toList();
  }
}
