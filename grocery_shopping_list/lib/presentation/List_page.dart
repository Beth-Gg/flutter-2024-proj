import 'package:flutter/material.dart';
import '/Infrastructure/models/shop.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/Application/bloc/list/list_bloc.dart';
import '/Application/bloc/list/list_state.dart';
import '/Application/bloc/list/list_event.dart';
import "/Infrastructure/repositories/cart_repository.dart";
import '/Application/Usecase/list_usecase.dart';

class GroceryListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroceryListBloc(
       
        listRepository: ListRepository(), // Add this line
      ),
      child: GroceryListWidget(),
    );
  }
}

class GroceryListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<GroceryListBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Grocery Lists'),
      ),
      body: BlocBuilder<GroceryListBloc, GroceryListState>(
        builder: (context, state) {
          if (state is GroceryListLoaded) {
            return ListView.builder(
              itemCount: state.lists.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.lists[index].content),
                );
              },
            );
          } else if (state is GroceryListError) {
            return Text(state.message);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddListDialog(context, bloc);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddListDialog(BuildContext context, GroceryListBloc bloc) {
    final _formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final itemController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add List'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: itemController,
                  decoration: InputDecoration(labelText: 'Item'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an item';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  bloc.add(AddAddListEvent(
                    date: DateTime.now().toString(),
                    content: '${titleController.text}: ${itemController.text}',
                  ));
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
