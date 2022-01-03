import 'package:moolaxv2/business_logic/models/rate.dart';
import 'package:moolaxv2/services/web_api/web_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// 1
class WebApiImpl implements WebApi {
  // final _host = 'api.exchangeratesapi.io';
  // final _path = 'latest?access_key=054d9416bf877ff644e29e06c6aa1dd2';
  final url =
      'http://api.exchangeratesapi.io/v1/latest?access_key=ACCES_KEY';
  final Map<String, String> _headers = {'Content-type': 'application/json'};

  //2
  List<Rate>? _rateCache;

  @override
  Future<List<Rate>?> fetchExchangeRates() async {
    if (_rateCache == null) {
      print('getting rates from the web');
      // final uri = Uri.https(_host, _path);
      final results = await http.get(Uri.parse(url), headers: _headers);
      final jsonObject = json.decode(results.body);
      _rateCache = _createRateListFromRawMap(jsonObject);
    } else {
      print('getting rates from cache');
    }
    return _rateCache;
  }

  List<Rate>? _createRateListFromRawMap(Map jsonObject) {
    final Map rates = jsonObject['rates'];
    final String base = jsonObject['base'];
    List<Rate> list = [];
    list.add(Rate(baseCurrency: base, quoteCurrency: base, exchangeRate: 1.0));
    for (var rate in rates.entries) {
      // print(rate.key);
      // print(rate.value);
      list.add(
        Rate(
          baseCurrency: base,
          quoteCurrency: rate.key,
          exchangeRate: rate.value,
        ),
      );
    }
    return list;
  }
}
