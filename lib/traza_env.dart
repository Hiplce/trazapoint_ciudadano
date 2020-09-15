import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trazapoint_ciudadano/bloc/trazabloc/bloc.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:trazapoint_ciudadano/traza_repository.dart';
import 'package:trazapoint_ciudadano/user_repository.dart';

class TrazaEnv extends StatefulWidget {
  final UserRepository _userRepository;
  final TrazaRepository _trazaRepository;
  final String _nombre;
  String qrResult;
  TrazaEnv({Key key,@required UserRepository userRepository,@required TrazaRepository trazaRepository,@required String email})
  :assert(userRepository != null),
  assert(trazaRepository != null),
  assert(trazaRepository != null),
  _userRepository = userRepository,
  _trazaRepository = trazaRepository,
  _nombre = email,
  super(key: key);
  @override
  _TrazaEnvState createState() => _TrazaEnvState();
}

class _TrazaEnvState extends State<TrazaEnv> {

  UserRepository get _userRepository => widget._userRepository;
  TrazaRepository get _trazaRepository => widget._trazaRepository;
  String get _nombre => widget._nombre;
  String res;
  String dni = "";
  bool verificado;
  void set _nombre(String nombre){
    _nombre = nombre;
  }
  @override
  void initState() async{
    super.initState();
    User user = await _userRepository.getUserData();
    verificado = user.emailVerified;
    //_getDni(_nombre);
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<TrazaBloc,TrazaState>(
      listener: (context,state){
        if(state.isFailure){
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Colors.red,
                title: Text("Rechazado!"),
                content: Text("No se ha podido registrar sus datos de trazabilidad, revise su conexion e intente nuevamente"),
                actions: [
                  FlatButton(
                    child: Text("OK"),
                    onPressed:(){ Navigator.of(context).pop();},
                  )
                ],
              )
          );
            }

            if(state.isSubmitting){

              /*Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                    SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Cargando"),
                          CircularProgressIndicator(),
                        ],
                      ),
                      backgroundColor: Colors.white,
                    )
                );*/

            }
            if(state.isSuccess){
              showDialog(
                  context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.green,
                  title: Text("Confirmado!"),
                  content: Text("Ingreso/Egreso notificado con exito"),
                  actions: [
                    FlatButton(
                      child: Text("OK"),
                      onPressed:(){ Navigator.of(context).pop();},
                    )
                  ],
                )
              );
            }
            if(state.isOnLocal){
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.yellow,
                    title: Text("En Dispositivo!"),
                    content: Text("Los datos de trazabilidad se han guardado en el dispositivo, porfavor sincronice los datos cuando disponga de internet"),
                    actions: [
                      FlatButton(
                        child: Text("OK"),
                        onPressed:(){ Navigator.of(context).pop();},
                      )
                    ],
                  )
              );

            }
            },
      child:Container(
        child: Column(

            children: [
              Image.asset('assets/fty.png',height: 100,),
               Text(
                "Bienvenido",
                style: new TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),

              SizedBox(
                height: 30,
              ),
              RaisedButton(
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)
                ),
                  onPressed: () async {
                    var connectivity = await (Connectivity().checkConnectivity());
                    if (connectivity == ConnectivityResult.mobile || connectivity == ConnectivityResult.wifi ) {
                      try {
                        final result = await InternetAddress.lookup('google.com.ar');
                        print(result);
                        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                          List<String> res = await _trazaRepository.readTraza();
                          int asd = 0;
                          for (String s in res) {
                            var splitting = s.split('|');
                            Future.delayed(const Duration(milliseconds: 500), () async {
                              print("iteracion numero: \n");
                              print(asd);
                              if (splitting[1] == null && splitting[1] != "") {
                                _trazaRepository.insertTraza(
                                    splitting[1], splitting[0], splitting[2]);
                              } else {
                                String email = await _userRepository.readUser();
                                _trazaRepository.insertTraza(
                                    email, splitting[0], splitting[2]);
                              }
                            });
                            asd++;
                          }
                          _trazaRepository.deleteFile();
                          return showDialog(
                              context: context,
                              builder: (context) =>
                                  AlertDialog(
                                    backgroundColor: Colors.green,
                                    title: Text("Sincronizado!!"),
                                    content: Text(
                                        "La sincronizacion fue realizada con exito"),
                                    actions: [
                                      FlatButton(
                                        child: Text("OK"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  )
                          );
                        }
                      }
                      catch(e){
                        return showDialog(
                            context: context,
                            builder: (context) =>
                                AlertDialog(
                                  backgroundColor: Colors.red,
                                  title: Text("No se realizo la sincronizacion!!"),
                                  content: Text(
                                      "Chequee su conectividad para realizar la sincronizacion de manera segura"),
                                  actions: [
                                    FlatButton(
                                      child: Text("OK"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                )
                        );
                      }
                    }

                    else {
                      return showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.red,
                            title: Text("Rechazado!"),
                            content: Text("Revise su conexion de internet antes de realizar la sincronizacion"),
                            actions: [
                              FlatButton(
                                child: Text("OK"),
                                onPressed:(){ Navigator.of(context).pop();},
                              )
                            ],
                          )
                      );
                    }
                },
                child: Text("Sincronizar"),
                ),
              SizedBox(
                height: 40,
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)
                ),
                onPressed: _scanQR,
                child: Text("Escanee Comercio"),
              ),

            ] ,

          ),
      ),

    );


  }
  Future _scanQR() async {
    String qrResult;

    try {

      User user = await _userRepository.getUserData();
      print("pre-reload");
      print(user.emailVerified);
      await user.reload();
      user = await _userRepository.getUserData();
      print("post-reload");
      print(user.emailVerified);
      if(!user.emailVerified){
        print("algo");
        throw UnverifiedException();
      }

      ScanResult res = await BarcodeScanner.scan();
      qrResult = res.rawContent;
      print("paso por aca");
      if(_nombre == null) {
        _nombre = await _userRepository.getUser();
        print("paso por aca");
      }
      print("saco el usuario");
      print(_nombre);

      var connectivity = await (Connectivity().checkConnectivity());
      if((qrResult != null && qrResult != "") && _nombre != null && dni != null ){
        var conexion = await InternetAddress.lookup('google.com.ar');
        print(conexion);
        if ((connectivity == ConnectivityResult.mobile || connectivity == ConnectivityResult.wifi) && conexion.isNotEmpty && conexion[0].rawAddress.isNotEmpty) {
        print("hay Internet");
        BlocProvider.of<TrazaBloc>(context).add(SaveOnServer(localid: qrResult,
            dni: _nombre,
            date: DateTime.now().toString().substring(0, 19)));

        }

      }


    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.cameraAccessDenied) {
        print("no hay permiso");
      } else {
        setState(() {
          res = "Unknown Error $ex";
        });
      }
    } on FormatException {

        print("volvio");

    }
    on UnverifiedException {
      print("no hago ni bosta");
      return showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                backgroundColor: Colors.red,
                title: Text("Email no verificado!"),
                content: Text(
                    "Verifique su cuenta para acceder a trazabilidad, revise el email con el que se registro."),
                actions: [
                  FlatButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              )
      );

    }
    catch (ex) {

        print("La flasho $ex");
        try{

            print("no hay Internter");
            BlocProvider.of<TrazaBloc>(context).add(SaveOnLocal(localid: qrResult,
                dni: _nombre,
                date: DateTime.now().toString().substring(0, 19)));

        }
        catch(e) {
          return showDialog(
              context: context,
              builder: (context) =>
                  AlertDialog(
                    backgroundColor: Colors.red,
                    title: Text("Rechazado!"),
                    content: Text(
                        "No se ha podido registrar sus datos de trazabilidad, revise su conexion e intente nuevamente"),
                    actions: [
                      FlatButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  )
          );
        }


    }

  }


}
class UnverifiedException implements Exception {
  final String menssage;
  const UnverifiedException([this.menssage = "email no verificado"]);
  @override
  String toString() => "UnverifiedException: $menssage";
}
