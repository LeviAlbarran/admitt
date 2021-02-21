import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:admitt/src/constants.dart';

import '../../comunidad_class.dart';

class Contactlist extends StatefulWidget {
  Contactlist({Key key}) : super(key: key);
  static String tag = 'contactolist-page';
  @override
  _ContactlistState createState() => _ContactlistState();
}

class _ContactlistState extends State<Contactlist> {
  Iterable<Contact> _contacts;

  @override
  void initState() {
    getContacts();
    super.initState();
  }

  Future<void> getContacts() async {
    //Aqui ya se debe tener el permiso para los contactos
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Comunidad comunidad = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
            title: Text("Comunidades"),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [pink, hardPink, hardGrey])),
            )),
        body: _contacts != null
            //Crea una lista con todos los contactos
            ? ListView.builder(
                itemCount: _contacts?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  Contact contact = _contacts?.elementAt(index);
                  return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 18),
                      leading: (contact.avatar != null &&
                              contact.avatar.isNotEmpty)
                          ? CircleAvatar(
                              backgroundImage: MemoryImage(contact.avatar),
                            )
                          : CircleAvatar(
                              child: Text(
                                contact.initials(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              backgroundColor: Theme.of(context).accentColor,
                            ),
                      title: Text(contact.displayName ?? ''),
                      //Se puede expandir para mostrar detalles del contacto
                      onTap: () => Navigator.pop(
                          context,
                          contact.displayName +
                              contact.phones.elementAt(0).value));
                },
              )
            : Center(child: const CircularProgressIndicator()));
  }
}
