class SportsComplex {
  final String id; // _id in JSON
  final String name;
  final String address;
  final String city;
  final String phone;
  final String email;
  final String openingTime;
  final String closingTime;
  final int pricePerHour;
  final String description;
  final String? managerId; // Nullable because it could be an ID or a populated object
  final Manager? manager; // Nullable to handle when it's not populated
  final List<Sport> sports;
  final List<String> images;

  SportsComplex({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.phone,
    required this.email,
    required this.openingTime,
    required this.closingTime,
    required this.pricePerHour,
    required this.description,
    this.managerId,
    this.manager,
    required this.sports,
    required this.images,
  });

  factory SportsComplex.fromJson(Map<String, dynamic> json) {
    final managerData = json['manager'];

    return SportsComplex(
      id: json['_id'], 
      name: json['name'],
      address: json['address'],
      city: json['city'],
      phone: json['phone'],
      email: json['email'],
      openingTime: json['openingTime'],
      closingTime: json['closingTime'],
      pricePerHour: json['pricePerHour'],
      description: json['description'],
      managerId: managerData is String ? managerData : null, // Handle manager as ID
      manager: managerData is Map<String, dynamic> ? Manager.fromJson(managerData) : null, // Handle populated manager
      sports: (json['sports'] as List<dynamic>)
          .map((sport) => Sport.fromJson(sport))
          .toList(),
      images: List<String>.from(json['images']),
    );
  }
}

class Manager {
  final String id; // _id in JSON
  final String? name; // Nullable in case only id is present
  final String? email;

  Manager({
    required this.id,
    this.name,
    this.email,
  });

  factory Manager.fromJson(Map<String, dynamic> json) {
    return Manager(
      id: json['_id'],
      name: json['name'], // Could be null if not populated
      email: json['email'], // Could be null if not populated
    );
  }
}

class Sport {
  final String id; // _id in JSON
  final String name;

  Sport({
    required this.id,
    required this.name,
  });

  factory Sport.fromJson(Map<String, dynamic> json) {
    return Sport(
      id: json['_id'],
      name: json['name'],
    );
  }
}
