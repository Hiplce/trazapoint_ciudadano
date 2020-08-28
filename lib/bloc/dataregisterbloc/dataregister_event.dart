import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class DataRegisterEvent extends Equatable{
  const DataRegisterEvent();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class DirectionChanged extends DataRegisterEvent{
  final String direction;

  const DirectionChanged({@required this.direction});

  @override
  // TODO: implement props
  List<Object> get props => [direction];

  @override
  String toString() => "DirectionChanged {email: $direction}";

}

class LocationChanged extends DataRegisterEvent {
  final location;

  const LocationChanged({@required this.location});

  @override
  // TODO: implement props
  List<Object> get props => [location];

  @override
  String toString() => "LocationChanged {password: $location}";

}

class PhoneChanged extends DataRegisterEvent {
  final phone;

  const PhoneChanged({@required this.phone});

  @override
  // TODO: implement props
  List<Object> get props => [phone];

  @override
  String toString() => "PhoneChanged {password: $phone}";

}
class Submitted extends DataRegisterEvent{
  final String email;
  final String password;
  final String name;
  final String lastname;
  final String dni;
  final String direction;
  final String location;
  final String phone;

  const Submitted({@required this.email,@required this.password,@required this.name, @required this.lastname,@required this.dni,@required this.direction,@required this.location,@required this.phone});

  @override
  // TODO: implement props
  List<Object> get props => [email,password,name,lastname,dni,direction,location,phone];

  @override
  String toString() => "Submitted {nombre: $name, apellido: $lastname , DNI: $dni , direccion: $direction, Localidad: $location, telefono: $phone}";

}
