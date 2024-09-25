class SportsComplex {
  final String imageUrl;
  final String name;
  final double pricePerHour;
  final String location;
  final String id;
  final List<Sport> sports; // Adding a list of sports

  SportsComplex({
    required this.imageUrl,
    required this.name,
    required this.pricePerHour,
    required this.location,
    required this.sports, // Include sports in the constructor
    required this.id,
  });

  factory SportsComplex.fromJson(Map<String, dynamic> json) {
    return SportsComplex(
      imageUrl: json['images'][0],
      name: json['name'],
      pricePerHour: json['pricePerHour'].toDouble(),
      location: json['city'],
      id: json['_id'],
      sports: (json['sports'] as List<dynamic>)
          .map((sportJson) => Sport.fromJson(sportJson))
          .toList(), // Map sports list
    );
  }
}

// Create a separate Sport class to handle sport details
class Sport {
  final String id;
  final String name;

  Sport({required this.id, required this.name});

  factory Sport.fromJson(Map<String, dynamic> json) {
    return Sport(
      id: json['_id'],
      name: json['name'],
    );
  }
}
