import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/shops_model.dart';
import '../../../providers/shops_providers.dart';


class EditShopDialog extends StatefulWidget {
  final Shop? shop;
  final Function(String, String) onEdit;

  EditShopDialog({this.shop, required this.onEdit});

  @override
  _EditShopDialogState createState() => _EditShopDialogState();
}

class _EditShopDialogState extends State<EditShopDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _itemsController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.shop?.name ?? '');
    _itemsController = TextEditingController(text: widget.shop?.items ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.shop == null ? 'Add Shop' : 'Edit Shop'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Shop Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a shop name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _itemsController,
              decoration: InputDecoration(labelText: 'Items'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter items';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onEdit(
                _nameController.text,
                _itemsController.text,
              );
              Navigator.of(context).pop();
            }
          },
          child: Text(widget.shop == null ? 'Add' : 'Save'),
        ),
      ],
    );
  }
}
