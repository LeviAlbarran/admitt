import 'package:admitt/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class Publicacionbloc with Validators {
  final _descriptionController = BehaviorSubject<String>();

  Stream<String> get descriptionStream =>
      _descriptionController.stream.transform(validateDescription);

  Stream<bool> get formValidStream =>
      Rx.combineLatest2(descriptionStream, descriptionStream, (a, b) => true);

  Function(String) get changeDescription => _descriptionController.sink.add;

  String get description => _descriptionController.value;

  dispose() {
    _descriptionController?.close();
  }
}
