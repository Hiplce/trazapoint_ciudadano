import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trazapoint_ciudadano/LoginScreen.dart';
import 'package:trazapoint_ciudadano/bloc/authenticationbloc/authentication_bloc.dart';
import 'package:trazapoint_ciudadano/bloc/authenticationbloc/authentication_event.dart';
import 'package:trazapoint_ciudadano/bloc/authenticationbloc/authentication_state.dart';
import 'package:trazapoint_ciudadano/bloc/simplebloc_delegate.dart';
import 'package:trazapoint_ciudadano/home_screen.dart';
import 'package:trazapoint_ciudadano/splash_screen.dart';
import 'package:trazapoint_ciudadano/user_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AuthenticationBlocDelegate();
  await Firebase.initializeApp();
  final UserRepository userRepository = UserRepository();
  runApp(
      BlocProvider(
        create: (context) => AuthenticationBloc(userRepository: userRepository)
          ..add(AppStarted()),
        child: MyApp(userRepository : userRepository),
      )
  );
}


class MyApp extends StatelessWidget {
  final UserRepository _userRepository;

  MyApp( {Key key, @required UserRepository userRepository,})
  : assert ( userRepository != null),
  _userRepository = userRepository,
  super(key:key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Trazaciuda",
      home: BlocBuilder<AuthenticationBloc,AuthenticationState>(
        builder:  (context,state){

          if(state is Uninitialized){
            return SplashScreen();
          }
          if(state is Authenticated){
            return HomeScreen(name: state.displayName,);
          }
          if(state is Unauthenticated){
            return LogginScreen(userRepository: _userRepository,);
          }
          return Container();
        },

      ),
    );

  }
}
