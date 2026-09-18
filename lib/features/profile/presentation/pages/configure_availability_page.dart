import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../bloc/availability/AvailabilityIntent.dart';
import '../bloc/availability/availability_bloc.dart';
import '../bloc/availability/availability_state.dart';
import '../util/AvailabilityConstants.dart';
import '../util/input_validators.dart';

class ConfigureAvailabilityPage extends StatefulWidget {
  const ConfigureAvailabilityPage({super.key});

  @override
  State<ConfigureAvailabilityPage> createState() => _ConfigureAvailabilityPageState();
}

class _ConfigureAvailabilityPageState extends State<ConfigureAvailabilityPage> {
  final Map<String, List<Map<String, dynamic>>> _workingSchedule = {
    'Lunes': [],
    'Martes': [],
    'Miércoles': [],
    'Jueves': [],
    'Viernes': [],
    'Sábado': [],
    'Domingo': [],
  };

  // Mapa para almacenar los precios por tipo de clase: Simple, Grupal, Simple Excluyente
  final Map<String, double> _classTypePrices = {
    'Individual': 15000.0,
    'Grupal': 12000.0,
    'Individual Exclusivo': 20000.0,
  };

  // Controladores y estados para los precios de clases
  String _selectedClassType = 'Individual';
  final TextEditingController _classPriceController = TextEditingController(text: '15000');

  // Valores seleccionados para hora desde, hasta y día
  String _startTime = AvailabilityConstants.hoursRange.first;
  String _endTime = AvailabilityConstants.hoursRange[1];
  String _selectedDay = AvailabilityConstants.daysOfWeek.first;

  @override
  void initState() {
    super.initState();
    // Actualizamos el input del precio cuando cambia el tipo de clase seleccionado por defecto
    _classPriceController.text = _classTypePrices[_selectedClassType]!.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _classPriceController.dispose();
    super.dispose();
  }

