import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_shopping_list/repositories/shop_repositoriy.dart';
import '../../../models/shops_model.dart';
import '../../../providers/shops_providers.dart';
import 'shops_dialog.dart';

class AdminShopPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shops = ref.watch(shopsProvider);
    final shopsNotifier = ref.watch(shopsProvider.notifier);
    final asyncShops = ref.watch(fetchShopsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Shemeta Shoppings'),
        backgroundColor: Color.fromARGB(255, 124, 118, 207),
      ),
      body: asyncShops.when(
        data: (shops) {
          return ListView.builder(
            itemCount: shops.length,
            itemBuilder: (context, index) {
              final shop = shops[index];
              return Card(
                margin: EdgeInsets.all(8),
                elevation: 4,
                child: ListTile(
                  title: Text(shop.name),
                  subtitle: Text(shop.items),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => EditShopDialog(
                              shop: shop,
                              onEdit: (name, items) {
                                shopsNotifier.editShop(shop.id, name, items);
                              },
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          shopsNotifier.deleteShop(shop.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Failed to load shops')),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Center(
          child: TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => EditShopDialog(
                  onEdit: (name, items) {
                    shopsNotifier.addShop(name, items);
                  },
                ),
              );
            },
            child: Text(
              'Add a shop',
              style: TextStyle(color: Colors.white),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Color.fromARGB(255, 110, 112, 240),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
