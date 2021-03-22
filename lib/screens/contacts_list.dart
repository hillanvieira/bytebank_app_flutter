import 'package:bytebank_app/components/container.dart';
import 'package:bytebank_app/components/loading_centered_message.dart';
import 'package:bytebank_app/database/dao/contact_dao.dart';
import 'package:bytebank_app/models/contact.dart';
import 'package:bytebank_app/screens/contact_form.dart';
import 'package:bytebank_app/screens/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
abstract class ContactsListState {
  const ContactsListState();
}

@immutable
class LoadingContactsListState extends ContactsListState {
  const LoadingContactsListState();
}

@immutable
class InitContactsListState extends ContactsListState {
  const InitContactsListState();
}

@immutable
class LoadedContactsListState extends ContactsListState {
  final List<Contact> _contacts;

  const LoadedContactsListState(this._contacts);
}

@immutable
class FatalErrorContactsListState extends ContactsListState {
  const FatalErrorContactsListState();
}

class ContactsListCubit extends Cubit<ContactsListState> {
  ContactsListCubit() : super(InitContactsListState());

  void reload(ContactDao dao) async{

    emit(LoadingContactsListState());
   // final List<Contact> contacts = await dao.findAll();
   // emit(LoadedContactsListState(contacts));

    dao.findAll().then((contacts) => emit(LoadedContactsListState(contacts)));
  }
}

class ContactsListContainer extends BlocContainer {
  @override
  Widget build(BuildContext context) {
    final ContactDao dao = new ContactDao();

    return BlocProvider<ContactsListCubit>(
      create: (_) {
        final ContactsListCubit cubit = new ContactsListCubit();
        cubit.reload(dao);
        return cubit;
       //ContactsListCubit().reload(dao);
      //return ContactsListCubit();
      },
      child: ContactsList(dao),
    );
  }
}

class ContactsList extends StatelessWidget {
  final ContactDao _dao;

  ContactsList(this._dao);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer'),
      ),
      body: BlocBuilder<ContactsListCubit, ContactsListState>(
        builder: (context, state) {

          switch (state.runtimeType) {
            case InitContactsListState:
            case LoadingContactsListState:
              return LoadingCenteredMessage();
              break;
            case  LoadedContactsListState:
              if(state is LoadedContactsListState) {
                final contacts = state._contacts;
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return _ContactItem(
                      contact,
                      onClick: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TransactionFormContainer(contact),
                          ),
                        );
                      },
                    );
                  },
                  itemCount: contacts.length,
                );
              }
                break;
          }

          // if (state is InitContactsListState ||
          //     state is LoadingContactsListState) {
          //   return LoadingCenteredMessage();
          // }
          // if (state is LoadedContactsListState) {
          //   final contacts = state._contacts;
          //   return ListView.builder(
          //     itemBuilder: (context, index) {
          //       final contact = contacts[index];
          //       return _ContactItem(
          //         contact,
          //         onClick: () {
          //           Navigator.of(context).push(
          //             MaterialPageRoute(
          //               builder: (context) => TransactionForm(contact),
          //             ),
          //           );
          //         },
          //       );
          //     },
          //     itemCount: contacts.length,
          //   );
          // }
          return const Text('Unknown error');
        },
      ),
      floatingActionButton: buildAddContactButton(context),
    );
  }

  FloatingActionButton buildAddContactButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ContactForm(),
          ),
        );
        update(context);
      },
      child: Icon(
        Icons.add,
      ),
    );
  }

  void update(BuildContext context) {
    context.read<ContactsListCubit>().reload(_dao);
  }
}

class _ContactItem extends StatelessWidget {
  final Contact contact;
  final Function onClick;

  _ContactItem(
    this.contact, {
    @required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => onClick(),
        title: Text(
          contact.name,
          style: TextStyle(
            fontSize: 24.0,
          ),
        ),
        subtitle: Text(
          contact.accountNumber.toString(),
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
