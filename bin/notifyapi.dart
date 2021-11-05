import 'package:shelf_plus/shelf_plus.dart';

import 'errors.dart';

Handler init() {
  Middleware _selectContentType = setContentType('application/json');
  RouterPlus api = Router().plus;

  // api.get('/text', () => 'a text');
  // api.get('/binary', () => File('data.zip').openRead());
  // api.get('/json', () => {'name': 'John', 'age': 42});
  // api.get('/class', () => Person('Theo'));
  // api.get('/handler', () => typeByExtension('html') >> '<h1>Hello</h1>');
  // api.get('/file', () => File('thesis.pdf'));

  api.all('/<ignored|.*>', (Request request) {
    return ApiError.notFound;
  }, use: _selectContentType);
  return api;
}

void main() {
  shelfRun(
    init,
    defaultBindPort: 8080,
    defaultEnableHotReload: true,
  );
}
