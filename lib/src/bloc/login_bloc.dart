
import 'dart:async';

import 'package:app_plaga_enfermedades/src/bloc/validators_form.dart';

import 'package:rxdart/rxdart.dart';

class LoginBloc with ValidatorsForm{
    //sin el rxdart
    // final _emailController = StreamController<String>.broadcast();
    // final _passwordController = StreamController<String>.broadcast();
    
    
    final _emailController = BehaviorSubject<String>();
    final _passwordController = BehaviorSubject<String>();

    //Recuperar  los datos del stream
    Stream<String> get emailStream => _emailController.stream.transform(validarEmail);
    Stream<String> get passwordStream => _passwordController.stream.transform(validarPassword);

    //Combinar stream
    Stream<bool> get formValidStream =>
       Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);


    //Insertar valores al stream
    Function(String) get changeEmail => _emailController.sink.add;
    Function(String) get changePassword => _passwordController.sink.add;

    //obtener el ultimo valor
    String get email => _emailController.value;
    String get password => _passwordController.value;

    dispose(){
        _emailController?.close();
        _passwordController?.close();
    }
}