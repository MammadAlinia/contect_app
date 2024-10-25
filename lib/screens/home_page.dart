// lib/screens/home_page.dart
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import '../models/contact.dart';
import 'new_contact_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Contact> contacts = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print('$path/contacts.json');
    return File('$path/contacts.json');
  }

  Future<void> loadContacts() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonList = json.decode(contents);
        setState(() {
          contacts = jsonList.map((json) => Contact.fromMap(json)).toList();
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> saveContacts() async {
    final file = await _localFile;
    final jsonList = contacts.map((contact) => contact.toMap()).toList();
    await file.writeAsString(json.encode(jsonList));
  }

  void deleteContact(int index) {
    setState(() {
      contacts.removeAt(index);
    });
    saveContacts();
  }

  List<Contact> getFilteredContacts() {
    if (searchController.text.isEmpty) {
      return contacts;
    }
    return contacts.where((contact) {
      final searchTerm = searchController.text.toLowerCase();
      return contact.name.toLowerCase().contains(searchTerm) ||
          contact.lastName.toLowerCase().contains(searchTerm) ||
          contact.phoneNumber.contains(searchTerm);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredContacts = getFilteredContacts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = filteredContacts[index];
                return ListTile(
                  title: Text('${contact.name} ${contact.lastName}'),
                  subtitle: Text(contact.phoneNumber),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deleteContact(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newContact = await Navigator.push<Contact>(
            context,
            MaterialPageRoute(builder: (context) => const NewContactPage()),
          );
          if (newContact != null) {
            setState(() {
              contacts.add(newContact);
            });
            saveContacts();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
