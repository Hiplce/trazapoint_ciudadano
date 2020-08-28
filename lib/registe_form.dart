import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trazapoint_ciudadano/RegisterButton.dart';
import 'package:trazapoint_ciudadano/bloc/authenticationbloc/authentication_bloc.dart';
import 'package:trazapoint_ciudadano/bloc/authenticationbloc/authentication_event.dart';
import 'package:trazapoint_ciudadano/bloc/registerbloc/bloc.dart';
import 'package:bloc/bloc.dart';
class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  RegisterBloc _registerBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passController.addListener(_onPassChanged);
  }
  bool get isPopulated => _emailController.text.isNotEmpty && _passController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  void _onEmailChanged(){
    _registerBloc.add(EmailChanged(email: _emailController.text));
  }
  void _onPassChanged(){
    _registerBloc.add(PasswordChanged(password: _passController.text));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc,RegisterState>(
      listener: (context,state){
         if(state.isSubmitting){
           Scaffold.of(context)
               ..hideCurrentSnackBar()
               ..showSnackBar(
                 SnackBar(
                   content: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text("Registering"),
                       CircularProgressIndicator()
                     ],
                   ),
                 )
               );
         }
         if(state.isFailure){
           Scaffold.of(context)
             ..hideCurrentSnackBar()
             ..showSnackBar(
                 SnackBar(
                   content: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text("Register Failure"),
                       Icon(Icons.error)
                     ],
                   ),
                   backgroundColor: Colors.red,
                 )
             );
         }
         if(state.isSuccess){
           BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
           Navigator.of(context).pop();

         }
      },
      child: BlocBuilder<RegisterBloc,RegisterState>(
        builder: (context,state) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              child: ListView(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.email),
                        labelText: "email"
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autovalidate: true,
                    autocorrect: false,
                    validator: (_) {
                      return !state.isEmailValid? "invalid Email" : null;
                    },
                  ),
                  TextFormField(
                    controller: _passController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        labelText: "Password"
                    ),
                    obscureText: true,
                    autovalidate: true,
                    autocorrect: false,
                    validator: (_) {
                      return !state.isPasswordValid? "invalid Password" : null;
                    },
                  ),
                  RegisterButton(
                    onPressed: isRegisterButtonEnabled(state)
                        ? _onFormSubmitted
                    : null,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onFormSubmitted() {
    _registerBloc.add(
        Submitted(
          email: _emailController.text,
          password: _passController.text
        ));
  }
}

