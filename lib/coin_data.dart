import 'dart:convert';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'bitcoin',
  'ethereum',
  'litecoin',
];

const coinGeckoURL = 'https://api.coingecko.com/api/v3/simple/price';

class CoinData {
  Future<Map<String, String>> getCoinData(String selectedCurrency) async {
    Map<String, String> cryptoPrices = {};

    for (String crypto in cryptoList) {
      String requestURL =
          '$coinGeckoURL?ids=${crypto}&vs_currencies=${selectedCurrency.toLowerCase()}';
      http.Response response = await http.get(Uri.parse(requestURL));
      print(response.body);

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        double price =
            decodedData[crypto][selectedCurrency.toLowerCase()] + 0.0;
        cryptoPrices[crypto] = price.toStringAsFixed(2);
      } else {
        print('HTTP Error: ${response.statusCode}');
        throw 'Problem with the get request';
      }
      await Future.delayed(Duration(milliseconds: 500));
    }
    return cryptoPrices;
  }
}
