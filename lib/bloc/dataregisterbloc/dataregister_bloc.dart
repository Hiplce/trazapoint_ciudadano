


import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:trazapoint_ciudadano/bloc/dataregisterbloc/bloc.dart';
import 'package:trazapoint_ciudadano/user_repository.dart';
import 'package:trazapoint_ciudadano/util/validator.dart';

class DataRegisterBloc extends Bloc<DataRegisterEvent,DataRegisterState> {

  final UserRepository _userRepository;

  DataRegisterBloc({@required UserRepository userRepository})
      :assert (userRepository != null),
        _userRepository = userRepository,
        super(DataRegisterState.empty());

  @override
    Stream<DataRegisterState> mapEventToState(DataRegisterEvent event) async* {
      // TODO: implement mapEventToState
    if(event is DirectionChanged){
      yield*   _mapDirecitonChangedToState(event.direction);
    }
    if(event is LocationChanged){
      yield* _mapLocationChangedToState(event.location);
    }
    if(event is PhoneChanged){
      yield* _mapPhoneChangedToState(event.phone);
    }
    if(event is Submitted){
      yield* _mapSubmittedToState(event.email,event.password,event.name,event.lastname,event.dni,event.location,event.direction,event.phone);
    }

    }

  Stream<DataRegisterState> _mapDirecitonChangedToState(String direction) async* {
    yield state.update( isDirectionValid: Validator.isValidDirection(direction));
  }
  Stream<DataRegisterState> _mapLocationChangedToState(String direction) async* {
    yield state.update( isLocationValid: Validator.isValidLocation(direction));
  }
  Stream<DataRegisterState> _mapPhoneChangedToState(String phone) async* {
    yield state.update( isPhoneValid: Validator.isValidPhone(phone));
  }

  Stream<DataRegisterState>_mapSubmittedToState(String email,String password,String name,String lastname,String dni,String location,String direction,String phone) async* {
    yield DataRegisterState.loading();
    try{
      await _userRepository.insertUser(email, password,name,lastname,dni,location,direction,phone);
      yield DataRegisterState.success();
    }
    catch(e){
      print(e);
      yield DataRegisterState.failure();
    }
  }
}