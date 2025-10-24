import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:async';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  Map<String, String> coinValuesMap = {};
  bool isWaiting = false;
  Timer? timer;

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
          getData();
        });
      },
    );
  }

  void getData() async {
    // coinValuesMap = den map af coin navn og værdi som vi fik fra coin data class
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        isWaiting = false;
        coinValuesMap = data; //   (BTC, ETH, LTC)
        print('coinValues: $coinValuesMap');
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    // Call getData() when the screen loads up
    getData();
    timer = Timer.periodic(Duration(seconds: 30), (Timer t) {
      //timer for at priserne bliver updatet hver 30 sec
      getData();
    });
  }

  @override // Timeren stopper, når brugeren forlader skærmen
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bitcoin.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                child: makeCards(),
              ),
              Container(
                height: 150.0,
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 30.0),
                color: Colors.white10,
                child: androidDropdown(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column makeCards() {
    // en column af de kort
    List<Widget> cryptoCards = [];
    for (String crypto in cryptoList) {
      // loopes i bitcoin,ethereum,litecoin,dogecoin
      cryptoCards.add(
        // adder hver card to in liste med tre
        CryptoCard(
          cryptoCurrency: crypto,
          value: isWaiting ? '?' : coinValuesMap[crypto] ?? '?',
          selectedCurrency: selectedCurrency,
        ),
      );
    }
    return Column(
      // retuner en column med de cart som list
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }
}

class CryptoCard extends StatelessWidget {
  // en class som laver en cart med en text af 3 variabler
  final String cryptoCurrency;
  final String value;
  final String selectedCurrency;

  const CryptoCard({
    required this.cryptoCurrency,
    required this.value,
    required this.selectedCurrency,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 0),
      child: Card(
        color: Colors.white10,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
          child: Text(
            '1 ${cryptoCurrency.toUpperCase()} = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
