import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import '../database/app_database.dart';
import '../database/dataconfigurationmenu/AvailabilityDao.dart';
import '../database/lesson_slots_dao.dart';
import '../database/login_user/login_dao.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() => getIt.init();

@module
abstract class RegisterModule {
  @lazySingleton
  AppDatabase get appDatabase => AppDatabase();

  @lazySingleton
  LessonSlotsDao lessonSlotsDao(AppDatabase database) => LessonSlotsDao(database);

  @lazySingleton
  AvailabilityDao availabilityDao(AppDatabase database) => AvailabilityDao(database);

  @lazySingleton
  LoginDao loginDao(AppDatabase database) => LoginDao(database);
}