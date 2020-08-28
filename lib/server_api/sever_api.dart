
import "dart:async";
import 'package:chopper/chopper.dart';

// this is necessary for the generated code to find your class
part "sever_api.chopper.dart";

@ChopperApi(baseUrl: "/")
abstract class TrazaService extends ChopperService {

  // helper methods that help you instanciate your service
  static TrazaService create([ChopperClient client]) =>
      _$TrazaService(client);

  @Post(path: '/traza_ciudadano.php')
  Future<Response> insertPersona(@Body() String body);

  @Post(path: '/traza_traza.php')
  Future<Response> insertTraza(@Body() String body);

  @Get(path: '/traza_persona.php')
  Future<Response> getPersona(@Body() String email);

  static getClient() {
    final chopper = ChopperClient(
      baseUrl: "trak.trazapoint.com.ar",
      services: {
        TrazaService.create()
      }
    );
    return chopper.getService<TrazaService>();
  }

}