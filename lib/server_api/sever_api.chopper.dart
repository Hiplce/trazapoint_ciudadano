
part of 'sever_api.dart';

class _$TrazaService extends TrazaService {
  _$TrazaService([ChopperClient client]) {
    if(client == null) return;
    this.client = client;
  }

  @override
  // TODO: implement definitionType
  Type get definitionType => TrazaService;

  @override
  Future<Response<dynamic>> insertPersona(String body) {
    // TODO: implement insertPersona
    final $url = '//traza_ciudadano.php';
    final $body = body;
    final $request = Request('POST',$url,client.baseUrl, body: $body);
    return client.send<dynamic,dynamic>($request);
  }
  @override
  Future<Response> insertTraza(String body) {
    // TODO: implement insertTraza
    final $url = '//traza_traza.php';
    final $body = body;
    final $request = Request('POST',$url,client.baseUrl, body: $body);
    return client.send<dynamic,dynamic>($request);
  }

  @override
  Future<Response> getPersona(String email) {
    // TODO: implement getPersona
    final $url = '//traza_persona.php';
    final $body = email;
    final $request = Request('GET', $url, client.baseUrl,body: $body);
    return client.send<dynamic,dynamic>($request);
  }
}