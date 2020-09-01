

import 'package:flutter/cupertino.dart';
import 'package:bloc/bloc.dart';
import 'package:trazapoint_ciudadano/traza_repository.dart';
import 'package:trazapoint_ciudadano/user_repository.dart';
import 'package:trazapoint_ciudadano/bloc/trazabloc/bloc.dart';

class TrazaBloc extends Bloc<TrazaEvent,TrazaState>{
  final TrazaRepository _trazaRepository;

  TrazaBloc({@required TrazaRepository trazaRepository})
  :assert(trazaRepository != null),
  _trazaRepository = trazaRepository,super(TrazaState.initial());

  @override
  Stream<TrazaState> mapEventToState(TrazaEvent event) async* {
    if(event is SaveOnServer){
      yield* _mapSaveOnServerToState(event.localid,event.dni,event.date);
    }
    if(event is SaveOnLocal){
      yield* _mapSaveOnLocalToState(event.localid,event.dni,event.date);
    }
  }

  Stream<TrazaState>_mapSaveOnServerToState(String localid,String dni,String date) async* {
    yield TrazaState.loading();
    try{
      _trazaRepository.insertTraza(dni, localid,date);
      yield TrazaState.success();
    }
    catch(_){
      try{
      _mapSaveOnLocalToState(localid, dni, date);
      //yield TrazaState.onLocal();
      }catch(_){
        yield TrazaState.failure();
      }
    }

  }
  Stream<TrazaState>_mapSaveOnLocalToState(String localid,String dni,String date) async* {
    yield TrazaState.loading();
    try{
      String counter = localid + '|' + dni + '|' + date;
          _trazaRepository.writeTraza(counter);
      yield TrazaState.onLocal();
    }
    catch(_){
      yield TrazaState.failure();
    }

  }

}