  void _saveClassTypePrice() {
    developer.log("--- INTENTANDO ACTUALIZAR PRECIO DE CLASE ---");
    developer.log("Tipo de clase seleccionado: '$_selectedClassType'");
    developer.log("Texto ingresado en el input: '${_classPriceController.text}'");

    final priceError = InputValidators.validatePrice(_classPriceController.text);
    if (priceError != null) {
      developer.log("Error de validación del precio: $priceError");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(priceError)));
      return;
    }

    final double price = double.parse(_classPriceController.text.replaceAll(',', '.'));

    setState(() {
      _classTypePrices[_selectedClassType] = price;
    });

    developer.log("Precio actualizado exitosamente en memoria: Map actual -> $_classTypePrices");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Precio para "$_selectedClassType" actualizado a \$$price')),
    );
  }

  void _addTimeRangeSlot() {
    // Validar que la hora de inicio sea anterior a la de fin
    final startIndex = AvailabilityConstants.hoursRange.indexOf(_startTime);
    final endIndex = AvailabilityConstants.hoursRange.indexOf(_endTime);

    if (startIndex >= endIndex) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La hora de finalización debe ser posterior a la de inicio')),
      );
      return;
    }

    // Tomamos como referencia el precio configurado para la clase "Simple" o general por defecto,
    // o puedes adaptarlo según lo que necesite tu slot. Usaremos el precio de la clase seleccionada actualmente.
    final double currentPrice = _classTypePrices[_selectedClassType] ?? 15000.0;
    final rangeText = '$_startTime - $_endTime';

    setState(() {
      final exists = _workingSchedule[_selectedDay]!.any((slot) => slot['time'] == rangeText);
      if (!exists) {
        _workingSchedule[_selectedDay]!.add({
          'time': rangeText,
          'price': currentPrice,
          'classType': _selectedClassType, // Guardamos el tipo de clase asociado si lo deseas
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Este rango horario ya existe para ese día')),
        );
      }
    });
  }

  void _removeTimeSlot(String day, String timeRange) {
    setState(() {
      _workingSchedule[day]!.removeWhere((slot) => slot['time'] == timeRange);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AvailabilityBloc>()..add(LoadAvailabilityIntent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Configurar Precios y Horarios'),
          backgroundColor: Colors.green.shade700,
          foregroundColor: Colors.white,
        ),
        body: BlocConsumer<AvailabilityBloc, AvailabilityState>(
          listener: (context, state) {
            if (state is AvailabilityLoaded) {
              // Solo cargamos de Firebase si nuestro mapa local está completamente vacío
              // (es decir, al abrir la pantalla por primera vez)
              bool isEmpty = _workingSchedule.values.every((list) => list.isEmpty);

              if (isEmpty) {
                setState(() {
                  _workingSchedule.clear();
                  developer.log("CARGANDO DATOS INICIALES DE FIREBASE: ${state.schedule}");
                  _workingSchedule.addAll(state.schedule);
                });
              }
            } else if (state is AvailabilitySavedSuccess) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Configuración guardada correctamente')),
              );
            } else if (state is AvailabilityError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
            }
          },
          builder: (context, state) {
            final bool isSaving = state is AvailabilitySaving;

            if (state is AvailabilityLoading || state is AvailabilityInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ==========================================
                // SECCIÓN 1: TIPOS DE CLASE Y SUS PRECIOS
                // ==========================================
                const Text(
                  '1. Configurar Precios por Tipo de Clase',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          value: _selectedClassType,
                          decoration: const InputDecoration(
                            labelText: 'Tipo de Clase',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          items: const ['Individual', 'Grupal', 'Individual Exclusivo'].map((type) {
                            return DropdownMenuItem(value: type, child: Text(type));
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedClassType = value;
                                _classPriceController.text = _classTypePrices[value]!.toStringAsFixed(0);
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _classPriceController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [InputValidators.onlyPriceFormat],
                          decoration: const InputDecoration(
                            labelText: 'Precio para este tipo de clase',
                            prefixText: '\$ ',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal.shade700,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: _saveClassTypePrice,
                            child: const Text('Actualizar Precio de Clase'),
                          ),
                        ),
                        const Divider(height: 24),
                        // Listado visual rápido de precios actuales
                        Wrap(
                          spacing: 8,
                          children: _classTypePrices.entries.map((entry) {
                            return Chip(
                              label: Text('${entry.key}: \$${entry.value}'),
                              backgroundColor: Colors.teal.shade50,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ==========================================
                // SECCIÓN 2: ASIGNACIÓN DE RANGOS HORARIOS
                // ==========================================
                const Text(
                  '2. Agregar Rangos Horarios por Día',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _startTime,
                                decoration: const InputDecoration(
                                  labelText: 'Desde',
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                                items: AvailabilityConstants.hoursRange.map((time) {
                                  return DropdownMenuItem(value: time, child: Text(time));
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) setState(() => _startTime = value);
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _endTime,
                                decoration: const InputDecoration(
                                  labelText: 'Hasta',
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                                items: AvailabilityConstants.hoursRange.map((time) {
                                  return DropdownMenuItem(value: time, child: Text(time));
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) setState(() => _endTime = value);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _selectedDay,
                          decoration: const InputDecoration(
                            labelText: 'Día de la Semana',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          items: AvailabilityConstants.daysOfWeek.map((day) {
                            return DropdownMenuItem(value: day, child: Text(day));
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) setState(() => _selectedDay = value);
                          },
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: _addTimeRangeSlot,
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Agregar Rango al Día'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Listado de días configurados
                ..._workingSchedule.entries.map((entry) {
                  final day = entry.key;
                  final slots = entry.value;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(day, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                          const SizedBox(height: 8),
                          slots.isEmpty
                              ? const Text('Sin horarios habilitados', style: TextStyle(color: Colors.grey, fontSize: 13))
                              : Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: slots.map((slotData) {
                              final String timeRange = slotData['time'];
                              final double price = slotData['price'] ?? 0.0;
                              final String type = slotData['classType'] ?? '';

                              return Chip(
                                label: Text('$timeRange ${type.isNotEmpty ? "($type)" : ""} - \$$price'),
                                deleteIcon: const Icon(Icons.close, size: 16),
                                onDeleted: () => _removeTimeSlot(day, timeRange),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 24),

                // Botón global de guardado
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade800,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: isSaving
                      ? null
                      : () {
                    context.read<AvailabilityBloc>().add(SaveAvailabilityIntent(_workingSchedule));
                  },
                  child: isSaving
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                      : const Text('Guardar Toda la Configuración', style: TextStyle(fontSize: 16)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}