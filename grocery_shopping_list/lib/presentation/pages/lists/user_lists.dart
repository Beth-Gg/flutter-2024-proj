import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_shopping_list/providers/authProvider.dart';
// import 'package:grocery_shopping_list/providers/lists_Provider.dart';
import 'package:grocery_shopping_list/providers/lists_provider.dart';
import 'package:grocery_shopping_list/repositories/lists_repository.dart';
import '../../../models/shops_model.dart';
import '../../../providers/shops_providers.dart';
import './list_dialogbox.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/login_provider.dart';

final bottomNavIndexProvider = StateProvider((ref) => 0);

class UserListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currnetIndex = ref.watch(bottomNavIndexProvider);
    final auth = ref.watch(authoProvider);

    // final shops = ref.watch(shopsProvider);
    final shopsNotifier = ref.watch(listsProvider.notifier);
    final asyncShops = ref.watch(fetchListsProvider);

    int _selectedIndex = 0;
    void _onItemTapped(int index) {
      _selectedIndex = index;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Shemeta Shopping'),
        backgroundColor: Color.fromARGB(255, 124, 118, 207),
        actions: [
          TextButton(
            onPressed: () {
              auth.logout();
              context.go('/login');
            },
            child: const Text(
              'Logout',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => EditListDialog(
                  onEdit: (date, content) {
                    shopsNotifier.addLists(date, content);
                  },
                ),
              );
            },
            child: Text(
              'Add a List',
              style: TextStyle(color: Colors.white),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Color.fromARGB(255, 110, 112, 240),
              ),
            ),
          ),
        ],
      ),
      body: asyncShops.when(
        data: (lists) {
          return ListView.builder(
            itemCount: lists.length,
            itemBuilder: (context, index) {
              final list = lists[index];
              return Card(
                margin: EdgeInsets.all(8),
                elevation: 4,
                child: ListTile(
                  title: Text(list.date),
                  subtitle: Text(list.content),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => EditListDialog(
                              shop: list,
                              onEdit: (date, content) {
                                shopsNotifier.editList(list.id, date, content);
                              },
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          shopsNotifier.deleteShop(list.id);
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: currnetIndex,
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.shop,
              color: currnetIndex == 0 ? Colors.purple : Colors.grey,
            ),
            label: 'Shop Page',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.list,
              color: currnetIndex == 1 ? Colors.purple : Colors.grey,
            ),
            label: 'List Page',
          ),
        ],
        onDestinationSelected: (value) {
          ref.read(bottomNavIndexProvider.notifier).state = value;
          switch (value) {
            case 0:
              GoRouter.of(context).go('/');
              break;
            case 1:
              GoRouter.of(context).go('/userShops');
              break;
          }
        },
      ),
    );
  }
}
