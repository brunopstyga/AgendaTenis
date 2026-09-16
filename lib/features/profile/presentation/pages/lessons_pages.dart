import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../presentation/widgets/app_drawer.dart';
import '../bloc/lessons_bloc.dart';
import '../bloc/lessons_intent.dart';
import '../bloc/lessons_state.dart';
import '../components/day_selector_widget.dart';
import '../components/student_modal_form.dart';

import '../pages/login_page.dart';
import '../bloc/login/login_bloc.dart';
import '../../domain/entity/user_entity.dart';

import 'configure_availability_page.dart';
import 'daily_schedule_page.dart';

class LessonsPage extends StatefulWidget {
  final UserEntity? currentUser;
  const LessonsPage({super.key, this.currentUser});

  @override
  State<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  final ScrollController _scrollController = ScrollController();

  late List<DateTime> _dateRange;
  late DateTime _selectedDate;

  // Mapa de claves globales para ubicar exactamente cada chip de fecha
  late final Map<DateTime, GlobalKey> _dayKeys;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();

    // Generamos un rango de 11 días: 5 días antes de hoy y 5 días después de hoy
    _dateRange = List.generate(11, (index) {
      return DateTime.now().subtract(Duration(days: 5 - index));
    });

    // Inicializamos las claves globales para cada fecha del rango
    _dayKeys = {
      for (var date in _dateRange) date: GlobalKey(),
    };

    context.read<LessonsBloc>().add(LoadLessons());
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelectedDate());
  }

  // 2. Lógica para definir si es el profesor (puedes cambiar 'admin@tennis.com' por tu correo real)
  bool get _isTeacher {
    if (widget.currentUser == null) return false;
    // Ejemplo: si el email coincide con el de administración, es profesor
    return widget.currentUser!.email == 'admin@tennis.com';
  }


  String get _selectedDayName {
    const days = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    return days[_selectedDate.weekday - 1];
  }

  void _scrollToSelectedDate() {
    final targetContext = _dayKeys.entries
        .firstWhere((entry) =>
    entry.key.year == _selectedDate.year &&
        entry.key.month == _selectedDate.month &&
        entry.key.day == _selectedDate.day,
        orElse: () => MapEntry(_selectedDate, GlobalKey())
    ).value.currentContext;

    if (targetContext != null && _scrollController.hasClients) {
      Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.5,
        alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
      );
    }
  }

  void _scrollNextDay() {
    final currentIndex = _dateRange.indexWhere((date) =>
    date.year == _selectedDate.year && date.month == _selectedDate.month && date.day == _selectedDate.day
    );
    // Avanzamos si no nos pasamos del límite de los 5 días futuros
    if (currentIndex < _dateRange.length - 1) {
      setState(() {
        _selectedDate = _dateRange[currentIndex + 1];
      });
      _scrollToSelectedDate();
    }
  }

  void _scrollPreviousDay() {
    final currentIndex = _dateRange.indexWhere((date) =>
    date.year == _selectedDate.year && date.month == _selectedDate.month && date.day == _selectedDate.day
    );
    // Retrocedemos de forma segura hasta el límite de los 5 días pasados (índice 0)
    if (currentIndex > 0) {
      setState(() {
        _selectedDate = _dateRange[currentIndex - 1];
      });
      _scrollToSelectedDate();
    }
  }

  void _handleLoginLocal(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => getIt<LoginBloc>(),
          child: const LoginPage(),
        ),
      ),
    );
  }

  // Items del menú lateral
  void _handleLoginGmail() => debugPrint('Iniciando sesión con Gmail...');
  void _handleLoginApple() => debugPrint('Iniciando sesión con Apple...');

  void _handleShowDailySchedule(BuildContext context) {
    final lessonsBloc = context.read<LessonsBloc>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: lessonsBloc,
          child: const DailySchedulePage(),
        ),
      ),
    );
  }

  void _handleShowWeeklySchedule(BuildContext context) => _showSnackBar('Abriendo planilla semanal completa...');

  void _handleConfigureAvailability(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const ConfigureAvailabilityPage()));
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showAddStudentModal(BuildContext context, {dynamic slotToEdit}) {
    final lessonsBloc = context.read<LessonsBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: lessonsBloc,
        child: StudentModalForm(selectedDay: _selectedDayName, slotToEdit: slotToEdit),
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => getIt<LoginBloc>(),
          child: const LoginPage(),
        ),
      ),
          (route) => false, // Elimina el historial anterior para que no pueda volver atrás
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(_isTeacher ? 'Agenda (Profesor)' : 'Agenda (Alumno)'),
      ),
      drawer: AppDrawer(
        onLoginLocal: () => _handleLoginLocal(context),
        onLoginGmail: _handleLoginGmail,
        onLoginApple: _handleLoginApple,
        // 3. Si es profesor ejecuta la acción, si es alumno no hace nada o muestra aviso
        onShowDailySchedule: _isTeacher ? () => _handleShowDailySchedule(context) : () => _showSnackBar('Acceso exclusivo para profesores'),
        onShowWeeklySchedule: _isTeacher ? () => _handleShowWeeklySchedule(context) : () => _showSnackBar('Acceso exclusivo para profesores'),
        onConfigureAvailability: _isTeacher ? () => _handleConfigureAvailability(context) : () => _showSnackBar('Acceso exclusivo para profesores'),
        onLogout: () => _handleLogout(context),
      ),
      body: Column(
        children: [
          DaySelectorWidget(
            dates: _dateRange,
            selectedDate: _selectedDate,
            scrollController: _scrollController,
            dayKeys: _dayKeys,
            onDaySelected: (date) {
              setState(() => _selectedDate = date);
              _scrollToSelectedDate();
            },
            onScrollLeft: _scrollPreviousDay,
            onScrollRight: _scrollNextDay,
          ),
          Expanded(child: _buildLessonsListBuilder()),
        ],
      ),
      // 4. El botón flotante desaparece (null) si el usuario es alumno
      floatingActionButton: _isTeacher
          ? FloatingActionButton(
        onPressed: () => _showAddStudentModal(context),
        tooltip: 'Inscribir Alumno',
        child: const Icon(Icons.person_add),
      )
          : null,
    );
  }

  Widget _buildLessonsListBuilder() {
    return BlocBuilder<LessonsBloc, LessonsState>(
      builder: (context, state) {
        if (state.isLoading) return const Center(child: CircularProgressIndicator());
        if (state.errorMessage != null) return Center(child: Text('Error: ${state.errorMessage}'));

        // Filtramos utilizando el nombre del día correspondiente a la fecha seleccionada
        final filteredSlots = state.slots.where((slot) => slot.date == _selectedDayName).toList();
        if (filteredSlots.isEmpty) {
          return Center(child: Text('No hay turnos cargados para el día $_selectedDayName'));
        }

        return ListView.builder(
          itemCount: filteredSlots.length,
          itemBuilder: (context, index) {
            final slot = filteredSlots[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: ListTile(
                // Si es alumno, evitamos que al tocar abra el modal de edición de turnos
                onTap: _isTeacher ? () => _showAddStudentModal(context, slotToEdit: slot) : null,
                title: Text(slot.title),
                subtitle: Text('Horario: ${slot.timeSlot} | Alumno: ${slot.studentName ?? "Sin asignar"}'),
                // Si es alumno, ocultamos el botón de borrar en la lista
                trailing: _isTeacher
                    ? IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => context.read<LessonsBloc>().add(DeleteLessonIntent(slot.id)),
                )
                    : null,
              ),
            );
          },
        );
      },
    );
  }
}