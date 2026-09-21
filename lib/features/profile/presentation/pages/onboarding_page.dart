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
  Map<String, double> _currentDayClassPrices = {};

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

  /// Procesa la disponibilidad adaptada al nuevo modelo de rangos y precios por día:
  /// { 'Lunes': { 'startTime': '08:00', 'endTime': '21:00', 'prices': { ... } } }
  void _processAvailability(AvailabilityState state) {
    if (state is AvailabilityLoaded) {
      final dayData = state.schedule[_currentSelectedDay] ??
          state.schedule[_currentSelectedDay.toLowerCase()] ?? {};

      final String startHour = dayData['startTime'] ?? '08:00';
      final String endHour = dayData['endTime'] ?? '21:00';

      final Map<String, dynamic> rawPrices = dayData['prices'] ?? {};
      _currentDayClassPrices = rawPrices.map((key, value) => MapEntry(key, (value as num).toDouble()));

      // Generación dinámica de los slots de tiempo entre startTime y endTime
      List<String> extractedSlots = [];
      final startIndex = AvailabilityConstants.hoursRange.indexOf(startHour);
      final endIndex = AvailabilityConstants.hoursRange.indexOf(endHour);

      if (startIndex != -1 && endIndex != -1 && startIndex < endIndex) {
        for (int i = startIndex; i < endIndex; i++) {
          final slotRange = '${AvailabilityConstants.hoursRange[i]} - ${AvailabilityConstants.hoursRange[i + 1]}';
          extractedSlots.add(slotRange);
        }
      }

      setState(() {
        _availableTimeSlots = extractedSlots.isNotEmpty ? extractedSlots : List.from(AvailabilityConstants.hoursRange);

        if (_availableTimeSlots.isNotEmpty && (_selectedTimeSlot == null || !_availableTimeSlots.contains(_selectedTimeSlot))) {
          _selectedTimeSlot = _availableTimeSlots.first;
        }

        // Actualizamos el precio inicial según el tipo de clase actual
        _updatePriceForClassType(_selectedClassType);
      });
    }
  }

  void _updatePriceForClassType(String classType) {
    final double price = _currentDayClassPrices[classType] ?? 20.0;
    setState(() {
      _basePriceFromTeacher = price;
    });
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
                            labelText: 'Nivel',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'Básico', child: Text('Básico')),
                            DropdownMenuItem(value: 'Intermedio', child: Text('Intermedio')),
                            DropdownMenuItem(value: 'Avanzado', child: Text('Avanzado')),
                            DropdownMenuItem(value: 'Competencia', child: Text('Competencia')),
                          ],
                          onChanged: (value) {
                            if (value != null) setState(() => _selectedLevel = value);
                          },
                        ),
                        const SizedBox(height: 16),

                        // Dropdown Tipo de Clase
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
                            if (value != null) {
                              setState(() {
                                _selectedClassType = value;
                                _updatePriceForClassType(value);
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 16),

                        // Dropdown Horarios Disponibles
                        DropdownButtonFormField<String>(
                          value: (_selectedTimeSlot != null && _availableTimeSlots.contains(_selectedTimeSlot))
                              ? _selectedTimeSlot
                              : (_availableTimeSlots.isNotEmpty ? _availableTimeSlots.first : null),
                          decoration: const InputDecoration(
                            labelText: 'Horario Disponible',
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
                                  final titleDetails = fullName.isEmpty ? 'Clase - $_currentSelectedDay' : fullName;

                                  int maxSpots;
                                  int available;

                                  if (_selectedClassType == 'Grupal') {
                                    maxSpots = 4;
                                    available = 3;
                                  } else {
                                    maxSpots = 1;
                                    available = 0;
                                  }

                                  innerContext.read<LessonsBloc>().add(AddLessonIntent(
                                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                                    userId: widget.user.id,
                                    title: titleDetails,
                                    date: _currentSelectedDay,
                                    timeSlot: _selectedTimeSlot ?? '08:00 - 09:00',
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