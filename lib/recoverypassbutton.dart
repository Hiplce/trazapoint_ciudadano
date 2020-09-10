import 'package:flutter/material.dart';
import 'package:trazapoint_ciudadano/recovery_screem.dart';
import 'package:trazapoint_ciudadano/register_screen.dart';
import 'package:trazapoint_ciudadano/user_repository.dart';

class RecoveryPassButton extends StatelessWidget {

  final UserRepository _userRepository;

  RecoveryPassButton({Key key, @required UserRepository userRepository}):
      assert(userRepository != null),
  _userRepository = userRepository,
  super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text('Recuperar Contraseña'),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return RecoveryScreen(userRepository: _userRepository,);
          })
        );
      },
    );
  }
}
