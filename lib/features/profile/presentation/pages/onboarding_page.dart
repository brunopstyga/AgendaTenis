import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../bloc/lessons_bloc.dart';
import '../bloc/lessons_intent.dart';
import '../bloc/availability/availability_bloc.dart';
import '../bloc/availability/availability_state.dart';
import '../bloc/availability/AvailabilityIntent.dart';
import '../components/onboarding_form_widget.dart';
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

  late String _currentSelectedDay;
  String? _selectedTimeSlot;
  String _selectedLevel = AppStrings.defaultLevel;
  String _selectedClassType = AppStrings.defaultClassType;
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

  void _processAvailability(AvailabilityState state) {
    if (state is AvailabilityLoaded) {
      final dayData = state.schedule[_currentSelectedDay] ??
          state.schedule[_currentSelectedDay.toLowerCase()] ?? {};

      final String startHour = dayData['startTime'] ?? AppStrings.defaultStartHour;
      final String endHour = dayData['endTime'] ?? AppStrings.defaultEndHour;

      final Map<String, dynamic> rawPrices = dayData['prices'] ?? {};
      _currentDayClassPrices = rawPrices.map((key, value) => MapEntry(key, (value as num).toDouble()));

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

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final fullName = '${_nameController.text} ${_surnameController.text}'.trim();
      final titleDetails = fullName.isEmpty ? 'Clase - $_currentSelectedDay' : fullName;

      final int maxSpots = (_selectedClassType == 'Grupal') ? 4 : 1;
      final int available = (_selectedClassType == 'Grupal') ? 3 : 0;

      context.read<LessonsBloc>().add(AddLessonIntent(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: widget.user.id,
        title: titleDetails,
        date: _currentSelectedDay,
        timeSlot: _selectedTimeSlot ?? AppStrings.defaultTimeSlot,
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
            value: context.read<LessonsBloc>(),
            child: LessonsPage(currentUser: widget.user),
          ),
        ),
            (route) => false,
      );
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
              title: const Text(AppStrings.onboardingTitle),
              automaticallyImplyLeading: false,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: OnboardingFormWidget(
                    formKey: _formKey,
                    nameController: _nameController,
                    surnameController: _surnameController,
                    phoneController: _phoneController,
                    selectedLevel: _selectedLevel,
                    selectedClassType: _selectedClassType,
                    selectedTimeSlot: _selectedTimeSlot,
                    availableTimeSlots: _availableTimeSlots,
                    basePriceFromTeacher: _basePriceFromTeacher,
                    onLevelChanged: (val) => setState(() => _selectedLevel = val!),
                    onClassTypeChanged: (val) {
                      setState(() {
                        _selectedClassType = val!;
                        _updatePriceForClassType(val);
                      });
                    },
                    onTimeSlotChanged: (val) => setState(() => _selectedTimeSlot = val),
                    onSubmit: () => _submitForm(context),
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