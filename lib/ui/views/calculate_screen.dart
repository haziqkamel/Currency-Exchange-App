import 'package:flutter/material.dart';
import 'package:moolaxv2/business_logic/view_models/calculate_screen_viewmodel.dart';
import 'package:moolaxv2/services/service_locator.dart';
import 'package:provider/provider.dart';

import 'choose_favorites.dart';

class CalculateCurrencyScreen extends StatefulWidget {
  const CalculateCurrencyScreen({Key? key}) : super(key: key);

  @override
  _CalculateCurrencyScreenState createState() =>
      _CalculateCurrencyScreenState();
}

class _CalculateCurrencyScreenState extends State<CalculateCurrencyScreen> {
  CalculateScreenViewModel model = serviceLocator<CalculateScreenViewModel>();
  late TextEditingController _controller;

  @override
  void initState() {
    model.loadData();
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CalculateScreenViewModel>(
      create: (context) => model,
      child: Consumer<CalculateScreenViewModel>(
        builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            title: const Text('MoolaX v2'),
            actions: [
              IconButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChooseFavoriteCurrencyScreen(),
                    ),
                  );
                  model.refreshFavorites();
                },
                icon: const Icon(Icons.favorite),
              )
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              baseCurrencyTitle(model),
              baseCurrencyTextField(model),
              quoteCurrencyList(model),
            ],
          ),
        ),
      ),
    );
  }

  Widget baseCurrencyTitle(CalculateScreenViewModel model) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, top: 32, right: 32, bottom: 5),
      child: Text(
        model.baseCurrency.longName,
        style: const TextStyle(fontSize: 25),
      ),
    );
  }

  Widget baseCurrencyTextField(CalculateScreenViewModel model) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 32,
        right: 32,
        bottom: 32,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: TextField(
          style: const TextStyle(fontSize: 20),
          controller: _controller,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: SizedBox(
                width: 60,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    model.baseCurrency.flag,
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              ),
            ),
            labelStyle: const TextStyle(fontSize: 20),
            // hintText: 'Enter amount to exchange',
            hintStyle: const TextStyle(fontSize: 20),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(20),
          ),
          keyboardType: TextInputType.number,
          onChanged: (text) => model.calculateExchange(text),
        ),
      ),
    );
  }

  Widget quoteCurrencyList(CalculateScreenViewModel model) {
    return Expanded(
      child: ListView.builder(
        itemCount: model.quoteCurrencies.length,
        itemBuilder: (context, i) => Card(
          child: ListTile(
            leading: SizedBox(
              width: 60,
              child: Text(
                model.quoteCurrencies[i].flag,
                style: const TextStyle(fontSize: 30),
              ),
            ),
            title: Text(model.quoteCurrencies[i].longName),
            subtitle: Text(model.quoteCurrencies[i].amount),
            onTap: () {
              model.setNewBaseCurrency(i);
              _controller.clear();
            },
          ),
        ),
      ),
    );
  }
}
