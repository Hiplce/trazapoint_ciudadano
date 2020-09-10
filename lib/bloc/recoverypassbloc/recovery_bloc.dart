import 'package:bloc/bloc.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:trazapoint_ciudadano/bloc/recoverypassbloc/bloc.dart';
import 'package:trazapoint_ciudadano/user_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trazapoint_ciudadano/util/validator.dart';

class RecoveryBloc extends Bloc<RecoveryEvent,RecoveryState>{

   UserRepository _userRepository;

   RecoveryBloc({@required UserRepository userRepository}):
       assert (userRepository != null),
     _userRepository = userRepository, super(RecoveryState.empty());

   @override
  Stream<Transition<RecoveryEvent, RecoveryState>> transformEvents(Stream<RecoveryEvent> events, transitionFn) {
    final nonDebouceStream = events.where((event) {
      return( event is! EmailChanged);
    });
    final debounceStream = events.where((event) {
      return (event is EmailChanged );
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(nonDebouceStream.mergeWith([debounceStream]), transitionFn);
  }
  @override
  Stream<RecoveryState> mapEventToState(RecoveryEvent event) async*{
     if(event is EmailChanged){
        yield* _mapEmailChangedToState(event.email);
     }

     if(event is Submitted){
       yield* _mapSubmittedPressToState(email: event.email);
     }

  }
  Stream<RecoveryState> _mapEmailChangedToState(String email) async* {
     yield state.update(isEmailValid: Validator.isValidEmail(email));
  }


   Stream<RecoveryState> _mapSubmittedPressToState({String email}) async* {
     yield RecoveryState.loading();
     try{
        await _userRepository.resetPass(email);
        yield RecoveryState.success();
     }
     catch(_){
       yield RecoveryState.failure();
     }
   }
}