// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/profile/data/repositories/availability_repository_impl.dart'
    as _i214;
import '../../features/profile/data/repositories/lesson_repository.dart'
    as _i350;
import '../../features/profile/data/repositories/login_data_repository_impl.dart'
    as _i857;
import '../../features/profile/domain/repositories/AvailabilityRepository.dart'
    as _i431;
import '../../features/profile/domain/repositories/i_lesson_repository.dart'
    as _i262;
import '../../features/profile/domain/repositories/repository_login_user.dart'
    as _i212;
import '../../features/profile/domain/usecases/addlessonusecase.dart' as _i1013;
import '../../features/profile/domain/usecases/configurationdata/get_schedule_use_case.dart'
    as _i68;
import '../../features/profile/domain/usecases/configurationdata/save_schedule_use_case.dart'
    as _i742;
import '../../features/profile/domain/usecases/deletelessonusecase.dart'
    as _i303;
import '../../features/profile/domain/usecases/loginuser/login_user_usecase.dart'
    as _i1004;
import '../../features/profile/domain/usecases/loginuser/register_user_usecase.dart'
    as _i359;
import '../../features/profile/domain/usecases/updatelessonusecase.dart'
    as _i909;
import '../../features/profile/domain/usecases/watchlessonsusecase.dart'
    as _i368;
import '../../features/profile/presentation/bloc/availability/availability_bloc.dart'
    as _i780;
import '../../features/profile/presentation/bloc/lessons_bloc.dart' as _i234;
import '../../features/profile/presentation/bloc/login/login_bloc.dart'
    as _i600;
import '../database/app_database.dart' as _i982;
import '../database/dataconfigurationmenu/AvailabilityDao.dart' as _i282;
import '../database/lesson_slots_dao.dart' as _i969;
import '../database/login_user/login_dao.dart' as _i897;
import 'injection.dart' as _i464;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i982.AppDatabase>(() => registerModule.appDatabase);
    gh.lazySingleton<_i969.LessonSlotsDao>(
      () => registerModule.lessonSlotsDao(gh<_i982.AppDatabase>()),
    );
    gh.lazySingleton<_i282.AvailabilityDao>(
      () => registerModule.availabilityDao(gh<_i982.AppDatabase>()),
    );
    gh.lazySingleton<_i897.LoginDao>(
      () => registerModule.loginDao(gh<_i982.AppDatabase>()),
    );
    gh.lazySingleton<_i212.RepositoryLoginUser>(
      () => _i857.LoginDataRepositoryImpl(gh<_i897.LoginDao>()),
    );
    gh.factory<_i1004.LoginUserUseCase>(
      () => _i1004.LoginUserUseCase(gh<_i212.RepositoryLoginUser>()),
    );
    gh.factory<_i359.RegisterUserUseCase>(
      () => _i359.RegisterUserUseCase(gh<_i212.RepositoryLoginUser>()),
    );
    gh.lazySingleton<_i262.ILessonRepository>(
      () => _i350.LessonRepository(gh<_i969.LessonSlotsDao>()),
    );
    gh.factory<_i600.LoginBloc>(
      () => _i600.LoginBloc(
        loginUserUseCase: gh<_i1004.LoginUserUseCase>(),
        registerUserUseCase: gh<_i359.RegisterUserUseCase>(),
      ),
    );
    gh.lazySingleton<_i431.AvailabilityRepository>(
      () => _i214.AvailabilityRepositoryImpl(gh<_i282.AvailabilityDao>()),
    );
    gh.factory<_i68.GetScheduleUseCase>(
      () => _i68.GetScheduleUseCase(gh<_i431.AvailabilityRepository>()),
    );
    gh.factory<_i742.SaveScheduleUseCase>(
      () => _i742.SaveScheduleUseCase(gh<_i431.AvailabilityRepository>()),
    );
    gh.factory<_i1013.AddLessonUseCase>(
      () => _i1013.AddLessonUseCase(gh<_i262.ILessonRepository>()),
    );
    gh.factory<_i303.DeleteLessonUseCase>(
      () => _i303.DeleteLessonUseCase(gh<_i262.ILessonRepository>()),
    );
    gh.factory<_i909.UpdateLessonUseCase>(
      () => _i909.UpdateLessonUseCase(gh<_i262.ILessonRepository>()),
    );
    gh.factory<_i368.WatchLessonsUseCase>(
      () => _i368.WatchLessonsUseCase(gh<_i262.ILessonRepository>()),
    );
    gh.factory<_i780.AvailabilityBloc>(
      () => _i780.AvailabilityBloc(
        gh<_i68.GetScheduleUseCase>(),
        gh<_i742.SaveScheduleUseCase>(),
      ),
    );
    gh.factory<_i234.LessonsBloc>(
      () => _i234.LessonsBloc(
        watchLessonsUseCase: gh<_i368.WatchLessonsUseCase>(),
        addLessonUseCase: gh<_i1013.AddLessonUseCase>(),
        deleteLessonUseCase: gh<_i303.DeleteLessonUseCase>(),
        updateLessonUseCase: gh<_i909.UpdateLessonUseCase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i464.RegisterModule {}
