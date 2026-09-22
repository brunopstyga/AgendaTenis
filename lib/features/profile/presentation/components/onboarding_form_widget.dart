import 'package:flutter/material.dart';

import 'custom_dropdown_field.dart';


class OnboardingFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController surnameController;
  final TextEditingController phoneController;

  final String selectedLevel;
  final String selectedClassType;
  final String? selectedTimeSlot;
  final List<String> availableTimeSlots;
  final double basePriceFromTeacher;

  final ValueChanged<String?> onLevelChanged;
  final ValueChanged<String?> onClassTypeChanged;
  final ValueChanged<String?> onTimeSlotChanged;
  final VoidCallback onSubmit;

  const OnboardingFormWidget({
    Key? key,
    required this.formKey,
    required this.nameController,
    required this.surnameController,
    required this.phoneController,
    required this.selectedLevel,
    required this.selectedClassType,
    required this.selectedTimeSlot,
    required this.availableTimeSlots,
    required this.basePriceFromTeacher,
    required this.onLevelChanged,
    required this.onClassTypeChanged,
    required this.onTimeSlotChanged,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '¡Bienvenido! Completa tus datos, nivel y tipo de clase',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          _buildTextField(
            controller: nameController,
            label: 'Nombre',
          ),
          const SizedBox(height: 16),

          _buildTextField(
            controller: surnameController,
            label: 'Apellido',
          ),
          const SizedBox(height: 16),

          _buildTextField(
            controller: phoneController,
            label: 'Teléfono',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),

          CustomDropdownField<String>(
            value: selectedLevel,
            label: 'Nivel',
            items: const ['Básico', 'Intermedio', 'Avanzado', 'Competencia'],
            itemLabelBuilder: (level) => level,
            onChanged: onLevelChanged,
          ),
          const SizedBox(height: 16),


          CustomDropdownField<String>(
            value: selectedClassType,
            label: 'Tipo de Clase',
            items: const ['Grupal', 'Individual', 'Individual Exclusivo'],
            itemLabelBuilder: (type) {
              if (type == 'Grupal') return 'Grupal (Máximo 4 cupos)';
              return type;
            },
            onChanged: onClassTypeChanged,
          ),
          const SizedBox(height: 16),

          CustomDropdownField<String>(
            value: (selectedTimeSlot != null && availableTimeSlots.contains(selectedTimeSlot))
                ? selectedTimeSlot
                : (availableTimeSlots.isNotEmpty ? availableTimeSlots.first : null),
            label: 'Horario Disponible',
            items: availableTimeSlots,
            itemLabelBuilder: (slot) => slot,
            onChanged: onTimeSlotChanged,
          ),
          const SizedBox(height: 16),

          Text(
            'Importe configurado: \$ ${basePriceFromTeacher.toStringAsFixed(0)}',
            style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey, fontSize: 15),
          ),
          const SizedBox(height: 30),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: onSubmit,
            child: const Text('Continuar a la Agenda', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
    );
  }
}