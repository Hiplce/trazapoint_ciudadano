import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trazapoint_ciudadano/bloc/authenticationbloc/authentication_bloc.dart';
import 'package:trazapoint_ciudadano/bloc/authenticationbloc/authentication_event.dart';
import 'package:trazapoint_ciudadano/bloc/loginbloc/bloc.dart';
import 'package:trazapoint_ciudadano/create_account_button.dart';
import 'package:trazapoint_ciudadano/login_button.dart';
import 'package:trazapoint_ciudadano/user_repository.dart';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;

  LoginForm({Key key,@required UserRepository userRepository}):
      assert(userRepository != null),
  _userRepository = userRepository,
  super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;


  bool get isPopulated => _emailController.text.isNotEmpty && _passController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passController.addListener(_onPassChanged);
  }

  void _onEmailChanged(){
    _loginBloc.add(EmailChanged(email: _emailController.text));
  }
  void _onPassChanged(){
    _loginBloc.add(PasswordChanged(password: _passController.text));
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
    return BlocListener<LoginBloc,LoginState>(
      listener: (context,state) {
        if(state.isFailure){
          Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Login Failure"),
                      Icon(Icons.error)
                    ],
                  ),
                  backgroundColor: Colors.red,
                )
              );
        }
        if(state.isSubmitting){
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Logging in.."),
                      CircularProgressIndicator(),
                    ],
                  ),
                  backgroundColor: Colors.red,
                )
            );

        }
        if(state.isSuccess){
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());

        }
      },
      child: BlocBuilder<LoginBloc,LoginState>(
        builder: (context,state){
          return Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              child: ListView(
                children: [
                  Padding(padding: EdgeInsets.symmetric(vertical: 20),
                  //falta imagen
                  ),
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
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        LoginButton(onPressed: isLoginButtonEnabled(state)? _onFormSubmitted : null ,),
                        CreateAcountButton(userRepository : _userRepository)
                      ],
                    ),
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
    _loginBloc.add(LogginWhithCreddentialsPressed(email: _emailController.text, password: _passController.text ));
  }
}
