import 'dart:async';


class Validators{

  final validateEmail = StreamTransformer<String,String>.fromHandlers(
    handleData: (email,sink){

      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = new RegExp(pattern);

      if(regExp.hasMatch(email)){
        sink.add(email);
      }
      else{
        sink.addError('El Email no es válido.');
      }
    }
  );

  final validateEmpty    = StreamTransformer<String,String>.fromHandlers(
    handleData: (text,sink){
      if(text.length>0){
        sink.add(text);
      }
      else{
        sink.addError('Debe completar este campo.');
      }
    }
  );

  final validatePassword = StreamTransformer<String,String>.fromHandlers(
    handleData: (password,sink){
      if(password.length >= 6){
        sink.add(password);
      }
      else{
        sink.addError('La Contraseña debe tener al menos 6 carácteres.');
      }
    }
  );

  final validateVerification = StreamTransformer<String,String>.fromHandlers(
    handleData: (verification,sink){
      
    }
  );

  final validateName     = StreamTransformer<String,String>.fromHandlers(
    handleData: (name,sink){

      Pattern pattern = r'^[a-záóíéúÁÓÍÉÚ ñÑA-Z]+$';
      RegExp regExp   = new RegExp(pattern);
      if(regExp.hasMatch(name) && name.length<20){
        sink.add(name);
      }
      else{
        sink.addError('Su nombre no es válido.');
      }     
    }
  );

  final validateNameLong     = StreamTransformer<String,String>.fromHandlers(
    handleData: (name,sink){
      Pattern pattern = r'^[a-z!?¿¡,.áóíéúÁÓÍÉÚ+= 0-9ñÑA-Z]+$';
      RegExp regExp   = new RegExp(pattern);
      if(regExp.hasMatch(name) && name.length<30){
        sink.add(name);
      }
      else{
        sink.addError('Su nombre no es válido.');
      }     
    }
  );

    final validateDescription     = StreamTransformer<String,String>.fromHandlers(
    handleData: (description,sink){
      Pattern pattern = r'^[a-z!?¿¡,.áóíéú+= 0-9ñÑA-Z]+$';
      RegExp regExp   = new RegExp(pattern);
      if(regExp.hasMatch(description) && description.length<250){
        sink.add(description);
      }
      else{
        sink.addError('Su Descripción no es válida.');
      }     
    }
  );

  final validateLastName     = StreamTransformer<String,String>.fromHandlers(
    handleData: (lastName,sink){
      Pattern pattern = r'^[a-záóíéúÁÓÍÉÚ ñÑA-Z]+$';
      RegExp regExp   = new RegExp(pattern);
      if(regExp.hasMatch(lastName) && lastName.length<20){
        sink.add(lastName);
      }
      else{
        sink.addError('Su apellido no es válido.');
      }     
    }
  );

  final validatePhone    = StreamTransformer<String,String>.fromHandlers(
    handleData: (phone,sink){

      Pattern pattern = r'^(\+569)([0-9]*)([0-9])$';
      RegExp regExp   = new RegExp(pattern);
      if(regExp.hasMatch(phone) && phone.length>11){
        sink.add(phone);
      }
      else{
        sink.addError('Número telefónico no es válido.');
      }
    }

  );

}