import 'package:bytebank_app/database/app_database.dart';
import 'package:bytebank_app/models/contact.dart';
import 'package:sqflite/sqflite.dart';

class ContactDao {
  static const String _tableName = 'contacts';
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _account_number = 'account_number';

  static const String tablesql = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY AUTOINCREMENT, '
      '$_name TEXT, '
      '$_account_number INTEGER)';

  Future<int> update(Contact contact) async {
    final Database db = await createDatabase();
    final Map<String, dynamic> contactMap = _toMap(contact);
    return db.update(
      _tableName,
      contactMap,
      where: '$_id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<int> save(Contact contact) async {
    final Database db = await createDatabase();
    Map<String, dynamic> contactMap = _toMap(contact);
    return db.insert(_tableName, contactMap);
  }

  Future<int> delete(int id) async {
    final Database db = await createDatabase();
    return db.delete(
      _tableName,
      where: '$_id = ?',
      whereArgs: [id],
    );
  }

  static void dropTable() async {
    final Database db = await createDatabase();
    db.delete(_tableName);
  }

  Future<List<Contact>> findAll() async {
    final Database db = await createDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<Contact> contacts = _toList(result);
    return contacts;
  }

  Map<String, dynamic> _toMap(Contact contact) {
    final Map<String, dynamic> contactMap = Map();
    //contactMap[_id] = contact.id;
    contactMap[_name] = contact.name;
    contactMap[_account_number] = contact.accountNumber;
    return contactMap;
  }


  List<Contact> _toList(List<Map<String, dynamic>> result) {
    final List<Contact> contacts = [];
    for (Map<String, dynamic> row in result) {
      final Contact contact = Contact(
        row[_id],
        row[_name],
        row[_account_number],
      );
      contacts.add(contact);
    }
    return contacts;
  }



/*Future<int> save(Contact contact) {
  return createDatabase().then((db) {
    final Map<String, dynamic> contactMap = Map();
    //contactMap['id'] = contact.id;
    contactMap['name'] = contact.name;
    contactMap['account_number'] = contact.accountNumber;
    return db.insert('contacts', contactMap);
  });
}*/

/*Future<List<Contact>> findAll() {
  return createDatabase().then((db) {
    return db.query('contacts').then((result) {
      final List<Contact> contacts = [];
      for (Map<String, dynamic> row in result) {
        final Contact contact = Contact(
          row['id'],
          row['name'],
          row['account_number'],
        );
        contacts.add(contact);
      }
      return contacts;
    });
  });
}*/
}
