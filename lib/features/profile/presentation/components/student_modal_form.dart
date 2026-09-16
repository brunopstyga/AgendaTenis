import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import '../../../../core/di/injection.dart';
import '../bloc/availability/AvailabilityIntent.dart';
import '../bloc/availability/availability_bloc.dart';
import '../bloc/availability/availability_state.dart';
import '../bloc/lessons_bloc.dart';
import '../bloc/lessons_intent.dart';
import '../util/AvailabilityConstants.dart';
import '../util/input_validators.dart';

class StudentModalForm extends StatefulWidget {
  final String selectedDay;
  final dynamic slotToEdit;
  final int? currentUserId;
  final String? currentUserEmail;
  final LessonsBloc lessonsBloc;

  const StudentModalForm({
    super.key,
    required this.selectedDay,
    this.slotToEdit,
    this.currentUserId,
    this.currentUserEmail,
    required this.lessonsBloc,
  });

  @override
  State<StudentModalForm> createState() => _StudentModalFormState();
}

class _StudentModalFormState extends State<StudentModalForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _surnameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _priceController;
  late DateTime _selectedDate;
  late String _currentSelectedDay;

  String? _selectedTimeSlot;
  List<Map<String, dynamic>> _daySlotsData = [];
  List<String> _validTimeSlots = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _phoneController = TextEditingController(text: widget.slotToEdit?.studentPhone ?? '');

    final initialPrice = widget.slotToEdit?.price ?? 0.0;
    _priceController = TextEditingController(text: initialPrice > 0 ? initialPrice.toStringAsFixed(0) : '');

    _selectedDate = DateTime.now();
    _currentSelectedDay = widget.selectedDay;

    if (widget.slotToEdit != null && widget.slotToEdit.studentName != null) {
      final nameParts = widget.slotToEdit.studentName!.split(' ');
      if (nameParts.isNotEmpty) _nameController.text = nameParts.first;
      if (nameParts.length > 1) _surnameController.text = nameParts.sublist(1).join(' ');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // Convierte un DateTime al nombre del día en español para que coincida con las keys del mapa
  String _getDayName(DateTime date) {
    const days = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    return days[date.weekday - 1];
  }

  void _updatePriceForSelectedSlot(String timeSlot) {
    if (widget.slotToEdit == null) {
      for (var slot in _daySlotsData) {
        final timeVal = slot['time']?.toString() ?? '';
        final price = (slot['price'] as num?)?.toDouble() ?? 0.0;

        if (timeVal.contains('-') || timeVal == timeSlot) {
          if (price > 0) {
            _priceController.text = price.toStringAsFixed(0);
          }
          if (timeVal == timeSlot) break;
        }
      }
    }
  }

  // Lógica central para procesar y desglosar los horarios del día actual
  void _processSlotsForDay(String dayName, AvailabilityState state) {
    if (state is AvailabilityLoaded) {
      _daySlotsData = state.schedule[dayName] ?? state.schedule[dayName.toLowerCase()] ?? [];

      List<String> extractedSlots = [];

      for (var slot in _daySlotsData) {
        final timeVal = slot['time']?.toString() ?? '';

        if (timeVal.contains('-')) {
          final parts = timeVal.split('-').map((e) => e.trim()).toList();
          if (parts.length == 2) {
            final startHour = parts[0];
            final endHour = parts[1];

            final startIndex = AvailabilityConstants.hoursRange.indexOf(startHour);
            final endIndex = AvailabilityConstants.hoursRange.indexOf(endHour);

            if (startIndex != -1 && endIndex != -1 && startIndex <= endIndex) {
              for (int i = startIndex; i <= endIndex; i++) {
                final hourSlot = AvailabilityConstants.hoursRange[i];
                if (!extractedSlots.contains(hourSlot)) {
                  extractedSlots.add(hourSlot);
                }
              }
            }
          }
        } else if (timeVal.isNotEmpty) {
          if (!extractedSlots.contains(timeVal)) {
            extractedSlots.add(timeVal);
          }
        }
      }

      _validTimeSlots = extractedSlots;

      // Si no hay horarios configurados para este día, usamos la lista general por defecto
      if (_validTimeSlots.isEmpty) {
        _validTimeSlots = List.from(AvailabilityConstants.hoursRange);
      }

      // Si estamos editando y el slot actual no está en la lista, lo agregamos para no romper la UI
      if (widget.slotToEdit != null && !_validTimeSlots.contains(widget.slotToEdit.timeSlot)) {
        _validTimeSlots.add(widget.slotToEdit.timeSlot);
      }

      // Asignamos una selección inicial válida si aún no hay una
      if (_validTimeSlots.isNotEmpty && (_selectedTimeSlot == null || !_validTimeSlots.contains(_selectedTimeSlot))) {
        _selectedTimeSlot = widget.slotToEdit?.timeSlot ?? _validTimeSlots.first;
        _updatePriceForSelectedSlot(_selectedTimeSlot!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return BlocProvider(
      create: (context) => getIt<AvailabilityBloc>()..add(LoadAvailabilityIntent()),
      child: BlocConsumer<AvailabilityBloc, AvailabilityState>(
        listener: (context, state) {
          if (state is AvailabilityLoaded) {
            setState(() {
              _processSlotsForDay(_currentSelectedDay, state);
            });
          }
        },
        builder: (context, state) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.only(
              bottom: keyboardHeight + 24,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        widget.slotToEdit == null ? 'Inscribir Alumno a Clase' : 'Editar Turno / Alumno',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        inputFormatters: [InputValidators.onlyLetters],
                        decoration: const InputDecoration(labelText: 'Nombre', border: OutlineInputBorder()),
                        validator: (value) => InputValidators.validateRequired(value, 'Nombre'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _surnameController,
                        inputFormatters: [InputValidators.onlyLetters],
                        decoration: const InputDecoration(labelText: 'Apellido', border: OutlineInputBorder()),
                        validator: (value) => InputValidators.validateRequired(value, 'Apellido'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [InputValidators.onlyNumbers],
                        decoration: const InputDecoration(labelText: 'Teléfono', border: OutlineInputBorder()),
                        validator: InputValidators.validatePhone,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MediaQuery.of(context).size.width > 0
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.start,
                        children: [
                          Text(
                            'Fecha: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 365)),
                              );
                              if (picked != null && picked != _selectedDate) {
                                setState(() {
                                  _selectedDate = picked;
                                  // Actualizamos el nombre del día basado en la nueva fecha seleccionada
                                  _currentSelectedDay = _getDayName(picked);

                                  // Volvemos a procesar los slots si el Bloc ya tiene la data cargada
                                  if (state is AvailabilityLoaded) {
                                    _processSlotsForDay(_currentSelectedDay, state);
                                  }
                                });
                              }
                            },
                            icon: const Icon(Icons.calendar_today, size: 18),
                            label: const Text('Cambiar'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Día seleccionado: $_currentSelectedDay',
                        style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: (_selectedTimeSlot != null && _validTimeSlots.contains(_selectedTimeSlot))
                            ? _selectedTimeSlot
                            : (_validTimeSlots.isNotEmpty ? _validTimeSlots.first : null),
                        decoration: const InputDecoration(
                          labelText: 'Horario disponible',
                          border: OutlineInputBorder(),
                        ),
                        items: _validTimeSlots.map((slot) {
                          return DropdownMenuItem(value: slot, child: Text(slot));
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedTimeSlot = value;
                              _updatePriceForSelectedSlot(value);
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(
                          labelText: 'Importe / Precio (\$)',
                          border: OutlineInputBorder(),
                          prefixText: '\$ ',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Por favor ingresa un importe';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final fullName = '${_nameController.text} ${_surnameController.text}'.trim();
                                final displayTitle = fullName.isEmpty ? 'Clase - $_currentSelectedDay' : fullName;
                                final parsedPrice = double.tryParse(_priceController.text) ?? 0.0;
                                final bloc = getIt<LessonsBloc>();

                                if (widget.slotToEdit == null) {
                                  widget.lessonsBloc.add(AddLessonIntent(
                                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                                    userId: widget.currentUserId,
                                    title: displayTitle,
                                    date: _currentSelectedDay,
                                    timeSlot: _selectedTimeSlot ?? '08:00 AM',
                                    totalSpots: 4,
                                    availableSpots: 3,
                                    isBooked: true,
                                    studentName: fullName,
                                    studentPhone: _phoneController.text,
                                    studentEmail: widget.currentUserEmail,
                                    price: parsedPrice,
                                  ));
                                } else {
                                  widget.lessonsBloc.add(UpdateLessonIntent(
                                    id: widget.slotToEdit.id,
                                    title: displayTitle,
                                    date: _currentSelectedDay,
                                    timeSlot: _selectedTimeSlot ?? widget.slotToEdit.timeSlot,
                                    totalSpots: widget.slotToEdit.totalSpots,
                                    availableSpots: widget.slotToEdit.availableSpots,
                                    isBooked: true,
                                    studentName: fullName,
                                    studentPhone: _phoneController.text,
                                    studentEmail: widget.slotToEdit.studentEmail,
                                    price: parsedPrice,
                                  ));
                                }
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              widget.slotToEdit == null ? 'Guardar Reserva' : 'Actualizar Cambios',
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}