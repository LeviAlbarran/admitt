import 'package:admitt/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class Contactobloc with Validators{

  final _nameController  = BehaviorSubject<String>();
  final _phoneController = BehaviorSubject<String>();

  Stream<String> get nameStream  => _nameController.stream.transform(validateNameLong);
  Stream<String> get phoneStream => _phoneController.stream.transform(validatePhone);

  Stream<bool> get formValidStream     =>
    Rx.combineLatest2(nameStream, phoneStream, (a, b) => true);

  Function(String) get changeName  => _nameController.sink.add;
  Function(String) get changePhone => _phoneController.sink.add;

  dispose(){
    _nameController?.close();
    _phoneController?.close();
  }
}