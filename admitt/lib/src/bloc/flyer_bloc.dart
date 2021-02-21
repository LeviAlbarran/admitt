import 'package:admitt/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class Flyerbloc with Validators {
  final _nameController = BehaviorSubject<String>();
  final _descriptionController = BehaviorSubject<String>();

  Stream<String> get nameStream =>
      _nameController.stream.transform(validateNameLong);
  Stream<String> get descriptionStream =>
      _descriptionController.stream.transform(validateDescription);

  Stream<bool> get formValidStream =>
      Rx.combineLatest2(nameStream, descriptionStream, (a, b) => true);

  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changeDescription => _descriptionController.sink.add;

  String get name => _nameController.value;
  String get description => _descriptionController.value;

  dispose() {
    _nameController?.close();
    _descriptionController?.close();
  }
}
