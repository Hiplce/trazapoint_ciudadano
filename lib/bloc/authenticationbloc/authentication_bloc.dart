import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:trazapoint_ciudadano/bloc/authenticationbloc/authentication_event.dart';
import 'package:trazapoint_ciudadano/bloc/authenticationbloc/authentication_state.dart';

import 'package:trazapoint_ciudadano/user_repository.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent,AuthenticationState> {
  final UserRepository _userRepository;
 /* @override
  AuthenticationState get initialState => Uninitialized();*/

  AuthenticationBloc({@required UserRepository userRepository})
  : assert ( userRepository != null),
  _userRepository = userRepository, super(Uninitialized());


  @override
  Stream<AuthenticationState> mapEventToState ( AuthenticationEvent event) async* {
    if(event is AppStarted){
      yield*  _mappAppStartedToState();
    }
    if (event is LoggedIn){
      yield* _mappLoggedInToState();
    }
    if(event is LoggedOut){
      yield* _mappLoggedOutToState();

    }
  }

  Stream<AuthenticationState> _mappAppStartedToState() async* {
    try{
      final isSingedIn = await _userRepository.isSignedIn();
      if(isSingedIn) {
        final user = await _userRepository.getUser();
        yield Authenticated(user);
      }
      else{
        yield Unauthenticated();
      }
    }
    catch(_){
      yield Unauthenticated();
    }

  }
  Stream<AuthenticationState> _mappLoggedInToState() async* {

    yield Authenticated(await _userRepository.getUser());

  }
  Stream<AuthenticationState> _mappLoggedOutToState() async* {
    yield Unauthenticated();
    _userRepository.singOut();

  }
}