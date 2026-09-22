import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../bloc/availability/AvailabilityIntent.dart';
import '../bloc/availability/availability_bloc.dart';
import '../bloc/availability/availability_state.dart';
import '../components/app_snack_bar.dart';
import '../util/AvailabilityConstants.dart';
import '../util/input_validators.dart';

import 'dart:developer' as developer;

class ConfigureAvailabilityPage extends StatefulWidget {
  const ConfigureAvailabilityPage({super.key});

  @override
  State<ConfigureAvailabilityPage> createState() =>
      _ConfigureAvailabilityPageState();
}

class _ConfigureAvailabilityPageState
    extends State<ConfigureAvailabilityPage> {
  final Map<String, Map<String, dynamic>> _workingSchedule = {
    'Lunes': {
      'startTime': '08:00',
      'endTime': '21:00',
      'prices': <String, double>{},
    },
    'Martes': {
      'startTime': '08:00',
      'endTime': '21:00',
      'prices': <String, double>{},
    },
    'Miércoles': {
      'startTime': '08:00',
      'endTime': '21:00',
      'prices': <String, double>{},
    },
    'Jueves': {
      'startTime': '08:00',
      'endTime': '21:00',
      'prices': <String, double>{},
    },
    'Viernes': {
      'startTime': '08:00',
      'endTime': '21:00',
      'prices': <String, double>{},
    },
    'Sábado': {
      'startTime': '08:00',
      'endTime': '21:00',
      'prices': <String, double>{},
    },
    'Domingo': {
      'startTime': '08:00',
      'endTime': '21:00',
      'prices': <String, double>{},
    },
  };

  String _selectedDay = AvailabilityConstants.daysOfWeek.first;

  String _startTime = AvailabilityConstants.hoursRange.first;

  String _endTime = AvailabilityConstants.hoursRange[1];

  String _selectedClassType = 'Individual';

  final TextEditingController _classPriceController =
  TextEditingController();

  bool _hasLoadedInitialData = false;

  final List<String> _classTypes = const [
    'Individual',
    'Grupal',
    'Individual Exclusivo',
  ];

  @override
  void dispose() {
    _classPriceController.dispose();
    super.dispose();
  }

  void _loadSelectedDayData() {
    final dayData = _workingSchedule[_selectedDay];

    if (dayData == null) return;

    final startTime = dayData['startTime'];
    final endTime = dayData['endTime'];
    final prices = dayData['prices'] as Map<String, dynamic>? ?? {};

    setState(() {
      // Validamos que el startTime exista en el rango, si no, usamos el primero por defecto
      if (startTime is String && AvailabilityConstants.hoursRange.contains(startTime)) {
        _startTime = startTime;
      } else {
        _startTime = AvailabilityConstants.hoursRange.first;
      }

      // Validamos que el endTime exista en el rango, si no, usamos el segundo por defecto
      if (endTime is String && AvailabilityConstants.hoursRange.contains(endTime)) {
        _endTime = endTime;
      } else {
        _endTime = AvailabilityConstants.hoursRange.length > 1
            ? AvailabilityConstants.hoursRange[1]
            : AvailabilityConstants.hoursRange.first;
      }

      final price = prices[_selectedClassType];

      if (price != null) {
        _classPriceController.text = price.toString();
      } else {
        _classPriceController.clear();
      }
    });
  }

  void _saveDayConfiguration() {
    final startIndex =
    AvailabilityConstants.hoursRange.indexOf(_startTime);

    final endIndex =
    AvailabilityConstants.hoursRange.indexOf(_endTime);

    if (startIndex == -1 || endIndex == -1) {
      AppSnackBar.show(
      context,
      'Horario inválido',
      isError: true,
    );
    return;
    }

    if (startIndex >= endIndex) {
        AppSnackBar.show(
          context,
            'La hora de finalización debe ser posterior a la de inicio',
          isError: true,
      );
      return;
    }

    setState(() {
      _workingSchedule[_selectedDay]?['startTime'] = _startTime;

      _workingSchedule[_selectedDay]?['endTime'] = _endTime;
    });
    AppSnackBar.show(
        context,
      'Horario de atención actualizado para $_selectedDay',
    isError: true,);
    return;
  }

  void _saveClassTypePrice() {
    final priceText = _classPriceController.text.trim();

    final priceError =
    InputValidators.validatePrice(priceText);

    if (priceError != null) {
      AppSnackBar.show(context, priceError, isError: true);
      return;
    }

    final cleanText = priceText.replaceAll(',', '.');

    final double price = double.parse(cleanText);

    final prices =
        _workingSchedule[_selectedDay]?['prices']
        as Map<String, dynamic>? ??
            {};

    setState(() {
      prices[_selectedClassType] = price;

      _workingSchedule[_selectedDay]?['prices'] = prices;
    });

    developer.log(
      'Precio $_selectedClassType para $_selectedDay: $price',
    );
   AppSnackBar.show(context, 'Precio de "$_selectedClassType" para $_selectedDay actualizado a \$$price',
   isError: true);
   return;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      getIt<AvailabilityBloc>()
        ..add(LoadAvailabilityIntent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Configurar Horarios y Precios',
          ),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        body: BlocConsumer<AvailabilityBloc, AvailabilityState>(
          listener: (context, state) {
            if (state is AvailabilityLoaded &&
                !_hasLoadedInitialData) {
              setState(() {
                _hasLoadedInitialData = true;

                state.schedule.forEach((key, value) {
                  final matchingDay =
                  _workingSchedule.keys.firstWhere(
                        (day) =>
                    day.toLowerCase() ==
                        key.toLowerCase(),
                    orElse: () => key,
                  );

                  if (_workingSchedule.containsKey(matchingDay)) {
                    _workingSchedule[matchingDay] =
                    Map<String, dynamic>.from(value);
                  }
                });
              });
              _loadSelectedDayData();
            }
            if (state is AvailabilitySavedSuccess) {
              Navigator.pop(context);
              AppSnackBar.show(context, 'Configuración guardada correctamente',
              isError: true);
              return;
            }
            if (state is AvailabilityError) {
              AppSnackBar.show(context, 'Error: ${state.message}',
                isError: true,
              );
              return;
            }
          },
          builder: (context, state) {
            final bool isSaving =
            state is AvailabilitySaving;

            if ((state is AvailabilityLoading ||
                state is AvailabilityInitial) &&
                !_hasLoadedInitialData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final currentDayData =
                _workingSchedule[_selectedDay] ?? {};

            final currentPrices =
                currentDayData['prices']
                as Map<String, dynamic>? ??
                    {};

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Día',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(height: 8),

                DropdownButtonFormField<String>(
                  value: _selectedDay,
                  decoration: const InputDecoration(
                    labelText: 'Seleccionar día',
                    border: OutlineInputBorder(),
                  ),
                  items: AvailabilityConstants.daysOfWeek
                      .map(
                        (day) => DropdownMenuItem(
                      value: day,
                      child: Text(day),
                    ),
                  )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      _selectedDay = value;
                    });

                    _loadSelectedDayData();
                  },
                ),

                const SizedBox(height: 24),

                const Text(
                  'Horarios',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(height: 8),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child:
                              DropdownButtonFormField<String>(
                                value: _startTime,
                                decoration:
                                const InputDecoration(
                                  labelText: 'Desde',
                                  border:
                                  OutlineInputBorder(),
                                  isDense: true,
                                ),
                                items:
                                AvailabilityConstants
                                    .hoursRange
                                    .map(
                                      (time) =>
                                      DropdownMenuItem(
                                        value: time,
                                        child: Text(time),
                                      ),
                                ).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _startTime = value;
                                    });
                                  }
                                },
                              ),
                            ),

                            const SizedBox(width: 8),

                            Expanded(
                              child:
                              DropdownButtonFormField<String>(
                                value: _endTime,
                                decoration:
                                const InputDecoration(
                                  labelText: 'Hasta',
                                  border:
                                  OutlineInputBorder(),
                                  isDense: true,
                                ),
                                items:
                                AvailabilityConstants
                                    .hoursRange
                                    .map(
                                      (time) =>
                                      DropdownMenuItem(
                                        value: time,
                                        child: Text(time),
                                      ),
                                ).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _endTime = value;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        ElevatedButton(
                          onPressed:
                          _saveDayConfiguration,
                          child: const Text(
                            'Actualizar Horario del Día',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Precios',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(height: 8),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          value: _selectedClassType,
                          decoration:
                          const InputDecoration(
                            labelText: 'Tipo de clase',
                            border:
                            OutlineInputBorder(),
                            isDense: true,
                          ),
                          items: _classTypes
                              .map(
                                (type) =>
                                DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ),
                          )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;

                            setState(() {
                              _selectedClassType =
                                  value;

                              final price =
                              currentPrices[value];

                              if (price != null) {
                                _classPriceController
                                    .text =
                                    price.toString();
                              } else {
                                _classPriceController
                                    .clear();
                              }
                            });
                          },
                        ),

                        const SizedBox(height: 12),

                        TextField(
                          controller:
                          _classPriceController,
                          keyboardType:
                          const TextInputType
                              .numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            InputValidators
                                .onlyPriceFormat,
                          ],
                          decoration:
                          const InputDecoration(
                            labelText: 'Precio',
                            prefixText: '\$ ',
                            border:
                            OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),

                        const SizedBox(height: 12),

                        ElevatedButton(
                          onPressed:
                          _saveClassTypePrice,
                          child: const Text(
                            'Guardar Precio',
                          ),
                        ),

                        const Divider(height: 24),

                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                          currentPrices.entries
                              .map(
                                (entry) => Chip(
                              label: Text(
                                '${entry.key}: \$${entry.value}',
                              ),
                            ),
                          ).toList(),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                ElevatedButton(
                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    Colors.green.shade800,
                    foregroundColor: Colors.white,
                    padding:
                    const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                  ),
                  onPressed: isSaving
                      ? null
                      : () {
                    context
                        .read<AvailabilityBloc>()
                        .add(
                      SaveAvailabilityIntent(
                        _workingSchedule,
                      ),
                    );
                  },
                  child: isSaving
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : const Text(
                    'Guardar Toda la Configuración',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}