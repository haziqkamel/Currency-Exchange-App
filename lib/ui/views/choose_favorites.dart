import 'package:flutter/material.dart';
import 'package:moolaxv2/business_logic/view_models/choose_favorites_viewmodel.dart';
import 'package:moolaxv2/services/service_locator.dart';
import 'package:provider/provider.dart';

class ChooseFavoriteCurrencyScreen extends StatefulWidget {
  const ChooseFavoriteCurrencyScreen({Key? key}) : super(key: key);

  @override
  _ChooseFavoriteCurrencyScreenState createState() =>
      _ChooseFavoriteCurrencyScreenState();
}

class _ChooseFavoriteCurrencyScreenState
    extends State<ChooseFavoriteCurrencyScreen> {
  // 1 - The service locator returns a new instance of the view model for this screen
  ChooseFavoritesViewModel model = serviceLocator<ChooseFavoritesViewModel>();

  //2
  @override
  void initState() {
    model.loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildListView(ChooseFavoritesViewModel viewModel) {
      // 1 - You add ChangeNotifierProvider, a specia type of Provider which listens for changes in your view model.
      return ChangeNotifierProvider<ChooseFavoritesViewModel>(
        // 2 - ChangeNotifierProvider has a create method that provides a value to the widget tree under it.
        // In this case, since you already have a reference to the view model, you can use that.
        create: (context) => viewModel,
        // 3 Consumer rebuilds the widget tree below it when there are changes, caused by the view model calling notifyListeners(),
        // The Consumer's builder closure exposes model to its descendants. This is the view model that it got from ChangeNotifierProvider.
        child: Consumer<ChooseFavoritesViewModel>(
          builder: (context, model, child) => ListView.builder(
            itemCount: model.choices.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: SizedBox(
                    width: 60,
                    child: Text(
                      model.choices[index].flag,
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                  // 4 - Using the data in model, you can build the UI. Notice that the UI has very little logic.
                  // The view model preformats everything.
                  title: Text(model.choices[index].alphabeticCode),
                  subtitle: Text(model.choices[index].longName),
                  trailing: (model.choices[index].isFavorite)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border,
                        ),
                        // 5 - Since you have a reference to the view model, you can call methods on it directly.
                        // toggleFavoriteStatus() calls notifyListeners(), of which Consume is one,
                        // so Consumer will trigger another rebuild, thus updating the UI
                  onTap: () => model.toggleFavoriteStatus(index),
                ),
              );
            },
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Currencies'),
      ),
      body: buildListView(model),
    );
  }
}
