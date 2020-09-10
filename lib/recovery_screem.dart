import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trazapoint_ciudadano/bloc/recoverypassbloc/bloc.dart';
import 'package:trazapoint_ciudadano/bloc/registerbloc/bloc.dart';
import 'package:trazapoint_ciudadano/recovery_form.dart';
import 'package:trazapoint_ciudadano/registe_form.dart';
import 'package:trazapoint_ciudadano/user_repository.dart';

class RecoveryScreen extends StatelessWidget {

  final UserRepository _userRepository;

  RecoveryScreen({Key key, @required UserRepository userRepository})
  : assert (userRepository != null),
  _userRepository = userRepository,
  super(key : key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Recuperar Contraseña"),),
      body: Center(
        child: BlocProvider<RecoveryBloc>(
          create: (context) => RecoveryBloc(userRepository: _userRepository),

          child: RecoveryForm(userRepository: _userRepository,),
        ),
      ),
    );
  }
}