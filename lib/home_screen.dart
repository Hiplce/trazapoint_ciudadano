import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trazapoint_ciudadano/bloc/authenticationbloc/authentication_bloc.dart';
import 'package:trazapoint_ciudadano/bloc/authenticationbloc/authentication_event.dart';


class HomeScreen extends StatelessWidget {

  final String name;

  HomeScreen({Key key , @required this.name}) : super(key : key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
              }
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(child:
            Text("holaaaaaaaaaaaaa $name"),)
        ],
      ),
    );
  }
}
