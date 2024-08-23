import 'package:flutter/material.dart';
import 'package:flutter_application_10/features/app/home/home_page.dart';
import 'package:flutter_application_10/features/app/theme/style.dart';
import 'package:flutter_application_10/features/chat/presentation/cubit/chat/cubit/chat_cubit.dart';
import 'package:flutter_application_10/features/chat/presentation/cubit/message/cubit/message_cubit.dart';
import 'package:flutter_application_10/features/status/presentaion/cubit/get_my_status/cubit/get_my_status_cubit.dart';
import 'package:flutter_application_10/features/status/presentaion/cubit/get_status/cubit/status_cubit.dart';
import 'package:flutter_application_10/features/user/presentation/bloc/auth/cubit/auth_cubit.dart';
import 'package:flutter_application_10/features/user/presentation/bloc/credential/cubit/credential_cubit.dart';
import 'package:flutter_application_10/features/user/presentation/bloc/get_device_number/cubit/get_device_number_cubit.dart';
import 'package:flutter_application_10/features/user/presentation/bloc/get_single_user/cubit/get_single_user_cubit.dart';
import 'package:flutter_application_10/features/user/presentation/bloc/user/cubit/user_cubit.dart';
import 'package:flutter_application_10/routes/on_generate_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/app/splash/splash_screen.dart';
import 'main_injection_container.dart' as di;
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<AuthCubit>()..AppStarted(),
        ),
        BlocProvider(
          create: (context) => di.sl<CredentialCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<GetDeviceNumberCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<GetSingleUserCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<UserCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<ChatCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<MessageCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<StatusCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<GetMyStatusCubit>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: backgroundColor,
            colorScheme: ColorScheme.fromSeed(
              seedColor: tabColor,
              brightness: Brightness.dark
              ),
            dialogBackgroundColor: appBarColor,
            appBarTheme: const AppBarTheme(color: appBarColor)),
        onGenerateRoute: OnGenerateRoute.route,
        initialRoute: "/",
        routes: {"/": (context){
          return BlocBuilder<AuthCubit,AuthState>(
            builder: (context, state) {
              if(state is Authticated){
                return HomePage(uid: state.uid);
              }
              return SplashScreen();
            },);
        }},
      ),
    );
  }
}
