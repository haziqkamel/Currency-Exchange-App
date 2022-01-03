// 1 - To let the UI listen for changes in the view model, you use ChangeNotifier.
// This calss is part of the Flutter foundation package.
import 'package:flutter/foundation.dart';
import 'package:moolaxv2/business_logic/models/currency.dart';
import 'package:moolaxv2/business_logic/models/rate.dart';
import 'package:moolaxv2/business_logic/utils/iso_data.dart';

import 'package:moolaxv2/services/currency/currency_service.dart';
import 'package:moolaxv2/services/service_locator.dart';

// 2 - Extending the view model class with ChangeNotifier. Another option would be to use a mixin.
// ChangeNotifier provides notifyListeners(), which you'll use below
class ChooseFavoritesViewModel extends ChangeNotifier {
  // 3 - A service handles the work of getting and saving the currencies and exchange rates.
  // Here, you get an implementation of the abstract CurrencyService. The actual implementation is hidden from the view model.
  // You can swap it out with different implementations, or even fake data, and the view model will be none the wiser.
  final CurrencyService _currencyService = serviceLocator<CurrencyService>();

  List<FavoritePresentation> _choices = [];
  List<Currency> _favorites = [];

  // 4 - Anyone who has a reference to this view model can access a list of currencies choices that the user can favorite.
  // The UI will use that list to create a clickable Listview
  List<FavoritePresentation> get choices => _choices;

  void loadData() async {
    final rates = await _currencyService.getAllExchangeRates();
    _favorites = await _currencyService.getFavoriteCurrencies();
    _prepareChoicePresentation(rates);

    // 5 - After loading the list of currencies or changing the favorite status of a currency,
    // you can notify the listeners. The UI will listen so it can reflect the change visually.
    notifyListeners();
  }

  void toggleFavoriteStatus(int choiceIndex) {
    final isFavorite = !_choices[choiceIndex].isFavorite;
    final code = _choices[choiceIndex].alphabeticCode;
    _choices[choiceIndex].isFavorite = isFavorite;
    if (isFavorite) {
      _addToFavorites(code);
    } else {
      _removeFromFavorites(code);
    }

    // 5
    notifyListeners();
  }

  void _prepareChoicePresentation(List<Rate> rates) {
    List<FavoritePresentation> list = [];
    for (Rate rate in rates) {
      String code = rate.quoteCurrency;
      bool isFavorite = _getFavoriteStatus(code);
      list.add(
        FavoritePresentation(
          flag: IsoData.flagOf(code),
          alphabeticCode: code,
          longName: IsoData.longNameOf(code),
          isFavorite: isFavorite,
        ),
      );
    }
    _choices = list;
  }

  bool _getFavoriteStatus(String code) {
    for (Currency currency in _favorites) {
      if (code == currency.isoCode) return true;
    }
    return false;
  }

  void _addToFavorites(String alphabeticCode) {
    _favorites.add(Currency(alphabeticCode));
    _currencyService.saveFavoriteCurrencies(_favorites);
  }

  void _removeFromFavorites(String alphabeticCode) {
    for (final currency in _favorites) {
      if (currency.isoCode == alphabeticCode) {
        _favorites.remove(currency);
        break;
      }
    }
    _currencyService.saveFavoriteCurrencies(_favorites);
  }
}

class FavoritePresentation {
  final String flag;
  final String alphabeticCode;
  final String longName;
  bool isFavorite;
  FavoritePresentation({
    required this.flag,
    required this.alphabeticCode,
    required this.longName,
    required this.isFavorite,
  });
}
