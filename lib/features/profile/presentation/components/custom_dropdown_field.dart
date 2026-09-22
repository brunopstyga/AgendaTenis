import 'package:flutter/material.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final T? value;
  final String label;
  final List<T> items;
  final String Function(T item) itemLabelBuilder;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;

  const CustomDropdownField({
    super.key,
    required this.value,
    required this.label,
    required this.items,
    required this.itemLabelBuilder,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(itemLabelBuilder(item)),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator ?? (v) => v == null ? 'Por favor selecciona una opción' : null,
    );
  }
}