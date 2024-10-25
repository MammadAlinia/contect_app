class Contact {
  final String name;
  final String lastName;
  final String phoneNumber;
  final String description;

  Contact({
    required this.name,
    required this.lastName,
    required this.phoneNumber,
    this.description = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'description': description,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      name: map['name'] ?? '',
      lastName: map['lastName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      description: map['description'] ?? '',
    );
  }
}
