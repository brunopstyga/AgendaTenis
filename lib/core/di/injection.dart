import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../services/notification_service.dart';
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
  // Proveemos la instancia de FirebaseAuth para que Injectable la reconozca
  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  // Proveemos la instancia de FirebaseFirestore
  @lazySingleton
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

}