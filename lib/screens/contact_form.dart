import 'package:bytebank_app/components/container.dart';
import 'package:bytebank_app/database/dao/contact_dao.dart';
import 'package:bytebank_app/models/contact.dart';
import 'package:bytebank_app/widgets/app_dependencies.dart';
import 'package:flutter/material.dart';


class ContactFormContainer extends BlocContainer{
  @override
  Widget build(BuildContext context) {
    return ContactForm();
  }

}

class ContactForm extends StatefulWidget {
  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  //final ContactDao daoContact = new ContactDao();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dependencies = AppDependencies.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('New contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full name',
              ),
              style: TextStyle(
                fontSize: 24.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: _accountNumberController,
                decoration: InputDecoration(
                  labelText: 'Account number',
                ),
                style: TextStyle(
                  fontSize: 24.0,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  child: Text('Create'),
                  onPressed: () => setState(() {
                    final String name = _nameController.text;
                    final int accountNumber = int.tryParse(
                      _accountNumberController.text,
                    );
                    final Contact newContact = Contact(
                      0,
                      name,
                      accountNumber,
                    );

                    setState(() {
                      dependencies.contactDao.save(newContact);
                    });
                    Navigator.pop(context);
                  }),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
