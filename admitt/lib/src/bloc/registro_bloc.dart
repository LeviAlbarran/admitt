import 'dart:async';
import 'package:admitt/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class Registrobloc with Validators{

  final _nameController     = BehaviorSubject<String>();
  final _lastNameController = BehaviorSubject<String>();
  final _emailController    = BehaviorSubject<String>();
  final _phoneController    = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _verificationController   = BehaviorSubject<String>();

  Stream<String> get nameStream     => _nameController.stream.transform(validateName);
  Stream<String> get lastNameStream => _lastNameController.stream.transform(validateLastName);
  Stream<String> get emailStream    => _emailController.stream.transform(validateEmail);
  Stream<String> get phoneStream    => _phoneController.stream.transform(validatePhone);
  Stream<String> get passwordStream => _passwordController.stream.transform(validatePassword);
  Stream<String> get verificationStream   => _verificationController.stream.transform(validateVerification);

  
  Stream<bool> get formValidStream => 
    Rx.combineLatest5(nameStream,lastNameStream,emailStream,phoneStream, passwordStream, (e,p,q,s,w,) => true);

  Function(String) get changeName         => _nameController.sink.add;
  Function(String) get changeLastName     => _lastNameController.sink.add;
  Function(String) get changeEmail        => _emailController.sink.add;
  Function(String) get changePhone        => _phoneController.sink.add;
  Function(String) get changePassword     => _passwordController.sink.add;
  Function(String) get changeVerification => _verificationController.sink.add;

  String get name         => _nameController.value;
  String get lastName     => _lastNameController.value;
  String get email        => _emailController.value;
  String get phone        => _phoneController.value;
  String get password     => _passwordController.value;
  String get verficiation => _verificationController.value;

    dispose() {
    _nameController?.close();
    _lastNameController?.close();
    _emailController?.close();
    _phoneController?.close();
    _passwordController?.close();
    _verificationController?.close();
  }
}