import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String currentCurrency = "USD";
  String apiKey = '4CC0CF46-4C1A-439C-92FC-A1F3B690544A#';
  double currencyRate;
  String cryptoName = '?';
  String finalCurrency = '?';

  Future<void> networkingHelper() async {
    http.Response response = await http.get(
        'https://rest.coinapi.io/v1/exchangerate/$cryptoName/$currentCurrency?apikey=$apiKey');
    String data = response.body;
    if (response.statusCode == 200) {
      var usExchange = jsonDecode(data)['rate'];
      currencyRate = usExchange;
      String actualCurrency = currencyRate.toStringAsFixed(2);
      finalCurrency = actualCurrency;
      print(actualCurrency);
      print('data available');
    } else {
      print(response.statusCode);
    }

    return jsonDecode(data);
  }

  DropdownButton<String> androidDropDown() {
    List<DropdownMenuItem<String>> itemList = [];
    for (String currency in currenciesList) {
      var menuItem = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );
      itemList.add(menuItem);
    }
    return DropdownButton(
      value: currentCurrency,
      onChanged: (value) {
        setState(() {
          currentCurrency = value;
          networkingHelper();
        });
      },
      items: itemList,
    );
  }

  CupertinoPicker iOSPickerItems() {
    List<Text> newItems = [];
    for (String currency in currenciesList) {
      var newText = Text(
        currency,
        style: TextStyle(color: Colors.white),
      );
      newItems.add(newText);
    }
    return CupertinoPicker(
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          currentCurrency = currenciesList[selectedIndex];
        });
      },
      itemExtent: 32.0,
      backgroundColor: Colors.lightBlue,
      children: newItems,
    );
  }

  Widget cryptoCard(String cryptoCurrency) {
    networkingHelper();
    cryptoName = cryptoCurrency;
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $finalCurrency $currentCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    networkingHelper();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              cryptoCard('BTC'),
              cryptoCard('ETH'),
              cryptoCard('LTC'),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: iOSPickerItems(),
            // child: iOSPickerItems(),
          ),
        ],
      ),
    );
  }
}
