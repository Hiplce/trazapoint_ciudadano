import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trazapoint_ciudadano/bloc/authenticationbloc/authentication_bloc.dart';
import 'package:trazapoint_ciudadano/bloc/authenticationbloc/bloc.dart';
import 'package:trazapoint_ciudadano/bloc/dataregisterbloc/bloc.dart';
import 'package:trazapoint_ciudadano/home_screen.dart';
import 'package:trazapoint_ciudadano/user_repository.dart';

class CompleteRegisterForm extends StatefulWidget {

  String _nombre;
  String _apellido;
  String _dni;
  String _email;
  String _password;
  UserRepository _userRepository;

  CompleteRegisterForm({Key key,@required UserRepository userRepository,@required String nombre,@required String email,@required String password, @required String apellido,@required String dni}):
        assert(userRepository != null),
        assert(nombre != null),
        assert(apellido != null),
        assert(dni != null),
        assert(email != null),
        assert(password != null),
        _userRepository = userRepository,
        _nombre = nombre,
        _apellido = apellido,
        _dni = dni,
        _email = email,
        _password = password,
        super(key: key);
  @override
  _CompleteRegisterFormState createState() => _CompleteRegisterFormState();
}

class _CompleteRegisterFormState extends State<CompleteRegisterForm> {
  final TextEditingController _directionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String get _nombre => widget._nombre;
  String get _apellido => widget._apellido;
  String get _dni => widget._dni;
  String get _email => widget._email;
  String get _password => widget._password;
  //UserRepository get _userRepository => widget._userRepository;

  DataRegisterBloc _dataRegisterBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dataRegisterBloc = BlocProvider.of<DataRegisterBloc>(context);
    //_dataRegisterBloc = DataRegisterBloc(userRepository: _userRepository);
    _directionController.addListener(_onDirectionChanged);
    _locationController.addListener(_onLocationChanged);
    _phoneController.addListener(_onPhoneChanged);

  }

  bool isRegisterButtonEnabled(DataRegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }
  void _onDirectionChanged(){
    _dataRegisterBloc.add(DirectionChanged(direction: _directionController.text));
  }
  void _onLocationChanged(){
    _dataRegisterBloc.add(LocationChanged(location: _locationController.text));
  }
  void _onPhoneChanged(){
    _dataRegisterBloc.add(PhoneChanged(phone: _phoneController.text));
  }

  bool get isPopulated => _directionController.text.isNotEmpty && _locationController.text.isNotEmpty && _phoneController.text.isNotEmpty;

  @override
  void dispose() {
    // TODO: implement dispose
    _directionController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: BlocListener<DataRegisterBloc,DataRegisterState>(
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
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {
              return HomeScreen(name: _nombre,);}),
              (route) => false);

            }
          },
          child: BlocBuilder<DataRegisterBloc,DataRegisterState>(
            builder: (context,state) {
              return Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  child: ListView(
                    children: [
                      Container(
                        child: Text("Nombre: " + _nombre + "\n"+"Apellido: "+ _apellido + "\n" + "DNI: " + _dni,style: TextStyle(fontSize: 24,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),),
                      ),
                      TextFormField(
                        controller: _locationController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.domain),
                            labelText: "Localidad"
                        ),
                        keyboardType: TextInputType.text,
                        autovalidate: true,
                        autocorrect: false,
                        validator: (_) {
                          return !state.isLocationValid? "Localidad Invalida" : null;
                        },
                      ),
                      TextFormField(
                        controller: _directionController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.home),
                            labelText: "Direccion"
                        ),

                        autovalidate: true,
                        autocorrect: false,
                        validator: (_) {
                          return !state.isDirectionValid? "Direccion Invalida" : null;
                        },
                      ),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.phone),
                            labelText: "Telefono"
                        ),
                        keyboardType: TextInputType.number,
                        autovalidate: true,
                        autocorrect: false,
                        validator: (_) {
                          return !state.isPhoneValid? "Telefono Invalida" : null;
                        },
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                          ),
                        onPressed: isRegisterButtonEnabled(state) ? _onFormSubmitt : null,
                        child: Text("Register"),
                      )

                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );

  }

  void _onFormSubmitt() {

    _dataRegisterBloc.add(Submitted(
      email: _email,
      password: _password,
      name: _nombre,
      lastname: _apellido,
      dni: _dni,
      location: _locationController.text,
      direction: _directionController.text,
      phone: _phoneController.text
    ));
  }
}
