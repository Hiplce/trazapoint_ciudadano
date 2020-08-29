import 'dart:async';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:trazapoint_ciudadano/completeregister_form.dart';
import 'package:trazapoint_ciudadano/user_repository.dart';
import 'file:///C:/Users/aguch/StudioProjects/trazapoint_ciudadano/lib/completeregister_screen.dart';


class DniScanScreen extends StatefulWidget {
  UserRepository _userRepository;
  String _email;
  String _password;

  DniScanScreen({Key key,@required UserRepository userRepository,@required String email,@required String password}):
        assert(userRepository != null),
        assert(email != null),
        assert(password != null),
        _userRepository = userRepository,
        _email = email,
        _password = password,
        super(key: key);
  @override
  _DniScanScreenState createState() => _DniScanScreenState();
}

class _DniScanScreenState extends State<DniScanScreen> {
  UserRepository get _userRepository => widget._userRepository;
  String get _email => widget._email;
  String get _password => widget._password;
  String res;

  bool isNumeric(String str) {
    try{
      int value = int.parse(str);
      //print(value);
      return true;
    } catch(e) {
      return false;
    }
  }

  Future _scanQR() async {
    String nombre;
    String apellido;
    String dni;
    try {

        ScanResult res = await BarcodeScanner.scan();
        String qrResult = res.rawContent;
        var aux = qrResult.split('@');
        //print(aux);
        var algo = isNumeric(aux[1]);
        //print(algo);
        var datos;
        if (!isNumeric(aux[1])) {
          datos = "Apellido: " + aux[1] + "\n" +
              "Nombre: " + aux[2] + "\n" +
              "Documento: " + aux[4] + "\n";
          nombre = aux[2];
          apellido = aux[1];
          dni = aux[4];
        }
        else {
          datos = "Apellido: " + aux[4] + "\n" +
              "Nombre: " + aux[5] + "\n" +
              "Documento: " + aux[1] + "\n";
          nombre = aux[5];
          apellido = aux[4];
          dni = aux[1];
        }

    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          res = "Camera permission was denied";
        });
      } else {
        setState(() {
          res = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        res = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        res = "Unknown Error $ex";
      });
    }
    if(nombre == null || apellido == null || dni == null) return;
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          return CompleteRegisterScreen(userRepository: _userRepository,name: nombre,lastname: apellido,dni: dni,email: _email,password: _password, );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Scanner"),
      ),
      body: Center(
        child: Text(
          "Scanee el codigo de barras de su dni para continuar",
          style: new TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text("Scan"),
        onPressed: _scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
