import 'package:bytebank_app/components/loading_centered_message.dart';
import 'package:bytebank_app/database/dao/contact_dao.dart';
import 'package:bytebank_app/models/contact.dart';
import 'package:bytebank_app/screens/contact_form.dart';
import 'package:bytebank_app/screens/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:bytebank_app/screens/dashboard.dart';

class ContactsList extends StatefulWidget {
  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  final ContactDao _daoContact = new ContactDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer'),
      ),
      body: FutureBuilder<List<Contact>>(
        initialData: [],
        future: _daoContact.findAll(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return LoadingCenteredMessage();

            case ConnectionState.active:
              break;
            case ConnectionState.done:
              final List<Contact> contacts = snapshot.data;
              return ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  return _ContactItem(
                    contact: contacts[index],
                    updateState: () {
                      setState(() {});
                    },
                    onClick: () {
                      navigateTo(
                        context,
                        TransactionForm(contacts[index]),
                      );
                    },
                  );
                },
              );
          }

          return Text("Unknown error");
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ContactForm();
              },
            ),
          ).then((value) {
            setState(() {});
          });
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final ContactDao _daoContact = new ContactDao();
  final Contact contact;
  final Function updateState;
  final Function onClick;

  _ContactItem({
    Key key,
     this.contact,
     this.updateState,
     this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              onTap: () {
                return onClick();
              },
              title: Text(
                contact.name,
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              subtitle: Text(
                contact.accountNumber.toString(),
                // "${contact.accountNumber.toString()} ${contact.id.toString()}",
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('Delete'),
                  onPressed: () async {
                    await _daoContact.delete(contact.id);
                    updateState();
                  },
                ),
                const SizedBox(width: 8),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
