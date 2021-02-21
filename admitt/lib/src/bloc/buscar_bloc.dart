import 'package:admitt/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class Buscarbloc with Validators {
  final _descriptionController = BehaviorSubject<String>();

  Stream<String> get descriptionStream =>
      _descriptionController.stream.transform(validateDescription);

  Function(String) get changeDescription => _descriptionController.sink.add;

  String get description => _descriptionController.value;

  dispose() {
    _descriptionController?.close();
  }
}
