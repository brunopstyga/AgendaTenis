import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../bloc/availability/AvailabilityIntent.dart';
import '../bloc/availability/availability_bloc.dart';
import '../bloc/availability/availability_state.dart';
import '../bloc/lessons_bloc.dart';
import '../bloc/lessons_intent.dart';
import '../util/AvailabilityConstants.dart';
import '../util/input_validators.dart';

import 'dart:developer' as developer;

class StudentModalForm extends StatefulWidget {
  final String selectedDay;
  final dynamic slotToEdit;
  final String? currentUserId;
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
  State<StudentModalForm> createState() =>
      _StudentModalFormState();
}

class _StudentModalFormState
    extends State<StudentModalForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _surnameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _priceController;

  late DateTime _selectedDate;

  late String _currentSelectedDay;

  String? _timeSlotErrorText;

  String? _selectedTimeSlot;

  String _selectedLevel = 'Básico';

  String _selectedClassType = 'Grupal';

  final List<String> _levelOptions = [
    'Básico',
    'Intermedio',
    'Avanzado',
    'Competencia',
  ];

  final List<String> _classTypeOptions = [
    'Grupal',
    'Individual',
    'Individual Exclusivo',
  ];

  List<String> _validTimeSlots = [];

  Map<String, double> _currentDayClassPrices = {};

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();

    _surnameController = TextEditingController();

    _phoneController = TextEditingController(
      text: widget.slotToEdit?.studentPhone ?? '',
    );

    final initialPrice =
        widget.slotToEdit?.price ?? 0.0;

    _priceController = TextEditingController(
      text: initialPrice > 0
          ? initialPrice.toStringAsFixed(0)
          : '',
    );

    if (widget.slotToEdit != null) {
      if (widget.slotToEdit.level != null &&
          _levelOptions.contains(
            widget.slotToEdit.level,
          )) {
        _selectedLevel =
            widget.slotToEdit.level;
      }

      if (widget.slotToEdit.classType != null &&
          _classTypeOptions.contains(
            widget.slotToEdit.classType,
          )) {
        _selectedClassType =
            widget.slotToEdit.classType;
      }
    }

    _selectedDate = DateTime.now();

    _currentSelectedDay =
        widget.selectedDay;

    if (widget.slotToEdit != null &&
        widget.slotToEdit.studentName != null) {
      final nameParts =
      widget.slotToEdit.studentName!
          .split(' ');

      if (nameParts.isNotEmpty) {
        _nameController.text =
            nameParts.first;
      }

      if (nameParts.length > 1) {
        _surnameController.text =
            nameParts
                .sublist(1)
                .join(' ');
      }
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

  void _processScheduleForDay(
      String dayName,
      Map<String, Map<String, dynamic>>
      scheduleMap,
      ) {
    Map<String, dynamic> dayData = {};

    String normalize(String input) {
      return input
          .toLowerCase()
          .replaceAll('á', 'a')
          .replaceAll('é', 'e')
          .replaceAll('í', 'i')
          .replaceAll('ó', 'o')
          .replaceAll('ú', 'u');
    }

    final normalizedTarget =
    normalize(dayName);

    for (final entry
    in scheduleMap.entries) {
      if (normalize(entry.key) ==
          normalizedTarget) {
        dayData =
        Map<String, dynamic>.from(
          entry.value,
        );
        break;
      }
    }

    developer.log(
      'Configuración encontrada para $dayName: $dayData',
    );

    final String startHour =
        dayData['startTime'] ?? '08:00';

    final String endHour =
        dayData['endTime'] ?? '21:00';

    final rawPrices =
        dayData['prices']
        as Map<String, dynamic>? ??
            {};

    _currentDayClassPrices =
        rawPrices.map(
              (key, value) {
            return MapEntry(
              key,
              value is num
                  ? value.toDouble()
                  : 0.0,
            );
          },
        );

    developer.log(
      'Precios para $dayName: $_currentDayClassPrices',
    );

    final List<String> generatedSlots = [];

    final startIndex =
    AvailabilityConstants.hoursRange
        .indexOf(startHour);

    final endIndex =
    AvailabilityConstants.hoursRange
        .indexOf(endHour);

    if (startIndex != -1 &&
        endIndex != -1 &&
        startIndex < endIndex) {
      for (
      int i = startIndex;
      i < endIndex;
      i++
      ) {
        generatedSlots.add(
          '${AvailabilityConstants.hoursRange[i]} - '
              '${AvailabilityConstants.hoursRange[i + 1]}',
        );
      }
    }

    setState(() {
      _validTimeSlots =
          generatedSlots;

      if (widget.slotToEdit != null &&
          !_validTimeSlots.contains(
            widget.slotToEdit.timeSlot,
          )) {
        _validTimeSlots.add(
          widget.slotToEdit.timeSlot,
        );
      }

      if (_validTimeSlots.isNotEmpty) {
        if (_selectedTimeSlot == null ||
            !_validTimeSlots.contains(
              _selectedTimeSlot,
            )) {
          _selectedTimeSlot =
              widget.slotToEdit?.timeSlot ??
                  _validTimeSlots.first;
        }
      } else {
        _selectedTimeSlot = null;
      }

      _updatePriceForClassType(
        _selectedClassType,
      );
    });
  }

  void _updatePriceForClassType(
      String classType,
      ) {
    final double price =
        _currentDayClassPrices[classType] ??
            0.0;

    developer.log(
      'Precio para $classType: $price',
    );

    _priceController.text =
    price > 0
        ? price.toStringAsFixed(0)
        : '';
  }

  String? _validateTimeSlot(
      String? timeSlot,
      ) {
    if (timeSlot == null) {
      return 'Por favor selecciona un horario';
    }

    return null;
  }

  void _guardarAlumno({
    required bool seguirAgregando,
  }) {
    final timeError =
    _validateTimeSlot(
      _selectedTimeSlot,
    );

    setState(() {
      _timeSlotErrorText =
          timeError;
    });

    if (timeError != null) {
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final fullName =
    '${_nameController.text} '
        '${_surnameController.text}'
        .trim();

    final displayTitle =
    fullName.isEmpty
        ? 'Clase - $_currentSelectedDay'
        : fullName;

    final parsedPrice =
        double.tryParse(
          _priceController.text,
        ) ??
            0.0;

    final maxSpots =
    (_selectedClassType ==
        'Individual' ||
        _selectedClassType ==
            'Individual Exclusivo')
        ? 1
        : 4;

    final availableSpots =
    maxSpots > 1
        ? maxSpots - 1
        : 0;

    final user =
        widget.currentUserId;

    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Error: No hay un usuario activo.',
          ),
        ),
      );

      return;
    }

    if (widget.slotToEdit == null) {
      widget.lessonsBloc.add(
        AddLessonIntent(
          id: DateTime.now()
              .millisecondsSinceEpoch
              .toString() +
              _nameController
                  .text
                  .hashCode
                  .toString(),

          userId: user,

          title: displayTitle,

          date: _currentSelectedDay,

          timeSlot:
          _selectedTimeSlot ?? '',

          totalSpots: maxSpots,

          availableSpots:
          availableSpots,

          isBooked: true,

          studentName: fullName,

          studentPhone:
          _phoneController.text,

          studentEmail:
          widget.currentUserEmail,

          price: parsedPrice,

          level: _selectedLevel,

          classType:
          _selectedClassType,
        ),
      );
    } else {
      widget.lessonsBloc.add(
        UpdateLessonIntent(
          id: widget.slotToEdit.id,

          userId: user,

          title: displayTitle,

          date: _currentSelectedDay,

          timeSlot:
          _selectedTimeSlot ??
              widget.slotToEdit.timeSlot,

          totalSpots: maxSpots,

          availableSpots:
          widget.slotToEdit.availableSpots,

          isBooked: true,

          studentName: fullName,

          studentPhone:
          _phoneController.text,

          studentEmail:
          widget.slotToEdit.studentEmail,

          price: parsedPrice,

          level: _selectedLevel,

          classType:
          _selectedClassType,
        ),
      );
    }

    if (seguirAgregando) {
      setState(() {
        _nameController.clear();
        _surnameController.clear();
        _phoneController.clear();
        _timeSlotErrorText = null;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            '¡Alumno guardado! Ya puedes ingresar al siguiente.',
          ),
          duration:
          Duration(seconds: 2),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight =
        MediaQuery.of(context)
            .viewInsets
            .bottom;

    return BlocProvider(
      create: (context) =>
      getIt<AvailabilityBloc>()
        ..add(
          LoadAvailabilityIntent(),
        ),
      child: BlocConsumer<
          AvailabilityBloc,
          AvailabilityState>(
        listener: (context, state) {
          if (state
          is AvailabilityLoaded) {
            _processScheduleForDay(
              _currentSelectedDay,
              state.schedule,
            );
          }
        },
        builder: (context, state) {
          return Container(
            decoration:
            const BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            padding: EdgeInsets.only(
              bottom:
              keyboardHeight + 24,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize:
                    MainAxisSize.min,
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .stretch,
                    children: [
                      Text(
                        widget.slotToEdit ==
                            null
                            ? 'Inscribir Alumno a Clase'
                            : 'Editar Turno / Alumno',
                        style:
                        const TextStyle(
                          fontSize: 18,
                          fontWeight:
                          FontWeight.bold,
                        ),
                        textAlign:
                        TextAlign.center,
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      TextFormField(
                        controller:
                        _nameController,
                        inputFormatters: [
                          InputValidators
                              .onlyLetters,
                        ],
                        decoration:
                        const InputDecoration(
                          labelText: 'Nombre',
                          border:
                          OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            InputValidators
                                .validateRequired(
                              value,
                              'Nombre',
                            ),
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      TextFormField(
                        controller:
                        _surnameController,
                        inputFormatters: [
                          InputValidators
                              .onlyLetters,
                        ],
                        decoration:
                        const InputDecoration(
                          labelText: 'Apellido',
                          border:
                          OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            InputValidators
                                .validateRequired(
                              value,
                              'Apellido',
                            ),
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      TextFormField(
                        controller:
                        _phoneController,
                        keyboardType:
                        TextInputType.phone,
                        inputFormatters: [
                          InputValidators
                              .onlyNumbers,
                        ],
                        decoration:
                        const InputDecoration(
                          labelText: 'Teléfono',
                          border:
                          OutlineInputBorder(),
                        ),
                        validator:
                        InputValidators
                            .validatePhone,
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      DropdownButtonFormField<
                          String>(
                        value:
                        _selectedLevel,
                        decoration:
                        const InputDecoration(
                          labelText:
                          'Nivel de Clase',
                          border:
                          OutlineInputBorder(),
                        ),
                        items: _levelOptions
                            .map(
                              (level) =>
                              DropdownMenuItem(
                                value: level,
                                child:
                                Text(level),
                              ),
                        )
                            .toList(),
                        onChanged:
                            (value) {
                          if (value !=
                              null) {
                            setState(() {
                              _selectedLevel =
                                  value;
                            });
                          }
                        },
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      DropdownButtonFormField<
                          String>(
                        value:
                        _selectedClassType,
                        decoration:
                        const InputDecoration(
                          labelText:
                          'Tipo de Clase',
                          border:
                          OutlineInputBorder(),
                        ),
                        items:
                        _classTypeOptions
                            .map(
                              (type) =>
                              DropdownMenuItem(
                                value: type,
                                child:
                                Text(type),
                              ),
                        )
                            .toList(),
                        onChanged:
                            (value) {
                          if (value ==
                              null) {
                            return;
                          }

                          setState(() {
                            _selectedClassType =
                                value;

                            _updatePriceForClassType(
                              value,
                            );
                          });
                        },
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                        children: [
                          Text(
                            'Fecha: '
                                '${_selectedDate.day}/'
                                '${_selectedDate.month}/'
                                '${_selectedDate.year}',
                            style:
                            const TextStyle(
                              fontWeight:
                              FontWeight
                                  .w500,
                              fontSize: 15,
                            ),
                          ),

                          TextButton.icon(
                            onPressed:
                                () async {
                              final picked =
                              await showDatePicker(
                                context:
                                context,
                                initialDate:
                                _selectedDate,
                                firstDate:
                                DateTime.now(),
                                lastDate:
                                DateTime.now()
                                    .add(
                                  const Duration(
                                    days: 365,
                                  ),
                                ),
                              );

                              if (picked !=
                                  null) {
                                setState(() {
                                  _selectedDate =
                                      picked;

                                  _currentSelectedDay =
                                      InputValidators
                                          .getCurrentDayName(
                                        picked,
                                      );
                                });

                                final currentState =
                                    context
                                        .read<
                                        AvailabilityBloc>()
                                        .state;

                                if (currentState
                                is AvailabilityLoaded) {
                                  _processScheduleForDay(
                                    _currentSelectedDay,
                                    currentState
                                        .schedule,
                                  );
                                }
                              }
                            },
                            icon:
                            const Icon(
                              Icons
                                  .calendar_today,
                              size: 18,
                            ),
                            label:
                            const Text(
                              'Cambiar',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 4,
                      ),

                      Text(
                        'Día seleccionado: '
                            '$_currentSelectedDay',
                        style:
                        const TextStyle(
                          fontWeight:
                          FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      DropdownButtonFormField<
                          String>(
                        value: (_selectedTimeSlot !=
                            null &&
                            _validTimeSlots
                                .contains(
                              _selectedTimeSlot,
                            ))
                            ? _selectedTimeSlot
                            : (_validTimeSlots
                            .isNotEmpty
                            ? _validTimeSlots
                            .first
                            : null),
                        decoration:
                        InputDecoration(
                          labelText:
                          'Horario disponible',
                          border:
                          const OutlineInputBorder(),
                          errorText:
                          _timeSlotErrorText,
                        ),
                        items: _validTimeSlots
                            .map(
                              (slot) =>
                              DropdownMenuItem(
                                value: slot,
                                child:
                                Text(slot),
                              ),
                        )
                            .toList(),
                        onChanged:
                            (value) {
                          if (value !=
                              null) {
                            setState(() {
                              _selectedTimeSlot =
                                  value;

                              _timeSlotErrorText =
                              null;
                            });
                          }
                        },
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      TextFormField(
                        controller:
                        _priceController,
                        readOnly: true,
                        decoration:
                        const InputDecoration(
                          labelText:
                          'Importe / Precio',
                          border:
                          OutlineInputBorder(),
                          prefixText: '\$ ',
                        ),
                        validator: (value) {
                          if (value ==
                              null ||
                              value
                                  .trim()
                                  .isEmpty) {
                            return 'No hay un precio configurado para este tipo de clase';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      ElevatedButton(
                        style:
                        ElevatedButton
                            .styleFrom(
                          backgroundColor:
                          Colors.green
                              .shade700,
                          foregroundColor:
                          Colors.white,
                          padding:
                          const EdgeInsets
                              .symmetric(
                            vertical: 14,
                          ),
                        ),
                        onPressed: () =>
                            _guardarAlumno(
                              seguirAgregando:
                              false,
                            ),
                        child:
                        const Text(
                          'Guardar Alumno',
                          style:
                          TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
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