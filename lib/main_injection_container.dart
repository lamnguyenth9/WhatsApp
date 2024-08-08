import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_10/features/chat/chat_injection_container.dart';
import 'package:get_it/get_it.dart';

import 'features/user/user_injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  sl.registerLazySingleton(() => auth);
  sl.registerLazySingleton(() => firestore);
  await userInjectionContainer();
  await ChatInjectionContainer();
}
