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
  'dogecoin',
];

const coinGeckoURL = 'https://api.coingecko.com/api/v3/simple/price';

class CoinData {
  Future<Map<String, String>> getCoinData(String selectedCurrency) async {
    Map<String, String> cryptoPrices = {};
    String ids = cryptoList.join(','); // bitcoin,ethereum,litecoin,dogecoin
    String requestURL =
        '$coinGeckoURL?ids=$ids&vs_currencies=${selectedCurrency.toLowerCase()}';
    // ex --> https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,litecoin,dogecoin&vs_currencies=eur
    print('Requesting: $requestURL');
    try {
      http.Response response = await http.get(Uri.parse(
          requestURL)); // få en json file med priserne af forskellige  bitcoins i forbindelse med valgte curency
      // { "bitcoin": { "eur": 94914 }, "dogecoin": { "eur": 0.167677 }, "ethereum": { "eur": 3318.13 }, "litecoin": { "eur": 80.96 } }

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        decodedData.forEach((crypto, data) {
          // FOR LOOP i hver item in json som indeholder coin-name og currency og pris
          double price = data[selectedCurrency.toLowerCase()] +
              0.0; // den format {"bitcoin": {"eur": 94914},}
          cryptoPrices[crypto] = price.toStringAsFixed(
              2); // her laves en map med key som er coin-navn og value som er prisen til hver coin
        });
      } else {
        print('HTTP Error: ${response.statusCode}');
        throw 'Problem with the get request';
      }
    } catch (e) {
      print('Request failed: $e');
      throw e;
    }

    return cryptoPrices; // map af coin navn og værdi retuneres
  }
}
