import 'dart:async';

class LoginValidators {
  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (data, sink) {
    if (data.contains('@')) {
      sink.add(data);
    } else {
      sink.addError("E-mail inválido");
    }
  });

  final validatePassword =
      StreamTransformer<String, String>.fromHandlers(handleData: (data, sink) {
    if (data.length > 4) {
      sink.add(data);
    } else {
      sink.addError("Senha inválida");
    }
  });
}
