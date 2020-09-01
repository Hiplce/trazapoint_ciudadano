import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trazapoint_ciudadano/bloc/authenticationbloc/authentication_bloc.dart';
import 'package:trazapoint_ciudadano/bloc/authenticationbloc/authentication_event.dart';
import 'package:trazapoint_ciudadano/bloc/trazabloc/bloc.dart';
import 'package:trazapoint_ciudadano/traza_env.dart';
import 'package:trazapoint_ciudadano/traza_repository.dart';
import 'package:trazapoint_ciudadano/user_repository.dart';


class HomeScreen extends StatefulWidget {

  final String name;

  HomeScreen({Key key , @required this.name}) : super(key : key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TrazaRepository _trazaRepository;
  String get name => widget.name;
  UserRepository _userRepository;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userRepository = UserRepository();
    _trazaRepository = TrazaRepository();
    _userRepository.writeUser(name);
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TrazaBloc(trazaRepository: _trazaRepository),
      child:
        Scaffold(
          appBar: AppBar(
            title: Text("Principal"),
            actions: [

              IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    _userRepository.deleteFile();
                    BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());

                  }
              ),

            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children:[
              Center(child:
               TrazaEnv(userRepository: _userRepository,trazaRepository: _trazaRepository, email: name,)),

            ]
          )

        ),
      );
  }


}
