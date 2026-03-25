import 'package:flutter/material.dart';
import 'package:qhawtak/shared/models/coffee.dart';
import 'package:qhawtak/shared/widgets/qhawtak_button.dart';

class EditCoffeeScreen extends StatefulWidget {
  const EditCoffeeScreen({super.key, this.initial});

  final CoffeeItem? initial;

  @override
  State<EditCoffeeScreen> createState() => _EditCoffeeScreenState();
}

class _EditCoffeeScreenState extends State<EditCoffeeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late String _category;
  late bool _isAvailable;

  @override
  void initState() {
    super.initState();
    final CoffeeItem? item = widget.initial;
    _nameController = TextEditingController(text: item?.name ?? '');
    _descriptionController = TextEditingController(text: item?.description ?? '');
    _priceController =
        TextEditingController(text: item != null ? item.price.toStringAsFixed(2) : '');
    _category = item?.category ?? 'Hot';
    _isAvailable = item?.isAvailable ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final CoffeeItem result = CoffeeItem(
      id: widget.initial?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      category: _category,
      imageUrl: widget.initial?.imageUrl ?? '',
      isAvailable: _isAvailable,
    );
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final bool editing = widget.initial != null;
    return Scaffold(
      appBar: AppBar(title: Text(editing ? 'Edit Coffee' : 'Add Coffee')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Coffee Name'),
                validator: (String? value) =>
                    (value == null || value.trim().isEmpty) ? 'Name is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Price'),
                validator: (String? value) {
                  final double? price = double.tryParse(value ?? '');
                  if (price == null || price <= 0) return 'Enter valid price';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _category,
                items: const <DropdownMenuItem<String>>[
                  DropdownMenuItem(value: 'Hot', child: Text('Hot')),
                  DropdownMenuItem(value: 'Cold', child: Text('Cold')),
                  DropdownMenuItem(value: 'Special', child: Text('Special')),
                ],
                onChanged: (String? value) => setState(() => _category = value ?? 'Hot'),
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 12),
              SwitchListTile.adaptive(
                title: const Text('Available'),
                value: _isAvailable,
                onChanged: (bool value) => setState(() => _isAvailable = value),
              ),
              const SizedBox(height: 12),
              QhawtakButton(
                label: editing ? 'Save Changes' : 'Add Coffee',
                icon: Icons.save_outlined,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
