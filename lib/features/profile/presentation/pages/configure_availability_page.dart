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

  // Valores seleccionados para inicio, fin, día y precio
  String _startTime = AvailabilityConstants.hoursRange.first;
  String _endTime = AvailabilityConstants.hoursRange[1]; // Por defecto la siguiente hora
  String _selectedDay = AvailabilityConstants.daysOfWeek.first;
  final TextEditingController _priceController = TextEditingController(text: '15000');

  // Método auxiliar para convertir "08:00 AM" a un índice o valor comparable si deseas validar rangos,
  // o simplemente validamos por posición en la lista de constantes.
  void _addTimeRangeSlot() {
    final priceError = InputValidators.validatePrice(_priceController.text);

    if (priceError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(priceError)),
      );
      return;
    }

    // Validar que la hora de inicio sea anterior a la de fin usando los índices de la lista
    final startIndex = AvailabilityConstants.hoursRange.indexOf(_startTime);
    final endIndex = AvailabilityConstants.hoursRange.indexOf(_endTime);

    if (startIndex >= endIndex) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La hora de finalización debe ser posterior a la de inicio')),
      );
      return;
    }

    final double price = double.parse(_priceController.text.replaceAll(',', '.'));
    final rangeText = '$_startTime - $_endTime';

    setState(() {
      final exists = _workingSchedule[_selectedDay]!.any((slot) => slot['time'] == rangeText);
      if (!exists) {
        _workingSchedule[_selectedDay]!.add({
          'time': rangeText,
          'price': price,
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
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AvailabilityBloc>()..add(LoadAvailabilityIntent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Configurar Días y Horarios'),
          backgroundColor: Colors.green.shade700,
          foregroundColor: Colors.white,
        ),
        body: BlocConsumer<AvailabilityBloc, AvailabilityState>(
          listener: (context, state) {
            if (state is AvailabilityLoaded) {
              setState(() {
                _workingSchedule.clear();
                _workingSchedule.addAll(state.schedule);
              });
            } else if (state is AvailabilitySavedSuccess) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Horarios y precios guardados correctamente')),
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
                const Text(
                  'Selecciona el horario de inicio, fin, el día y asigna el precio:',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),

                // Panel de selección superior con Inicio, Fin y Día
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Hora de Inicio
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
                            // Hora de Fin
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
                        Row(
                          children: [
                            // Selector de Día
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _selectedDay,
                                decoration: const InputDecoration(
                                  labelText: 'Día',
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
                            ),
                            const SizedBox(width: 8),
                            // Input de Precio
                            Expanded(
                              child: TextField(
                                controller: _priceController,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [InputValidators.onlyPriceFormat],
                                decoration: const InputDecoration(
                                  labelText: 'Precio',
                                  prefixText: '\$ ',
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                              ),
                            ),
                          ],
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

                // Listado de días configurados con los rangos en formato Chip
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
                              .toString() == 'true' && slots.isEmpty // formato seguro
                              ? const Text('Sin horarios habilitados', style: TextStyle(color: Colors.grey, fontSize: 13))
                              : Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: slots.map((slotData) {
                              // Aquí slotData['time'] contendrá algo como "08:00 AM - 09:00 PM"
                              final String timeRange = slotData['time'];
                              final double price = slotData['price'] ?? 0.0;

                              return Chip(
                                label: Text('$timeRange (\$$price)'),
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