import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../bloc/lessons_bloc.dart';
import '../bloc/lessons_intent.dart';
import '../bloc/availability/availability_bloc.dart';
import '../bloc/availability/availability_state.dart';
import '../bloc/availability/AvailabilityIntent.dart';
import '../util/AvailabilityConstants.dart';
import '../pages/lessons_pages.dart';
import '../../domain/entity/user_entity.dart';
import '../util/input_validators.dart';

class OnboardingPage extends StatefulWidget {
  final UserEntity user;

  const OnboardingPage({super.key, required this.user});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _currentSelectedDay = 'Lunes';
  String? _selectedTimeSlot;

  String _selectedLevel = 'Básico';
  String _selectedClassType = 'Grupal';
  double _basePriceFromTeacher = 20.0;

  List<String> _availableTimeSlots = [];

  @override
  void initState() {
    super.initState();
    _currentSelectedDay = InputValidators.getCurrentDayName(null);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _processAvailability(AvailabilityState state) {
    if (state is AvailabilityLoaded) {
      final daySlots = state.schedule[_currentSelectedDay] ?? state.schedule[_currentSelectedDay.toLowerCase()] ?? [];

      List<String> extractedSlots = [];
      double defaultSlotPrice = 20.0;

      for (var slot in daySlots) {
        final timeVal = slot['time']?.toString() ?? '';
        final priceVal = (slot['price'] as num?)?.toDouble() ?? 20.0;

        if (priceVal > 0) defaultSlotPrice = priceVal;

        if (timeVal.contains('-')) {
          final parts = timeVal.split('-').map((e) => e.trim()).toList();
          if (parts.length == 2) {
            final start = parts[0];
            final end = parts[1];
            final startIndex = AvailabilityConstants.hoursRange.indexOf(start);
            final endIndex = AvailabilityConstants.hoursRange.indexOf(end);

            if (startIndex != -1 && endIndex != -1 && startIndex <= endIndex) {
              for (int i = startIndex; i <= endIndex; i++) {
                final hour = AvailabilityConstants.hoursRange[i];
                if (!extractedSlots.contains(hour)) extractedSlots.add(hour);
              }
            }
          }
        } else if (timeVal.isNotEmpty) {
          if (!extractedSlots.contains(timeVal)) extractedSlots.add(timeVal);
        }
      }

      setState(() {
        _availableTimeSlots = extractedSlots.isNotEmpty ? extractedSlots : List.from(AvailabilityConstants.hoursRange);

        if (_availableTimeSlots.isNotEmpty && (_selectedTimeSlot == null || !_availableTimeSlots.contains(_selectedTimeSlot))) {
          _selectedTimeSlot = _availableTimeSlots.first;
        }
        _basePriceFromTeacher = defaultSlotPrice;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<LessonsBloc>()),
        BlocProvider(create: (context) => getIt<AvailabilityBloc>()..add(LoadAvailabilityIntent())),
      ],
      child: BlocConsumer<AvailabilityBloc, AvailabilityState>(
        listener: (context, state) {
          _processAvailability(state);
        },
        builder: (context, availabilityState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Configura tu Perfil y Turno'),
              automaticallyImplyLeading: false,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          '¡Bienvenido! Completa tus datos, nivel y tipo de clase',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: 'Nombre', border: OutlineInputBorder()),
                          validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _surnameController,
                          decoration: const InputDecoration(labelText: 'Apellido', border: OutlineInputBorder()),
                          validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(labelText: 'Teléfono', border: OutlineInputBorder()),
                          validator: (v) => v == null || v.isEmpty ? 'Campo requerido' : null,
                        ),
                        const SizedBox(height: 16),

                        // Dropdown Nivel
                        DropdownButtonFormField<String>(
                          value: _selectedLevel,
                          decoration: const InputDecoration(
                            labelText: 'Nivel (Básico, Intermedio, Pro)',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'Básico', child: Text('Básico')),
                            DropdownMenuItem(value: 'Intermedio', child: Text('Intermedio')),
                            DropdownMenuItem(value: 'Pro', child: Text('Pro')),
                          ],
                          onChanged: (value) {
                            if (value != null) setState(() => _selectedLevel = value);
                          },
                        ),
                        const SizedBox(height: 16),

                        DropdownButtonFormField<String>(
                          value: _selectedClassType,
                          decoration: const InputDecoration(
                            labelText: 'Tipo de Clase',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'Grupal', child: Text('Grupal (Máximo 4 cupos)')),
                            DropdownMenuItem(value: 'Individual', child: Text('Individual')),
                            DropdownMenuItem(value: 'Individual Exclusivo', child: Text('Individual Exclusivo')),
                          ],
                          onChanged: (value) {
                            if (value != null) setState(() => _selectedClassType = value);
                          },
                        ),
                        const SizedBox(height: 16),

                        // Dropdown Horarios
                        DropdownButtonFormField<String>(
                          value: _selectedTimeSlot,
                          decoration: const InputDecoration(
                            labelText: 'Horario Disponible (según profesor)',
                            border: OutlineInputBorder(),
                          ),
                          items: _availableTimeSlots.map((slot) {
                            return DropdownMenuItem(value: slot, child: Text(slot));
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) setState(() => _selectedTimeSlot = value);
                          },
                        ),
                        const SizedBox(height: 16),

                        Text(
                          'Importe configurado: \$ ${_basePriceFromTeacher.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey, fontSize: 15),
                        ),
                        const SizedBox(height: 30),

                        Builder(
                          builder: (innerContext) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  final fullName = '${_nameController.text} ${_surnameController.text}'.trim();
                                  final titleDetails = '$fullName ($_selectedLevel - $_selectedClassType)';

                                  int maxSpots;
                                  int available;

                                  if (_selectedClassType == 'Grupal') {
                                    maxSpots = 4;
                                    available = 3;
                                  } else if (_selectedClassType == 'Individual') {
                                    maxSpots = 4;
                                    available = 3;
                                  } else { // 'Individual exclusivo'
                                    maxSpots = 1;
                                    available = 0;
                                  }

                                  innerContext.read<LessonsBloc>().add(AddLessonIntent(
                                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                                    userId: widget.user.id,
                                    title: titleDetails,
                                    date: _currentSelectedDay,
                                    timeSlot: _selectedTimeSlot ?? '09:00 AM',
                                    totalSpots: maxSpots,
                                    availableSpots: available,
                                    isBooked: true,
                                    studentName: titleDetails,
                                    studentPhone: _phoneController.text,
                                    studentEmail: widget.user.email,
                                    price: _basePriceFromTeacher,
                                    level: _selectedLevel,
                                    classType: _selectedClassType,
                                  ));

                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider.value(
                                        value: innerContext.read<LessonsBloc>(),
                                        child: LessonsPage(currentUser: widget.user),
                                      ),
                                    ),
                                        (route) => false,
                                  );
                                }
                              },
                              child: const Text('Continuar a la Agenda', style: TextStyle(fontSize: 16)),
                            );
                          },
                        ),
                      ],
                    ),
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