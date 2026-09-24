class AppStrings {
  // General
  static const String errorLabel = 'Error';

  // Daily Schedule Page
  static const String dailyScheduleTitle = 'Planilla del Día';
  static const String totalMetric = 'Total';
  static const String occupiedMetric = 'Ocupados';
  static const String freeMetric = 'Libres';
  static const String revenueMetric = 'Recaudado';
  static const String noRecordsForDay = 'No hay registros para este día';

  // Configure Availability Page
  static const String configureAvailabilityTitle = 'Configurar Horarios y Precios';
  static const String dayLabel = 'Día';
  static const String selectDayLabel = 'Seleccionar día';
  static const String scheduleSectionTitle = 'Horarios';
  static const String startTimeLabel = 'Desde';
  static const String endTimeLabel = 'Hasta';
  static const String updateDayScheduleButton = 'Actualizar Horario del Día';
  static const String pricesSectionTitle = 'Precios';
  static const String classTypeLabel = 'Tipo de clase';
  static const String priceFieldLabel = 'Precio';
  static const String savePriceButton = 'Guardar Precio';
  static const String saveAllConfigButton = 'Guardar Toda la Configuración';

  // Mensajes de error / éxito
  static const String invalidScheduleError = 'Horario inválido';
  static const String endBeforeStartError = 'La hora de finalización debe ser posterior a la de inicio';
  static const String dayScheduleUpdatedMsg = 'Horario de atención actualizado para';
  static const String priceUpdatedMsg = 'Precio actualizado a';
  static const String configSavedSuccess = 'Configuración guardada correctamente';
  static const String errorPrefix = 'Error: ';

  // Lessons Grid Page
  static const String weeklyGridTitle = 'Grilla Semanal Completa';
  static const String scheduleColumnLabel = 'Horario';
  static const List<String> weekDayNames = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo'
  ];

  // Lessons Page
  static const String teacherAgendaTitle = 'Agenda (Profesor)';
  static const String studentAgendaTitle = 'Agenda (Alumno)';
  static const String openingWeeklyScheduleMsg = 'Abriendo planilla semanal completa...';
  static const String teacherOnlyAccessMsg = 'Acceso exclusivo para profesores';
  static const String registerStudentTooltip = 'Inscribir Alumno';
  static const String bookSlotTooltip = 'Reservar Turno';
  static const String noSlotsForDayMsg = 'No hay turnos cargados para el día';
  static const String scheduleLabel = 'Horario';
  static const String studentLabel = 'Alumno';
  static const String unassignedLabel = 'Sin asignar';

  // Login Page
  static const String loginTitle = 'Iniciar Sesión';
  static const String registerTitle = 'Registro de Usuario';
  static const String fillMandatoryFieldsError = 'Por favor completa los campos obligatorios';
  static const String registerSuccessMsg = '¡Registro exitoso! Ya puedes iniciar sesión.';

  // Onboarding Page
  static const String onboardingTitle = 'Configura tu Perfil y Turno';
  static const String defaultLevel = 'Básico';
  static const String defaultClassType = 'Grupal';
  static const String defaultStartHour = '08:00';
  static const String defaultEndHour = '21:00';
  static const String defaultTimeSlot = '08:00 - 09:00';

  static const String errorGetRepositoyImpl ='Error al obtener la disponibilidad';
  static const String errorSaveRepositoyImpl ='Error al guardar la disponibilidad:';
  static const String errorUpdateRepositoyImpl ='Error al actualizar el turno';
  static const String errorDeleteRepositoyImpl ='Error al eliminar el turno';

  static const String usersCollection = 'users';
  static const String authNotFoundFailure = 'No se pudo obtener el usuario de la autenticación.';
  static const String userDocNotFoundFailure = 'El usuario no existe en la base de datos.';
  static const String authCreateFailure = 'Error al crear el usuario en Auth.';
  static const String notCreateSesion = 'Error al iniciar sesión.';
  static const String errorRegister = 'Error en el registro';

}